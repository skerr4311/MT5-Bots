//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| TODO                                                             |
//+------------------------------------------------------------------+

// double check the 50% mitigation logic.

// prepare for writing buy / sell logic.

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "TradeHandler.mqh"

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
static input long    magicNumber = 69420; // magic number
input int lookBack = 1048; // Number of bars to look back to identify the highs and lows
input bool enableTrading = true; // Enable trading
input int maxPips = 25; // Max SL Pips 
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
//| Validates time format "[number][number]:[number][number]"        |
//+------------------------------------------------------------------+ 
bool ValidateTimeFormat(string inputTime) {
    // Check if the input string length is exactly 5 characters (HH:MM)
    if(StringLen(inputTime) != 5) return false;
    
    // Check if the colon is in the correct position
    if(StringGetCharacter(inputTime, 2) != ':') return false;
    
    // Extract hours and minutes as strings
    string strHour = StringSubstr(inputTime, 0, 2);
    string strMinute = StringSubstr(inputTime, 3, 2);
    
    // Convert strings to numbers
    int hour = StringToInteger(strHour);
    int minute = StringToInteger(strMinute);
    
    // Validate hour and minute ranges
    if(hour < 0 || hour > 23) return false;
    if(minute < 0 || minute > 59) return false;
    
    // If all checks pass, the format is valid
    return true;
}
//+------------------------------------------------------------------+
