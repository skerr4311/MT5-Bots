//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include "TrendClass.mqh"
#include "tFunctions.mqh"
#include "KillZoneClass.mqh"

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
         KillZone londonKZ;
      
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
            
            londonKZ.init(inputExecutionTimeframe, LONDON);
         }
         
         // ontick fuction()
         void OnTick() {
            trendClass.HandleTrend();
            executionClass.HandleTrend();
            checkForEntry();
            londonKZ.OnTick();
            UpdateInfoBox();
         }
         
         //+------------------------------------------------------------------+
         //| Check for entry                                                  |
         //+------------------------------------------------------------------+
         void checkForEntry() {
            datetime currentExecTime = getTime(inputExecutionTimeframe, 0);
            if(currentExecTime != oncePerBarExec && CalculateSpread() < 3.0) {
               // check one
               if(CheckPriceRejection(1, trendClass.getTrend())){
                  oncePerBarExec = currentExecTime;
                  return;
               }
               
               // check two
               // if(CheckTrendDirectionChange()) {
                  // currentExecTime = currentExecTime;
                  // return;
               // }
            }
            
            datetime currentTrendTime = getTime(inputTrendTimeframe, 0);
            if(currentTrendTime != oncePerBarTrend && CalculateSpread() < 3.0) {
               // if (CheckRejectionOffEma()) {
                  // oncePerBarTrend = currentTrendTime;
                  // return;
               // }
            }
         }
         
         //+------------------------------------------------------------------+
         //| Function to handle chart events                                  |
         //+------------------------------------------------------------------+
         void handleChartEvent(const string &sparam) {
             trendClass.handleButtonClick(sparam);
             executionClass.handleButtonClick(sparam);
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
             "\nAccount Balance: ", GetAccountBalance());
         }
         
         //+------------------------------------------------------------------+
         //| Check rejection off EMA                                          |
         //+------------------------------------------------------------------+
         bool CheckRejectionOffEma() {
            double fiftyEMA = GetEMAForBar(1, inputTrendTimeframe, 50);
            TrendDirection trend = trendClass.getTrend();
            CandleInfo prevCandle = getCandleInfo(inputTrendTimeframe, 1);
            CandleInfo currentCandle = getCandleInfo(inputTrendTimeframe, 0);
            
            if (EnumToString(trend) == "Down") {
               // Check for ema rejection
               if(prevCandle.high > fiftyEMA && prevCandle.close < fiftyEMA){
                  HandleTrade(SELL_NOW, prevCandle.high, currentCandle.close, "50ema rejection down");
                  return true;
               }
               
            } else if (EnumToString(trend) == "Up") {
               // Check for ema rejection
               if(prevCandle.low < fiftyEMA && prevCandle.close > fiftyEMA) {
                  HandleTrade(BUY_NOW, prevCandle.low, currentCandle.close, "50ema rejection up");
                  return true;
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
               Print("switch: ", EnumToString(trend));
               if(EnumToString(trend) == "Down" && EnumToString(executionArrow) == "Down") {
                  // closePositions(1);
                  HandleTrade(SELL_NOW, getHigh(inputTrendTimeframe, 0), getClose(inputTrendTimeframe, 0), "Arrow down");
                  return true;
               } else if (EnumToString(trend) == "Up" && EnumToString(executionArrow) == "Up") {
                  // closePositions(2);
                  HandleTrade(BUY_NOW, getLow(inputTrendTimeframe, 0), getClose(inputTrendTimeframe, 0), "Arrow up");
                  return true;
               }
               
               trendArrow = trend;
            }
            
            return false;
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
                        HandleTrade(BUY_NOW, zone.bottom, getClose(inputExecutionTimeframe, 0), "Green zone rejection");
                        return true;
                     }
         
                 } else if (trend == TREND_DOWN) {
                     // Red zone
                     if (zone.trend == trend && previous.high > zone.bottom && previous.high < zone.top && current.close < zone.bottom) {
                        DrawHorizontalLineWithLabel(zone.top, clrRed, 0, "top");
                        DrawHorizontalLineWithLabel(zone.bottom, clrRed, 0, "bottom");
                        HandleTrade(SELL_NOW, zone.top, getClose(inputExecutionTimeframe, 0), "Red zone rejection");
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
