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


            if(isBuy) {
                if (close > position.takeProfitTwo + (position.takeProfitJump / 2)) {
                    // set stoploss = takeprofitTwo;
                    if (position.stopLoss != position.takeProfitTwo) {
                        if(ModifyPosition(position.ticket, position.takeProfitTwo, position.takeProfitThree)) {
                            positions[i].stopLoss = position.takeProfitTwo;
                        }
                        Print("Buy adjusted tp2");
                    }
                } else if (close > position.takeProfitTwo) {
                    // set stoploss = takeprofitOne;
                    if (position.stopLoss < position.takeProfitOne) {
                        if (ModifyPosition(position.ticket, position.takeProfitOne, position.takeProfitThree)) {
                            positions[i].stopLoss = position.takeProfitOne;
                        }
                        Print("Buy adjusted tp1");
                    }
                } else if (close > position.takeProfitOne) {
                    // set stoploss = openPrice;
                    if (position.stopLoss < adjustedOpenPrice) {
                        if (ModifyPosition(position.ticket, adjustedOpenPrice, position.takeProfitThree)) {
                            positions[i].stopLoss = adjustedOpenPrice;
                        }
                        Print("Break even hit");
                    }
                }
            } else {
                if (close < position.takeProfitTwo + (position.takeProfitJump / 2)) {
                    // set stoploss = takeprofitTwo;
                    if (position.stopLoss != position.takeProfitTwo) {
                        if (ModifyPosition(position.ticket, position.takeProfitTwo, position.takeProfitThree)) {
                            positions[i].stopLoss = position.takeProfitTwo;
                        }
                        Print("Buy adjusted tp2");
                    }
                } else if (close < position.takeProfitTwo) {
                    // set stoploss = takeprofitOne;
                    if (position.stopLoss > position.takeProfitOne) {
                        if (ModifyPosition(position.ticket, position.takeProfitOne, position.takeProfitThree)) {
                            positions[i].stopLoss = position.takeProfitOne;
                        }
                        Print("Buy adjusted tp1");
                    }
                } else if (close < position.takeProfitOne) {
                    // set stoploss = openPrice;
                    if (position.stopLoss > adjustedOpenPrice) {
                        if (ModifyPosition(position.ticket, adjustedOpenPrice, position.takeProfitThree)) {
                            positions[i].stopLoss = adjustedOpenPrice;
                        }
                        Print("Break even hit");
                    }
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
    //| Cancel all pending orders for the current symbol                 |
    //+------------------------------------------------------------------+
    void CancelAllPendingOrders() {
        int totalOrders = OrdersTotal();
        ulong orderTicket;
        ENUM_ORDER_TYPE orderType;
        string orderSymbol;

        // Iterate over all orders in a reverse manner to avoid indexing issues after deletion
        for (int i = totalOrders - 1; i >= 0; i--) {
            orderTicket = OrderGetTicket(i); // Directly get the order ticket
            orderType = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
            orderSymbol = OrderGetString(ORDER_SYMBOL);

            // Check if the order belongs to the current symbol and is a pending order
            if (orderSymbol == Symbol() && orderType >= ORDER_TYPE_BUY_LIMIT && orderType <= ORDER_TYPE_SELL_STOP_LIMIT) {
                // Try to delete the order and check for errors
                if (!ClosePendingOrder(orderTicket)) {
                    Print("Failed to delete order ", orderTicket, ": ", GetLastError());
                } else {
                    Print("Order ", orderTicket, " deleted successfully.");
                }
            }
        }
    }

    //+------------------------------------------------------------------+
    //| Handle trade                                                     |
    //+------------------------------------------------------------------+
    bool HandleTrade(PositionTypes type, double stopLoss, double price, string message = "", double customTakeProfit = 0.00){
        // Check if there is enough equity to take the trade.
        double stoplossInPips = CalculatePipDistance(stopLoss, price);
        
        if (stoplossInPips > maxPips || stoplossInPips < minPips) {
            Print("Pips out of range! - pips: ", stoplossInPips);
            return false;  
        }
        
        double lotSize;
        if(!CalculatePositionSize(risk_percent, stoplossInPips, lotSize)) {
            Print("Failed to calculate position size!");
            return false;
            }
        bool isBuy = StringFind(PositionToString(type), "Buy") != -1;
        // todo: handle more than just buy and sell
        double takeProfit = CalculateTakeProfit(price, stopLoss, customTakeProfit == 0.00 ? 3.0 : customTakeProfit, isBuy);
        // Required Margin = (Lot Size * Contract Size / Leverage) * Market Price
        double requiredEquity = getRequiredMargin(lotSize);
        double freeMargin = GetAvailableMargin();

        // todo: check this against other pairs. USDJPY seems to work correctly.
        if (requiredEquity > freeMargin) {
            Print("Not enough free margin - Required: $", requiredEquity, " - Free Margin $", freeMargin);
            return false;
        }
        
        if(enableTrading) {
            if (type == SELL_NOW) {
                return SellNow(lotSize, stopLoss, takeProfit, message);
            } else if (type == BUY_NOW) {
                return BuyNow(lotSize, stopLoss, takeProfit, message);
            } else if (type == SELL_STOP) {
                return SellStop(lotSize, price, stopLoss, takeProfit, 0, message);
            } else if (type == BUY_STOP) {
                return BuyStop(lotSize, price, stopLoss, takeProfit, 0, message);
            }
        }

        return false;
    }
    
};
