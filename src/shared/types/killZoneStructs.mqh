//+------------------------------------------------------------------+
//| KillZoneStructs.mqh                                              |
//| Defines structures for kill zone information                     |
//+------------------------------------------------------------------+

#ifndef KILLZONE_STRUCTS_MQH
#define KILLZONE_STRUCTS_MQH

#include "KillZoneEnums.mqh"

struct KillZoneInfo {
    datetime startTime;
    datetime endTime;
    string killZoneName;
    double priceTop;
    double priceBottom;
    KillZoneTypes killZoneType;
};

#endif // KILLZONE_STRUCTS_MQH
