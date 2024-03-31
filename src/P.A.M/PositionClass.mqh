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
      ulong id;
      double stopLoss;
      double takeProfitOne;
      double takeProfitTwo;
      double takeProfitThree;
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
    //| get Take profit one & two                                        |
    //+------------------------------------------------------------------+
    void CalculateIntermediateTakeProfits(double currentPrice, double finalTakeProfit, double &takeProfitOne, double &takeProfitTwo) {
        double totalDistance = finalTakeProfit - currentPrice;
        double oneThirdDistance = totalDistance / 3;
        double twoThirdsDistance = 2 * totalDistance / 3;

        takeProfitOne = currentPrice + oneThirdDistance;
        takeProfitTwo = currentPrice + twoThirdsDistance;

        DrawHorizontalLineWithLabel(takeProfitOne, clrGreen, 0, "tp1", STYLE_DOT);
        DrawHorizontalLineWithLabel(takeProfitTwo, clrGreen, 0, "tp2", STYLE_DOT);
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
        double freeMargin = AccountInfoDouble(ACCOUNT_FREEMARGIN);

        // todo: check this against other pairs. USDJPY seems to work correctly.
        if (requiredEquity > freeMargin) {
            Print("Not enough free margin - Required: $", requiredEquity, " - Free Margin $", freeMargin);
            return;
        }

        Print("required equity: ", requiredEquity);

        ulong positionId = 0;
        double takeProfitOne, takeProfitTwo = takeProfit;
        
        if(enableTrading) {
            if (PositionToString(type) == "Sell Now") {
                positionId = SellNow(lotSize, stopLoss, takeProfit, message);
            } else if (PositionToString(type) == "Buy Now") {
                positionId = BuyNow(lotSize, stopLoss, takeProfit, message);
            }
        }

        if (positionId > 0) {
            CalculateIntermediateTakeProfits(price, takeProfit, takeProfitOne, takeProfitTwo);
            Position position;
            position.id = positionId;
            position.stopLoss = stopLoss;
            position.takeProfitOne = takeProfitOne;
            position.takeProfitTwo = takeProfitTwo;
            position.takeProfitThree = takeProfit;
            ArrayResize(positions, ArraySize(positions) + 1);
            positions[ArraySize(positions) - 1] = position;
        } else {
            Print("Failed to open position. Error code: ", GetLastError());
        }
    
    }
    
};
