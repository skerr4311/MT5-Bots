//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "iFunctions.mqh"
#include "CommonGlobals.mqh"

//+------------------------------------------------------------------+
//| Draw Functions                                                   |
//+------------------------------------------------------------------+

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
//| Draw new zone                                                    |
//+------------------------------------------------------------------+
void DrawZone(datetime startTime, string zoneName, double priceTop, double priceBottom, TrendDirection trend, ENUM_TIMEFRAMES timeframe) {
    datetime endTime = getTime(timeframe, 0); // Current time
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
//| Draw new kill zone                                                    |
//+------------------------------------------------------------------+
void DrawKillZone(datetime startTime, datetime endTime, string killZoneName, double priceTop, double priceBottom, KillZoneTypes killZoneType) {
     if (ObjectFind(0, killZoneName) == -1) {
        // Create the rectangle if it doesn't exist
        if(!ObjectCreate(0, killZoneName, OBJ_RECTANGLE, 0, startTime, priceTop, endTime, priceBottom)) {
            Print("Failed to create rectangle: ", GetLastError());
            return;
        }
   
        // Set properties of the rectangle (color, style, etc.)
        ObjectSetInteger(0, killZoneName, OBJPROP_STYLE, STYLE_DOT);
        ObjectSetInteger(0, killZoneName, OBJPROP_COLOR, KillZoneToColor(killZoneType));
        ObjectSetInteger(0, killZoneName, OBJPROP_FILL, false);
        ObjectSetInteger(0, killZoneName, OBJPROP_BACK, false); // Set to false if you don't want it in the background
        ObjectSetInteger(0, killZoneName, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, killZoneName, OBJPROP_SELECTED, false);
     } else {
        ObjectMove(0, killZoneName, 0, startTime, priceTop);
        ObjectMove(0, killZoneName, 1, endTime, priceBottom);
     }
     
     // Additional code to add or update text on top of the rectangle
     string textName = killZoneName + "_text"; // Unique name for the text object
     datetime middleTime = startTime + (endTime - startTime) / 3; // Calculate the middle time
     
     if(ObjectFind(0, textName) == -1) {
        // Create the text object if it doesn't exist
        if(!ObjectCreate(0, textName, OBJ_TEXT, 0, middleTime, priceTop)) {
            Print("Failed to create text object: ", GetLastError());
            return;
        }
        ObjectSetString(0, textName, OBJPROP_TEXT, KillZoneTypeToString(killZoneType)); // Set the text to kill zone type or any specific name
        ObjectSetInteger(0, textName, OBJPROP_COLOR, KillZoneToColor(killZoneType)); // Set text color
        ObjectSetInteger(0, textName, OBJPROP_FONTSIZE, 10); // Set font size as needed
        ObjectSetString(0, textName, OBJPROP_FONT, "Arial"); // Set font type as needed
        ObjectSetInteger(0, textName, OBJPROP_BACK, true); // Ensure text is always visible
        ObjectSetInteger(0, textName, OBJPROP_SELECTABLE, false); // Make it non-selectable
        ObjectSetInteger(0, textName, OBJPROP_SELECTED, false); // Unselect it
     } else {
        // If the text object exists, move it to the new location
        ObjectMove(0, textName, 0, middleTime, priceTop);
        // Optionally, update the text if the kill zone type changes
        ObjectSetString(0, textName, OBJPROP_TEXT, KillZoneTypeToString(killZoneType));
     }
}

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
//| Draw new trend                                                   |
//+------------------------------------------------------------------+
void DrawLabel(string name, string label, double price, datetime time) {
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
  
  string lineName = "PAM_EMA_" + IntegerToString(timeframe) + (string)period + "_" + (string)endTime;
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
//| Delete EA Objects                                                |
//+------------------------------------------------------------------+
void DeleteEAObjects(string prefix) {
    int totalObjects = ObjectsTotal(0);
    for(int i = totalObjects - 1; i >= 0; i--) {
        string name = ObjectName(0, i);
        if(StringFind(name, prefix) == 0) { // Check if the name starts with the prefix
            ObjectDelete(0, name);
        }
    }
}