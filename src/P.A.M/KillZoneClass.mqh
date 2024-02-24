//+------------------------------------------------------------------+
//|                                    KillZone            P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Include                                                           |
//+------------------------------------------------------------------+
#include "iFunctions.mqh"
#include "CommonGlobals.mqh"

class KillZone {
  private:
   ENUM_TIMEFRAMES TimeFrame;
   string boxNamePrefix;
   bool isInKillZone, isDrawingStarted, isKillZoneVisible;
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
    
  public:
    // Constructor
    KillZone() {}
    
    //Initiate
    void init(ENUM_TIMEFRAMES tf, KillZoneTypes killZone, string start, string end) {
      TimeFrame = tf;
      boxNamePrefix = "PAM_" + killZone + "_KillZone_";
      isInKillZone = false;
      kzStart = start;
      kzEnd = end;
      killZoneType = killZone;
      killZoneCount = 0;
      isKillZoneVisible = true;
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
         InsertNewKillZone(candleDateTime, killZoneName, getHigh(this.TimeFrame, candleId), getLow(this.TimeFrame, candleId), killZoneType);
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
