//+------------------------------------------------------------------+
//| TradeStructs.mqh                                                 |
//| Contains structures for trade and zone information               |
//+------------------------------------------------------------------+

#ifndef TRADE_STRUCTS_MQH
#define TRADE_STRUCTS_MQH

#include "PositionEnums.mqh"
#include "TrendEnums.mqh"

struct TradeActionInfo {
   string comment;
   double top;
   double bottom;
   PositionTypes postionType;
};

struct ZoneInfo {
   ENUM_TIMEFRAMES zoneTimeframe;
   string name;
   double top;
   double bottom;
   double midPrice;
   TrendDirection trend;
   datetime startTime;
};

#endif // TRADE_STRUCTS_MQH
