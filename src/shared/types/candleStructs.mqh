//+------------------------------------------------------------------+
//| CandleStructs.mqh                                                |
//| Defines structures for candle-related information                |
//+------------------------------------------------------------------+

#ifndef CANDLE_STRUCTS_MQH
#define CANDLE_STRUCTS_MQH

enum ENUM_CANDLE_PROPERTY {
    CANDLE_OPEN,
    CANDLE_CLOSE,
    CANDLE_HIGH,
    CANDLE_LOW
};

struct CandleInfo {
   double high;
   double low;
   double open;
   double close;
   bool isBull;
   double bottomOfTopWick;
   double topOfBottomWick;
};

struct HighLowTimeframe {
   double high;
   double low;
};

#endif // CANDLE_STRUCTS_MQH
