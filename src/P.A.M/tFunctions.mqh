//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>


// Open a market Buy order
void BuyNow(double volume, double sl = 0, double tp = 0, string comment = "")
  {
   trade.Buy(volume, Symbol(), sl, tp, 0, comment);
  }

// Open a market Sell order
void SellNow(double volume, double sl = 0, double tp = 0, string comment = "")
  {
   trade.Sell(volume, Symbol(), sl, tp, 0, comment);
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

double CalculatePositionSize(double riskPercentage, double stopLossPips) {
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    int leverage = AccountInfoInteger(ACCOUNT_LEVERAGE);
    double riskAmount = accountBalance * riskPercentage / 100.0;

    // Calculate pip value in account currency
    double pipValue = CalculatePipValue(Symbol(), accountBalance, leverage);

    // Total risk in monetary terms
    double totalRisk = stopLossPips * pipValue;

    // Position size in lots
    double positionSize = riskAmount / totalRisk;

    // Normalize to the nearest allowed lot size
    double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
    positionSize = NormalizeDouble(MathRound(positionSize / lotStep) * lotStep, _Digits);

    // Check minimum and maximum limits
    double minVolume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
    double maxVolume = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
    positionSize = MathMin(MathMax(positionSize, minVolume), maxVolume);

    return positionSize;
}

double CalculatePipValue(string symbol, double accountBalance, double leverage) {
    double pip = SymbolInfoDouble(symbol, SYMBOL_POINT);
    int digits = SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    pip = (digits == 5 || digits == 3) ? 0.00010 : 0.01;

    // Calculate the value of a pip in the quote currency
    double pipValue = pip * SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);

    // Convert pip value to account currency if necessary
    if (!IsAccountCurrencySameAsQuoteCurrency(symbol)) {
        pipValue = ConvertPipValueToAccountCurrency(pipValue, symbol);
    }

    // Adjust pip value based on leverage
    pipValue = pipValue / leverage;

    return pipValue;
}

bool IsAccountCurrencySameAsQuoteCurrency(string symbol) {
    string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
    string quoteCurrency = StringSubstr(symbol, StringLen(symbol) - 3);
    return (accountCurrency == quoteCurrency);
}

double ConvertPipValueToAccountCurrency(double pipValue, string symbol) {
    string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
    string baseCurrency = StringSubstr(symbol, 0, 3);
    string pairToCheck = baseCurrency + "/" + accountCurrency;

    if (SymbolInfoDouble(pairToCheck, SYMBOL_ASK) > 0) {
        double exchangeRate = SymbolInfoDouble(pairToCheck, SYMBOL_ASK);
        return pipValue / exchangeRate;
    } else {
        pairToCheck = accountCurrency + "/" + baseCurrency;
        if (SymbolInfoDouble(pairToCheck, SYMBOL_ASK) > 0) {
            double exchangeRate = SymbolInfoDouble(pairToCheck, SYMBOL_ASK);
            return pipValue * exchangeRate;
        }
    }

    // Return original pip value if conversion is not possible
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
    double pipSize = SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    int digits = SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);

    // Calculate the distance between entry price and stop loss
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




