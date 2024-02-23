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
   void InsertNewKillZone(datetime startTime, datetime endTime, string killZoneName, double priceTop, double priceBottom, KillZoneTypes killZoneType) {
      int newSize = ArraySize(killZones) + 1; // Increase array size by one
      ArrayResize(killZones, newSize); // Resize the array
      
      // Create a new KillZoneInfo struct and assign values
      KillZoneInfo newZone;
      newZone.startTime = startTime;
      newZone.endTime = endTime;
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
   //+------------------------------------------------------------------+
   //| Update Last kill zone                                            |
   //+------------------------------------------------------------------+
   void UpdateLatestKillZone(datetime startTime, datetime endTime, string killZoneName, double priceTop, double priceBottom, KillZoneTypes killZoneType) {
      int lastIndex = ArraySize(killZones) - 1; // Get the last index of the array
      
      if(lastIndex >= 0) { // Check if the array is not empty
         // Update the last item
         killZones[lastIndex].startTime = startTime;
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
   //| Get Market trend                                                 |
   //+------------------------------------------------------------------+
   void SetInitialMarketTrend() {
      for(int i = lookBack; i >= 1; i--) {
         Print("not ready yet.");
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
   bool checkIsInKillZone() {
      datetime currentTime = getTime(this.TimeFrame, 0);
      datetime startTime = StringToTime(kzStart);
      datetime endTime = StringToTime(kzEnd);
      string killZoneName = boxNamePrefix + IntegerToString(killZoneCount);
   
      // Check if current time is within the kill zone
      isInKillZone = currentTime >= startTime && currentTime <= endTime;
      
      if(isInKillZone && !isDrawingStarted) {
         isDrawingStarted = true;
         HighLowTimeframe response = GetLowestPriceFromStartTime(TimeFrame, startTime);
         InsertNewKillZone(startTime, endTime, killZoneName, response.high, response.low, killZoneType);
      } else if(isInKillZone && isDrawingStarted) {
         HighLowTimeframe response = GetLowestPriceFromStartTime(TimeFrame, startTime);
         UpdateLatestKillZone(startTime, endTime, killZoneName, response.high, response.low, killZoneType);
      } else if(!isInKillZone && isDrawingStarted) {
         // finalize item complete
         killZoneCount++;
         isDrawingStarted = false;
      }
   
      return isInKillZone;
   }
};
