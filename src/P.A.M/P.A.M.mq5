//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
static input long    magicNumber = 69420; // magic number
input int lookBack = 128; // Number of bars to look back to identify the highs and lows

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
MqlTick currentTick;
CTrade trade;
double highPrices[];
double lowPrices[];
datetime barTimes[];
datetime marketStructureExecutionTime;
double highestHigh = 0, highestLow = 0, lowestLow = 0, lowestHigh = 0;
double prevLL = 0, prevLH = 0, prevHH = 0, prevHL = 0;
bool isLowerLowReveseStarted = false, isHigherHighReverseStarted = false;
int indexLL = 0, indexHH = 0;
double lastHigh = 0, lastLow = 0;
enum TrendDirection
  {
   TREND_NONE = 0,
   TREND_UP,
   TREND_DOWN
  };
TrendDirection currentTrend = TREND_NONE;
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

// Resize arrays to the required size
   ArraySetAsSeries(highPrices, true);
   ArraySetAsSeries(lowPrices, true);
   ArraySetAsSeries(barTimes, true);
   ArrayResize(highPrices, lookBack + 1);
   ArrayResize(lowPrices, lookBack + 1);
   ArrayResize(barTimes, lookBack + 1);
   
   SetInitialMarketTrend();
   
   if(CopyTime(_Symbol, PERIOD_H1, 0, lookBack + 1, barTimes) <= 0)
     {
      Print("Failed to copy bar times: ", GetLastError());
      return INIT_FAILED;
     }
     
   marketStructureExecutionTime = barTimes[0];
   
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   IdentifyMarketStructure(1, PERIOD_H1);
   UpdateInfoBox();
  }
  
//+------------------------------------------------------------------+
//| Get H1 Market trend                                              |
//+------------------------------------------------------------------+
void SetInitialMarketTrend() {
   // run the bot in the past 26 candles
   highestHigh = iHigh(_Symbol, PERIOD_H1, lookBack + 1);
   lowestLow = iLow(_Symbol, PERIOD_H1, lookBack + 1);

   for(int i = lookBack; i >= 0; i--) {
      IdentifyMarketStructure(i,PERIOD_H1);
   }
}

//+------------------------------------------------------------------+
//| Function to create or update the information box                 |
//+------------------------------------------------------------------+
void UpdateInfoBox() {
    Comment(EA_Name, "\nTrend: ", EnumToString(currentTrend),
           "\nhighestHigh: ", (string)highestHigh,
           "\nlowestLow: ", (string)lowestLow,
           "\nlast high: ", (string)lastHigh,
           "\nlast low: ", (string)lastLow);
}

//+------------------------------------------------------------------+
//| EnumToString function for TrendDirection enum                    |
//+------------------------------------------------------------------+
string EnumToString(TrendDirection trend) {
    switch(trend) {
        case TREND_UP:
            return "Up";
        case TREND_DOWN:
            return "Down";
        default:
            return "None";
    }
}

