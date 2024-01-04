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
//| HighsAndLowsClass                                                       |
//+------------------------------------------------------------------+

class HighsAndLowsClass {
private:
   ENUM_TIMEFRAMES highsandlowsTimeframe;
   int trendCount;
   struct TrendInfo {
      string name; 
      string label;
      double price;
      datetime time;
   };
   TrendInfo trends[];
    
public:
    // Constructor
    HighsAndLowsClass() {
    }
    
   //+------------------------------------------------------------------+
   //| init class                                                       |
   //+------------------------------------------------------------------+
   void init(ENUM_TIMEFRAMES timeframe) {
      trendCount = 0;
      highsandlowsTimeframe = timeframe;
   }
   
   //+------------------------------------------------------------------+
   //| Draw All Trends                                                  |
   //+------------------------------------------------------------------+
   void DrawAllTrends() {
      for (int i = 0; i < ArraySize(trends); i++) {
         TrendInfo trend = trends[i];
         DrawLabel(trend.name, trend.label, trend.price, trend.time);
      }
   }
   
   //+------------------------------------------------------------------+
   //| Draw new trend                                                   |
   //+------------------------------------------------------------------+
   void DrawLabel(string name, string label, double price, datetime time) {
      if(!ObjectCreate(0, name, OBJ_TEXT, 0, time, price)) {
         Print("Failed to create rectangle: ", GetLastError());
         return;
      }
      
      // Set the properties for the label
      ObjectSetString(0, name, OBJPROP_TEXT, label);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, 0); // Make it non-selectable
      ObjectSetInteger(0, name, OBJPROP_SELECTED, 0); // Unselect it
   }
   
   //+------------------------------------------------------------------+
   //| Add trend info                                                   |
   //+------------------------------------------------------------------+
   void AddTrendInfo(string name, string label, double price, datetime time) {
       TrendInfo info;
       info.name = name;
       info.label = label;
       info.price = price;
       info.time = time;
       ArrayResize(trends, ArraySize(trends) + 1);
       trends[ArraySize(trends) - 1] = info;
   }
   
   //+------------------------------------------------------------------+
   //| Insert new trend                                                 |
   //+------------------------------------------------------------------+
   void InsertTrendObject(string label, double price, int candleId) {
       trendCount++;
       datetime time = getTime(highsandlowsTimeframe, candleId);
       string objectName = "PAM_trend" + (string)trendCount;
       this.AddTrendInfo(objectName, label, price, time);
       if(isTrendVisible){
         DrawLabel(objectName, label, price, time);
       }
   }
    
};
