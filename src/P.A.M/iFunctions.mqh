//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

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
//| Delete EA Objects                                                |
//+------------------------------------------------------------------+
void DeleteEAObjects(string prefix) {
    int totalObjects = ObjectsTotal(0);
    for(int i = totalObjects - 1; i >= 0; i--) {
        string name = ObjectName(0, i);
        if(StringFind(name, prefix) == 0) { // Check if the name starts with the prefix
            ObjectDelete(0, name);
        }
    }
}