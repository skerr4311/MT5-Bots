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
//| Functions Designed to simpliyp mq5 functions                     |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| get Time of candle                                               |
//+------------------------------------------------------------------+
datetime getTime(ENUM_TIMEFRAMES timeframe, int candleId) {
   return iTime(Symbol(), timeframe, candleId);
}
  
//+------------------------------------------------------------------+
//| get High of candle                                               |
//+------------------------------------------------------------------+
double getHigh(ENUM_TIMEFRAMES timeframe, int candleId) {
   return iHigh(Symbol(), timeframe, candleId);
}

//+------------------------------------------------------------------+
//| get low of candle                                                |
//+------------------------------------------------------------------+
double getLow(ENUM_TIMEFRAMES timeframe, int candleId) {
   return iLow(Symbol(), timeframe, candleId);
}

//+------------------------------------------------------------------+
//| get Open of candle                                               |
//+------------------------------------------------------------------+
double getOpen(ENUM_TIMEFRAMES timeframe, int candleId) {
   return iOpen(Symbol(), timeframe, candleId);
}

//+------------------------------------------------------------------+
//| get Close of candle                                              |
//+------------------------------------------------------------------+
double getClose(ENUM_TIMEFRAMES timeframe, int candleId) {
   return iClose(Symbol(), timeframe, candleId);
}

//+------------------------------------------------------------------+
//| check if bear candle                                             |
//+------------------------------------------------------------------+
double isBearCandle(ENUM_TIMEFRAMES timeframe, int candleId) {
   double close = getClose(timeframe, candleId);
   double open = getOpen(timeframe, candleId);
   
   return close > open;
}

//+------------------------------------------------------------------+
//| get candle info                                                  |
//+------------------------------------------------------------------+
CandleInfo getCandleInfo(ENUM_TIMEFRAMES timeframe, int candleId) {
   CandleInfo info;
   info.close = getClose(timeframe, candleId);
   info.high = getHigh(timeframe, candleId);
   info.isBull = !isBearCandle(timeframe, candleId);
   info.low = getLow(timeframe, candleId);
   info.open = getOpen(timeframe, candleId);

   return info;
}

//+------------------------------------------------------------------+
//| isLondonInitiated                                                |
//+------------------------------------------------------------------+
bool isLondonInitiated() {
   return londonKzStart != "00:00" && londonKzEnd != "00:00";
}

//+------------------------------------------------------------------+
//| isNewYorkInitiated                                               |
//+------------------------------------------------------------------+
bool isNewYorkInitiated() {
   return NewYorkKzStart != "00:00" && NewYorkKzEnd != "00:00";
}

//+------------------------------------------------------------------+
//| isAsiaInitiated                                                  |
//+------------------------------------------------------------------+
bool isAsiaInitiated() {
   return AsianKzStart != "00:00" && AsianKzEnd != "00:00";
}