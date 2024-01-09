//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "CommonGlobals.mqh"
#include "iDraw.mqh"

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
      ArrayResize(zones, 0);
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
       string rectName = "PAM_zone_" + IntegerToString(zoneTimeframe) + (string)zoneCount;
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
       double currentPrice = getClose(zoneTimeframe, candleId);
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
   //| Check if price has rejected off a zone                           |
   //+------------------------------------------------------------------+
   bool CheckPriceRejection(int candleId) {
       double currentPrice = getClose(zoneTimeframe, candleId);
       double previousPrice = getClose(zoneTimeframe, candleId + 1);
   
       for (int i = 0; i < ArraySize(zones); i++) {
           double zoneTop = zones[i].top;
           double zoneBottom = zones[i].bottom;
   
           // Check if the previous price was outside the zone and current price is inside
           if ((previousPrice < zoneBottom || previousPrice > zoneTop) &&
               (currentPrice >= zoneBottom && currentPrice <= zoneTop)) {
   
               // Check for rejection
               if (zones[i].trend == TREND_UP && currentPrice > zoneBottom + (zoneTop - zoneBottom) * 0.5) {
                  DrawHorizontalLineWithLabel(currentPrice, clrGreen, 0, "bull rej");
                  return true; // Bullish rejection
               }
               else if (zones[i].trend == TREND_DOWN && currentPrice < zoneTop - (zoneTop - zoneBottom) * 0.5) {
                  DrawHorizontalLineWithLabel(currentPrice, clrRed, 0, "bear rej");
                  return true; // Bearish rejection
               }
           }
       }
       return false;
   }

   
   //+------------------------------------------------------------------+
   //| Toggle Zone                                                      |
   //+------------------------------------------------------------------+
   bool ToggleIsVisible() {
       isZoneVisible = !isZoneVisible;
       return isZoneVisible;
   }
};
