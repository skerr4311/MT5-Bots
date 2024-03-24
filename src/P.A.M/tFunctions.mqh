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

//+------------------------------------------------------------------+
//| Get Account Balance                                              |
//+------------------------------------------------------------------+
double GetAccountBalance()
  {
   return AccountInfoDouble(ACCOUNT_BALANCE);
  }
  
//+------------------------------------------------------------------+
//| Get account equity                                               |
//+------------------------------------------------------------------+
double GetAccountEquity()
  {
   return AccountInfoDouble(ACCOUNT_EQUITY);
  }

//+------------------------------------------------------------------+
//| Get current profit                                               |
//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
//| Get account currency                                             |
//+------------------------------------------------------------------+
string GetAccountCurrency()
  {
   return AccountInfoString(ACCOUNT_CURRENCY);
  }

//+------------------------------------------------------------------+
//| Calculate position size                                          |
//+------------------------------------------------------------------+
double CalculatePositionSize(double riskPercentage, double stopLossPips, double &positionSize) {
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
    double riskAmount = accountBalance * riskPercentage;

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

    return positionSize;
}

//+------------------------------------------------------------------+
//| Calculate pip value in account currency                          |
//+------------------------------------------------------------------+
double CalculatePipValueInAccountCurrency(string symbol, string accountCurrency) {
    double pipValue = 0.0;
    double exchangeRate = SymbolInfoDouble(symbol, SYMBOL_ASK);
    int digits = SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    string baseCurrency = StringSubstr(symbol, 0, 3);
    string quoteCurrency = StringSubstr(symbol, StringLen(symbol) - 3);
    double contractSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);

    // Determine pip size based on the currency pair
    double pipSize = (digits == 3 || digits == 5) ? 0.0001 : 0.01;

    // Calculate the pip value in the quote currency
    pipValue = (quoteCurrency == "JPY" || digits == 3) ? pipSize * contractSize * 0.01 : pipSize * contractSize;

    // Convert pip value to account currency if necessary
    if(quoteCurrency != accountCurrency) {
        // Direct conversion for USD involved pairs
        if(accountCurrency == "USD" || quoteCurrency == "USD") {
            string conversionSymbol = (quoteCurrency == "USD") ? baseCurrency + "USD" : "USD" + quoteCurrency;
            double conversionRate = SymbolInfoDouble(conversionSymbol, SYMBOL_ASK);
            pipValue = (quoteCurrency == "USD") ? pipValue / conversionRate : pipValue * conversionRate;
        }
        // Indirect conversion for non-USD pairs
        else {
            // Convert from quote to USD
            string quoteToUSD = quoteCurrency + "USD";
            double quoteToUSDConversionRate = SymbolInfoDouble(quoteToUSD, SYMBOL_ASK);
            double pipValueInUSD = pipValue / quoteToUSDConversionRate;

            // Convert from USD to account currency
            string usdToAccountCurrency = "USD" + accountCurrency;
            double usdToAccountCurrencyRate = SymbolInfoDouble(usdToAccountCurrency, SYMBOL_ASK);
            pipValue = pipValueInUSD * usdToAccountCurrencyRate;
        }
    }

    return pipValue;
}

//+------------------------------------------------------------------+
//| Calculate pip distance                                           |
//+------------------------------------------------------------------+
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

//+------------------------------------------------------------------+
//| Adjust price by pip size                                         |
//+------------------------------------------------------------------+
double AdjustPriceByPipSize(double price, int pips, PipActionTypes action ) {
    long digits = SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
    double pipSize = (digits == 5 || digits == 3) ? 0.00010 : 0.01;
    
    if (action == ADD) {
      return price + (pipSize * pips);
    }
    
    return price - (pipSize * pips);
}

//+------------------------------------------------------------------+
//| Calculate take profit                                            |
//+------------------------------------------------------------------+
double CalculateTakeProfit(double entryPrice, double stopLoss, double riskRewardRatio, bool isBuy) {
    long digits = SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
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

//+------------------------------------------------------------------+
//| Calculate spread                                                 |
//+------------------------------------------------------------------+
double CalculateSpread() {
    // Ensure the symbol's prices are updated
    if (!SymbolInfoTick(Symbol(), MqlTick())) {
        Print("Failed to get symbol info for ", Symbol());
        return -1; // Return an error code
    }

    // Get Ask and Bid prices
    double askPrice = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
    double bidPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);

    // Calculate the difference between Ask and Bid
    double spread = askPrice - bidPrice;

    // Determine the pip size
    double pipSize = SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    long digits = SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
    if (digits == 3 || digits == 5) {
        pipSize *= 10; // For JPY pairs and pairs with 5 decimal places
    }

    // Convert the spread to pips
    double spreadPips = spread / pipSize;

    // Return the spread in pips
    return spreadPips;
}

