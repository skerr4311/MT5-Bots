//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| TODO                                                             |
//+------------------------------------------------------------------+

// double check the 50% mitigation logic.

// tp2 should go before tp1 logic

// Add "target amount" logic

// Add more strategies to test
  // Re-investigate fractals and using that to set a pending order.

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "TradeHandler.mqh"


//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
static input long    magicNumber = 69420; // magic number
input int lookBack = 1048; // Number of bars to look back to identify the highs and lows
input bool enableTrading = false; // Enable trading
input int maxPips = 35; // Max SL Pips 
input int minPips = 15; // Min SL Pips 

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
MqlTick currentTick;
TradeHandler tradeHandler;
string EA_Name = "P.A.M";

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
// init items here
   if(!checkParameters())
     {
      return INIT_PARAMETERS_INCORRECT;
     }

// set magic number to trade object
   trade.SetExpertMagicNumber(magicNumber);
   
   DeleteEAObjects("PAM_");
   tradeHandler.init(lookBack);
   
   Print("P.A.M: INITIALIZATION SUCCEEDED.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Print("P.A.M: DEINITIALIZATION SUCCEEDED.");
  }
 
//+------------------------------------------------------------------+
//| Expert Chart Event function                                      |
//+------------------------------------------------------------------+ 
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
    if(id == CHARTEVENT_OBJECT_CLICK) {
        tradeHandler.handleChartEvent(sparam);
    }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      tradeHandler.OnTick();
  }

//+------------------------------------------------------------------+
//| Trade transaction event handler                                  |
//+------------------------------------------------------------------+
void OnTrade()
  {
      tradeHandler.OnTrade();
  }


//+------------------------------------------------------------------+
//| Check Parameters function                                        |
//+------------------------------------------------------------------+
bool checkParameters()
  {
// check user inputs
   if(magicNumber <= 0)
     {
      Alert("Don't change the magic number");
      return false;
     }
     
   if(!ValidateTimeFormat(londonKzStart)) {
      Alert("londonKzStart not a valid time format");
      return false;
   }
   
   if(!ValidateTimeFormat(londonKzEnd)) {
      Alert("londonKzEnd not a valid time format");
      return false;
   }
   
   if(!ValidateTimeFormat(NewYorkKzStart)) {
      Alert("NewYorkKzStart not a valid time format");
      return false;
   }
   
   if(!ValidateTimeFormat(NewYorkKzEnd)) {
      Alert("NewYorkKzEnd not a valid time format");
      return false;
   }
   
   if(!ValidateTimeFormat(AsianKzStart)) {
      Alert("AsianKzStart not a valid time format");
      return false;
   }
   
   if(!ValidateTimeFormat(AsianKzEnd)) {
      Alert("AsianKzEnd not a valid time format");
      return false;
   }

   return true;
  }
  
//+------------------------------------------------------------------+
