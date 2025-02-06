//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//TYPES
#include "../shared/types/candleStructs.mqh"
#include "../shared/types/tradeStructs.mqh"

//+------------------------------------------------------------------+
//| Common Globals                                                   |
//+------------------------------------------------------------------+
enum KeyStructureType {
    KEY_STRUCTURE_HH,
    KEY_STRUCTURE_LL
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