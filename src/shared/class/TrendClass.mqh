//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "../function/iFunctions.mqh"
#include "../class/ZoneClass.mqh"
#include "../class/ArrowClass.mqh"
#include "../class/HighsAndLowsClass.mqh"
#include "../function/iDraw.mqh"

//+------------------------------------------------------------------+
//| Trend Class                                                      |
//+------------------------------------------------------------------+

// BasicClass.mqh
class TrendClass {
private:
    string emaButtonRectName, emaButtonTextName, zoneButtonRectName, zoneButtonTextName, dropdownButtonRectName, dropdownButtonTextName, arrowButtonRectName, arrowButtonTextName;
    datetime marketStructureExecutionTime;
    double highestHigh, highestLow, lowestLow, lowestHigh;
    double prevLL, prevLH, prevHH, prevHL;
    bool isLowerLowReveseStarted, isHigherHighReverseStarted, isEMAVisible, isZoneVisible, isDropdownVisible, isArrowVisible, isTrendTimeframe;
    int indexLL, indexHH, buttonHeight, buttonWidth, spacing, trendConformationCount;
    long midScreenPoint, chartWidth;
    TrendDirection currentTrend;
    ENUM_TIMEFRAMES trendTimeframe;
    int lookbackValue;
    ZoneClass zoneClass;
    ArrowClass arrowClass;
    HighsAndLowsClass highsAndLowsClass;
    
public:
    // Constructor
    TrendClass() {
    }
    
