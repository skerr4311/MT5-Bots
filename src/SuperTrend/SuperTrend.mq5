//+------------------------------------------------------------------+
//|                                                    SuperTrend.mq5 |
//|                             Copyright 2024, Steven Dangerfield-Kerr |
//|                                        https://www.mql5.com         |
//+------------------------------------------------------------------+
#property strict

// Inputs for SuperTrend settings
input double Factor = 3.0;          // Factor for ATR multiplier
input int ATRLength = 10;           // ATR Length
input double LotSize = 0.1;         // Lot size for trades

// Define variables
double SuperTrend[], Direction[];
double highestHigh, lowestLow, atrValue, superTrendValue;
int BarsCalculated;
int atrHandle;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Resize arrays to store values for at least two bars
   ArrayResize(SuperTrend, 2);  // Ensure at least two values
   ArrayResize(Direction, 2);   // Same for Direction array

   ArraySetAsSeries(SuperTrend, true);
   ArraySetAsSeries(Direction, true);

   // Create ATR handle
   atrHandle = iATR(_Symbol, _Period, ATRLength);
   if (atrHandle == INVALID_HANDLE)
     {
      Print("Error creating ATR handle: ", GetLastError());
      return INIT_FAILED;
     }

   Print("Initialization complete.");
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Check if there are enough bars to calculate SuperTrend
   int totalBars = Bars(_Symbol, _Period);
   Print("Bars available: ", totalBars);

   // Ensure there are enough bars to calculate the ATR and SuperTrend
   if (totalBars <= ATRLength + 1)
     {
      Print("Not enough bars to calculate ATR and SuperTrend. ATRLength: ", ATRLength);
      return;  // Exit OnTick if there are not enough bars
     }

   // Get the current closing price
   double closePrice = iClose(_Symbol, _Period, 0); // Get the close price of the current candle
   Print("Current Close Price: ", closePrice);

   // Calculate SuperTrend
   CalculateSuperTrend();

   // Ensure SuperTrend[0] is available before accessing it to avoid out-of-range error
   int superTrendArraySize = ArraySize(SuperTrend);
   Print("SuperTrend Array Size: ", superTrendArraySize);

   // Make sure array has the correct data size before accessing
   if (superTrendArraySize > 0 && !isnan(SuperTrend[0]) && !isnan(Direction[0]))
     {
      Print("SuperTrend[0]: ", SuperTrend[0]);
      Print("Direction[0]: ", Direction[0]);

      // Generate buy/sell signals
      if (closePrice > SuperTrend[0] && Direction[0] == 1)
        {
         Print("Buy Signal Detected");
         // Open a buy order if no position is open
         if (PositionsTotal() == 0)
           {
            OpenBuyOrder();
           }
        }
      else if (closePrice < SuperTrend[0] && Direction[0] == -1)
        {
         Print("Sell Signal Detected");
         // Close buy order if the signal flips
         CloseBuyOrder();
        }
     }
   else
     {
      Print("SuperTrend array is empty or contains invalid values.");
     }
  }

//+------------------------------------------------------------------+
//| Custom function to calculate SuperTrend                          |
//+------------------------------------------------------------------+
void CalculateSuperTrend()
  {
   // Ensure that the ATR handle is valid and data can be copied
   if (atrHandle == INVALID_HANDLE)
     {
      Print("ATR handle invalid. Exiting calculation.");
      return;
     }

   highestHigh = iHigh(_Symbol, _Period, 0);       // Get the highest high of the current candle
   lowestLow  = iLow(_Symbol, _Period, 0);         // Get the lowest low of the current candle
   Print("Highest High: ", highestHigh, " Lowest Low: ", lowestLow);

   // Retrieve ATR value using CopyBuffer
   double atrValues[];
   int copied = CopyBuffer(atrHandle, 0, 0, 1, atrValues);
   Print("ATR values copied: ", copied);

   if (copied <= 0)
     {
      Print("Error copying ATR values: ", GetLastError());
      return;
     }

   atrValue = atrValues[0]; // Get the current ATR value
   Print("ATR Value: ", atrValue);

   double closePrice = iClose(_Symbol, _Period, 0); // Get the current close price
   Print("Current Close Price for SuperTrend Calculation: ", closePrice);

   // Calculate SuperTrend and direction, ensuring you populate the arrays correctly
   if (ArraySize(SuperTrend) > 0)
     {
      if (closePrice > SuperTrend[0])
        {
         superTrendValue = lowestLow + Factor * atrValue;
         SuperTrend[0]   = superTrendValue;
         Direction[0]    = 1;   // Buy direction
         Print("Calculated SuperTrend: ", superTrendValue, " - Buy Direction");
        }
      else if (closePrice < SuperTrend[0])
        {
         superTrendValue = highestHigh - Factor * atrValue;
         SuperTrend[0]   = superTrendValue;
         Direction[0]    = -1;  // Sell direction
         Print("Calculated SuperTrend: ", superTrendValue, " - Sell Direction");
        }
     }
   else
     {
      Print("SuperTrend calculation error: Array is not properly initialized.");
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
   request.comment  = "SuperTrend Buy " + DoubleToString(superTrendValue, 2);  // Fix implicit conversion issue

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
