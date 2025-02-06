//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "CommonGlobals.mqh"
#include "../shared/class/iDraw.mqh"

//+------------------------------------------------------------------+
//| Zone Class                                                       |
//+------------------------------------------------------------------+

class ZoneClass {
private:
   ENUM_TIMEFRAMES zoneTimeframe;
   bool isZoneVisible;
   int zoneCount;
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
       info.zoneTimeframe = zoneTimeframe;
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
       double previousHigh = getCandleValue(zoneTimeframe, candleId + 1, CANDLE_HIGH);
       CandleInfo info = getCandleInfo(zoneTimeframe, candleId);
       ZoneInfo updatedZones[];
       bool isUdateNeeded = false;
       string trend = previousHigh > info.high ? "up" : "down";
   
       for (int i = ArraySize(zones) - 1; i >= 0; i--) {
           ZoneInfo zone = zones[i];
           
           if (zone.zoneTimeframe == zoneTimeframe) {
               if (trend == "up") {
                  // Price is moving up
                  if(info.high > zone.midPrice && info.close < zone.top && info.open < zone.top ) {
                     if(isZoneVisible) {
                        ObjectDelete(0, zone.name);
                     }
                     isUdateNeeded = true;
                  } else {
                     ArrayResize(updatedZones, ArraySize(updatedZones) + 1);
                     updatedZones[ArraySize(updatedZones) - 1] = zone;
                  }
              
              } else if (trend == "down") {
                  if(info.low < zone.midPrice && info.close > zone.bottom && info.open > zone.bottom){
                     if(isZoneVisible) {
                        ObjectDelete(0, zone.name);
                     }
                     isUdateNeeded = true;
                  } else {
                     ArrayResize(updatedZones, ArraySize(updatedZones) + 1);
                     updatedZones[ArraySize(updatedZones) - 1] = zone;
                  }
              }
           } else {
               ArrayResize(updatedZones, ArraySize(updatedZones) + 1);
               updatedZones[ArraySize(updatedZones) - 1] = zone;
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
   
   //+------------------------------------------------------------------+
   //| Get Zone size                                                    |
   //+------------------------------------------------------------------+
   int getZoneCount() {
      return ArraySize(zones);
   }
   
   //+------------------------------------------------------------------+
   //| Get Zone array                                                   |
   //+------------------------------------------------------------------+
   ZoneInfo getZones(int index) {
      ZoneInfo zone = zones[index];
      return zone;
   }
};
