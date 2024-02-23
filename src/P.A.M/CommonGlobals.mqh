//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

input ENUM_TIMEFRAMES inputTrendTimeframe = PERIOD_H1; // Trend timeframe
input ENUM_TIMEFRAMES inputExecutionTimeframe = PERIOD_M15; // Execution timeframe
input double risk_percent = 0.01; // Risk %
input string londonKzStart = "09:30"; // London KZ Start
input string londonKzEnd = "12:00"; // London KZ End
input string NewYorkKzStart = "15:00"; // NewYork KZ Start
input string NewYorkKzEnd = "17:30"; // NewYork KZ End
input string AsianKzStart = "00:00"; // Asian KZ Start
input string AsianKzEnd = "00:00"; // Asian KZ End

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
//+------------------------------------------------------------------+
//| Candle object                                                    |
//+------------------------------------------------------------------+
struct CandleInfo {
   double high;
   double low;
   double open;
   double close;
   bool isBull;
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
        case LONDON: return "London KZ";
        case NEW_YORK: return "New York KZ";
        case ASIAN: return "Asian KZ";
        default: return "Kill Zone";
    }
}
//+------------------------------------------------------------------+
//| EnumToString function for PositionType enum                      |
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