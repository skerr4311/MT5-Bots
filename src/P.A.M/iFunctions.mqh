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
//| check if bull candle                                             |
//+------------------------------------------------------------------+
double isBullCandle(double close, double open) {
   return close > open;
}



//+------------------------------------------------------------------+
//| get candle info                                                  |
//+------------------------------------------------------------------+
CandleInfo getCandleInfo(ENUM_TIMEFRAMES timeframe, int candleId) {
   double high = getHigh(timeframe, candleId);
   double low = getLow(timeframe, candleId);
   double open = getOpen(timeframe, candleId);
   double close = getClose(timeframe, candleId); 
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
    response.low = getLow(timeframe, index);
    response.high = getHigh(timeframe, index);
    
    for(int i = startBarIndex; i > index; i--) {
      double high = getHigh(timeframe, i);
      double low = getLow(timeframe, i);
      
      response.high = high > response.high ? high : response.high;
      response.low = low < response.low ? low : response.low;
    }
    
    return response;
}
