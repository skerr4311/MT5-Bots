//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//TYPES
#include "../shared/types/trendEnums.mqh"

//+------------------------------------------------------------------+
//| Common Globals                                                   |
//+------------------------------------------------------------------+
enum KeyStructureType {
    KEY_STRUCTURE_HH,
    KEY_STRUCTURE_LL
};
enum ENUM_CANDLE_PROPERTY {
    CANDLE_OPEN,
    CANDLE_CLOSE,
    CANDLE_HIGH,
    CANDLE_LOW
};

//+------------------------------------------------------------------+
//| Candle object                                                    |
//+------------------------------------------------------------------+
struct CandleInfo {
   double high;
   double low;
   double open;
   double close;
   bool isBull;
   double bottomOfTopWick;
   double topOfBottomWick;
};

//+------------------------------------------------------------------+
//| High and low of given timeframe                                  |
//+------------------------------------------------------------------+
struct HighLowTimeframe {
   double high;
   double low;
};
//+------------------------------------------------------------------+
//| Position Types                                                   |
//+------------------------------------------------------------------+
enum PositionTypes {
   SELL_NOW,
   SELL_STOP,
   SELL_LIMIT,
   BUY_NOW,
   BUY_STOP,
   BUY_LIMIT,
};
//+------------------------------------------------------------------+
//| Pip Action Types                                                 |
//+------------------------------------------------------------------+
enum PipActionTypes {
   ADD,
   SUBTRACT
};
//+------------------------------------------------------------------+
//| Pip Action Types                                                 |
//+------------------------------------------------------------------+
enum KillZoneTypes {
   LONDON,
   NEW_YORK,
   ASIAN
};

//+------------------------------------------------------------------+
//| ENUM KILLZONE TO COLOR                                           |
//+------------------------------------------------------------------+
color KillZoneToColor(KillZoneTypes kz) {
    switch(kz) {
        case LONDON:
            return clrDeepPink;
        case NEW_YORK:
            return clrBlueViolet;
        case ASIAN:
            return clrYellowGreen;
        default:
            return clrAliceBlue;
    }
}
//+------------------------------------------------------------------+
//| ENU KILLZONE TO TEXT                                             |
//+------------------------------------------------------------------+
string KillZoneTypeToString(KillZoneTypes killZoneType) {
    switch(killZoneType) {
        case LONDON: return "London";
        case NEW_YORK: return "New York";
        case ASIAN: return "Asian";
        default: return "Kill Zone";
    }
}
//+------------------------------------------------------------------+
//| TrendToString function for PositionType enum                      |
//+------------------------------------------------------------------+
string PositionToString(PositionTypes position) {
    switch(position) {
        case SELL_NOW:
            return "Sell Now";
        case SELL_STOP:
            return "Sell Stop";
        case SELL_LIMIT:
            return "Sell Limit";
        case BUY_NOW:
            return "Buy Now";
        case BUY_STOP:
            return "Buy Stop";
        case BUY_LIMIT:
            return "Buy Limit";
        default:
            return "None";
    }
}
//+------------------------------------------------------------------+
//| Trade Object                                                     |
//+------------------------------------------------------------------+
struct TradeActionInfo {
   string comment;
   double top;
   double bottom;
   PositionTypes postionType;
};
//+------------------------------------------------------------------+
//| Zone Type                                                        |
//+------------------------------------------------------------------+
struct ZoneInfo {
   ENUM_TIMEFRAMES zoneTimeframe;
   string name;
   double top;
   double bottom;
   double midPrice;
   TrendDirection trend;
   datetime startTime;
};

//+------------------------------------------------------------------+
//| KillZone Type                                                    |
//+------------------------------------------------------------------+
struct KillZoneInfo {
    datetime startTime;
    datetime endTime;
    string killZoneName;
    double priceTop;
    double priceBottom;
    KillZoneTypes killZoneType;
};