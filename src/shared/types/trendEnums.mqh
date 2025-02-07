//+------------------------------------------------------------------+
//| TrendEnums.mqh                                                   |
//| Contains trend-related enums and utility functions               |
//+------------------------------------------------------------------+

#ifndef TREND_ENUMS_MQH
#define TREND_ENUMS_MQH

enum KeyStructureType {
    KEY_STRUCTURE_HH,
    KEY_STRUCTURE_LL
};

enum TrendDirection {
   TREND_NONE = 0,
   TREND_UP,
   TREND_DOWN
};

string TrendToString(TrendDirection trend) {
    switch(trend) {
        case TREND_UP: return "Up";
        case TREND_DOWN: return "Down";
        default: return "None";
    }
}

#endif // TREND_ENUMS_MQH
