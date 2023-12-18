//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Inclue                                                           |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
static input long    magicNumber = 69420; // magic number
input int lookBack = 5; // Number of bars to look back to identify the highs and lows

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
MqlTick currentTick;
CTrade trade;
datetime openTimeBuy = 0;
datetime openTimeSell = 0;
double highPrices[];
double lowPrices[];
datetime barTimes[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   // init items here
   if(!checkParameters()) {return INIT_PARAMETERS_INCORRECT;}
   
   // set magic number to trade object
   trade.SetExpertMagicNumber(magicNumber);
   
   // Resize arrays to the required size
   ArraySetAsSeries(highPrices, true);
   ArraySetAsSeries(lowPrices, true);
   ArraySetAsSeries(barTimes, true);
   ArrayResize(highPrices, lookBack + 1);
   ArrayResize(lowPrices, lookBack + 1);
   ArrayResize(barTimes, lookBack + 1);

   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {

}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {   
   // Copy the high and low prices of the last 'lookBack + 1' bars
   if(CopyHigh(_Symbol, _Period, 0, lookBack + 1, highPrices) <= 0)
     {
      Print("Failed to copy high prices: ", GetLastError());
      return;
     }

   if(CopyLow(_Symbol, _Period, 0, lookBack + 1, lowPrices) <= 0)
     {
      Print("Failed to copy low prices: ", GetLastError());
      return;
     }

   // Get the bar index of the highest high and lowest low in the lookback period
   int highestIndex = ArrayMaximum(highPrices, 0, lookBack);
   int lowestIndex = ArrayMinimum(lowPrices, 0, lookBack);

   // Determine the highest high and lowest low values
   double lastHigh = highPrices[highestIndex];
   double lastLow = lowPrices[lowestIndex];

   // Detect Higher High (HH)
   if(lastHigh > highPrices[ArrayMaximum(highPrices, 1, lookBack)]) {
      DrawLabel("HH", lastHigh);
   }

   // Detect Higher Low (HL)
   if(lastLow > lowPrices[ArrayMinimum(lowPrices, 1, lookBack)]) {
      DrawLabel("HL", lastLow);
   }

   // Detect Lower High (LH)
   if(lastHigh < highPrices[ArrayMaximum(highPrices, 1, lookBack)]) {
      DrawLabel("LH", lastHigh);
   }

   // Detect Lower Low (LL)
   if(lastLow < lowPrices[ArrayMinimum(lowPrices, 1, lookBack)]) {
      DrawLabel("LL", lastLow);
   }

   //--- Update graphical objects if necessary

}

//+------------------------------------------------------------------+
//| Draw Label function                                              |
//+------------------------------------------------------------------+
void DrawLabel(string label, double priceLevel) {

   if(CopyTime(_Symbol, _Period, 0, lookBack + 1, barTimes) <= 0) {
      Print("Failed to copy bar times: ", GetLastError());
      return;
   }


   datetime time = barTimes[0]; // Current bar time

   // Draw text label on chart
    string name = "Label_" + label + "_" + TimeToString(time, TIME_DATE|TIME_MINUTES);
    if(ObjectFind(0, name) == -1)
    {
        if(!ObjectCreate(0, name, OBJ_TEXT, 0, time, priceLevel))
        {
            // If there's a problem creating the object, print an error message
            Print("Error creating object: ", GetLastError());
        }
        else
        {
            // Set the properties for the label
            ObjectSetString(0, name, OBJPROP_TEXT, label);
            ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
            ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
            ObjectSetInteger(0, name, OBJPROP_SELECTABLE, 0); // Make it non-selectable
            ObjectSetInteger(0, name, OBJPROP_SELECTED, 0); // Unselect it
        }
    }
    else
    {
        // If the label already exists, just move it to the new location
        ObjectMove(0, name, 0, time, priceLevel);
    }
}

//+------------------------------------------------------------------+
//| Check Parameters function                                        |
//+------------------------------------------------------------------+
bool checkParameters() {
   // check user inputs
   if(magicNumber <= 0) {
      Alert("Don't change the magic number");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Count open positions function                                    |
//+------------------------------------------------------------------+
bool countOpenPositions(int &buyCount, int &sellCount){

   buyCount    = 0;
   sellCount   = 0;
   int total = PositionsTotal();
   for(int i = total-1; i>=0; i--){
      ulong ticket = PositionGetTicket(i);
      if(ticket<=0){Print("Failed to get position ticket"); return false;}
      if(!PositionSelectByTicket(ticket)){Print("Failed to select position"); return false;}
      long magic;
      if(!PositionGetInteger(POSITION_MAGIC,magic)){Print("Failed to get position magic number"); return false;}
      if(magic==magicNumber){
         long type;
         if(!PositionGetInteger(POSITION_TYPE,type)){Print("Failed to get position type"); return false;}
         if(type==POSITION_TYPE_BUY){buyCount++;}
         if(type==POSITION_TYPE_SELL){sellCount++;}
      }
   }
   return true;
}

//+------------------------------------------------------------------+
//| Normalize price function                                         |
//+------------------------------------------------------------------+
bool normalizePrice(double &price){
   
   double tickSize=0;
   if(!SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE,tickSize)){
      Print("Failed to get tick size");
      return false;
   }
   price = NormalizeDouble(MathRound(price/tickSize)*tickSize,_Digits);
   
   return true;
}


//+------------------------------------------------------------------+
//| Close all positions function                                     |
//| 0 = all; 1 = buys; 2 = sells;                                    |
//+------------------------------------------------------------------+
bool closePositions(int all_buy_sell){
   int total = PositionsTotal();
   for(int i = total-1; i>=0; i--){
      ulong ticket = PositionGetTicket(i);
      if(ticket<=0){Print("Failed to get position ticket"); return false;}
      if(!PositionSelectByTicket(ticket)){Print("Failed to select position"); return false;}
      long magic;
      if(!PositionGetInteger(POSITION_MAGIC,magic)){Print("Failed to get position magic number"); return false;}
      if(magic==magicNumber){
         long type;
         if(!PositionGetInteger(POSITION_TYPE,type)){Print("Failed to get position type"); return false;}
         if(all_buy_sell==1 && type==POSITION_TYPE_SELL){continue;}
         if(all_buy_sell==2 && type==POSITION_TYPE_BUY){continue;}
         trade.PositionClose(ticket);
         if(trade.ResultRetcode()!=TRADE_RETCODE_DONE){
            Print("Failed to close position. ticket:",
                  (string)ticket, " result:", (string)trade.ResultRetcode(), ":",trade.CheckResultRetcodeDescription());
         }
      }
   }
   return true;
}
