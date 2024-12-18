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
#include "PatternRecognition.mqh"

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
      static datetime lastProcessedTime = 0;

      datetime currentTime = iTime(Symbol(), PERIOD_H1, 0);
      if (currentTime == lastProcessedTime) {
          return;
      }
      lastProcessedTime = currentTime;

      double prices[];
      ArraySetAsSeries(prices, true);
      if (CopyClose(Symbol(), PERIOD_H1, 0, 50, prices) <= 0) {
          Print("Error: Unable to fetch price data.");
          return;
      }

      int peak1, trough, peak2;
      if (PatternRecognition::IsMTop(prices, peak1, trough, peak2)) {
          Print("M Top detected at peaks: ", peak1, ", ", peak2, " and trough: ", trough);
          // Draw pattern on chart
          DrawHorizontalLineWithLabel(trough, clrOrange, 0, "LABEL", IntegerToString(trough));
      }

      int trough1, peak, trough2;
      if (PatternRecognition::IsWBottom(prices, trough1, peak, trough2)) {
          Print("W Bottom detected at troughs: ", trough1, ", ", trough2, " and peak: ", peak);
          // Draw pattern on chart
          DrawHorizontalLineWithLabel(trough, clrBlueViolet, 0, "LABEL", IntegerToString(trough));
      }
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
