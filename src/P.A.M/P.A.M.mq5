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
datetime barTimes[];
// MOVED TO CLASS
datetime marketStructureExecutionTime;
double highestHigh = 0, highestLow = 0, lowestLow = 0, lowestHigh = 0;
double prevLL = 0, prevLH = 0, prevHH = 0, prevHL = 0;
bool isLowerLowReveseStarted = false, isHigherHighReverseStarted = false;
int indexLL = 0, indexHH = 0;
TrendDirection currentTrend = TREND_NONE;
// END MOVE TO CLASS
TrendClass trendClass(lookBack, trendTimeframe);

string EA_Name = "P.A.M";
int zoneCount = 0;
struct ZoneInfo {
   string name;
   double top;
   double bottom;
   TrendDirection trend;
   ENUM_TIMEFRAMES timeframe;
   datetime startTime;
};
ZoneInfo zones[];
int trendCount = 0;
struct TrendInfo {
   string name; 
   string label;
   double price;
   ENUM_TIMEFRAMES timeframe;
   datetime time;
};
TrendInfo trends[];
int arrowCount = 0;
struct ArrowInfo {
   datetime time;
   string name;
   double price;
   ENUM_TIMEFRAMES timeframe;
   TrendDirection trend;
};
ArrowInfo arrows[];
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

// Resize arrays to the required size
   ArraySetAsSeries(barTimes, true);
   ArrayResize(barTimes, lookBack + 1);
   
   DeleteEAObjects("PAM_");
   // Start Update
   // SetInitialMarketTrend(trendTimeframe);
   trendClass.SetInitialMarketTrend();
   
   
   if(CopyTime(_Symbol, trendTimeframe, 0, lookBack + 1, barTimes) <= 0)
     {
      Print("Failed to copy bar times: ", GetLastError());
      return INIT_FAILED;
     }
     
   marketStructureExecutionTime = barTimes[0];
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
   HandleTrend();
   UpdateInfoBox();
  }

