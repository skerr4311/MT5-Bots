//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "CommonGlobals.mqh"
#include <Trade\Trade.mqh>
CTrade trade;

// Open a market Buy order
void BuyNow(double volume, double sl = 0, double tp = 0, string comment = "") {
   trade.Buy(volume, Symbol(), 0.0, sl, tp, comment);
}

// Open a market Sell order
void SellNow(double volume, double sl = 0, double tp = 0, string comment = "") {
   trade.Sell(volume, Symbol(), 0.0, sl, tp, comment);
}

// BuyLimit

// BuyStop

// SellLimit

// SellStop

//+------------------------------------------------------------------+
//| Count open positions function                                    |
//+------------------------------------------------------------------+
bool countOpenPositions(int &buyCount, int &sellCount)
  {

   buyCount    = 0;
   sellCount   = 0;
   int total = PositionsTotal();
   for(int i = total-1; i>=0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket<=0)
        {
         Print("Failed to get position ticket");
         return false;
        }
      if(!PositionSelectByTicket(ticket))
        {
         Print("Failed to select position");
         return false;
        }
      long magic;
      if(!PositionGetInteger(POSITION_MAGIC,magic))
        {
         Print("Failed to get position magic number");
         return false;
        }
      if(magic==magicNumber)
        {
         long type;
         if(!PositionGetInteger(POSITION_TYPE,type))
           {
            Print("Failed to get position type");
            return false;
           }
         if(type==POSITION_TYPE_BUY)
           {
            buyCount++;
           }
         if(type==POSITION_TYPE_SELL)
           {
            sellCount++;
           }
        }
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Normalize price function                                         |
//+------------------------------------------------------------------+
bool normalizePrice(double &price)
  {

   double tickSize=0;
   if(!SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE,tickSize))
     {
      Print("Failed to get tick size");
      return false;
     }
   price = NormalizeDouble(MathRound(price/tickSize)*tickSize,_Digits);

   return true;
  }


//+------------------------------------------------------------------+
//| Close all positions function                                     |
//| 0 = all; 1 = buys; 2 = sells;                                    |
//+------------------------------------------------------------------+
bool closePositions(int all_buy_sell)
  {
   int total = PositionsTotal();
   for(int i = total-1; i>=0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket<=0)
        {
         Print("Failed to get position ticket");
         return false;
        }
      if(!PositionSelectByTicket(ticket))
        {
         Print("Failed to select position");
         return false;
        }
      long magic;
      if(!PositionGetInteger(POSITION_MAGIC,magic))
        {
         Print("Failed to get position magic number");
         return false;
        }
      if(magic==magicNumber)
        {
         long type;
         if(!PositionGetInteger(POSITION_TYPE,type))
           {
            Print("Failed to get position type");
            return false;
           }
         if(all_buy_sell==1 && type==POSITION_TYPE_SELL)
           {
            continue;
           }
         if(all_buy_sell==2 && type==POSITION_TYPE_BUY)
           {
            continue;
           }
         trade.PositionClose(ticket);
         if(trade.ResultRetcode()!=TRADE_RETCODE_DONE)
           {
            Print("Failed to close position. ticket:",
                  (string)ticket, " result:", (string)trade.ResultRetcode(), ":",trade.CheckResultRetcodeDescription());
           }
        }
     }
   return true;
  }

double GetAccountBalance()
  {
   return AccountInfoDouble(ACCOUNT_BALANCE);
  }

double GetAccountEquity()
  {
   return AccountInfoDouble(ACCOUNT_EQUITY);
  }

double GetCurrentProfit()
  {
   double totalProfit = 0;
   for(int i = 0; i < PositionsTotal(); i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
        {
         totalProfit += PositionGetDouble(POSITION_PROFIT);
        }
     }
   return totalProfit;
  }

string GetAccountCurrency()
  {
   return AccountInfoString(ACCOUNT_CURRENCY);
  }

double CalculatePositionSize(double riskPercentage, double stopLossPips, double &positionSize) {
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
    double riskAmount = accountBalance * riskPercentage;

    Print("Account Balance: $", accountBalance);
    Print("Risk Amount: $", riskAmount);

    double pipValue = CalculatePipValueInAccountCurrency(Symbol(), accountCurrency);
    Print("Pip Value: $", pipValue);

    double totalRisk = stopLossPips * pipValue;
    Print("Total Risk: $", totalRisk);

    if(totalRisk == 0) {
        Print("Error: Total risk is zero.");
        return 0;
    }

    positionSize = riskAmount / totalRisk;
    Print("Raw Position Size: ", positionSize, " lots");

    double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
    double minVolume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
    double maxVolume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);

    positionSize = NormalizeDouble(MathRound(positionSize / lotStep) * lotStep, _Digits);
    positionSize = MathMin(MathMax(positionSize, minVolume), maxVolume);

    Print("Normalized Position Size: ", positionSize, " lots");
    Print("Lot Step: ", lotStep);
    Print("Min Volume: ", minVolume);
    Print("Max Volume: ", maxVolume);

    return positionSize;
}

