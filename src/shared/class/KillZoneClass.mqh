//+------------------------------------------------------------------+
//|                                    KillZone            P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Include                                                           |
//+------------------------------------------------------------------+
#include "../function/iFunctions.mqh"
#include "../function/iDraw.mqh"

class KillZone {
  private:
   ENUM_TIMEFRAMES TimeFrame;
   string boxNamePrefix, buttonPrefix;
   bool isInKillZone, isDrawingStarted, isKillZoneVisible, isInit;
   string kzStart;
   string kzEnd;
   KillZoneTypes killZoneType;
   int killZoneCount;
   KillZoneInfo killZones[];

   //+------------------------------------------------------------------+
   //| AddKZtoArray                                                     |
   //+------------------------------------------------------------------+
   void InsertNewKillZone(datetime startTime, string killZoneName, double priceTop, double priceBottom, KillZoneTypes killZoneType) {
      int newSize = ArraySize(killZones) + 1; // Increase array size by one
      ArrayResize(killZones, newSize); // Resize the array
      
      // Create a new KillZoneInfo struct and assign values
      KillZoneInfo newZone;
      newZone.startTime = startTime;
      newZone.endTime = startTime;
      newZone.killZoneName = killZoneName;
      newZone.priceTop = priceTop;
      newZone.priceBottom = priceBottom;
      newZone.killZoneType = killZoneType;
      
      // Assign the new item to the last index of the array
      killZones[newSize - 1] = newZone;

      if(isKillZoneVisible) {
         DrawKillZone(newZone);
      }
   }
   datetime getLastKzStartTime() {
      int lastIndex = ArraySize(killZones) - 1; // Get the last index of the array
      return killZones[lastIndex].startTime;
   }
   //+------------------------------------------------------------------+
   //| Update Last kill zone                                            |
   //+------------------------------------------------------------------+
   void UpdateLatestKillZone(datetime endTime, string killZoneName, double priceTop, double priceBottom, KillZoneTypes killZoneType) {
      int lastIndex = ArraySize(killZones) - 1; // Get the last index of the array
      
      if(lastIndex >= 0) { // Check if the array is not empty
         // Update the last item
         killZones[lastIndex].endTime = endTime;
         killZones[lastIndex].killZoneName = killZoneName;
         killZones[lastIndex].priceTop = priceTop;
         killZones[lastIndex].priceBottom = priceBottom;
         killZones[lastIndex].killZoneType = killZoneType;
      }

      if(isKillZoneVisible) {
         DrawKillZone(killZones[lastIndex]);
      }
   }

   bool isValidTime(string start, string end) {
      return ValidateTimeFormat(start) && ValidateTimeFormat(end);
   }
    
  public:
    // Constructor
    KillZone() {}
    
    //Initiate
    void init(ENUM_TIMEFRAMES tf, KillZoneTypes killZone, string start, string end) {
      TimeFrame = tf;
      boxNamePrefix = "PAM_" + killZone + "_KillZone_";
      buttonPrefix = "PAM_KZ_" + killZone;
      isInKillZone = false;
      kzStart = start;
      kzEnd = end;
      killZoneType = killZone;
      killZoneCount = 0;
      isKillZoneVisible = true;
      isInit = isValidTime(start, end);
      DrawToggleButton();
    }

    bool getIsInit() {
      return this.isInit;
    }

