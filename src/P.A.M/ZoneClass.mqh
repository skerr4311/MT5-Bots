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
      double midPrice;
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
       info.midPrice = (top + bottom) / 2;
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
       double previousHigh = getHigh(zoneTimeframe, candleId + 1);
       CandleInfo info = getCandleInfo(zoneTimeframe, candleId);
       ZoneInfo updatedZones[];
       bool isUdateNeeded = false;
       string trend = previousHigh > info.high ? "up" : "down";
   
       for (int i = ArraySize(zones) - 1; i >= 0; i--) {
           double zoneTop = zones[i].top;
           double zoneBottom = zones[i].bottom;
           double midPrice = (zoneTop + zoneBottom) / 2;
           
           if (trend == "up") {
               // Price is moving up
               if(info.high > midPrice && info.close < zoneTop && info.open < zoneTop ) {
                  if(isZoneVisible) {
                     ObjectDelete(0, zones[i].name);
                  }
                  isUdateNeeded = true;
               } else {
                  ArrayResize(updatedZones, ArraySize(updatedZones) + 1);
                  updatedZones[ArraySize(updatedZones) - 1] = zones[i];
               }
           
           } else if (trend == "down") {
               if(info.low < midPrice && info.close > zoneBottom && info.open > zoneBottom){
                  if(isZoneVisible) {
                     ObjectDelete(0, zones[i].name);
                  }
                  isUdateNeeded = true;
               } else {
                  ArrayResize(updatedZones, ArraySize(updatedZones) + 1);
                  updatedZones[ArraySize(updatedZones) - 1] = zones[i];
               }
           } else {
           // nothing 
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
   bool CheckPriceRejection(int candleId, TrendDirection trend) {
       CandleInfo current = getCandleInfo(zoneTimeframe, candleId);  
       CandleInfo previous = getCandleInfo(zoneTimeframe, candleId + 1);
   
       for (int i = 0; i < ArraySize(zones); i++) {
           ZoneInfo zone = zones[i];
           
           // Continuation: Zone is used as a retrace point for price to return to a zone to the continue on its path.       
           // Rejection: Zone is used as a rejection point. The movement is not strong enough to break through a point.
           
           if(trend == TREND_UP) {
               if (zone.trend == trend && previous.low < zone.top && previous.low > zone.bottom && current.close > zone.top) {
                  DrawHorizontalLineWithLabel(current.close, clrGreen, 0, "bull rej");
                  return true;
               }

           } else if (trend == TREND_DOWN) {
           // Red zone
               if (zone.trend == trend && previous.high > zone.bottom && previous.high < zone.top && current.close < zone.bottom) {
                  DrawHorizontalLineWithLabel(current.close, clrRed, 0, "bear rej");
                  return true;
               }

           } else {
            // nothing

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
   
   //+------------------------------------------------------------------+
   //| Get Zone size                                                    |
   //+------------------------------------------------------------------+
   int getZoneCount() {
      return ArraySize(zones);
   }
};
