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
//| get candle value                                                 |
//+------------------------------------------------------------------+
double getCandleValue(ENUM_TIMEFRAMES timeframe, int candleId, ENUM_CANDLE_PROPERTY property) {
    switch (property) {
        case CANDLE_OPEN: return iOpen(Symbol(), timeframe, candleId);
        case CANDLE_CLOSE: return iClose(Symbol(), timeframe, candleId);
        case CANDLE_HIGH: return iHigh(Symbol(), timeframe, candleId);
        case CANDLE_LOW: return iLow(Symbol(), timeframe, candleId);
        default: return 0.0;
    }
}

//+------------------------------------------------------------------+
//| check if bull candle                                             |
//+------------------------------------------------------------------+
double isBullCandle(double close, double open) {
   return close > open;
}



//+------------------------------------------------------------------+
//| get candle info                                                  |
//+------------------------------------------------------------------+
CandleInfo getCandleInfo(ENUM_TIMEFRAMES timeframe, int candleId) {
   double high = getCandleValue(timeframe, candleId, CANDLE_HIGH);
   double low = getCandleValue(timeframe, candleId, CANDLE_LOW);
   double open = getCandleValue(timeframe, candleId, CANDLE_OPEN);
   double close = getCandleValue(timeframe, candleId, CANDLE_CLOSE); 
   bool isBull = isBullCandle(close, open);
   double bottomOfTopWick = isBull ? close : open;
   double topOfBottomWick = isBull ? open : close;

   CandleInfo info;
   info.close = close;
   info.high = high;
   info.isBull = isBull;
   info.low = low;
   info.open = open;
   info.bottomOfTopWick = bottomOfTopWick;
   info.topOfBottomWick = topOfBottomWick;

   return info;
}

//+------------------------------------------------------------------+
//| check if Wicked below ema                                        |
//+------------------------------------------------------------------+
bool isCandleWickedBelowTrendEma(int candleId) {
   CandleInfo candle = getCandleInfo(inputTrendTimeframe, candleId);
   double fiftyEMA = GetEMAForBar(candleId, inputTrendTimeframe, 50);

   return candle.high > fiftyEMA && candle.close < fiftyEMA;
}

//+------------------------------------------------------------------+
//| check if Wicked above ema                                        |
//+------------------------------------------------------------------+
bool isCandleWickedAboveTrendEma(int candleId) {
   CandleInfo candle = getCandleInfo(inputTrendTimeframe, candleId);
   double fiftyEMA = GetEMAForBar(candleId, inputTrendTimeframe, 50);

   return candle.low < fiftyEMA && candle.close > fiftyEMA;
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

// Function to get the lowest price from a given start time within a specific timeframe
HighLowTimeframe GetLowestPriceFromStartTime(ENUM_TIMEFRAMES timeframe, datetime startTime, int index) {
    // Find the bar index for the given start time
    int startBarIndex = iBarShift(Symbol(), timeframe, startTime, true);
    
    // Check if startBarIndex is valid
    if(startBarIndex == -1) {
        Print("Error: Start time is beyond the available data.");
    }
    
    HighLowTimeframe response;
    response.low = getCandleValue(timeframe, index, CANDLE_LOW);
    response.high = getCandleValue(timeframe, index, CANDLE_HIGH);
    
    for(int i = startBarIndex; i > index; i--) {
      double high = getCandleValue(timeframe, i, CANDLE_HIGH);
      double low = getCandleValue(timeframe, i, CANDLE_LOW);
      
      response.high = high > response.high ? high : response.high;
      response.low = low < response.low ? low : response.low;
    }
    
    return response;
}
