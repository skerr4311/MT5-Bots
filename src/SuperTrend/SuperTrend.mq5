//+------------------------------------------------------------------+
//|                                                    SuperTrend.mq5 |
//|                             Copyright 2024, Steven Dangerfield-Kerr |
//|                                        https://www.mql5.com         |
//+------------------------------------------------------------------+
#property strict

#include "../shared/class/SuperTrendClass.mqh" // Include the SuperTrendClass header

// Inputs for SuperTrend settings
input double Factor = 3.0;          // Factor for ATR multiplier
input int ATRLength = 10;           // ATR Length
input double LotSize = 0.1;         // Lot size for trades

// Define variables
SuperTrendClass superTrend; // Instance of SuperTrendClass

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Initialize the SuperTrendClass with input parameters
   superTrend.Init(Factor, ATRLength, _Period);

   Print("Initialization complete.");
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
    superTrend.Calculate();       // Calculate SuperTrend
    superTrend.DrawLine(0);       // Draw the SuperTrend line for the current bar

    double superTrendValue = superTrend.GetSuperTrendForBar(0);
    int direction = superTrend.GetDirection();

    // Trading logic
    double closePrice = iClose(Symbol(), _Period, 0);
    if (closePrice > superTrendValue && direction == 1) {
        Print("Buy Signal Detected");
        if (PositionsTotal() == 0) {
            OpenBuyOrder();
        }
    } else if (closePrice < superTrendValue && direction == -1) {
        Print("Sell Signal Detected");
        CloseBuyOrder();
    }
}

//+------------------------------------------------------------------+
//| Custom function to open a buy order                              |
//+------------------------------------------------------------------+
void OpenBuyOrder()
  {
   MqlTradeRequest request;
   MqlTradeResult result;

   // Initialize trade request structure
   request.action   = TRADE_ACTION_DEAL;           // Immediate order execution
   request.symbol   = _Symbol;                     // The current symbol
   request.volume   = LotSize;                     // The lot size
   request.type     = ORDER_TYPE_BUY;              // Buy order
   request.price    = SymbolInfoDouble(_Symbol, SYMBOL_ASK);  // Current ask price
   request.sl       = 0;                           // Stop loss level (not set)
   request.tp       = 0;                           // Take profit level (not set)
   request.deviation= 10;                          // Max price deviation in points
   request.magic    = 123456;                      // Unique identifier for the trade
   request.comment  = "SuperTrend Buy " + DoubleToString(superTrend.GetSuperTrend(), 2);

   Print("Opening Buy Order with price: ", request.price);

   // Send trade request
   if (!OrderSend(request, result))
     {
      Print("Error opening buy order: ", GetLastError());
     }
   else
     {
      Print("Buy order opened successfully.");
     }
  }

//+------------------------------------------------------------------+
//| Custom function to close buy orders                              |
//+------------------------------------------------------------------+
void CloseBuyOrder()
  {
   for (int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if (PositionSelect(ticket) && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
        {
         MqlTradeRequest request;
         MqlTradeResult result;

         request.action   = TRADE_ACTION_DEAL;
         request.position = ticket;  // Position ticket

         if (!OrderSend(request, result))
           {
            Print("Error closing buy order: ", GetLastError());
           }
         else
           {
            Print("Buy order closed successfully.");
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   superTrend.Deinit(); // Clean up resources
  }