   //+------------------------------------------------------------------+
   //| Get Market trend                                                 |
   //+------------------------------------------------------------------+
   void init(int lookback, ENUM_TIMEFRAMES timeframe) {
      marketStructureExecutionTime = getTime(timeframe, 0);
      trendConformationCount = 0;
      highestHigh = 0;
      highestLow = 0;
      lowestLow = 0;
      lowestHigh = 0;
      prevLL = 0;
      prevLH = 0;
      prevHH = 0;
      prevHL = 0;
      isLowerLowReveseStarted = false;
      isHigherHighReverseStarted = false;
      indexLL = 0;
      indexHH = 0;
      currentTrend = TREND_NONE;
      trendTimeframe = timeframe;
      lookbackValue = lookback;
      buttonHeight = 30;
      buttonWidth = 80;
      spacing = 10;
      chartWidth = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
      midScreenPoint = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS) / 2;
      isTrendTimeframe = timeframe == inputTrendTimeframe;
      emaButtonRectName = "PAM_" + IntegerToString(timeframe) + "_ToggleEMA_Rect";
      emaButtonTextName = "PAM_" + IntegerToString(timeframe) + "_ToggleEMA_Text";
      isEMAVisible = timeframe == inputTrendTimeframe ? true : false;
      zoneButtonRectName = "PAM_" + IntegerToString(timeframe) + "_ToggleZone_Rect";
      zoneButtonTextName = "PAM_" + IntegerToString(timeframe) + "_ToggleZone_Text";
      isZoneVisible = true; // timeframe == inputExecutionTimeframe ? true : false;
      dropdownButtonRectName = "PAM_ToggleDropdownRect_" + IntegerToString(timeframe);
      dropdownButtonTextName = "PAM_ToggleDropdownText_" + IntegerToString(timeframe);
      isDropdownVisible = timeframe == inputTrendTimeframe ? true : false;
      arrowButtonRectName = "PAM_" + IntegerToString(timeframe) + "_ToggleArrow_Rect";
      arrowButtonTextName = "PAM_" + IntegerToString(timeframe) + "_ToggleArrow_Text";
      isArrowVisible = timeframe == inputTrendTimeframe ? true : false;
      zoneClass.init(timeframe, isZoneVisible);
      arrowClass.init(timeframe, isArrowVisible);
      highsAndLowsClass.init(timeframe, false);
      CreateButton();
      if(timeframe == inputTrendTimeframe) {
      Print("Trend INIT");
      } else {
      Print("Execution INIT");
      }
    }
    
   //+------------------------------------------------------------------+
   //| Get Market trend                                                 |
   //+------------------------------------------------------------------+
   void SetInitialMarketTrend() {
      highestHigh = getCandleValue(trendTimeframe, lookbackValue + 1, CANDLE_HIGH);
      lowestLow = getCandleValue(trendTimeframe, lookbackValue + 1, CANDLE_LOW);
   
      for(int i = lookbackValue; i >= 1; i--) {
         this.IdentifyMarketStructure(i);
         this.handleChangeOfCharecter(i);
         zoneClass.CheckAndDeleteZones(i);
         if(isEMAVisible) {
            UpdateEMA(i, trendTimeframe, 50);
         }
      }
   }
   
   //+------------------------------------------------------------------+
   //| Handle Trend Function                                            |
   //+------------------------------------------------------------------+ 
   void HandleTrend() {
      OnTimeTick(0);
      handleChangeOfCharecter(0);
      if(isEMAVisible) {
         UpdateEMA(0, trendTimeframe, 50);
      }
   }
   
   //+------------------------------------------------------------------+
   //| Functions to run once a bar is complete                          |
   //+------------------------------------------------------------------+
   void OnTimeTick(int candleId){
      datetime prevCandletime = getTime(trendTimeframe, 1);
      
      if (prevCandletime != marketStructureExecutionTime) {
         marketStructureExecutionTime = prevCandletime;
         IdentifyMarketStructure(1);
         zoneClass.CheckAndDeleteZones(3);
         zoneClass.UpdateZoneEndDates();
      }
   }
   
   //+------------------------------------------------------------------+
   //| Function to Identify Market Structure                            |
   //+------------------------------------------------------------------+
   void IdentifyMarketStructure(int candleId)
     {
      double currentHigh = getCandleValue(trendTimeframe, candleId, CANDLE_HIGH);
      double currentLow = getCandleValue(trendTimeframe, candleId, CANDLE_LOW);
      
      if (currentTrend == TREND_UP) {
         if (currentHigh > highestHigh) {
            highestHigh = currentHigh;
            highestLow = currentLow;
            if (indexHH != 0 && isHigherHighReverseStarted) {
               // set HH; This is also a BOS
               int newHigherHighIndex;
               double newHigherHigh;
               this.DrawKeyStructurePoint(KEY_STRUCTURE_HH, candleId, newHigherHighIndex, newHigherHigh);
               prevHH = newHigherHigh;
               int newHigherLowIndex = candleId;
               double newHigherLow = getCandleValue(trendTimeframe, newHigherLowIndex, CANDLE_LOW);
               
               for(int i = candleId; i <= newHigherHighIndex; i++) {
                  double tempHigherLow = getCandleValue(trendTimeframe, i, CANDLE_LOW);
                  if (tempHigherLow < newHigherLow) {
                     newHigherLowIndex = i;
                     newHigherLow = tempHigherLow;
                  }
               }
               
               highsAndLowsClass.InsertTrendObject("HL", newHigherLow, newHigherLowIndex);
               prevHL = newHigherLow;
               isHigherHighReverseStarted = false;
               handleBreakOfStructure(candleId);
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
               DrawKeyStructurePoint(KEY_STRUCTURE_LL, candleId, newLowerLowIndex, newLowerLow);
               prevLL = newLowerLow;
               int newLowerHighIndex = candleId;
               double newLowerHigh = getCandleValue(trendTimeframe, newLowerHighIndex, CANDLE_HIGH);
               
               for(int i = candleId; i <= newLowerLowIndex; i++) {
                  double tempLowerHigh = getCandleValue(trendTimeframe, i, CANDLE_HIGH);
                  if (tempLowerHigh > newLowerHigh) {
                     newLowerHighIndex = i;
                     newLowerHigh = tempLowerHigh;
                  }
               }
               
               highsAndLowsClass.InsertTrendObject("LH", newLowerHigh, newLowerHighIndex);
               prevLH = newLowerHigh;
               isLowerLowReveseStarted = false;
               handleBreakOfStructure(candleId);
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
     
   //+------------------------------------------------------------------+
   //| Check for CHoCH                                                  |
   //+------------------------------------------------------------------+
   void handleChangeOfCharecter(int candleId) {
      if(currentTrend == TREND_DOWN) {
         // check for choch and reset needed variables
         double currentHigh = getCandleValue(trendTimeframe, candleId, CANDLE_HIGH);
         if(currentHigh > prevLH) {
            // confirmed choch
            // Switch to TREND_UP
            double currentLow = getCandleValue(trendTimeframe, candleId, CANDLE_LOW);
            arrowClass.InsertArrowObject(candleId, TREND_UP, candleId == 0);
            trendConformationCount = 0;
            currentTrend = TREND_UP;
            highestHigh = currentHigh;
            prevHH = currentHigh;
            highestLow = currentLow;
            prevHL = currentLow;
            indexLL = 0;
            
         }
      } else if (currentTrend == TREND_UP) {
         // check for choch and reset needed variables
         double currentLow = getCandleValue(trendTimeframe, candleId, CANDLE_LOW);
         if(currentLow < prevHL) {
            // confirmed choch
            double currentHigh = getCandleValue(trendTimeframe, candleId, CANDLE_HIGH);
            arrowClass.InsertArrowObject(candleId, TREND_DOWN, candleId == 0);
            trendConformationCount = 0;
            currentTrend = TREND_DOWN;
            lowestLow = currentLow;
            prevLL = currentLow;
            lowestHigh = currentHigh;
            prevLH = currentHigh;
            indexHH = 0;
         }
      }
   }
   
   //+------------------------------------------------------------------+
   //| Check for BOS                                                    |
   //+------------------------------------------------------------------+
   void handleBreakOfStructure(int candleId) {
      double currentLow = getCandleValue(trendTimeframe, candleId, CANDLE_LOW);
      double currentHigh = getCandleValue(trendTimeframe, candleId, CANDLE_HIGH);
      if(currentTrend == TREND_DOWN) {
         if(currentLow < prevLL) {
            // Create a supply zone
            // scan back and find the first bull candle:
            int bullId = 0;
            for(int i = candleId + 1; bullId == 0; i++) {
               double previousOpen = getCandleValue(trendTimeframe, i, CANDLE_OPEN);
               double previousClose = getCandleValue(trendTimeframe, i, CANDLE_CLOSE);
               if(previousClose > previousOpen) {
                  bullId = i;
               }
            }
            
            double low = getCandleValue(trendTimeframe, bullId, CANDLE_LOW);
            double high = getCandleValue(trendTimeframe, bullId, CANDLE_HIGH);
            if(getCandleValue(trendTimeframe, bullId - 1, CANDLE_HIGH) > high) {
               high = getCandleValue(trendTimeframe, bullId - 1, CANDLE_HIGH);
            }
            // complete high once i know this is working
            zoneClass.InsertZoneObject(bullId, high, low, currentTrend);
         }
      } else if (currentTrend == TREND_UP) {
         if(currentHigh > prevHH) {
            // Create a demand zone
            // scan back and find the first bear candle:
            int bearId = 0;
            for(int i = candleId + 1; bearId == 0; i++) {
               double previousOpen = getCandleValue(trendTimeframe, i, CANDLE_OPEN);
               double previousClose = getCandleValue(trendTimeframe, i, CANDLE_CLOSE);
               if(previousClose < previousOpen) {
                  bearId = i;
               }
            }
            
            double high = getCandleValue(trendTimeframe, bearId, CANDLE_HIGH);
            double low = getCandleValue(trendTimeframe, bearId, CANDLE_LOW);
            if(getCandleValue(trendTimeframe, bearId - 1, CANDLE_LOW) < low) {
               low = getCandleValue(trendTimeframe, bearId - 1, CANDLE_LOW);
            }
            // complete high once i know this is working
            zoneClass.InsertZoneObject(bearId, high, low, currentTrend);
         }
      }
   }
   
   //+------------------------------------------------------------------+
   //| Draw key structure point                                         |
   //+------------------------------------------------------------------+
   bool DrawKeyStructurePoint(KeyStructureType type, int candleId, int &index, double &price) {
      string label;
         switch(type) {
            case KEY_STRUCTURE_HH:
               label = "HH";
               index = candleId + indexHH + 1;
               price = getCandleValue(trendTimeframe, index, CANDLE_HIGH);
               break;
   
            case KEY_STRUCTURE_LL:
               label = "LL";
               index = candleId + indexLL + 1;
               price = getCandleValue(trendTimeframe, index, CANDLE_LOW);
               break;
   
            default:
               Print("Invalid type");
         }
         trendConformationCount += 1;
         highsAndLowsClass.InsertTrendObject(label, price, index);
         return true;
   }

   //+------------------------------------------------------------------+
   //| Get current trend                                                |
   //+------------------------------------------------------------------+
   TrendDirection getTrend() {
      return this.currentTrend;
   }

   //+------------------------------------------------------------------+
   //| Get current trend                                                |
   //+------------------------------------------------------------------+
   int getTrendConfirmation() {
      return trendConformationCount;
   }
   
   //+------------------------------------------------------------------+
   //| Initialize Buttons                                               |
   //+------------------------------------------------------------------+  
   void CreateButton() {
      long yOffset = isTrendTimeframe ? midScreenPoint : midScreenPoint - buttonHeight;
   
      CreateSingleButton(
         dropdownButtonRectName, 
         dropdownButtonTextName, 
         isTrendTimeframe ? "Trend" : "Execution", 
         yOffset, 
         chartWidth - buttonWidth - 10,
         buttonWidth,
         chartWidth - (buttonWidth / 2) - (isTrendTimeframe ? 23 : 38),
         isDropdownVisible ? clrDarkGreen : clrBlue, 
         isDropdownVisible ? clrGreen : clrDodgerBlue, 
         clrWhite
      );

      if(isDropdownVisible) {
         CreateButtonsAndContainerContainer();
      }
   }

   //+------------------------------------------------------------------+
   //| Initialize Buttons Container                                     |
   //+------------------------------------------------------------------+  
   void CreateButtonsAndContainerContainer() {
      int boxWidth = buttonWidth + (spacing * 2);
      int boxHeight = (buttonHeight * 3) + (spacing * 4);
      long yOffset = isTrendTimeframe ? midScreenPoint + buttonHeight + spacing : midScreenPoint - (buttonHeight) - spacing - boxHeight;


      CreateButtonContainer(
         dropdownButtonRectName + "_Container",
         yOffset,
         boxWidth,
         boxHeight,
         clrLightGray,
         clrLightGray
      );

      CreateSingleButton(
         arrowButtonRectName, 
         arrowButtonTextName, 
         "Arrow", 
         isTrendTimeframe ? yOffset + spacing : yOffset + boxHeight - (spacing + buttonHeight), 
         chartWidth - buttonWidth - 10,
         buttonWidth,
         chartWidth - (buttonWidth / 2) - 28,
         isArrowVisible ? clrDarkGreen : clrBlue, 
         isArrowVisible ? clrGreen : clrDodgerBlue, 
         clrWhite
      );

      CreateSingleButton(
         zoneButtonRectName, 
         zoneButtonTextName, 
         "Zone", 
         isTrendTimeframe ? yOffset + spacing + (spacing + buttonHeight) : yOffset + boxHeight - ((spacing + buttonHeight) * 2), 
         chartWidth - buttonWidth - 10,
         buttonWidth,
         chartWidth - (buttonWidth / 2) - 28,
         isZoneVisible ? clrDarkGreen : clrBlue, 
         isZoneVisible ? clrGreen : clrDodgerBlue, 
         clrWhite
      );

      CreateSingleButton(
         emaButtonRectName, 
         emaButtonTextName, 
         "EMA", 
         isTrendTimeframe ? yOffset + spacing + ((spacing + buttonHeight) * 2) : yOffset + boxHeight - ((spacing + buttonHeight) * 3), 
         chartWidth - buttonWidth - 10,
         buttonWidth,
         chartWidth - (buttonWidth / 2) - 28,
         isEMAVisible ? clrDarkGreen : clrBlue, 
         isEMAVisible ? clrGreen : clrDodgerBlue, 
         clrWhite
      );
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
            UpdateEMA(i, this.trendTimeframe, 50);
         }
      } else {
            // Code to delete all items in the container
            DeleteEAObjects("PAM_EMA_" + IntegerToString(this.trendTimeframe));
      }
   }
   
   // Function for the zone button's action
   void ToggleZoneDisplay() {
      isZoneVisible = zoneClass.ToggleIsVisible();
      ObjectSetInteger(0, zoneButtonRectName, OBJPROP_COLOR, isZoneVisible ? clrGreen : clrDodgerBlue); // Change rectangle color when clicked
      ObjectSetInteger(0, zoneButtonRectName, OBJPROP_BGCOLOR, isZoneVisible ? clrDarkGreen : clrBlue);
      
      if(isZoneVisible) {
         // Code to draw Zone
         zoneClass.DrawAllZones();
      } else {
         DeleteEAObjects("PAM_zone_" + IntegerToString(this.trendTimeframe));
      }
   }
   
   // Function for the dropdown options
   void ToggleDropDownDisplay() {
      isDropdownVisible = !isDropdownVisible;
      ObjectSetInteger(0, dropdownButtonRectName, OBJPROP_COLOR, isDropdownVisible ? clrGreen : clrDodgerBlue); // Change rectangle color when clicked
      ObjectSetInteger(0, dropdownButtonRectName, OBJPROP_BGCOLOR, isDropdownVisible ? clrDarkGreen : clrBlue);
      
      if(isDropdownVisible) {
         CreateButtonsAndContainerContainer();
      } else {
         DeleteEAObjects(dropdownButtonRectName + "_Container");
         DeleteEAObjects("PAM_" + IntegerToString(this.trendTimeframe));
      }
   }
   
   // Function for the trend button's action
   void ToggleArrowDisplay() {
      isArrowVisible = arrowClass.ToggleIsVisible();
      ObjectSetInteger(0, arrowButtonRectName, OBJPROP_COLOR, isArrowVisible ? clrGreen : clrDodgerBlue); // Change rectangle color when clicked
      ObjectSetInteger(0, arrowButtonRectName, OBJPROP_BGCOLOR, isArrowVisible ? clrDarkGreen : clrBlue);
      
      if(isArrowVisible) {
         // Code to draw Zone
         arrowClass.DrawAllArrows();
      } else {
         DeleteEAObjects("PAM_arrow_" + IntegerToString(trendTimeframe));
      }
   }
   //+-----------------Toggle Functions - End---------------------------+
   
   //+------------------------------------------------------------------+
   //| Handle Button Click                                              |
   //+------------------------------------------------------------------+
   void handleButtonClick(string sparam) {
      // Check if the EMA Toggle button was clicked
      if(sparam == emaButtonRectName || sparam == emaButtonTextName) {
         ToggleEMADisplay();
      }
      // Check if the Zone Button was clicked
      else if(sparam == zoneButtonRectName || sparam == zoneButtonTextName) {
         ToggleZoneDisplay();
      }
      // Check if the Trend Button was clicked
      else if(sparam == dropdownButtonRectName || sparam == dropdownButtonTextName) {
         ToggleDropDownDisplay();
      }
      // Check if the Arrow Button was clicked
      else if(sparam == arrowButtonRectName || sparam == arrowButtonTextName) {
         ToggleArrowDisplay();
      }
   }
   
   //+------------------------------------------------------------------+
   //| Get Zone size                                                    |
   //+------------------------------------------------------------------+
   int getZoneCount() {
      return zoneClass.getZoneCount();
   }
   
   //+------------------------------------------------------------------+
   //| Get Zone array                                                   |
   //+------------------------------------------------------------------+
   ZoneInfo getZones(int index) {
      return zoneClass.getZones(index);
   }
    
};
