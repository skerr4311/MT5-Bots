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
         }
         
         // ontick fuction()
         void OnTick() {
            trendClass.HandleTrend();
            executionClass.HandleTrend();
            
            // check one
            CheckPriceRejection(1, trendClass.getTrend());
            
            // check two
            CheckTrendDirectionChange();
            
            // run the check on each 
            UpdateInfoBox();
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
             "\nTrend Direction: ", EnumToString(trendArrow), 
             "\nExecute Direction: ", EnumToString(executionArrow),
             "\nTrend Zone count: ", IntegerToString(trendClass.getZoneCount()),
             "\nExecute Direction: ", IntegerToString(executionClass.getZoneCount()),
             "\nAccount Profit: ", GetAccountEquity() - GetAccountBalance());
         }
         
         void CheckTrendDirectionChange() {
            TrendDirection trend = trendClass.getTrend();
            
            if (trendArrow != trend) {
            Print("trebd hit");
               if(EnumToString(trend) == "Down") {
                  double pips = CalculatePipDistance(getHigh(inputTrendTimeframe, 0), getClose(inputTrendTimeframe, 0));
                  Print("Pips: ", (string)pips);
                  double lotSize = CalculatePositionSize(risk_percent, pips);
                  Print("lot size: ", (string)lotSize);
                  double stopLoss = CalculateTakeProfit(getClose(inputTrendTimeframe, 0), getHigh(inputTrendTimeframe, 0), 3.0, false);
                  SellNow(lotSize, getHigh(inputTrendTimeframe, 0), stopLoss, "testing stop loss");
               } else if (EnumToString(trend) == "Up") {
                  // trigger a buy
                  Print("buy trigger");
               }
               
               trendArrow = trend;
            }
            
            executionArrow = executionClass.getTrend();
         }
         
         //+------------------------------------------------------------------+
         //| Check if price has rejected off a zone                           |
         //+------------------------------------------------------------------+
         bool CheckPriceRejection(int candleId, TrendDirection trend) {
             CandleInfo current = getCandleInfo(inputExecutionTimeframe, candleId);  
             CandleInfo previous = getCandleInfo(inputExecutionTimeframe, candleId + 1);
         
             for (int i = 0; i < trendClass.getZoneCount(); i++) {
                 ZoneInfo zone = trendClass.getZones(i);
                 
                 // Continuation: Zone is used as a retrace point for price to return to a zone to the continue on its path.       
                 // Rejection: Zone is used as a rejection point. The movement is not strong enough to break through a point.
                 
                 if(trend == TREND_UP) {
                     // Price is in an up trend, moves down to a green zone and then rejects off it.
                     if (zone.trend == trend && previous.low < zone.top && previous.low > zone.bottom && current.close > zone.top) {
                        DrawHorizontalLineWithLabel(current.close, clrGreen, 0, "bull rej");
                        Print("Top: ", zone.top);
                        Print("Bottom: ", zone.bottom);
                        Print(CalculatePipDistance(zone.top, zone.bottom));
                        return true;
                     }
      
                 } else if (trend == TREND_DOWN) {
                     // Red zone
                     if (zone.trend == trend && previous.high > zone.bottom && previous.high < zone.top && current.close < zone.bottom) {
                        HandleTrade(SELL_NOW, zone, getClose(inputExecutionTimeframe, 0));
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
