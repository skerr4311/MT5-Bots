//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "../types/candleStructs.mqh"
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

//+------------------------------------------------------------------+
//| Validates time format "[number][number]:[number][number]"        |
//+------------------------------------------------------------------+ 
bool ValidateTimeFormat(string inputTime) {
    // Check if the input string length is exactly 5 characters (HH:MM)
    if(StringLen(inputTime) != 5) return false;
    
    // Check if the colon is in the correct position
    if(StringGetCharacter(inputTime, 2) != ':') return false;
    
    // Extract hours and minutes as strings
    string strHour = StringSubstr(inputTime, 0, 2);
    string strMinute = StringSubstr(inputTime, 3, 2);
    
    // Convert strings to numbers
    int hour = StringToInteger(strHour);
    int minute = StringToInteger(strMinute);
    
    // Validate hour and minute ranges
    if(hour < 0 || hour > 23) return false;
    if(minute < 0 || minute > 59) return false;
    
    // If all checks pass, the format is valid
    return true;
}
