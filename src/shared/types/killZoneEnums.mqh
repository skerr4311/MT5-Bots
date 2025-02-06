//+------------------------------------------------------------------+
//| KillZoneEnums.mqh                                                |
//| Contains kill zone-related enums and functions                   |
//+------------------------------------------------------------------+

#ifndef KILLZONE_ENUMS_MQH
#define KILLZONE_ENUMS_MQH

enum KillZoneTypes {
   LONDON,
   NEW_YORK,
   ASIAN
};

color KillZoneToColor(KillZoneTypes kz) {
    switch(kz) {
        case LONDON: return clrDeepPink;
        case NEW_YORK: return clrBlueViolet;
        case ASIAN: return clrYellowGreen;
        default: return clrAliceBlue;
    }
}

string KillZoneTypeToString(KillZoneTypes killZoneType) {
    switch(killZoneType) {
        case LONDON: return "London";
        case NEW_YORK: return "New York";
        case ASIAN: return "Asian";
        default: return "Kill Zone";
    }
}

#endif // KILLZONE_ENUMS_MQH
