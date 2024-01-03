//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "iFunctions.mqh"

//+------------------------------------------------------------------+
//| Trend Class                                                      |
//+------------------------------------------------------------------+

// BasicClass.mqh
class BasicClass {
private:
    datetime marketStructureExecutionTime;
    double highestHigh, highestLow, lowestLow, lowestHigh;
    double prevLL, prevLH, prevHH, prevHL;
    bool isLowerLowReveseStarted, isHigherHighReverseStarted;
    int indexLL, indexHH;
    enum TrendDirection
      {
       TREND_NONE,
       TREND_UP,
       TREND_DOWN
      };
    enum KeyStructureType {
       KEY_STRUCTURE_HH,
       KEY_STRUCTURE_LL
    };
    TrendDirection currentTrend;
    ENUM_TIMEFRAMES trendTimeframe;
    int lookbackValue;
    
public:
    // Constructor
    BasicClass(int lookback, ENUM_TIMEFRAMES timeframe) {
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
    }
    
   //+------------------------------------------------------------------+
   //| Get Market trend                                                 |
   //+------------------------------------------------------------------+
   void SetInitialMarketTrend() {
      highestHigh = getHigh(trendTimeframe, lookbackValue + 1);
      lowestLow = getLow(trendTimeframe, lookbackValue + 1);
   
      for(int i = lookbackValue; i >= 1; i--) {
         IdentifyMarketStructure(i);
         handleChangeOfCharecter(i);
         CheckAndDeleteZones(i);
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
               DrawKeyStructurePoint(KEY_STRUCTURE_HH, trendTimeframe, candleId, newHigherHighIndex, newHigherHigh);
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
               handleBreakOfStructure(candleId, trendTimeframe);
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
               DrawKeyStructurePoint(KEY_STRUCTURE_LL, trendTimeframe, candleId, newLowerLowIndex, newLowerLow);
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
               handleBreakOfStructure(candleId, trendTimeframe);
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
               InsertArrowObject(candleId, trendTimeframe, TREND_UP);
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
               InsertArrowObject(candleId, trendTimeframe, TREND_DOWN);
               lowestLow = currentLow;
               prevLL = currentLow;
               lowestHigh = currentHigh;
               prevLH = currentHigh;
               indexHH = 0;
            }
         }
      }
      
      //+------------------------------------------------------------------+
      //| Delete Zone if 50% mitigated                                     |
      //+------------------------------------------------------------------+
      void CheckAndDeleteZones(int candleId) {
          double currentPrice = getClose(trendTimeframe, candleId);
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

    
    
};
