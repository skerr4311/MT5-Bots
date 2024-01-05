//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| HighsAndLowsClass                                                |
//+------------------------------------------------------------------+

class HighsAndLowsClass {
private:
   ENUM_TIMEFRAMES highsandlowsTimeframe;
   bool isTrendVisible;
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
   void init(ENUM_TIMEFRAMES timeframe, bool isVisible) {
      trendCount = 0;
      highsandlowsTimeframe = timeframe;
      isTrendVisible = isVisible;
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
   
   //+------------------------------------------------------------------+
   //| Toggle Trend                                                     |
   //+------------------------------------------------------------------+
   bool ToggleIsVisible() {
       isTrendVisible = !isTrendVisible;
       return isTrendVisible;
   }
    
};
