//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "tFunctions.mqh"
#include "iDraw.mqh"

//+------------------------------------------------------------------+
//| PositionClass                                                    |
//+------------------------------------------------------------------+
class PositionClass {
private:
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
   Position positions[];
    
public:
    // Constructor
        PositionClass() {
    }
        
    //+------------------------------------------------------------------+
    //| init class                                                       |
    //+------------------------------------------------------------------+
    void init() {
        ArrayResize(positions, 0);
    }

    //+------------------------------------------------------------------+
    //| get Position Count                                               |
    //+------------------------------------------------------------------+
    int getPositionsCount() {
        return ArraySize(positions);
    }

    //+------------------------------------------------------------------+
    //| Handle open positions                                            |
    //+------------------------------------------------------------------+
    void HandleOpenPositions() {
        for(int i = 0; i < getPositionsCount(); i++) {
            Position position = positions[i];
            double close = getClose(inputExecutionTimeframe, 0);
            int digits = SymbolInfoInteger(position.symbol, SYMBOL_DIGITS);
            bool isBuy = position.type == "Buy";
            double adjustedOpenPrice = AdjustOpenPrice(position.openPrice, digits, isBuy);
            Print("Original: ", position.openPrice, " - Altered: ", adjustedOpenPrice);

            if(isBuy) {
                if (close > position.takeProfitOne && position.stopLoss != adjustedOpenPrice) {
                    // set stoploss = openPrice;
                    ModifyPosition(position.ticket, adjustedOpenPrice, position.takeProfitThree);
                    Print("Buy adjusted tp1");
                } else if (close > position.takeProfitTwo && position.stopLoss != position.takeProfitOne) {
                    // set stoploss = takeprofitOne;
                    ModifyPosition(position.ticket, position.takeProfitOne, position.takeProfitThree);
                    Print("Buy adjusted tp2");
                }
            } else {
                if (close < position.takeProfitOne && position.stopLoss != adjustedOpenPrice) {
                    // set stoploss = openPrice;
                    ModifyPosition(position.ticket, adjustedOpenPrice, position.takeProfitThree);
                    Print("Sell adjusted tp1");
                } else if (close < position.takeProfitTwo && position.stopLoss != position.takeProfitOne) {
                    // set stoploss = takeprofitOne;
                    ModifyPosition(position.ticket, position.takeProfitOne, position.takeProfitThree);
                    Print("Sell adjusted tp2");
                }
            }
        }
    }

    //+------------------------------------------------------------------+
    //| Handle open positions                                            |
    //+------------------------------------------------------------------+
    void HandleOnTradeFunction() {
        int totalPositions = PositionsTotal();
        CPositionInfo positionInfo;
        ArrayResize(positions, 0);

        // Iterate through only open positions and pairs the advisor is looking at
        for(int i = 0; i < totalPositions; ++i) {
            if(positionInfo.SelectByIndex(i) && positionInfo.Symbol() == Symbol()) {
                double openPrice = positionInfo.PriceOpen();
                double takeProfit = positionInfo.TakeProfit();
                double takeProfitOne, takeProfitTwo, takeProfitJump;
                CalculateIntermediateTakeProfits(openPrice, takeProfit, takeProfitOne, takeProfitTwo, takeProfitJump);

                Position position;
                position.ticket = positionInfo.Ticket();
                position.symbol = positionInfo.Symbol();
                position.volume = positionInfo.Volume();
                position.openPrice = openPrice;
                position.stopLoss = positionInfo.StopLoss();
                position.takeProfitOne = takeProfitOne;
                position.takeProfitTwo = takeProfitTwo;
                position.takeProfitThree = takeProfit;
                position.takeProfitJump = takeProfitJump;
                position.type = PositionTypeToString(positionInfo.PositionType());
                ArrayResize(positions, ArraySize(positions) + 1);
                positions[ArraySize(positions) - 1] = position;
            }
        }
    }


    //+------------------------------------------------------------------+
    //| Handle trade                                                     |
    //+------------------------------------------------------------------+
    void HandleTrade(PositionTypes type, double stopLoss, double price, string message = "", double customTakeProfit = 0.00){
        // Check if there is enough equity to take the trade.
        double stoplossInPips = CalculatePipDistance(stopLoss, price);
        
        if (stoplossInPips > maxPips || stoplossInPips < minPips) {
            Print("Pips out of range! - pips: ", stoplossInPips);
            return;  
        }
        
        double lotSize;
        if(!CalculatePositionSize(risk_percent, stoplossInPips, lotSize)) {
            Print("Failed to calculate position size!");
            return;
            }
        // todo: handle more than just buy and sell
        double takeProfit = CalculateTakeProfit(price, stopLoss, customTakeProfit == 0.00 ? 3.0 : customTakeProfit, PositionToString(type) == "Buy Now");
        
        // Required Margin = (Lot Size * Contract Size / Leverage) * Market Price
        double requiredEquity = getRequiredMargin(lotSize);
        double freeMargin = GetAvailableMargin();

        // todo: check this against other pairs. USDJPY seems to work correctly.
        if (requiredEquity > freeMargin) {
            Print("Not enough free margin - Required: $", requiredEquity, " - Free Margin $", freeMargin);
            return;
        }
        
        if(enableTrading) {
            if (PositionToString(type) == "Sell Now") {
                SellNow(lotSize, stopLoss, takeProfit, message);
            } else if (PositionToString(type) == "Buy Now") {
                BuyNow(lotSize, stopLoss, takeProfit, message);
            }
        }
    }
    
};
