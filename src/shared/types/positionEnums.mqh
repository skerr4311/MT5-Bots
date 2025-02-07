//+------------------------------------------------------------------+
//| PositionEnums.mqh                                                |
//| Contains position-related enums and utility functions            |
//+------------------------------------------------------------------+

#ifndef POSITION_ENUMS_MQH
#define POSITION_ENUMS_MQH

enum PositionTypes {
   SELL_NOW,
   SELL_STOP,
   SELL_LIMIT,
   BUY_NOW,
   BUY_STOP,
   BUY_LIMIT
};

struct Position {
    ulong ticket;
    string symbol;
    double volume;
    double openPrice;
    double stopLoss;
    double takeProfitOne;
    double takeProfitTwo;
    double takeProfitThree;
    double takeProfitJump;
    string type;
};

string PositionToString(PositionTypes position) {
    switch(position) {
        case SELL_NOW: return "Sell Now";
        case SELL_STOP: return "Sell Stop";
        case SELL_LIMIT: return "Sell Limit";
        case BUY_NOW: return "Buy Now";
        case BUY_STOP: return "Buy Stop";
        case BUY_LIMIT: return "Buy Limit";
        default: return "None";
    }
}

#endif // POSITION_ENUMS_MQH
