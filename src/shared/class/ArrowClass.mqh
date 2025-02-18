//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include "../function/iFunctions.mqh"
//+------------------------------------------------------------------+
//| ArrowClass                                                       |
//+------------------------------------------------------------------+

class ArrowClass {
private:
   ENUM_TIMEFRAMES arrowTimeframe;
   bool isArrowVisible;
   int arrowCount;
   struct ArrowInfo {
      datetime time;
      string name;
      double price;
      TrendDirection trend;
      ENUM_TIMEFRAMES arrowTimeframe;
   };
   ArrowInfo arrows[];
    
public:
    // Constructor
    ArrowClass() {
    }
    
   //+------------------------------------------------------------------+
   //| init class                                                       |
   //+------------------------------------------------------------------+
   void init(ENUM_TIMEFRAMES timeframe, bool isVisible) {
      arrowCount = 0;
      arrowTimeframe = timeframe;
      isArrowVisible = isVisible;
      ArrayResize(arrows, 0);
   }
   
   //+------------------------------------------------------------------+
   //| Draw All Arrows                                                  |
   //+------------------------------------------------------------------+
   void DrawAllArrows() {
      for (int i = 0; i < ArraySize(arrows); i++) {
         ArrowInfo arrow = arrows[i];
         DrawTrendArrow(arrow.time, arrow.name, arrow.price, arrow.trend, arrow.arrowTimeframe);
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
       info.arrowTimeframe = arrowTimeframe;
       ArrayResize(arrows, ArraySize(arrows) + 1);
       arrows[ArraySize(arrows) - 1] = info;
   }
   
   //+------------------------------------------------------------------+
   //| Insert new arrow                                                 |
   //+------------------------------------------------------------------+
   void InsertArrowObject(int candleId, TrendDirection trend, bool execution) {
       arrowCount++;
       datetime time = getTime(execution ? inputExecutionTimeframe : arrowTimeframe, candleId);
       string objectName = "PAM_arrow_" + IntegerToString(arrowTimeframe) + (string)arrowCount;
       double price = trend == TREND_UP ? getCandleValue(arrowTimeframe, candleId, CANDLE_LOW) : getCandleValue(arrowTimeframe, candleId, CANDLE_HIGH);
       
       AddArrowInfo(time, objectName, price, trend);
       if(isArrowVisible){
         DrawTrendArrow(time, objectName, price, trend, arrowTimeframe);
       }
   }
   
   //+------------------------------------------------------------------+
   //| Toggle Arrow                                                     |
   //+------------------------------------------------------------------+
   bool ToggleIsVisible() {
       isArrowVisible = !isArrowVisible;
       return isArrowVisible;
   }
    
};
