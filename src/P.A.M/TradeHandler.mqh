//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "TrendClass.mqh"
#include "tFunctions.mqh"
#include "KillZoneClass.mqh"
#include "iFunctions.mqh"
#include "CommonGlobals.mqh"
#include "PositionClass.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradeHandler
  {
      private:
         TrendClass trendClass;
         TrendClass executionClass;
         TrendDirection trendArrow;
         TrendDirection executionArrow;
         datetime oncePerBarExec;
         datetime oncePerBarTrend;
         datetime oncePerBarKillZone;
         KillZone londonKZ;
         KillZone newYorkKZ;
         KillZone asianKZ;
         bool isInKillZone;
         ZoneInfo breakerBlocks[];
         PositionClass positionClass;
      
      public:
         // Constructor
         TradeHandler() {}
         
         // Initiate
         void init(int lookback) {
            trendClass.init(lookBack, inputTrendTimeframe);
            trendClass.SetInitialMarketTrend();
            trendArrow = trendClass.getTrend();
            
            executionClass.init(lookBack, inputExecutionTimeframe);
            executionClass.SetInitialMarketTrend();
            executionArrow = executionClass.getTrend();
            
            oncePerBarExec = getTime(inputExecutionTimeframe, 0);
            oncePerBarTrend = getTime(inputTrendTimeframe, 0);
            
            isInKillZone = false;
            
            positionClass.init();
            initKillZones();
         }
         
         //+------------------------------------------------------------------+
         //| init Kill Zones                                                  |
         //+------------------------------------------------------------------+
         void initKillZones() {
            if(isLondonInitiated()) {
               londonKZ.init(inputExecutionTimeframe, LONDON, londonKzStart, londonKzEnd);
               londonKZ.SetInitialMarketTrend();
            }
            
            if(isNewYorkInitiated()) {
               newYorkKZ.init(inputExecutionTimeframe, NEW_YORK, NewYorkKzStart, NewYorkKzEnd);
               newYorkKZ.SetInitialMarketTrend();
            }
            
            if(isAsiaInitiated()) {
               asianKZ.init(inputExecutionTimeframe, ASIAN, AsianKzStart, AsianKzEnd);
               asianKZ.SetInitialMarketTrend();
            }
         }

         //+------------------------------------------------------------------+
         //| onTick fuction()                                                 |
         //+------------------------------------------------------------------+
         void OnTick() {
            trendClass.HandleTrend();
            executionClass.HandleTrend();
            if (target_profit > GetAccountBalance()) {
               CheckIfInKillZone();
               checkForBreakerBlock();
               checkForEntry();
               positionClass.HandleOpenPositions();
            } else {
               if (positionClass.getPositionsCount() > 0) {
                  positionClass.CloseAllOpenPositions();
               }
            }
            UpdateInfoBox();
         }

         //+------------------------------------------------------------------+
         //| onTrade fuction()                                                 |
         //+------------------------------------------------------------------+
         void OnTrade() {
            positionClass.HandleOnTradeFunction();
         }


         //+------------------------------------------------------------------+
         //| Check for breaker block                                          |
         //+------------------------------------------------------------------+
         void checkForBreakerBlock() {
            for(int i = 0; i < trendClass.getZoneCount(); i++) {
               ZoneInfo trendZone = trendClass.getZones(i);

               for(int j = 0; j < executionClass.getZoneCount(); j++) {
                  ZoneInfo executionZone = executionClass.getZones(j);

                  if(executionZone.top <= trendZone.top && executionZone.bottom >= trendZone.bottom) {
                     bool isAddToBreakerArray = false;
                     if (ArraySize(breakerBlocks) == 0) {
                        isAddToBreakerArray = true;
                     } else {
                        isAddToBreakerArray = true;                
                        for(int x = 0; x < ArraySize(breakerBlocks); x++) {
                           ZoneInfo breakerBlock = breakerBlocks[x];
                           if (executionZone.name == breakerBlock.name) {
                              isAddToBreakerArray = false;
                           }
                        }
                     }

                     if (isAddToBreakerArray) {
                        ArrayResize(breakerBlocks, ArraySize(breakerBlocks) + 1);
                        breakerBlocks[ArraySize(breakerBlocks) - 1] = executionZone;
                     }

                  }
               }
            }
         }
         
         //+------------------------------------------------------------------+
         //| Check If In Kill Zone                                            |
         //+------------------------------------------------------------------+
         void CheckIfInKillZone() {
            datetime currentExecTime = getTime(inputExecutionTimeframe, 0);
            if(currentExecTime != oncePerBarKillZone) {
               bool isOneKillZoneActive = false;
               if(isLondonInitiated() && londonKZ.checkIsInKillZone(0)){
                  isOneKillZoneActive = true;
               } else if(isNewYorkInitiated() && newYorkKZ.checkIsInKillZone(0)) {
                  isOneKillZoneActive = true;
               } else if(isAsiaInitiated() && asianKZ.checkIsInKillZone(0)) {
                  isOneKillZoneActive = true;
               } else if (!isLondonInitiated() && !isNewYorkInitiated() && !isAsiaInitiated()) {
                  // if not KZ initiated then trade all time frames
                  isOneKillZoneActive = true;
               }
            
               isInKillZone = isOneKillZoneActive;
               oncePerBarKillZone = currentExecTime;
            }
         }
         
         //+------------------------------------------------------------------+
         //| Function to handle chart events                                  |
         //+------------------------------------------------------------------+
         void handleChartEvent(const string &sparam) {
             trendClass.handleButtonClick(sparam);
             executionClass.handleButtonClick(sparam);
             if(isLondonInitiated()) {
               londonKZ.HandleButtonClick(sparam);
            }
            
            if(isNewYorkInitiated()) {
               newYorkKZ.HandleButtonClick(sparam);
            }
            
            if(isAsiaInitiated()) {
               asianKZ.HandleButtonClick(sparam);
            }
         }
         
         //+------------------------------------------------------------------+
         //| Function to create or update the information box                 |
         //+------------------------------------------------------------------+
         void UpdateInfoBox() {
             Comment(EA_Name, 
             "\nTrend Direction: ", EnumToString(trendClass.getTrend()), 
             "\nExecute Direction: ", EnumToString(executionClass.getTrend()),
             "\nTrend Zone count: ", IntegerToString(trendClass.getZoneCount()),
             "\nExecute Direction: ", IntegerToString(executionClass.getZoneCount()),
             "\nAccount Profit: ", GetAccountEquity() - GetAccountBalance(),
             "\nAccount Balance: ", GetAccountBalance(),
             "\nConfirmation Count: ", trendClass.getTrendConfirmation(),
             "\nPosition Count: ", positionClass.getPositionsCount(),
             "\nBB: ", IntegerToString(ArraySize(breakerBlocks)));
         }

         /*
         TESTING: trend: 1hr exec: 5min period: 01-01-23 - 23-03-24
          - CheckTrendDirectionChange
          - CheckPriceContinuationOffZone
          - CheckRejectionOffEma (Trend Time)

         GBPJPY: -$540.63
         * No protection - tapped out GROSS 50K!
         EURUSD: -$73.19
         * Tapped out very quickly
         USDCAD: $1,651.40
         * Tapped out very quickly
         GBPUSD: Tapped out
         * tapped ut fairly quickly
         AUDUSD: $711.88
         * tapped out semi quickly
         USDJPY: -$952.10
         * tapped out two months
         USDCHF: tapped out
         * tapped out quick

         * no protection is no good
         */
         
         //+------------------------------------------------------------------+
         //| Check for entry                                                  |
         //+------------------------------------------------------------------+
         void checkForEntry() {
            if(isInKillZone) {
               datetime currentExecTime = getTime(inputExecutionTimeframe, 0);
               if(currentExecTime != oncePerBarExec) {  // Ensure this runs only once per bar
                  if (CalculateSpread() < 3.0) {
                     // Combined check for all conditions
                     bool shouldExecuteTrade = 
                           //CheckPriceRejection(1, trendClass.getTrend()) ||  // Uncomment and use if needed
                           //CheckTrendDirectionChange() ||  // Uncomment and use if needed
                           //CheckRejectionOffEma() // ||
                           CheckPriceContinuationOffZone();

                     if (shouldExecuteTrade) {
                           oncePerBarExec = currentExecTime;  // Update the execution timestamp after any condition is true
                           Print("Trade executed or operation performed for the current bar: ", currentExecTime);
                           return;
                     }
                  }
               } else {
                  Print("Attempt to execute multiple times in the same bar prevented.");
               }
               
               datetime currentTrendTime = getTime(inputTrendTimeframe, 0);
               if(currentTrendTime != oncePerBarTrend && CalculateSpread() < 3.0) {
                  // if (CheckRejectionOffEma()) {
                  //    oncePerBarTrend = currentTrendTime;
                  //    return;
                  // }
               }
            }
         }         
         
         //+------------------------------------------------------------------+
         //| Check rejection off EMA                                          |
         //+------------------------------------------------------------------+
         bool CheckRejectionOffEma() {
            double fiftyEMA = GetEMAForBar(0, inputTrendTimeframe, 50);
            TrendDirection trend = trendClass.getTrend();
            CandleInfo prevPrevCandle = getCandleInfo(inputExecutionTimeframe, 2);
            CandleInfo prevCandle = getCandleInfo(inputExecutionTimeframe, 1);
            CandleInfo currentCandle = getCandleInfo(inputExecutionTimeframe, 0);

            if(trend == TREND_DOWN) {
               if((prevPrevCandle.high < fiftyEMA) || (prevPrevCandle.high > fiftyEMA && prevPrevCandle.topOfBottomWick < fiftyEMA)) {
                  if (prevCandle.high >= fiftyEMA) {
                     if (prevCandle.bottomOfTopWick < fiftyEMA) {
                        positionClass.HandleTrade(SELL_NOW, prevCandle.high, currentCandle.close, "50ema rejection down");
                     }
                  }
               }
            }
            
            return false;
         }
         
         //+------------------------------------------------------------------+
         //| Check trend direction                                            |
         //+------------------------------------------------------------------+
         /*
         TESTING: trend: 1hr exec: 5min period: 01-01-23 - 23-03-24
         */
         bool CheckTrendDirectionChange() {
            TrendDirection trend = trendClass.getTrend();
            executionArrow = executionClass.getTrend();
            
            if (trendArrow != trend) {
               if(EnumToString(trend) == "Down" && EnumToString(executionArrow) == "Down") {
                  // closePositions(1);
                  positionClass.HandleTrade(SELL_NOW, getHigh(inputTrendTimeframe, 0), getClose(inputTrendTimeframe, 0), "Arrow down");
                  return true;
               } else if (EnumToString(trend) == "Up" && EnumToString(executionArrow) == "Up") {
                  // closePositions(2);
                  positionClass.HandleTrade(BUY_NOW, getLow(inputTrendTimeframe, 0), getClose(inputTrendTimeframe, 0), "Arrow up");
                  return true;
               }
               
               trendArrow = trend;
            }
            
            return false;
         }

         //+------------------------------------------------------------------+
         //| Check if price continuation off a zone                           |
         //+------------------------------------------------------------------+
         /*
         TESTING: trend: 1hr exec: 5min period: 01-01-23 - 23-03-24
         */

         bool CheckPriceContinuationOffZone() {
            TrendDirection trend = trendClass.getTrend();
            CandleInfo prevPrevCandle = getCandleInfo(inputExecutionTimeframe, 2);
            CandleInfo prevCandle = getCandleInfo(inputExecutionTimeframe, 1);
            CandleInfo currentCandle = getCandleInfo(inputExecutionTimeframe, 0);
            bool isTrade = false;

            if (trend == TREND_DOWN){
               DrawHorizontalLineWithLabel(currentCandle.close, clrRed, 0, "LABEL", "trend");
               for (int i = 0; i < executionClass.getZoneCount(); i++) {
                  ZoneInfo zone = executionClass.getZones(i);
                  if (zone.trend == TREND_DOWN){
                     // Looking for continuation
                     if (prevCandle.bottomOfTopWick > zone.bottom && prevCandle.high < zone.midPrice) {
                        if (prevPrevCandle.bottomOfTopWick > zone.bottom && prevPrevCandle.high < zone.midPrice) {
                           DrawHorizontalLineWithLabel(zone.midPrice, clrPurple, 0, "LABEL", IntegerToString(i));
                           positionClass.HandleTrade(SELL_STOP, zone.top, prevCandle.low, "Zone continuation");
                        }
                     }
                  } 
               }
            } else {
               DrawHorizontalLineWithLabel(currentCandle.close, clrGreen, 0, "LABEL", "trend");
            }
            
            return isTrade;
         }

         //+------------------------------------------------------------------+
         //| Get Stoploss from zone                                           |
         //+------------------------------------------------------------------+
         double getStopLossFromZone(TrendDirection trend, bool isTrend, double entryPrice) {
            double stoploss = entryPrice;

            if (isTrend) {
               for (int i = 0; i < trendClass.getZoneCount(); i++) {
                  ZoneInfo zone = trendClass.getZones(i);
                  if (trend == TREND_UP) {
                     if (zone.trend == TREND_DOWN && zone.bottom > entryPrice && zone.bottom > stoploss) {
                        stoploss = zone.bottom;
                     }
                  } else {
                     if (zone.trend == TREND_UP && zone.top < entryPrice && zone.top < stoploss) {
                        stoploss = zone.top;
                     }
                  }
               }
            } else {
               for (int i = 0; i < executionClass.getZoneCount(); i++) {
                  ZoneInfo zone = executionClass.getZones(i);
                  if (trend == TREND_UP) {
                     if (zone.trend == TREND_DOWN && zone.bottom > entryPrice && zone.bottom > stoploss) {
                        stoploss = zone.bottom;
                     }
                  } else {
                     if (zone.trend == TREND_UP && zone.top < entryPrice && zone.top < stoploss) {
                        stoploss = zone.top;
                     }
                  }
               }
            }

            return stoploss == entryPrice ? 0.00 : stoploss;

         }
         
         //+------------------------------------------------------------------+
         //| Check if price has rejected off a zone                           |
         //+------------------------------------------------------------------+
         bool CheckPriceRejection(int candleId, TrendDirection trend) {
             CandleInfo current = getCandleInfo(inputExecutionTimeframe, candleId);  
             CandleInfo previous = getCandleInfo(inputExecutionTimeframe, candleId + 1);
         
             /*
               
             for (int i = 0; i < trendClass.getZoneCount(); i++) {
                 ZoneInfo zone = trendClass.getZones(i);
                 
                 // Continuation: Zone is used as a retrace point for price to return to a zone to the continue on its path.       
                 // Rejection: Zone is used as a rejection point. The movement is not strong enough to break through a point.
                 
                 if(trend == TREND_UP) {
                     // Price is in an up trend, moves down to a green zone and then rejects off it.
                     if (zone.trend == trend && previous.low < zone.top && previous.low > zone.bottom && current.close > zone.top) {
                        HandleTrade(BUY_NOW, zone.bottom, getClose(inputExecutionTimeframe, 0), "Green zone rejection");
                        return true;
                     }
         
                 } else if (trend == TREND_DOWN) {
                     // Red zone
                     if (zone.trend == trend && previous.high > zone.bottom && previous.high < zone.top && current.close < zone.bottom) {
                        HandleTrade(SELL_NOW, zone.top, getClose(inputExecutionTimeframe, 0), "Red zone rejection");
                        return true;
                     }
         
                 } else {
                  // nothing
         
                 }
             }
             */
             for (int i = 0; i < executionClass.getZoneCount(); i++) {
                 ZoneInfo zone = executionClass.getZones(i);
                 
                 // Continuation: Zone is used as a retrace point for price to return to a zone to the continue on its path.       
                 // Rejection: Zone is used as a rejection point. The movement is not strong enough to break through a point.
                 
                 if(trend == TREND_UP) {
                     // Price is in an up trend, moves down to a green zone and then rejects off it.
                     if (zone.trend == trend && previous.low < zone.top && previous.low > zone.bottom && current.close > zone.top) {
                        positionClass.HandleTrade(BUY_NOW, zone.bottom, getClose(inputExecutionTimeframe, 0), "Green zone rejection");
                        return true;
                     }
         
                 } else if (trend == TREND_DOWN) {
                     // Red zone
                     if (zone.trend == trend && previous.high > zone.bottom && previous.high < zone.top && current.close < zone.bottom) {
                        positionClass.HandleTrade(SELL_NOW, zone.top, getClose(inputExecutionTimeframe, 0), "Red zone rejection");
                        return true;
                     }
         
                 } else {
                  // nothing
         
                 }
             }
             
             return false;
         }
  };
//+------------------------------------------------------------------+
