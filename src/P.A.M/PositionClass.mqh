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
    //| Close all open positions                                         |
    //+------------------------------------------------------------------+
    void CloseAllOpenPositions() {
        bool result;
        
        for(int i = ArraySize(positions) - 1; i >= 0; i--) {
            ulong ticket = positions[i].ticket;
            result = ClosePosition(ticket);
            
            if(result) {
                PrintFormat("Closed position %d for symbol %s successfully.", ticket, positions[i].symbol);
            } else {
                PrintFormat("Failed to close position %d for symbol %s.", ticket, positions[i].symbol);
            }
        }
        
        ArrayResize(positions, 0);
    }

    //+------------------------------------------------------------------+
    //| Check and manage pending orders                                  |
    //+------------------------------------------------------------------+
    // void ManagePendingOrders() {
    //     int totalOrders = OrdersTotal();
    //     datetime oldestTime = TimeCurrent(); // Get current server time
    //     ulong oldestTicket = 0;
        
    //     // Iterate through all orders to find the oldest pending order
    //     for (int i = 0; i < totalOrders; i++) {
    //         if (OrderSelect(i, SELECT_BY_POS)) {
    //             if (OrderType() <= ORDER_TYPE_SELL_STOP && OrderSymbol() == Symbol()) {
    //                 if (OrderTime() < oldestTime) {
    //                     oldestTime = OrderTime();
    //                     oldestTicket = OrderTicket();
    //                 }
    //             }
    //         }
    //     }
        
    //     // Check if the oldest order is older than 3 hours
    //     if (TimeCurrent() - oldestTime > 3 * 60 * 60) {
    //         // If the oldest order is older than 3 hours, delete it
    //         if (oldestTicket != 0) {
    //             if (!OrderDelete(oldestTicket)) {
    //                 Print("Failed to delete order ", oldestTicket, ": ", GetLastError());
    //             } else {
    //                 Print("Deleted old order ", oldestTicket);
    //             }
    //         }
    //     }
        
    //     // Ensure only one pending order exists at any time
    //     // This logic assumes you want to keep only the latest pending order
    //     if (OrdersTotal() > 1) {
    //         for (int i = 0; i < OrdersTotal(); i++) {
    //             if (OrderSelect(i, SELECT_BY_POS) && OrderTicket() != oldestTicket && OrderType() <= ORDER_TYPE_SELL_STOP) {
    //                 if (!OrderDelete(OrderTicket())) {
    //                     Print("Failed to delete extra order ", OrderTicket(), ": ", GetLastError());
    //                 } else {
    //                     Print("Deleted extra pending order ", OrderTicket());
    //                 }
    //             }
    //         }
    //     }
    // }




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
            if (type == SELL_NOW) {
                SellNow(lotSize, stopLoss, takeProfit, message);
            } else if (type == BUY_NOW) {
                BuyNow(lotSize, stopLoss, takeProfit, message);
            } else if (type == SELL_STOP) {
                SellStop(lotSize, price, stopLoss, takeProfit, 0, message);
            }
        }
    }
    
};