//+------------------------------------------------------------------+
//| Function to Identify Market Structure                            |
//+------------------------------------------------------------------+
void IdentifyMarketStructure(int candleId, ENUM_TIMEFRAMES timeframe)
  {
  if(CopyTime(_Symbol, timeframe, 0, lookBack + 1, barTimes) <= 0)
     {
      Print("Failed to copy bar times: ", GetLastError());
      return;
     }
   
   if (barTimes[candleId] != marketStructureExecutionTime) {
   
      marketStructureExecutionTime = barTimes[candleId];
      double currentHigh = iHigh(Symbol(), timeframe, candleId);
      double currentLow = iLow(Symbol(), timeframe, candleId);
   
      // Logic to identify Higher High, Higher Low, Lower Low, Lower High
      if (currentTrend == TREND_UP) {
         if (currentHigh > highestHigh) {
            highestHigh = currentHigh;
            highestLow = currentLow;
            if (indexHH != 0 && isHigherHighReverseStarted) {
               // set HH
               int newHigherHighIndex = candleId + indexHH + 1;
               double newHigherHigh = iHigh(Symbol(), timeframe, newHigherHighIndex);
               DrawLabel("HH", newHigherHigh, newHigherHighIndex);
               prevHH = newHigherHigh;
               int newHigherLowIndex = candleId;
               double newHigherLow = iLow(Symbol(), timeframe, newHigherLowIndex);
               
               for(int i = candleId; i <= newHigherHighIndex; i++) {
                  double tempHigherLow = iLow(Symbol(), timeframe, i);
                  if (tempHigherLow < newHigherLow) {
                     newHigherLowIndex = i;
                     newHigherLow = tempHigherLow;
                  }
               }
               
               DrawLabel("HL", newHigherLow, newHigherLowIndex);
               prevHL = newHigherLow;
               isHigherHighReverseStarted = false;
            
            }
            indexHH = 0;
         } else if (currentHigh < highestHigh) {
            // DO NOTHING FOR NOW
            isHigherHighReverseStarted = true;
            indexHH++;
         } else {
            indexHH++;
         }
      } else if (currentTrend == TREND_DOWN) {
         if (currentLow < lowestLow) {
            lowestLow = currentLow;
            lowestHigh = currentHigh;
            if (indexLL != 0 && isLowerLowReveseStarted) {
               // set LL
               int newLowerLowIndex = candleId + indexLL + 1;
               double newLowerLow = iLow(Symbol(), timeframe, newLowerLowIndex);
               DrawLabel("LL", newLowerLow, newLowerLowIndex);
               prevLL = newLowerLow;
               int newLowerHighIndex = candleId;
               double newLowerHigh = iHigh(Symbol(), timeframe, newLowerHighIndex);
               
               for(int i = candleId; i <= newLowerLowIndex; i++) {
                  double tempLowerHigh = iHigh(Symbol(), timeframe, i);
                  if (tempLowerHigh > newLowerHigh) {
                     newLowerHighIndex = i;
                     newLowerHigh = tempLowerHigh;
                  }
               }
               
               DrawLabel("LH", newLowerHigh, newLowerHighIndex);
               prevLH = newLowerHigh;
               isLowerLowReveseStarted = false;
            }
            indexLL = 0;
         } else if (currentHigh > lowestHigh) {
            // DO NOTHING FOR NOW.
            isLowerLowReveseStarted = true;
            indexLL++;
         } else {
            indexLL++;
         }
      } else {
         // There is no trend for now. or trend unknown.
         if (currentHigh > highestHigh) {
            currentTrend = TREND_UP;
            highestHigh = currentHigh;
            highestLow = currentLow;
         } else if (currentLow < lowestLow) {
            currentTrend = TREND_DOWN;
            lowestLow = currentLow;
            prevLL = currentLow;
            lowestHigh = currentHigh;
            prevLH = currentHigh;
         }
      }
    }
    
    handleChangeOfCharecter(candleId, timeframe);
  }
  
//+------------------------------------------------------------------+
//| Check for CHoCH                                                  |
//+------------------------------------------------------------------+
void handleChangeOfCharecter(int candleId, ENUM_TIMEFRAMES timeframe) {
   if(currentTrend == TREND_DOWN) {
      // check for choch and reset needed variables
      double currentHigh = iHigh(Symbol(), timeframe, candleId);
      if(currentHigh > prevLH) {
         // confirmed choch
         double currentLow = iLow(Symbol(), timeframe, candleId);
         DrawHorizontalLineWithLabel(prevLH, clrRed, candleId, "CHoCH");
         currentTrend = TREND_UP;
         highestHigh = currentHigh;
         prevHH = currentHigh;
         highestLow = currentLow;
         prevHL = currentLow;
         indexLL = 0;
         
      }
   } else if (currentTrend == TREND_UP) {
      // check for choch and reset needed variables
      double currentLow = iLow(Symbol(), timeframe, candleId);
      Print("condition: ", (string)currentLow, (string)prevHL);
      if(currentLow < prevHL) {
         // confirmed choch
         Print("currentLow < prevHL");
         double currentHigh = iHigh(Symbol(), timeframe, candleId);
         DrawHorizontalLineWithLabel(prevLH, clrRed, candleId, "CHoCH");
         currentTrend = TREND_DOWN;
         lowestLow = currentLow;
         prevLL = currentLow;
         lowestHigh = currentHigh;
         prevLH = currentHigh;
      }
   }
}


