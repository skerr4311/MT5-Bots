//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "iFunctions.mqh"
#include "ZoneClass.mqh"
#include "ArrowClass.mqh"
#include "CommonGlobals.mqh"

//+------------------------------------------------------------------+
//| Trend Class                                                      |
//+------------------------------------------------------------------+

// BasicClass.mqh
class TrendClass {
private:
    datetime marketStructureExecutionTime;
    double highestHigh, highestLow, lowestLow, lowestHigh;
    double prevLL, prevLH, prevHH, prevHL;
    bool isLowerLowReveseStarted, isHigherHighReverseStarted;
    int indexLL, indexHH;
    TrendDirection currentTrend;
    ENUM_TIMEFRAMES trendTimeframe;
    int lookbackValue;
    ZoneClass zoneClass;
    ArrowClass arrowClass;
    
public:
    // Constructor
    TrendClass(int lookback, ENUM_TIMEFRAMES timeframe) {
       marketStructureExecutionTime = getTime(timeframe, 0);
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
       zoneClass.init(timeframe);
       arrowClass.init(timeframe);
    }
    
   //+------------------------------------------------------------------+
   //| Get Market trend                                                 |
   //+------------------------------------------------------------------+
   void SetInitialMarketTrend() {
      highestHigh = getHigh(trendTimeframe, lookbackValue + 1);
      lowestLow = getLow(trendTimeframe, lookbackValue + 1);
   
      for(int i = lookbackValue; i >= 1; i--) {
         this.IdentifyMarketStructure(i);
         this.handleChangeOfCharecter(i);
         zoneClass.CheckAndDeleteZones(i);
      }
   }
   
   //+------------------------------------------------------------------+
   //| Function to Identify Market Structure                            |
   //+------------------------------------------------------------------+
   void IdentifyMarketStructure(int candleId)
     {
      double currentHigh = getHigh(trendTimeframe, candleId);
      double currentLow = getLow(trendTimeframe, candleId);
      
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
               double newHigherLow = getLow(trendTimeframe, newHigherLowIndex);
               
               for(int i = candleId; i <= newHigherHighIndex; i++) {
                  double tempHigherLow = getLow(trendTimeframe, i);
                  if (tempHigherLow < newHigherLow) {
                     newHigherLowIndex = i;
                     newHigherLow = tempHigherLow;
                  }
               }
               
               InsertTrendObject("HL", newHigherLow, newHigherLowIndex, trendTimeframe);
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
               double newLowerHigh = getHigh(trendTimeframe, newLowerHighIndex);
               
               for(int i = candleId; i <= newLowerLowIndex; i++) {
                  double tempLowerHigh = getHigh(trendTimeframe, i);
                  if (tempLowerHigh > newLowerHigh) {
                     newLowerHighIndex = i;
                     newLowerHigh = tempLowerHigh;
                  }
               }
               
               InsertTrendObject("LH", newLowerHigh, newLowerHighIndex, trendTimeframe);
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
            double currentHigh = getHigh(trendTimeframe, candleId);
            if(currentHigh > prevLH) {
               // confirmed choch
               double currentLow = getLow(trendTimeframe, candleId);
               arrowClass.InsertArrowObject(candleId, TREND_UP);
               currentTrend = TREND_UP;
               highestHigh = currentHigh;
               prevHH = currentHigh;
               highestLow = currentLow;
               prevHL = currentLow;
               indexLL = 0;
               
            }
         } else if (currentTrend == TREND_UP) {
            // check for choch and reset needed variables
            double currentLow = getLow(trendTimeframe, candleId);
            if(currentLow < prevHL) {
               // confirmed choch
               double currentHigh = getHigh(trendTimeframe, candleId);
               arrowClass.InsertArrowObject(candleId, TREND_DOWN);
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
         double currentLow = getLow(trendTimeframe, candleId);
         double currentHigh = getHigh(trendTimeframe, candleId);
         if(currentTrend == TREND_DOWN) {
            if(currentLow < prevLL) {
               // Create a supply zone
               // scan back and find the first bull candle:
               int bullId = 0;
               for(int i = candleId + 1; bullId == 0; i++) {
                  double previousOpen = getOpen(trendTimeframe, i);
                  double previousClose = getClose(trendTimeframe, i);
                  if(previousClose > previousOpen) {
                     bullId = i;
                  }
               }
               
               double low = getLow(trendTimeframe, bullId);
               double high = getHigh(trendTimeframe, bullId);
               if(getHigh(trendTimeframe, bullId - 1) > high) {
                  high = getHigh(trendTimeframe, bullId - 1);
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
                  double previousOpen = getOpen(trendTimeframe, i);
                  double previousClose = getClose(trendTimeframe, i);
                  if(previousClose < previousOpen) {
                     bearId = i;
                  }
               }
               
               double high = getHigh(trendTimeframe, bearId);
               double low = getLow(trendTimeframe, bearId);
               if(getLow(trendTimeframe, bearId - 1) < low) {
                  low = getLow(trendTimeframe, bearId - 1);
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
                  price = getHigh(trendTimeframe, index);
                  break;
      
              case KEY_STRUCTURE_LL:
                  label = "LL";
                  index = candleId + indexLL + 1;
                  price = getLow(trendTimeframe, index);
                  break;
      
              default:
                  Print("Invalid type");
          }
          InsertTrendObject(label, price, index, trendTimeframe);
          return true;
      }

    
    
};
