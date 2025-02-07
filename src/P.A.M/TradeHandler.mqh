//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include "../shared/class/TrendClass.mqh"
#include "../shared/class/KillZoneClass.mqh"

#include "../shared/function/tFunctions.mqh"
#include "../shared/function/iFunctions.mqh"

#include "../shared/class/PositionClass.mqh"

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
            londonKZ.init(inputExecutionTimeframe, LONDON, londonKzStart, londonKzEnd);
            newYorkKZ.init(inputExecutionTimeframe, NEW_YORK, NewYorkKzStart, NewYorkKzEnd);
            asianKZ.init(inputExecutionTimeframe, ASIAN, AsianKzStart, AsianKzEnd);
            
            if(londonKZ.getIsInit()) {
               londonKZ.SetInitialMarketTrend();
            }
            
            if(newYorkKZ.getIsInit()) {
               newYorkKZ.SetInitialMarketTrend();
            }
            
            if(asianKZ.getIsInit()) {
               asianKZ.SetInitialMarketTrend();
            }
         }

         //+------------------------------------------------------------------+
         //| Trade handler onTick fuction()                                                 |
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
               if(londonKZ.getIsInit() && londonKZ.checkIsInKillZone(0)){
                  isOneKillZoneActive = true;
               } else if(newYorkKZ.getIsInit() && newYorkKZ.checkIsInKillZone(0)) {
                  isOneKillZoneActive = true;
               } else if(asianKZ.getIsInit() && asianKZ.checkIsInKillZone(0)) {
                  isOneKillZoneActive = true;
               } else if (!londonKZ.getIsInit() && !newYorkKZ.getIsInit() && !asianKZ.getIsInit()) {
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
             if(londonKZ.getIsInit()) {
               londonKZ.HandleButtonClick(sparam);
            }
            
            if(newYorkKZ.getIsInit()) {
               newYorkKZ.HandleButtonClick(sparam);
            }
            
            if(asianKZ.getIsInit()) {
               asianKZ.HandleButtonClick(sparam);
            }
         }
         
         //+------------------------------------------------------------------+
         //| Function to create or update the information box                 |
         //+------------------------------------------------------------------+
         void UpdateInfoBox() {
             Comment(EA_Name, 
             "\nTrend Direction: ", TrendToString(trendClass.getTrend()), 
             "\nExecute Direction: ", TrendToString(executionClass.getTrend()),
             "\nTrend Zone count: ", IntegerToString(trendClass.getZoneCount()),
             "\nExecute Zone count: ", IntegerToString(executionClass.getZoneCount()),
             "\nAccount Profit: ", GetAccountEquity() - GetAccountBalance(),
             "\nAccount Balance: ", GetAccountBalance(),
             "\nConfirmation Count: ", trendClass.getTrendConfirmation(),
             "\nPosition Count: ", positionClass.getPositionsCount(),
             "\nBB: ", IntegerToString(ArraySize(breakerBlocks)));
         }

         //+------------------------------------------------------------------+
         //| Check for entry                                                  |
         //+------------------------------------------------------------------+
         void checkForEntry() {
            if(isInKillZone) {
               datetime currentExecTime = getTime(inputExecutionTimeframe, 0);
               if(currentExecTime != oncePerBarExec) {  // Ensure this runs only once per bar
                  oncePerBarExec = currentExecTime;
                  if (CalculateSpread() < 3.0) {
                     // attempt some execution specific check for entry
                  }
               }
               
               datetime currentTrendTime = getTime(inputTrendTimeframe, 0);
               if(currentTrendTime != oncePerBarTrend) {
                  oncePerBarTrend = currentTrendTime;
                  if (CalculateSpread() < 3.0) {
                     CheckPriceContinuation();
                  }
               }
            }
         }

         //+------------------------------------------------------------------+
         //| Check if price continuation off a zone                           |
         //+------------------------------------------------------------------+
         bool CheckPriceContinuation() {
            TrendDirection trend = trendClass.getTrend();
            CandleInfo prevCandle = getCandleInfo(inputTrendTimeframe, 1);

            DrawHorizontalLineWithLabel(prevCandle.high, clrPink, 0, "candle top", "Candle_top");
            DrawHorizontalLineWithLabel(prevCandle.bottomOfTopWick, clrPink, 0, "candle bottom of top wick", "Candle_bottom_top_wick");

            datetime currentTrendTime = getTime(inputTrendTimeframe, 0);

            DrawLabel("name", "label", prevCandle.high, currentTrendTime);


            for (int i = 0; i < executionClass.getZoneCount(); i++) {
               ZoneInfo zone = executionClass.getZones(i);
               DrawHorizontalLineWithLabel(zone.bottom, clrAntiqueWhite, 0, "candle bottom", zone.startTime);
               if (trend == TREND_DOWN && zone.trend == TREND_DOWN){
                  if (prevCandle.high > zone.bottom && prevCandle.bottomOfTopWick < zone.bottom) {
                     // DrawHorizontalLineWithLabel(zone.bottom, clrPink, 0, "candle bottom", "Candle_bottom");
                     return positionClass.HandleTrade(SELL_STOP, zone.top, zone.bottom, "Down trend Exec Zone continuation");
                  }
               }
            }
            return true;
         }         

         //+------------------------------------------------------------------+
         //| Check if price continuation off a zone                           |
         //+------------------------------------------------------------------+
         bool CheckPriceContinuationOffZone() {
            TrendDirection trend = trendClass.getTrend();
            TrendDirection execTrend = executionClass.getTrend();
            CandleInfo prevPrevCandle = getCandleInfo(inputExecutionTimeframe, 2);
            CandleInfo prevCandle = getCandleInfo(inputExecutionTimeframe, 1);
            CandleInfo currentCandle = getCandleInfo(inputExecutionTimeframe, 0);
            bool isTrade = false;

            positionClass.CancelAllPendingOrders();
            // Execution Zones
            for (int i = 0; i < executionClass.getZoneCount(); i++) {
               Print("zone: " + i + " out of " + executionClass.getZoneCount() + " zones.");
               ZoneInfo zone = executionClass.getZones(i);
               if (trend == TREND_DOWN){
                  DrawHorizontalLineWithLabel(prevCandle.low, clrOrange, 1, "candle bottom", "Candle_bottom");
                  if (zone.trend == TREND_DOWN){
                     // Looking for continuation
                     /*
                     1. if prevprev candle is below the given zone
                     2. if prevcandle wicks zone
                     3. if current candle is below the zone
                     */
                     
                     if (prevPrevCandle.close < zone.bottom) {
                        if (prevCandle.high > zone.bottom && prevCandle.close < zone.bottom) {
                           DrawHorizontalLineWithLabel(zone.top, clrOrange, 0, "Zone trend down", zone.startTime);
                           return positionClass.HandleTrade(SELL_STOP, zone.top, prevCandle.low, "Down trend Exec Zone continuation");
                        }
                     }
                  } else if (zone.trend == TREND_UP) {
                     // looking for rejection
                     if (prevPrevCandle.low > zone.top) {
                        if (prevCandle.low < zone.top) {
                           if (currentCandle.close > zone.top) {
                              DrawHorizontalLineWithLabel(zone.bottom, clrOrange, 0, "LABEL", IntegerToString(zone.bottom));
                              return positionClass.HandleTrade(BUY_STOP, zone.bottom, currentCandle.high, "Down trend Zone rejection");
                           }
                        }
                     }
                  }
               } else if (trend == TREND_UP) {
                  if (zone.trend == TREND_UP) {

                  } else if (zone.trend == TREND_DOWN) {
                     /*
                     Look for rejection off Red Zone
                     1. prevprev candle close below red zone
                     2. prevcandle wicks zone
                     3. currentCandle close is below zone
                     */
                    if (prevPrevCandle.close < zone.bottom) {
                     if (prevCandle.high > zone.bottom && prevCandle.bottomOfTopWick < zone.bottom) {
                        if (currentCandle.close < zone.bottom) {
                           DrawHorizontalLineWithLabel(zone.bottom, clrOrange, 0, "LABEL", IntegerToString(zone.bottom));
                           return positionClass.HandleTrade(SELL_STOP, zone.top, prevCandle.low, "Down trend Exec Zone continuation");
                        }
                     }
                    }
                  }
               }
            }
            // Trend Zones
            for (int z = 0; z < trendClass.getZoneCount(); z++) {
               ZoneInfo zone = trendClass.getZones(z);
               if (trend == TREND_DOWN){
                  if (zone.trend == TREND_DOWN) {
                     // Looking for continuation
                     /*
                     Three conditions:
                     1. the wick was just shy
                     2. the zone was wicked
                     3. the prev candle was inside the zone but the current closed below.
                     */
                     if ((zone.bottom > prevPrevCandle.high && CalculatePipDifference(zone.bottom, prevPrevCandle.high) < 5.0) || (prevPrevCandle.high > zone.bottom && prevPrevCandle.bottomOfTopWick < zone.bottom)) {
                        if (zone.bottom > prevCandle.high) {
                           DrawHorizontalLineWithLabel(zone.top, clrOrange, 0, "LABEL", IntegerToString(zone.bottom));
                           return positionClass.HandleTrade(SELL_STOP, zone.top, prevCandle.low, "Down trend high Zone rejection");
                        }
                     }

                     // Looking for rejection
                     // DrawHorizontalLineWithLabel(zone.top, clrAqua, 0, "LABEL", IntegerToString(z));
                     if (prevPrevCandle.low > zone.top) {
                        if (zone.top > prevCandle.low) {
                           if (prevCandle.topOfBottomWick > zone.top) {
                              DrawHorizontalLineWithLabel(zone.bottom, clrOrange, 0, "LABEL", IntegerToString(zone.bottom));
                              return positionClass.HandleTrade(BUY_STOP, zone.bottom, prevCandle.high, "Down trend Zone rejection");
                           }
                        }
                     }
                  } else if (zone.trend == TREND_UP) {
                     /*
                     looking for a trend down rejection off green zone
                     1. is price higher that the green zone? is it moving down towards a green zone?
                     2. does the previous candle wick the top of the zone?
                     3. is the current candle close higher than the top of the zone?
                     */
                    if (prevPrevCandle.close > zone.top) {
                     if (prevCandle.close > zone.top && prevCandle.low < zone.top && prevCandle.low > zone.midPrice) {
                        if (currentCandle.close > zone.top) {
                           DrawHorizontalLineWithLabel(zone.bottom, clrOrange, 0, "LABEL", IntegerToString(zone.bottom));
                           return positionClass.HandleTrade(BUY_STOP, prevCandle.low, prevCandle.high, "Down trend Zone rejection");
                        }
                     }
                    }
                  }
               } else if (trend == TREND_UP) {
                  if (zone.trend == TREND_UP) {
                     // Looking for continuation

                     // Looking for rejection
                     if (prevPrevCandle.high < zone.bottom ) {
                        if (prevCandle.high > zone.bottom && prevCandle.bottomOfTopWick < zone.bottom) {
                           DrawHorizontalLineWithLabel(zone.top, clrOrange, 0, "LABEL", IntegerToString(zone.bottom));
                           return positionClass.HandleTrade(SELL_STOP, zone.top, prevCandle.low, "Up trend Zone rejection");
                        }
                     }
                  } else {
                     // look for rejection of red zone higher than price
                     // if (prevPrevCandle.high > zone.bottom && prevPrevCandle.high < zone.top) {
                     //    if (prevCandle.close < zone.bottom) {
                     //       return positionClass.HandleTrade(SELL_STOP, zone.top, prevCandle.low, "Up trend red Zone rejection");
                     //    }
                     // }
                  }
               }
            }
            
            return isTrade;
         }
  };
//+------------------------------------------------------------------+