//+------------------------------------------------------------------+
//| Handle Trend Function                                            |
//+------------------------------------------------------------------+ 
void HandleTrend() {
   OnTimeTick(0, trendTimeframe);
   handleChangeOfCharecter(0, trendTimeframe);
   CheckAndDeleteZones(0, trendTimeframe);
   if(isEMAVisible) {
      UpdateEMA(0, trendTimeframe, 50);
   }
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
      DrawAllZones();
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
      DrawAllTrends();
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
      DrawAllArrows();
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
//| Functions to run once a bar is complete                          |
//+------------------------------------------------------------------+
void OnTimeTick(int candleId, ENUM_TIMEFRAMES timeframe){
   if(CopyTime(_Symbol, timeframe, 0, lookBack + 1, barTimes) <= 0)
     {
      Print("Failed to copy bar times: ", GetLastError());
      return;
     }
   
   if (barTimes[candleId] != marketStructureExecutionTime) {
      marketStructureExecutionTime = barTimes[candleId];
      IdentifyMarketStructure(1, timeframe);
      UpdateZoneEndDates(timeframe);
   }
}

// MOVED
//+------------------------------------------------------------------+
//| Get Market trend                                                 |
//+------------------------------------------------------------------+
void SetInitialMarketTrend(ENUM_TIMEFRAMES timeframe) {
   highestHigh = iHigh(_Symbol, timeframe, lookBack + 1);
   lowestLow = iLow(_Symbol, timeframe, lookBack + 1);

   for(int i = lookBack; i >= 1; i--) {
      IdentifyMarketStructure(i,timeframe);
      handleChangeOfCharecter(i, timeframe);
      CheckAndDeleteZones(i, timeframe);
      if(isEMAVisible){
         UpdateEMA(i, timeframe, 50);
      }
   }
}
// MOVED END

//+------------------------------------------------------------------+
//| Function to create or update the information box                 |
//+------------------------------------------------------------------+
void UpdateInfoBox() {
    Comment(EA_Name, "\nTrend: ", EnumToString(currentTrend),
           "\nhighestHigh: ", (string)highestHigh,
           "\nlowestLow: ", (string)lowestLow,
           "\nZones: ", (string)ArraySize(zones),
           "\nTrends: ", (string)ArraySize(trends));
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

// MOVED
//+------------------------------------------------------------------+
//| Function to Identify Market Structure                            |
//+------------------------------------------------------------------+
void IdentifyMarketStructure(int candleId, ENUM_TIMEFRAMES timeframe)
  {
   double currentHigh = getHigh(timeframe, candleId);
   double currentLow = getLow(timeframe, candleId);
   
   if (currentTrend == TREND_UP) {
      if (currentHigh > highestHigh) {
         highestHigh = currentHigh;
         highestLow = currentLow;
         if (indexHH != 0 && isHigherHighReverseStarted) {
            // set HH; This is also a BOS
            int newHigherHighIndex;
            double newHigherHigh;
            DrawKeyStructurePoint(KEY_STRUCTURE_HH, timeframe, candleId, newHigherHighIndex, newHigherHigh);
            prevHH = newHigherHigh;
            int newHigherLowIndex = candleId;
            double newHigherLow = getLow(timeframe, newHigherLowIndex);
            
            for(int i = candleId; i <= newHigherHighIndex; i++) {
               double tempHigherLow = getLow(timeframe, i);
               if (tempHigherLow < newHigherLow) {
                  newHigherLowIndex = i;
                  newHigherLow = tempHigherLow;
               }
            }
            
            InsertTrendObject("HL", newHigherLow, newHigherLowIndex, timeframe);
            prevHL = newHigherLow;
            isHigherHighReverseStarted = false;
            handleBreakOfStructure(candleId, timeframe);
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
            // set LL, this is also a BOS
            int newLowerLowIndex;
            double newLowerLow;
            DrawKeyStructurePoint(KEY_STRUCTURE_LL, timeframe, candleId, newLowerLowIndex, newLowerLow);
            prevLL = newLowerLow;
            int newLowerHighIndex = candleId;
            double newLowerHigh = getHigh(timeframe, newLowerHighIndex);
            
            for(int i = candleId; i <= newLowerLowIndex; i++) {
               double tempLowerHigh = getHigh(timeframe, i);
               if (tempLowerHigh > newLowerHigh) {
                  newLowerHighIndex = i;
                  newLowerHigh = tempLowerHigh;
               }
            }
            
            InsertTrendObject("LH", newLowerHigh, newLowerHighIndex, timeframe);
            prevLH = newLowerHigh;
            isLowerLowReveseStarted = false;
            handleBreakOfStructure(candleId, timeframe);
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
// MOVED END

// MOVED
//+------------------------------------------------------------------+
//| Draw key structure point                                         |
//+------------------------------------------------------------------+
bool DrawKeyStructurePoint(KeyStructureType type, ENUM_TIMEFRAMES timeframe, int candleId, int &index, double &price) {
   string label;
    switch(type) {
        case KEY_STRUCTURE_HH:
            label = "HH";
            index = candleId + indexHH + 1;
            price = getHigh(timeframe, index);
            break;

        case KEY_STRUCTURE_LL:
            label = "LL";
            index = candleId + indexLL + 1;
            price = getLow(timeframe, index);
            break;

        default:
            Print("Invalid type");
    }
    InsertTrendObject(label, price, index, timeframe);
    return true;
}

// MOVED
//+------------------------------------------------------------------+
//| Delete Zone if 50% mitigated                                     |
//+------------------------------------------------------------------+
void CheckAndDeleteZones(int candleId, ENUM_TIMEFRAMES timeframe) {
    double currentPrice = iClose(_Symbol, timeframe, candleId);
    ZoneInfo updatedZones[];
    bool isUdateNeeded = false;

    for (int i = ArraySize(zones) - 1; i >= 0; i--) {
        double midPrice = (zones[i].top + zones[i].bottom) / 2;
        if ((currentPrice > midPrice && currentPrice < zones[i].top) || 
            (currentPrice < midPrice && currentPrice > zones[i].bottom)) {
            // Price has penetrated more than 50% into the rectangle
            if(isZoneVisible) {
               ObjectDelete(0, zones[i].name);
            }
            isUdateNeeded = true;
        } else {
            ArrayResize(updatedZones, ArraySize(updatedZones) + 1);
            updatedZones[ArraySize(updatedZones) - 1] = zones[i];
        }
    }
    
    if(isUdateNeeded) {
      // Replace zones with updatedZones
       ArrayResize(zones, ArraySize(updatedZones));
       for (int i = 0; i < ArraySize(updatedZones); i++) {
           zones[i] = updatedZones[i];
       }
    }
}
// END

// MOVED ALL ZONE
//+------------------------------------------------------------------+
//| Add zone info                                                    |
//+------------------------------------------------------------------+
void AddZoneInfo(string name, double top, double bottom,  ENUM_TIMEFRAMES timeframe, TrendDirection trend, datetime startTime) {
    ZoneInfo info;
    info.name = name;
    info.top = top;
    info.bottom = bottom;
    info.trend = trend;
    info.timeframe = timeframe;
    info.startTime = startTime;
    ArrayResize(zones, ArraySize(zones) + 1);
    zones[ArraySize(zones) - 1] = info;
}

//+------------------------------------------------------------------+
//| Move existing zones                                              |
//+------------------------------------------------------------------+
void UpdateZoneEndDates(ENUM_TIMEFRAMES timeframe) {
   if(isZoneVisible) {
      datetime endTime = iTime(_Symbol, timeframe, 0);

       for (int i = 0; i < ArraySize(zones); i++) {
           string rectName = zones[i].name;
           double priceBottom = zones[i].bottom;
   
           // Check if the rectangle exists
           if (ObjectFind(0, rectName) != -1) {
               // Get the start time and price levels of the rectangle
               ObjectMove(0, rectName, 1, endTime, priceBottom);
           }
       }
   }
}

//+------------------------------------------------------------------+
//| Insert new zone                                                  |
//+------------------------------------------------------------------+
void InsertZoneObject(int startCandleIndex, double priceTop, double priceBottom, ENUM_TIMEFRAMES timeframe, TrendDirection trend) {
    datetime startTime = iTime(_Symbol, timeframe, startCandleIndex);
    string rectName = "PAM_zone" + (string)zoneCount; 
    AddZoneInfo(rectName, priceTop, priceBottom, timeframe, trend, startTime);
    if(isZoneVisible){
      DrawZone(startTime, rectName, priceTop, priceBottom, timeframe, trend);
    }
}

//+------------------------------------------------------------------+
//| Draw new zone                                                    |
//+------------------------------------------------------------------+
void DrawZone(datetime startTime, string zoneName, double priceTop, double priceBottom, ENUM_TIMEFRAMES timeframe, TrendDirection trend) {
    datetime endTime = iTime(_Symbol, timeframe, 0); // Current time
    color zoneColor = clrRed;
 
    if (trend == TREND_UP) {
      zoneColor = clrGreen;
    }

     // Create the rectangle if it doesn't exist
     if(!ObjectCreate(0, zoneName, OBJ_RECTANGLE, 0, startTime, priceTop, endTime, priceBottom)) {
         Print("Failed to create rectangle: ", GetLastError());
         return;
     }

     // Set properties of the rectangle (color, style, etc.)
     ObjectSetInteger(0, zoneName, OBJPROP_STYLE, STYLE_SOLID);
     ObjectSetInteger(0, zoneName, OBJPROP_COLOR, zoneColor);
     ObjectSetInteger(0, zoneName, OBJPROP_FILL, true);
     ObjectSetInteger(0, zoneName, OBJPROP_BACK, false); // Set to false if you don't want it in the background
     ObjectSetInteger(0, zoneName, OBJPROP_SELECTABLE, false);
     ObjectSetInteger(0, zoneName, OBJPROP_SELECTED, false);
}

//+------------------------------------------------------------------+
//| Draw All Zones                                                   |
//+------------------------------------------------------------------+
void DrawAllZones() {
   for (int i = 0; i < ArraySize(zones); i++) {
      ZoneInfo zone = zones[i];
      DrawZone(zone.startTime, zone.name, zone.top, zone.bottom, zone.timeframe, zone.trend);
   }
}

//+------------------------------------------------------------------+
//| Draw All Trends                                                  |
//+------------------------------------------------------------------+
void DrawAllTrends() {
   for (int i = 0; i < ArraySize(trends); i++) {
      TrendInfo trend = trends[i];
      DrawLabel(trend.name, trend.label, trend.price, trend.time);
   }
}

//+------------------------------------------------------------------+
//| Draw new trend                                                   |
//+------------------------------------------------------------------+
void DrawLabel(string name, string label, double price, datetime time) {
   // Create the rectangle if it doesn't exist
   if(!ObjectCreate(0, name, OBJ_TEXT, 0, time, price)) {
      Print("Failed to create rectangle: ", GetLastError());
      return;
   }
   
   // Set the properties for the label
   ObjectSetString(0, name, OBJPROP_TEXT, label);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, 0); // Make it non-selectable
   ObjectSetInteger(0, name, OBJPROP_SELECTED, 0); // Unselect it
}

//+------------------------------------------------------------------+
//| Add trend info                                                   |
//+------------------------------------------------------------------+
void AddTrendInfo(string name, string label, double price, ENUM_TIMEFRAMES timeframe, datetime time) {
    TrendInfo info;
    info.name = name;
    info.label = label;
    info.price = price;
    info.timeframe = timeframe;
    info.time = time;
    ArrayResize(trends, ArraySize(trends) + 1);
    trends[ArraySize(trends) - 1] = info;
}

//+------------------------------------------------------------------+
//| Insert new trend                                                 |
//+------------------------------------------------------------------+
void InsertTrendObject(string label, double price, int candleId, ENUM_TIMEFRAMES timeframe) {
    trendCount++;
    datetime time = getTime(timeframe, candleId);
    string objectName = "PAM_trend" + (string)trendCount;
    AddTrendInfo(objectName, label, price, timeframe, time);
    if(isTrendVisible){
      DrawLabel(objectName, label, price, time);
    }
}

// MOVED ARROW
//+------------------------------------------------------------------+
//| Draw Trend arrow                                                 |
//+------------------------------------------------------------------+
void DrawTrendArrow(datetime time, string name, double price, TrendDirection trend) {
   ENUM_OBJECT arrow = trend == TREND_UP ? OBJ_ARROW_UP : OBJ_ARROW_DOWN;
   color arrowColor = trend == TREND_UP ? clrGreenYellow : clrDeepPink;
   long anchor = trend == TREND_UP ? ANCHOR_TOP : ANCHOR_BOTTOM;
   
   if(!ObjectCreate(0, name, arrow, 0, time, price)) {
     Print("Failed to create up arrow: ", GetLastError());
     return;
    }

    // Set properties of the arrow
    ObjectSetInteger(0, name, OBJPROP_COLOR, arrowColor);
    ObjectSetInteger(0, name, OBJPROP_WIDTH, 2); // Adjust width for size
    ObjectSetInteger(0, name, OBJPROP_ANCHOR, anchor);
    ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
    ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
}

//+------------------------------------------------------------------+
//| Draw All Arrows                                                  |
//+------------------------------------------------------------------+
void DrawAllArrows() {
   for (int i = 0; i < ArraySize(arrows); i++) {
      ArrowInfo arrow = arrows[i];
      DrawTrendArrow(arrow.time, arrow.name, arrow.price, arrow.trend);
   }
}

//+------------------------------------------------------------------+
//| Add arrow info                                                   |
//+------------------------------------------------------------------+
void AddArrowInfo(datetime time, string name, double price, ENUM_TIMEFRAMES timeframe, TrendDirection trend) {
    ArrowInfo info;
    info.time = time;
    info.name = name;
    info.price = price;
    info.timeframe = timeframe;
    info.trend = trend;
    ArrayResize(arrows, ArraySize(arrows) + 1);
    arrows[ArraySize(arrows) - 1] = info;
}

//+------------------------------------------------------------------+
//| Insert new arrow                                                 |
//+------------------------------------------------------------------+
void InsertArrowObject(int candleId, ENUM_TIMEFRAMES timeframe, TrendDirection trend) {
    arrowCount++;
    currentTrend = trend;
    datetime time = getTime(timeframe, candleId);
    string objectName = "PAM_arrow" + (string)arrowCount;
    double price = trend == TREND_UP ? getLow(timeframe, candleId) : getHigh(timeframe, candleId);
    
    AddArrowInfo(time, objectName, price, timeframe, trend);
    if(isArrowVisible){
      DrawTrendArrow(time, objectName, price, trend);
    }
}

// MOVED
//+------------------------------------------------------------------+
//| Check for BOS                                                    |
//+------------------------------------------------------------------+
void handleBreakOfStructure(int candleId, ENUM_TIMEFRAMES timeframe) {
   double currentLow = getLow(timeframe, candleId);
   double currentHigh = getHigh(timeframe, candleId);
   if(currentTrend == TREND_DOWN) {
      if(currentLow < prevLL) {
         // Create a supply zone
         // scan back and find the first bull candle:
         int bullId = 0;
         for(int i = candleId + 1; bullId == 0; i++) {
            double previousOpen = getOpen(timeframe, i);
            double previousClose = getClose(timeframe, i);
            if(previousClose > previousOpen) {
               bullId = i;
            }
         }
         
         double low = getLow(timeframe, bullId);
         double high = getHigh(timeframe, bullId);
         if(getHigh(timeframe, bullId - 1) > high) {
            high = getHigh(timeframe, bullId - 1);
         }
         // complete high once i know this is working
         InsertZoneObject(bullId, high, low, timeframe, TREND_DOWN);
         zoneCount++;
      }
   } else if (currentTrend == TREND_UP) {
      if(currentHigh > prevHH) {
         // Create a demand zone
         // scan back and find the first bear candle:
         int bearId = 0;
         for(int i = candleId + 1; bearId == 0; i++) {
            double previousOpen = getOpen(timeframe, i);
            double previousClose = getClose(timeframe, i);
            if(previousClose < previousOpen) {
               bearId = i;
            }
         }
         
         double high = getHigh(timeframe, bearId);
         double low = getLow(timeframe, bearId);
         if(getLow(timeframe, bearId - 1) < low) {
            low = getLow(timeframe, bearId - 1);
         }
         // complete high once i know this is working
         InsertZoneObject(bearId, high, low, timeframe, TREND_UP);
         zoneCount++;
      }
   }
}
  
// MOVED
//+------------------------------------------------------------------+
//| Check for CHoCH                                                  |
//+------------------------------------------------------------------+
void handleChangeOfCharecter(int candleId, ENUM_TIMEFRAMES timeframe) {
   if(currentTrend == TREND_DOWN) {
      // check for choch and reset needed variables
      double currentHigh = getHigh(timeframe, candleId);
      if(currentHigh > prevLH) {
         // confirmed choch
         double currentLow = getLow(timeframe, candleId);
         InsertArrowObject(candleId, timeframe, TREND_UP);
         highestHigh = currentHigh;
         prevHH = currentHigh;
         highestLow = currentLow;
         prevHL = currentLow;
         indexLL = 0;
         
      }
   } else if (currentTrend == TREND_UP) {
      // check for choch and reset needed variables
      double currentLow = getLow(timeframe, candleId);
      if(currentLow < prevHL) {
         // confirmed choch
         double currentHigh = getHigh(timeframe, candleId);
         InsertArrowObject(candleId, timeframe, TREND_DOWN);
         lowestLow = currentLow;
         prevLL = currentLow;
         lowestHigh = currentHigh;
         prevLH = currentHigh;
         indexHH = 0;
      }
   }
}
// ENd

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
