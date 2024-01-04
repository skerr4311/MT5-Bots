//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| TODO                                                             |
//+------------------------------------------------------------------+
// create the following for both trend and arrows
   // create button [trend time complete]
   // create new array + object [trend time complete]
   // add items to object and stop showing them. [trend time complete]
   // add logic to show when needed. [trend time complete (testing needed)]
// set up the same thing for execution time zone.
// there should be a good way of handling trend vs execution time.

// double check the 50% mitigation logic.

// prepare for writing buy / sell logic.

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include "TrendClass.mqh"
#include "iFunctions.mqh"
#include "CommonGlobals.mqh"

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
static input long    magicNumber = 69420; // magic number
input int lookBack = 1048; // Number of bars to look back to identify the highs and lows
input bool showMarketStructure = false; // Show HH, HL, LL, LH
input ENUM_TIMEFRAMES trendTimeframe = PERIOD_H1; // Trend timeframe
input ENUM_TIMEFRAMES executionTimeframe = PERIOD_M15; // Execution timeframe

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
MqlTick currentTick;
CTrade trade;
TrendClass trendClass(lookBack, trendTimeframe);
string EA_Name = "P.A.M";
string emaButtonRectName = "PAM_ToggleEMARect";
string emaButtonTextName = "PAM_ToggleEMAText";
bool isEMAVisible = true;
string zoneButtonRectName = "PAM_ToggleZoneRect";
string zoneButtonTextName = "PAM_ToggleZoneText";
bool isZoneVisible = true;
string trendButtonRectName = "PAM_ToggleTrendRect";
string trendButtonTextName = "PAM_ToggleTrendText";
bool isTrendVisible = false;
string arrowButtonRectName = "PAM_ToggleArrowRect";
string arrowButtonTextName = "PAM_ToggleArrowText";
bool isArrowVisible = true;



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
   trendClass.SetInitialMarketTrend();
   
   CreateButton();
   
   Print("P.A.M: INITIALIZATION SUCCEEDED.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
 
//+------------------------------------------------------------------+
//| Expert Chart Event function                                      |
//+------------------------------------------------------------------+ 
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
    if(id == CHARTEVENT_OBJECT_CLICK) {
        // Check if the EMA Toggle button was clicked
        if(sparam == emaButtonRectName || sparam == emaButtonTextName) {
            ToggleEMADisplay();
        }
        // Check if the Zone Button was clicked
        else if(sparam == zoneButtonRectName || sparam == zoneButtonTextName) {
            ToggleZoneDisplay();
        }
        // Check if the Trend Button was clicked
        else if(sparam == trendButtonRectName || sparam == trendButtonTextName) {
            ToggleTrendDisplay();
        }
        // Check if the Arrow Button was clicked
        else if(sparam == arrowButtonRectName || sparam == arrowButtonTextName) {
            ToggleArrowDisplay();
        }
    }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   trendClass.HandleTrend();
   UpdateInfoBox();
  }
  
//+------------------------------------------------------------------+
//| Initialize Buttons                                               |
//+------------------------------------------------------------------+  
void CreateButton() {
    long yOffset = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS) / 2;
    int buttonHeight = 30;
    int spacing = 10;  // Space between buttons

    // Create the first button (EMA Toggle)
    CreateSingleButton(emaButtonRectName, emaButtonTextName, "Toggle EMA", yOffset - 11, isEMAVisible ? clrDarkGreen : clrBlue, isEMAVisible ? clrGreen : clrDodgerBlue, clrWhite);

    // Create the second button 10px below the first button
    CreateSingleButton(zoneButtonRectName, zoneButtonTextName, "Toggle Zones", yOffset - 11 + buttonHeight + spacing, isZoneVisible ? clrDarkGreen : clrBlue, isZoneVisible ? clrGreen : clrDodgerBlue, clrWhite);
    
    // Create the second button 10px below the second button
    CreateSingleButton(trendButtonRectName, trendButtonTextName, "Toggle Trend", yOffset - 11 + (buttonHeight + spacing) * 2, isTrendVisible ? clrDarkGreen : clrBlue, isTrendVisible ? clrGreen : clrDodgerBlue, clrWhite);
    
    // Create the second button 10px below the second button
    CreateSingleButton(arrowButtonRectName, arrowButtonTextName, "Toggle Arrow", yOffset - 11 + (buttonHeight + spacing) * 3, isArrowVisible ? clrDarkGreen : clrBlue, isArrowVisible ? clrGreen : clrDodgerBlue, clrWhite);
}

