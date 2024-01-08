//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

input ENUM_TIMEFRAMES inputTrendTimeframe = PERIOD_H1; // Trend timeframe
input ENUM_TIMEFRAMES inputExecutionTimeframe = PERIOD_M15; // Execution timeframe

//+------------------------------------------------------------------+
//| Common Globals                                                   |
//+------------------------------------------------------------------+

enum TrendDirection
  {
   TREND_NONE = 0,
   TREND_UP,
   TREND_DOWN
  };
enum KeyStructureType {
    KEY_STRUCTURE_HH,
    KEY_STRUCTURE_LL
};
//+------------------------------------------------------------------+
//| EnumToString function for TrendDirection enum                    |
//+------------------------------------------------------------------+
string EnumToString(TrendDirection trend) {
    switch(trend) {
        case TREND_UP:
            return "Up";
        case TREND_DOWN:
            return "Down";
        default:
            return "None";
    }
}