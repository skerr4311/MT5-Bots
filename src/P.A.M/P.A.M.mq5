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

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
MqlTick currentTick;
CTrade trade;
datetime openTimeBuy = 0;
datetime openTimeSell = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   // init items here
   if(!checkParameters()) {return INIT_PARAMETERS_INCORRECT;}
   
   // set magic number to trade object
   trade.SetExpertMagicNumber(magicNumber);
   
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
   // on tick starts

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