//+------------------------------------------------------------------+
//| Get required margin for a given lot size in account currency     |
//+------------------------------------------------------------------+
double getRequiredMargin(double lotSize) {
    string currentPair = Symbol();
    int leverage = AccountInfoInteger(ACCOUNT_LEVERAGE);
    string accountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
    double contractSize = SymbolInfoDouble(currentPair, SYMBOL_TRADE_CONTRACT_SIZE);
    
    // Extract base and quote currencies from the symbol
    string baseCurrency = StringSubstr(currentPair, 0, 3);
    string quoteCurrency = StringSubstr(currentPair, StringLen(currentPair) - 3);

    // Initial required margin calculation in the base currency
    double requiredMarginBaseCurrency = (lotSize * contractSize) / leverage;

    // If the account currency matches the base currency, no conversion is needed
    if(accountCurrency == baseCurrency) {
        return requiredMarginBaseCurrency;
    }

    // Conversion rate to account currency
    double conversionRate = 1.0; // Default to 1.0 for direct matches

    // If the account currency is the same as the quote currency
    if(accountCurrency == quoteCurrency) {
        // Convert required margin from base to quote currency using the current price
        double price = SymbolInfoDouble(currentPair, SYMBOL_BID); // Use bid price for selling
        conversionRate = price;
    } else {
        // If account currency differs from both base and quote currency, find conversion rate
        string conversionPairBase = baseCurrency + accountCurrency; // Base to Account
        string conversionPairQuote = quoteCurrency + accountCurrency; // Quote to Account
        
        if(SymbolInfoDouble(conversionPairBase, SYMBOL_BID) > 0) {
            Print("if!!!!!");
            conversionRate = SymbolInfoDouble(conversionPairBase, SYMBOL_BID);
        } else if(SymbolInfoDouble(conversionPairQuote, SYMBOL_BID) > 0) {
            Print("else!!!!");
            conversionRate = 1.0 / SymbolInfoDouble(conversionPairQuote, SYMBOL_ASK); // Use ask price for buying
        } else {
            Print("Error: Unable to find a suitable conversion rate.");
            return -1; // Error handling
        }
    }

    // Convert the required margin to the account currency
    double requiredMarginAccountCurrency = requiredMarginBaseCurrency * conversionRate;

    return requiredMarginAccountCurrency;
}


//+------------------------------------------------------------------+
//| Handle trade                                                     |
//+------------------------------------------------------------------+
void HandleTrade(PositionTypes type, double priceOffset, double price, string message = "", double customTakeProfit = 0.00){
   // Check if there is enough equity to take the trade.
   double stoplossInPips = CalculatePipDistance(priceOffset, price);
   Print("stoplossInPips: ", (string)stoplossInPips);
   
   
   if (stoplossInPips > maxPips || stoplossInPips < minPips) {
      Print("Pips out of range! - pips: ", stoplossInPips);
      return;  
   }
   
   double lotSize;
   if(!CalculatePositionSize(risk_percent, stoplossInPips, lotSize)) {
      Print("Failed to calculate position size!");
      return;
    }
   Print("lot size: ", (string)lotSize);
   
   double takeProfit = customTakeProfit == 0.00 ? CalculateTakeProfit(price, priceOffset, 3.0, PositionToString(type) == "Buy Now") : customTakeProfit;
   Print("takeProfit: ", (string)takeProfit);
   
   // Required Margin = (Lot Size * Contract Size / Leverage) * Market Price
   double requiredEquity = getRequiredMargin(lotSize);
   
   Print("Required Equity: ", requiredEquity);
   
   if(enableTrading) {
      if (PositionToString(type) == "Sell Now") {
         SellNow(lotSize, priceOffset, takeProfit, message);
      } else {
         BuyNow(lotSize, priceOffset, takeProfit, message);
      }
   }
   
}
