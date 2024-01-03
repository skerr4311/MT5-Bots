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
//| ArrowClass                                                       |
//+------------------------------------------------------------------+

class ArrowClass {
private:
   ENUM_TIMEFRAMES arrowTimeframe;
   int arrowCount;
   struct ArrowInfo {
      datetime time;
      string name;
      double price;
      TrendDirection trend;
   };
   ArrowInfo arrows[];
    
public:
    // Constructor
    ArrowClass() {
    }
    
   //+------------------------------------------------------------------+
   //| init class                                                       |
   //+------------------------------------------------------------------+
   void init(ENUM_TIMEFRAMES timeframe) {
      arrowCount = 0;
      arrowTimeframe = timeframe;
   }
   
   //+------------------------------------------------------------------+
   //| Draw Trend arrow                                                 |
   //+------------------------------------------------------------------+
   void DrawTrendArrow(datetime time, string name, double price, TrendDirection trend) {
      ENUM_OBJECT arrow = trend == TREND_UP ? OBJ_ARROW_UP : OBJ_ARROW_DOWN;
      color arrowColor = trend == TREND_UP ? clrGreenYellow : clrDeepPink;
      long anchor = trend == TREND_UP ? ANCHOR_TOP : ANCHOR_BOTTOM;
      
      if(!ObjectCreate(0, name, arrow, 0, time, price)) {
        Print("Failed to create up arrow: ", GetLastError());
        return;
       }
   
       // Set properties of the arrow
       ObjectSetInteger(0, name, OBJPROP_COLOR, arrowColor);
       ObjectSetInteger(0, name, OBJPROP_WIDTH, 2); // Adjust width for size
       ObjectSetInteger(0, name, OBJPROP_ANCHOR, anchor);
       ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
       ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   }
   
   //+------------------------------------------------------------------+
   //| Draw All Arrows                                                  |
   //+------------------------------------------------------------------+
   void DrawAllArrows() {
      for (int i = 0; i < ArraySize(arrows); i++) {
         ArrowInfo arrow = arrows[i];
         DrawTrendArrow(arrow.time, arrow.name, arrow.price, arrow.trend);
      }
   }
   
   //+------------------------------------------------------------------+
   //| Add arrow info                                                   |
   //+------------------------------------------------------------------+
   void AddArrowInfo(datetime time, string name, double price, TrendDirection trend) {
       ArrowInfo info;
       info.time = time;
       info.name = name;
       info.price = price;
       info.trend = trend;
       ArrayResize(arrows, ArraySize(arrows) + 1);
       arrows[ArraySize(arrows) - 1] = info;
   }
   
   //+------------------------------------------------------------------+
   //| Insert new arrow                                                 |
   //+------------------------------------------------------------------+
   void InsertArrowObject(int candleId, TrendDirection trend) {
       arrowCount++;
       currentTrend = trend;
       datetime time = getTime(arrowTimeframe, candleId);
       string objectName = "PAM_arrow" + (string)arrowCount;
       double price = trend == TREND_UP ? getLow(arrowTimeframe, candleId) : getHigh(arrowTimeframe, candleId);
       
       AddArrowInfo(time, objectName, price, trend);
       if(isArrowVisible){
         DrawTrendArrow(time, objectName, price, trend);
       }
   }
    
};