double CalculatePipValueInAccountCurrency(string symbol, string accountCurrency) {
    double pipSize;
    int digits = SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    
    // For JPY pairs, a pip is the second decimal place (0.01), otherwise it's the fourth decimal place (0.0001)
    pipSize = (StringFind(symbol, "JPY") > -1) ? 0.01 : 0.0001;

    // Calculate the value of a pip in the quote currency
    double contractSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);
    double pipValue = pipSize * contractSize;

    // Convert pip value to account currency if necessary
    string quoteCurrency = StringSubstr(symbol, StringLen(symbol) - 3);
    if(accountCurrency != quoteCurrency) {
        string conversionSymbol = (accountCurrency == "USD" || quoteCurrency == "USD") ? 
                                  accountCurrency + quoteCurrency : quoteCurrency + "/" + accountCurrency;

        if (SymbolInfoDouble(conversionSymbol, SYMBOL_ASK) > 0) {
            double exchangeRate = SymbolInfoDouble(conversionSymbol, SYMBOL_ASK);
            pipValue = (accountCurrency == "USD" || quoteCurrency == "USD") ? pipValue / exchangeRate : pipValue * exchangeRate;
        } else {
            Print("Error: Unable to find exchange rate for ", conversionSymbol);
            return 0; // Handle this error appropriately
        }
    }

    return pipValue;
}



  
double CalculatePipDistance(double price1, double price2) {
    // Calculate the absolute difference in prices
    double difference = MathAbs(price1 - price2);

    // For most 5-digit pairs (like EURUSD), 1 pip is 0.0001
    // For 3-digit pairs (like pairs with JPY), 1 pip is 0.01
    double pipValue = (StringFind(Symbol(), "JPY") > -1) ? 0.01 : 0.0001;

    // Convert the difference to pips
    double pips = difference / pipValue;

    // Normalize to 2 decimal places for pips
    return NormalizeDouble(pips, 2);
}

// Calculate Take Profit point based on a risk-reward ratio
// Parameters:
//   double entryPrice - Entry price of the trade
//   double stopLoss - Stop loss price
//   double riskRewardRatio - Risk to reward ratio (e.g., 1:3 would be 3.0)
//   bool isBuy - Indicates if the trade is a buy (true) or sell (false)
// Returns:
//   double - Calculated take profit price
double CalculateTakeProfit(double entryPrice, double stopLoss, double riskRewardRatio, bool isBuy) {
    int digits = SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
    double pipSize = (digits == 5 || digits == 3) ? 0.00010 : 0.01;  // Adjust pip size for JPY pairs

    // Calculate the distance between entry price and stop loss in pips
    double riskDistance = MathAbs(entryPrice - stopLoss) / pipSize;

    // Calculate the take profit distance based on the risk-reward ratio
    double takeProfitDistance = riskDistance * riskRewardRatio;

    // Convert the distance back to price format
    double takeProfitPrice;
    if (isBuy) {
        // For a buy order, add the distance to the entry price
        takeProfitPrice = entryPrice + takeProfitDistance * pipSize;
    } else {
        // For a sell order, subtract the distance from the entry price
        takeProfitPrice = entryPrice - takeProfitDistance * pipSize;
    }

    // Normalize to the correct number of digits
    return NormalizeDouble(takeProfitPrice, digits);
}

void HandleTrade(PositionTypes type, double priceOffset, double price, string message = ""){
   // Check if there is enough equity to take the trade.
   
   Print(PositionToString(type));
   Print("Price: ", DoubleToString(price));
   Print("Stop loss: ", DoubleToString(priceOffset));
   
   double pips = CalculatePipDistance(priceOffset, price);
   Print("Pips: ", (string)pips);
   
   double lotSize;
   if(!CalculatePositionSize(risk_percent, pips, lotSize)) {return; }
   Print("lot size: ", (string)lotSize);
   
   double takeProfit = CalculateTakeProfit(price, priceOffset, 3.0, PositionToString(type) == "Buy Now");
   Print("takeProfit: ", (string)takeProfit);
   
   if (PositionToString(type) == "Sell Now") {
      SellNow(lotSize, priceOffset, takeProfit, message);
   } else {
      BuyNow(lotSize, priceOffset, takeProfit, message);
   }
   
}




