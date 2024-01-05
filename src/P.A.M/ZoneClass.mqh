//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "CommonGlobals.mqh"

//+------------------------------------------------------------------+
//| Zone Class                                                       |
//+------------------------------------------------------------------+

class ZoneClass {
private:
   ENUM_TIMEFRAMES zoneTimeframe;
   bool isZoneVisible;
   int zoneCount;
   struct ZoneInfo {
      string name;
      double top;
      double bottom;
      TrendDirection trend;
      datetime startTime;
   };
   ZoneInfo zones[];
    
public:
    // Constructor
    ZoneClass() {
    }
    
   //+------------------------------------------------------------------+
   //| set timeframe                                                    |
   //+------------------------------------------------------------------+
   void init(ENUM_TIMEFRAMES timeframe, bool isVisible) {
      zoneCount = 0;
      zoneTimeframe = timeframe;
      isZoneVisible = isVisible;
   }
    
   //+------------------------------------------------------------------+
   //| Add zone info                                                    |
   //+------------------------------------------------------------------+
   void AddZoneInfo(string name, double top, double bottom, TrendDirection trend, datetime startTime) {
       ZoneInfo info;
       info.name = name;
       info.top = top;
       info.bottom = bottom;
       info.trend = trend;
       info.startTime = startTime;
       ArrayResize(zones, ArraySize(zones) + 1);
       zones[ArraySize(zones) - 1] = info;
   }
   
   //+------------------------------------------------------------------+
   //| Move existing zones                                              |
   //+------------------------------------------------------------------+
   void UpdateZoneEndDates() {
      if(isZoneVisible) {
         datetime endTime = getTime(zoneTimeframe, 0);
   
          for (int i = 0; i < ArraySize(zones); i++) {
              string rectName = zones[i].name;
              double priceBottom = zones[i].bottom;
      
              // Check if the rectangle exists
              if (ObjectFind(0, rectName) != -1) {
                  // Get the start time and price levels of the rectangle
                  ObjectMove(0, rectName, 1, endTime, priceBottom);
              }
          }
      }
   }
   
   //+------------------------------------------------------------------+
   //| Insert new zone                                                  |
   //+------------------------------------------------------------------+
   void InsertZoneObject(int startCandleIndex, double priceTop, double priceBottom, TrendDirection trend) {
       datetime startTime = getTime(zoneTimeframe, startCandleIndex);
       string rectName = "PAM_zone" + (string)zoneCount;
       zoneCount++;
       this.AddZoneInfo(rectName, priceTop, priceBottom, trend, startTime);
       if(isZoneVisible){
         DrawZone(startTime, rectName, priceTop, priceBottom, trend, zoneTimeframe);
       }
   }
   
   //+------------------------------------------------------------------+
   //| Draw All Zones                                                   |
   //+------------------------------------------------------------------+
   void DrawAllZones() {
      for (int i = 0; i < ArraySize(zones); i++) {
         ZoneInfo zone = zones[i];
         DrawZone(zone.startTime, zone.name, zone.top, zone.bottom, zone.trend, zoneTimeframe);
      }
   }
   
   //+------------------------------------------------------------------+
   //| Delete Zone if 50% mitigated                                     |
   //+------------------------------------------------------------------+
   void CheckAndDeleteZones(int candleId) {
       double currentPrice = getClose(trendTimeframe, candleId);
       ZoneInfo updatedZones[];
       bool isUdateNeeded = false;
   
       for (int i = ArraySize(zones) - 1; i >= 0; i--) {
           double midPrice = (zones[i].top + zones[i].bottom) / 2;
           if ((currentPrice > midPrice && currentPrice < zones[i].top) || 
               (currentPrice < midPrice && currentPrice > zones[i].bottom)) {
               // Price has penetrated more than 50% into the rectangle
               if(isZoneVisible) {
                  ObjectDelete(0, zones[i].name);
               }
               isUdateNeeded = true;
           } else {
               ArrayResize(updatedZones, ArraySize(updatedZones) + 1);
               updatedZones[ArraySize(updatedZones) - 1] = zones[i];
           }
       }
       
       if(isUdateNeeded) {
         // Replace zones with updatedZones
          ArrayResize(zones, ArraySize(updatedZones));
          for (int i = 0; i < ArraySize(updatedZones); i++) {
              zones[i] = updatedZones[i];
          }
       }
   }
   
   //+------------------------------------------------------------------+
   //| Toggle Zone                                                      |
   //+------------------------------------------------------------------+
   bool ToggleIsVisible() {
       isZoneVisible = !isZoneVisible;
       return isZoneVisible;
   }
};