//+------------------------------------------------------------------+
//| Create Button                                                    |
//+------------------------------------------------------------------+  
void CreateSingleButton(string rectName, string textName, string buttonText, long yDistance, color bgColor, color borderColor, color textColor) {
    // Create the rectangle
    if(ObjectCreate(0, rectName, OBJ_RECTANGLE_LABEL, 0, 0, 0)) {
        ObjectSetInteger(0, rectName, OBJPROP_XDISTANCE, ChartGetInteger(0, CHART_WIDTH_IN_PIXELS) - 115);
        ObjectSetInteger(0, rectName, OBJPROP_YDISTANCE, yDistance);
        ObjectSetInteger(0, rectName, OBJPROP_XSIZE, 100);
        ObjectSetInteger(0, rectName, OBJPROP_YSIZE, 30);
        ObjectSetInteger(0, rectName, OBJPROP_BGCOLOR, bgColor);
        ObjectSetInteger(0, rectName, OBJPROP_COLOR, borderColor);
        ObjectSetInteger(0, rectName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
        ObjectSetInteger(0, rectName, OBJPROP_SELECTABLE, true);
        ObjectSetInteger(0, rectName, OBJPROP_SELECTED, false);
    }

    // Create the label for text
    if(ObjectCreate(0, textName, OBJ_LABEL, 0, 0, 0)) {
        ObjectSetString(0, textName, OBJPROP_TEXT, buttonText);
        ObjectSetInteger(0, textName, OBJPROP_XDISTANCE, ChartGetInteger(0, CHART_WIDTH_IN_PIXELS) - 100);
        ObjectSetInteger(0, textName, OBJPROP_YDISTANCE, yDistance + 5);
        ObjectSetInteger(0, textName, OBJPROP_COLOR, textColor);
        ObjectSetInteger(0, textName, OBJPROP_BACK, false);
        ObjectSetInteger(0, textName, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, textName, OBJPROP_SELECTED, false);
    }
}

//+------------------------------------------------------------------+
//| Toggle Functions - Start                                         |
//+------------------------------------------------------------------+  
// Function to toggle EMA display
void ToggleEMADisplay() {
   isEMAVisible = !isEMAVisible;
   ObjectSetInteger(0, emaButtonRectName, OBJPROP_COLOR, isEMAVisible ? clrGreen : clrDodgerBlue); // Change rectangle color when clicked
   ObjectSetInteger(0, emaButtonRectName, OBJPROP_BGCOLOR, isEMAVisible ? clrDarkGreen : clrBlue);

   if(isEMAVisible) {
       // Code to draw EMA
       for(int i = lookBack; i >= 1; i--) {
         UpdateEMA(i, trendTimeframe, 50);
      }
   } else {
       // Code to delete EMA
       DeleteEAObjects("PAM_EMA50");
   }
}

// Function for the zone button's action
void ToggleZoneDisplay() {
   isZoneVisible = !isZoneVisible;
   ObjectSetInteger(0, zoneButtonRectName, OBJPROP_COLOR, isZoneVisible ? clrGreen : clrDodgerBlue); // Change rectangle color when clicked
   ObjectSetInteger(0, zoneButtonRectName, OBJPROP_BGCOLOR, isZoneVisible ? clrDarkGreen : clrBlue);
   
   if(isZoneVisible) {
      // Code to draw Zone
      // DrawAllZones();
   } else {
      DeleteEAObjects("PAM_zone");
   }
}

// Function for the trend button's action
void ToggleTrendDisplay() {
   isTrendVisible = !isTrendVisible;
   ObjectSetInteger(0, trendButtonRectName, OBJPROP_COLOR, isTrendVisible ? clrGreen : clrDodgerBlue); // Change rectangle color when clicked
   ObjectSetInteger(0, trendButtonRectName, OBJPROP_BGCOLOR, isTrendVisible ? clrDarkGreen : clrBlue);
   
   if(isTrendVisible) {
      // Code to draw Zone
      // DrawAllTrends();
   } else {
      DeleteEAObjects("PAM_trend");
   }
}

// Function for the trend button's action
void ToggleArrowDisplay() {
   isArrowVisible = !isArrowVisible;
   ObjectSetInteger(0, arrowButtonRectName, OBJPROP_COLOR, isArrowVisible ? clrGreen : clrDodgerBlue); // Change rectangle color when clicked
   ObjectSetInteger(0, arrowButtonRectName, OBJPROP_BGCOLOR, isArrowVisible ? clrDarkGreen : clrBlue);
   
   if(isArrowVisible) {
      // Code to draw Zone
      // DrawAllArrows();
   } else {
      DeleteEAObjects("PAM_arrow");
   }
}
//+-----------------Toggle Functions - End---------------------------+

//+------------------------------------------------------------------+
//| Get EMA Value                                                    |
//+------------------------------------------------------------------+  
double GetEMAForBar(int candleIndex, ENUM_TIMEFRAMES timeframe, int period) {
    // Create the EMA handle if not already created
    static int emaHandle = iMA(_Symbol, timeframe, period, 0, MODE_EMA, PRICE_CLOSE);
    if(emaHandle == INVALID_HANDLE) {
        emaHandle = iMA(_Symbol, timeframe, period, 0, MODE_EMA, PRICE_CLOSE);
        if (emaHandle == INVALID_HANDLE) {
            Print("Failed to create EMA handle");
            return EMPTY_VALUE;
        }
    }

    double emaValue[1]; // Array to store the EMA value
    if (CopyBuffer(emaHandle, 0, candleIndex, 1, emaValue) <= 0) {
        Print("Failed to copy EMA data: ", candleIndex);
        return EMPTY_VALUE;
    }
    return emaValue[0]; // Return the first (and only) element of the array
}


//+------------------------------------------------------------------+
//| UpdateEMArray                                                    |
//+------------------------------------------------------------------+
void UpdateEMA(int candleId, ENUM_TIMEFRAMES timeframe, int period) {
  datetime startTime = getTime(timeframe, candleId + 1);
  datetime endTime = getTime(timeframe, candleId);
  
  double startEma = GetEMAForBar(candleId + 1, timeframe, period);
  double endEma = GetEMAForBar(candleId, timeframe, period);
  
  string lineName = "PAM_EMA" + (string)period + "_" + (string)endTime;
  if (ObjectFind(0, lineName) == -1) {
      ObjectCreate(0, lineName, OBJ_TREND, 0, endTime, endEma, startTime, startEma);
      ObjectSetInteger(0, lineName, OBJPROP_COLOR, clrDodgerBlue);
      ObjectSetInteger(0, lineName, OBJPROP_WIDTH, 1);
  } else {
      ObjectMove(0, lineName, 0, endTime, endEma);
      ObjectMove(0, lineName, 1, startTime, startEma);
  }
}

//+------------------------------------------------------------------+
//| Function to create or update the information box                 |
//+------------------------------------------------------------------+
void UpdateInfoBox() {
    Comment(EA_Name, "\nTrend: ", EnumToString(trendClass.getTrend()));
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
//| Draw Horizontail line with label function                        |
//+------------------------------------------------------------------+
void DrawHorizontalLineWithLabel(double level, color lineColor, int candleId, string labelText) {
    string lineName = "PAM_TrendLine_" + IntegerToString(GetTickCount());  // Unique name for the line
    string labelName = "PAM_Label_" + lineName;  // Unique name for the label
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