//+------------------------------------------------------------------+
//| Draw Horizontail line with label function                        |
//+------------------------------------------------------------------+
void DrawHorizontalLineWithLabel(double level, color lineColor, int candleId, string labelText) {
    string lineName = "TrendLine_" + IntegerToString(GetTickCount());  // Unique name for the line
    string labelName = "Label_" + lineName;  // Unique name for the label
    int firstBarIndex = candleId + 6;  // Last 6 candles
    int lastBarIndex = candleId;   // Current candle

    datetime timeFirst = iTime(_Symbol, _Period, firstBarIndex);
    datetime timeLast = iTime(_Symbol, _Period, lastBarIndex);
    datetime timeMiddle = iTime(_Symbol, _Period, candleId + 3);

    // Create the trend line
    if(!ObjectCreate(0, lineName, OBJ_TREND, 0, timeFirst, level, timeLast, level)) {
        Print("Failed to create trend line: ", GetLastError());
        return;
    }

    // Set line properties
    ObjectSetInteger(0, lineName, OBJPROP_COLOR, lineColor);
    ObjectSetInteger(0, lineName, OBJPROP_STYLE, STYLE_SOLID);
    ObjectSetInteger(0, lineName, OBJPROP_WIDTH, 1);  // Width of the line

    // Create the label
    if(!ObjectCreate(0, labelName, OBJ_TEXT, 0, timeMiddle, level)) {
        Print("Failed to create label: ", GetLastError());
        return;
    }

    // Set label properties
    ObjectSetString(0, labelName, OBJPROP_TEXT, labelText);
    ObjectSetInteger(0, labelName, OBJPROP_COLOR, lineColor);
    ObjectSetInteger(0, labelName, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
    ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, 10); // Adjust for exact positioning
    ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, 30); // Distance from the top, adjust as needed
    ObjectSetInteger(0, labelName, OBJPROP_FONTSIZE, 9);  // Font size
}

//+------------------------------------------------------------------+
//| Draw Label function                                              |
//+------------------------------------------------------------------+
void DrawLabel(string label, double priceLevel, int candleIndex)
  {

   if(CopyTime(_Symbol, _Period, 0, lookBack + 1, barTimes) <= 0)
     {
      Print("Failed to copy bar times: ", GetLastError());
      return;
     }


   datetime time = barTimes[candleIndex]; // Current bar time

// Draw text label on chart
   string name = "Label_" + label + "_" + TimeToString(time, TIME_DATE|TIME_MINUTES);
   if(ObjectFind(0, name) == -1)
     {
      if(!ObjectCreate(0, name, OBJ_TEXT, 0, time, priceLevel))
        {
         // If there's a problem creating the object, print an error message
         Print("Error creating object: ", GetLastError());
        }
      else
        {
         // Set the properties for the label
         ObjectSetString(0, name, OBJPROP_TEXT, label);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
         ObjectSetInteger(0, name, OBJPROP_SELECTABLE, 0); // Make it non-selectable
         ObjectSetInteger(0, name, OBJPROP_SELECTED, 0); // Unselect it
        }
     }
   else
     {
      // If the label already exists, just move it to the new location
      ObjectMove(0, name, 0, time, priceLevel);
     }
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

   return true;
  }

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
