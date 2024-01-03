//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "iFunctions.mqh"
#include "CommonGlobals.mqh"

//+------------------------------------------------------------------+
//| Zone Class                                                       |
//+------------------------------------------------------------------+

class ZoneClass {
private:
   ENUM_TIMEFRAMES zoneTimeframe;
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
   void init(ENUM_TIMEFRAMES timeframe) {
      zoneCount = 0;
      zoneTimeframe = timeframe;
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
         this.DrawZone(startTime, rectName, priceTop, priceBottom, trend);
       }
   }
   
   //+------------------------------------------------------------------+
   //| Draw new zone                                                    |
   //+------------------------------------------------------------------+
   void DrawZone(datetime startTime, string zoneName, double priceTop, double priceBottom, TrendDirection trend) {
       datetime endTime = getTime(zoneTimeframe, 0); // Current time
       color zoneColor = clrRed;
 
       if (trend == TREND_UP) {
         zoneColor = clrGreen;
       }
   
        // Create the rectangle if it doesn't exist
        if(!ObjectCreate(0, zoneName, OBJ_RECTANGLE, 0, startTime, priceTop, endTime, priceBottom)) {
            Print("Failed to create rectangle: ", GetLastError());
            return;
        }
   
        // Set properties of the rectangle (color, style, etc.)
        ObjectSetInteger(0, zoneName, OBJPROP_STYLE, STYLE_SOLID);
        ObjectSetInteger(0, zoneName, OBJPROP_COLOR, zoneColor);
        ObjectSetInteger(0, zoneName, OBJPROP_FILL, true);
        ObjectSetInteger(0, zoneName, OBJPROP_BACK, false); // Set to false if you don't want it in the background
        ObjectSetInteger(0, zoneName, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, zoneName, OBJPROP_SELECTED, false);
   }
   
   //+------------------------------------------------------------------+
   //| Draw All Zones                                                   |
   //+------------------------------------------------------------------+
   void DrawAllZones() {
      for (int i = 0; i < ArraySize(zones); i++) {
         ZoneInfo zone = zones[i];
         this.DrawZone(zone.startTime, zone.name, zone.top, zone.bottom, zone.trend);
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
};