   //+------------------------------------------------------------------+
   //| Create Toggle Button                                             |
   //+------------------------------------------------------------------+
   void DrawToggleButton() {
      int buttonHeight = 30;
      int buttonWidth = 80;
      int spacing = 10;
      long chartWidth = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS) / 2 - (buttonWidth / 2);
      long yOffset = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS) - buttonHeight;
      long buttonPlacement = KillZoneTypeToString(killZoneType) == "London" ? chartWidth : KillZoneTypeToString(killZoneType) == "Asian" ? chartWidth + buttonWidth : chartWidth - buttonWidth;
      int textOffset = KillZoneTypeToString(killZoneType) == "London" ? 16 : KillZoneTypeToString(killZoneType) == "Asian" ? 19 : 13;


      CreateSingleButton(
            buttonPrefix + "_Button", 
            buttonPrefix + "_Text", 
            KillZoneTypeToString(killZoneType),
            yOffset, 
            buttonPlacement,
            buttonWidth,
            buttonPlacement + textOffset,
            isKillZoneVisible ? clrDarkGreen : clrBlue, 
            isKillZoneVisible ? clrGreen : clrDodgerBlue, 
            clrWhite
         );
   }

   //+------------------------------------------------------------------+
   //| Handle Button Click                                              |
   //+------------------------------------------------------------------+
   void HandleButtonClick(string sparam) {
    if (StringFind(sparam, buttonPrefix) == 0) {
        ToggleIsVisible();
    }
}
    
   //+------------------------------------------------------------------+
   //| Draw Past Zones                                                  |
   //+------------------------------------------------------------------+
   void SetInitialMarketTrend() {
      for(int i = lookBack; i >= 1; i--) {
         checkIsInKillZone(i);
      }
   }
   
   //+------------------------------------------------------------------+
   //| Toggle isKillZoneVisible                                         |
   //+------------------------------------------------------------------+
   bool ToggleIsVisible() {
      isKillZoneVisible = !isKillZoneVisible;
      ObjectSetInteger(0, buttonPrefix + "_Button", OBJPROP_COLOR, isKillZoneVisible ? clrGreen : clrDodgerBlue);
      ObjectSetInteger(0, buttonPrefix + "_Button", OBJPROP_BGCOLOR, isKillZoneVisible ? clrDarkGreen : clrBlue);

      if (isKillZoneVisible) {
      DrawAllKillZones();
      } else {
      DeleteEAObjects(boxNamePrefix);
      }
      return isKillZoneVisible;
   }

   //+------------------------------------------------------------------+
   //| Draw All KillZones                                                  |
   //+------------------------------------------------------------------+
   void DrawAllKillZones() {
      for (int i = 0; i < ArraySize(killZones); i++) {
         KillZoneInfo killZone = killZones[i];
         DrawKillZone(killZone);
      }
   }
    
   //+------------------------------------------------------------------+
   //| isInKillZone                                                     |
   //+------------------------------------------------------------------+
   bool checkIsInKillZone(int candleId) {
      datetime candleDateTime = getTime(this.TimeFrame, candleId);
    
      // Convert times to datetime for today's date for comparison
      datetime startDateTime = StringToTime(TimeToString(candleDateTime, TIME_DATE) + " " + kzStart);
      datetime endDateTime = StringToTime(TimeToString(candleDateTime, TIME_DATE) + " " + kzEnd);

      // Extract just the time part by subtracting the date part
      datetime candleTimeOnly = candleDateTime - (candleDateTime - (candleDateTime % 86400));
      datetime startTimeOnly = startDateTime - (startDateTime - (startDateTime % 86400));
      datetime endTimeOnly = endDateTime - (endDateTime - (endDateTime % 86400));

      string killZoneName = boxNamePrefix + IntegerToString(killZoneCount);
   
      // Check if current time is within the kill zone
      isInKillZone = candleTimeOnly >= startTimeOnly && candleTimeOnly <= endTimeOnly;
      
      if(isInKillZone && !isDrawingStarted) {
         isDrawingStarted = true;
         InsertNewKillZone(candleDateTime, killZoneName, getCandleValue(this.TimeFrame, candleId, CANDLE_HIGH), getCandleValue(this.TimeFrame, candleId, CANDLE_LOW), killZoneType);
      } else if(isInKillZone && isDrawingStarted) {
         HighLowTimeframe response = GetLowestPriceFromStartTime(TimeFrame, getLastKzStartTime(), candleId);
         UpdateLatestKillZone(candleDateTime, killZoneName, response.high, response.low, killZoneType);
      } else if(!isInKillZone && isDrawingStarted) {
         // finalize item complete
         killZoneCount++;
         isDrawingStarted = false;
      }
   
      return isInKillZone;
   }
};
