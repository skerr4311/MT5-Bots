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
            oncePerBarTrend = getTime(inputExecutionTimeframe, 0);
            
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
         
         //+------------------------------------------------------------------+
         //| Check for entry                                                  |
         //+------------------------------------------------------------------+
         void checkForEntry() {
            if(isInKillZone) {
               datetime currentExecTime = getTime(inputExecutionTimeframe, 0);
               if(currentExecTime != oncePerBarExec && CalculateSpread() < 3.0) {
                  /*
                  // check one
                  if(CheckPriceRejection(1, trendClass.getTrend())){
                     oncePerBarExec = currentExecTime;
                     return;
                  }
                  
                  
                  // check two
                  if(CheckTrendDirectionChange()) {
                     currentExecTime = currentExecTime;
                     return;
                  }
                  */
                  // check three
                  if(CheckRejectionOffEma()){
                     oncePerBarExec = currentExecTime;
                     return;
                  }
                  /*
                  if(CheckPriceContinuationOffZone()){
                     oncePerBarExec = currentExecTime;
                     return;
                  }
                  */
               }
               
               datetime currentTrendTime = getTime(inputTrendTimeframe, 0);
               if(currentTrendTime != oncePerBarTrend && CalculateSpread() < 3.0) {
                  // if (CheckRejectionOffEma()) {
                     // oncePerBarTrend = currentTrendTime;
                     // return;
                  // }
               }
            }
         }
         
         //+------------------------------------------------------------------+
         //| Check rejection off EMA                                          |
         //+------------------------------------------------------------------+
         /*
         TESTING: trend: 1hr exec: 5min period: 01-01-24 - 23-03-24

         GBPJPY: 0.55 winRate: 45.45% short: 27.50% long: 66.67% consecLoss: 2 drawdown: 1.75%
         EURUSD: 1.06 winRate: 57.14% short: 66.67% long: 50.00% consecLoss: 2 drawdown: 2.85%
         USDCAD: 1.95 winRate: 57.14% short: 60.00% long: 50:00% consecLoss: 2 drawdown: 1.13%
         GBPUSD: 0.99 winRate: 40.00% short: 66.67% long: 00.00% consecLoss: 2 drawdown: 2.05%
         AUDUSD: 0.02 winRate: 14.29% short: 00.00% long: 25:00% consecLoss: 3 drawdown: 5.32%
         USDJPY: 0.02 winRate: 11.11% short: 16.67% long: 00.00% consecLoss: 4 drawdown: 3.70%
         USDCHF: 1.01 winRate: 50.00% short: 50.00% long: 50.00% consecLoss: 2 drawdown: 2.72%
         */
         bool CheckRejectionOffEma() {
            double fiftyEMA = GetEMAForBar(0, inputTrendTimeframe, 50);
            TrendDirection trend = trendClass.getTrend();
            CandleInfo prevprevCandle = getCandleInfo(inputExecutionTimeframe, 2);
            CandleInfo prevCandle = getCandleInfo(inputExecutionTimeframe, 1);
            CandleInfo currentCandle = getCandleInfo(inputExecutionTimeframe, 0);
            
            if (EnumToString(trend) == "Down") {
               // Check for ema rejection
               if(prevCandle.high > fiftyEMA && prevCandle.close < fiftyEMA){
                  positionClass.HandleTrade(SELL_NOW, prevCandle.high, currentCandle.close, "50ema rejection down");
                  return true;
               }
               
            } else if (EnumToString(trend) == "Up") {
               // Check for ema rejection
               if (prevprevCandle.high < fiftyEMA && prevCandle.close < fiftyEMA) {
                  // looking for rejection
                  if(prevCandle.high > fiftyEMA && prevCandle.close < fiftyEMA) {
                     positionClass.HandleTrade(SELL_NOW, prevCandle.high, currentCandle.close, "50ema rejection up");
                     return true;
                  }
               } else {
                  // looking for continuation
                  if(prevCandle.low < fiftyEMA && prevCandle.close > fiftyEMA) {
                     positionClass.HandleTrade(BUY_NOW, prevCandle.low, currentCandle.close, "50ema continuation up");
                     return true;
                  }
               }
            }
            
            return false;
         }
         
         //+------------------------------------------------------------------+
         //| Check trend direction                                            |
         //+------------------------------------------------------------------+
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

         GBPJPY: 1.88 winRate: 38.89% short: 66.67% long: 33.33% consecLoss: 9
         * GBPJPY: 0.54 winRate: 52.63% short: 100.00% long: 43.75% consecLoss: 2
         EURUSD: 5.83 winRate: 66.67% short: 66.67% long: 66.67% consecLoss: 2
         * EURUSD: 5.84 winRate: 66.67% short: 66.67% long: 66.67% consecLoss: 2
         USDCAD: FAIL
         * USDCAD: Survived in the negatives
         GBPUSD: 1.23 winRate: 30.77% short: 00.00% long: 40.00% consecLoss: 4
         * GBPUSD: 1.95 winRate: 57.14% short: 25.00% long: 70.00% consecLoss: 1
         AUDUSD: FAIL
         * AUDUSD: 0.14 winRate: 50.00% short: 100.00% long: 33.33% consecLoss: 2
         USDJPY: 1.27 winRate: 31.58% short: 28.57% long: 33.33% consecLoss: 3
         * USDJPY: 1.07 winRate: 52.63% short: 28.57% long: 66.67% consecLoss: 3
         USDCHF: 0.80 winRate: 20.00% short: 00.00% long: 25.00% consecLoss: 2
         * USDCHF: 0.00 winRate: 00.00% short: 00.00% long: 00.00% consecLoss: 2
         */

         bool CheckPriceContinuationOffZone() {
            TrendDirection trend = trendClass.getTrend();
            CandleInfo prevPrevCandle = getCandleInfo(inputExecutionTimeframe, 2);
            CandleInfo prevCandle = getCandleInfo(inputExecutionTimeframe, 1);
            CandleInfo currentCandle = getCandleInfo(inputExecutionTimeframe, 0);
            bool isTrade = false;

            for (int i = 0; i < executionClass.getZoneCount(); i++) {
               ZoneInfo zone = executionClass.getZones(i);
               if (trend == TREND_UP && trendClass.getTrendConfirmation() > 1 && zone.trend == TREND_UP){
                  if (zone.top > prevPrevCandle.low && prevPrevCandle.high > zone.top && prevCandle.high > zone.top ) {

                     positionClass.HandleTrade(BUY_NOW, zone.bottom, currentCandle.close, "Green zone rejection");
                     isTrade = true;
                     break;
                  }
               } else if (trend == TREND_DOWN && trendClass.getTrendConfirmation() > 1 && zone.trend == TREND_DOWN) {
                  if (prevPrevCandle.high > zone.bottom && zone.bottom > prevPrevCandle.low && zone.bottom > prevCandle.low) {
                     positionClass.HandleTrade(SELL_NOW, zone.top, currentCandle.close, "Red zone rejection");
                     isTrade = true;
                     break;
                  }
               }
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
                        DrawHorizontalLineWithLabel(zone.top, clrGreen, 0, "top");
                        DrawHorizontalLineWithLabel(zone.bottom, clrGreen, 0, "bottom");
                        positionClass.HandleTrade(BUY_NOW, zone.bottom, getClose(inputExecutionTimeframe, 0), "Green zone rejection");
                        return true;
                     }
         
                 } else if (trend == TREND_DOWN) {
                     // Red zone
                     if (zone.trend == trend && previous.high > zone.bottom && previous.high < zone.top && current.close < zone.bottom) {
                        DrawHorizontalLineWithLabel(zone.top, clrRed, 0, "top");
                        DrawHorizontalLineWithLabel(zone.bottom, clrRed, 0, "bottom");
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
