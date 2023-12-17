//+------------------------------------------------------------------+
//|                                                    SimpleRSI.mq5 |
//|                                         Copyright 2023, SDK Ltd. |
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
static input double  lotSize     = 0.01;  // lot size
input int            rsiPeriod   = 21;    // rsi period
input int            rsiLevel     = 70;    // rsi level (upper)
input int            stopLoss    = 200;   // stop loss in points (0=off)
input int            takeProfit  = 100;   // take profit in points (0=off)
input bool           closeSignal = false; // close trades by opposite signal

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
int handle;
double buffer[];
MqlTick currentTick;
CTrade trade;
datetime openTimeBuy = 0;
datetime openTimeSell = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // check user inputs
   if(magicNumber <= 0) {
      Alert("Don't change the magic number");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(lotSize <= 0 || lotSize > 10) {
      Alert("Lot size is either 0 or larger than 10.");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(rsiPeriod <= 1) {
      Alert("Rsi period is too low. try again.");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(rsiLevel >= 100 || rsiLevel <= 50) {
      Alert("The rsi period needs to be between 99 - 51. Please reset this value and try again.");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(stopLoss < 0) {
      Alert("Stop loss should not be less than zero.");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(takeProfit < 0) {
      Alert("Take profit should not be less than zero.");
      return INIT_PARAMETERS_INCORRECT;
   }
   
   // set magic number to trade object
   trade.SetExpertMagicNumber(magicNumber);
   
   // create rsi handle
   handle = iRSI(_Symbol,PERIOD_CURRENT,rsiPeriod,PRICE_CLOSE);
   if (handle == INVALID_HANDLE) {
      Alert("Failed to create indicator handle");
      return INIT_FAILED;
   }
   
   // set buffer as series
   ArraySetAsSeries(buffer,true);
   
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // release indicator handle
   if(handle != INVALID_HANDLE) {
      IndicatorRelease(handle);
   }   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // get current tick
   if(!SymbolInfoTick(_Symbol,currentTick)) {Print("Failed to get current tick"); return;}
   
   // get rsi values
   int values = CopyBuffer(handle,0,0,2,buffer);
   if (values!=2) {
      Print("Failed to get indicator values");
      return;
   }
   
   Comment("buffer[0]: ", buffer[0],
            "\nbuffer[1]: ", buffer[1]);
            
   // count open positions
   int buyCount, sellCount;
   if(!CountOpenPositions(buyCount,sellCount)){return;}
   
   // check for buy position
   if(buyCount==0 && buffer[1]>=(100-rsiLevel) && buffer[0]<(100-rsiLevel) && openTimeBuy!=iTime(_Symbol,PERIOD_CURRENT,0)){
   
      openTimeBuy=iTime(_Symbol,PERIOD_CURRENT,0);
      if(closeSignal){if(!ClosePositions(2)){return;}}
      double sl = stopLoss==0 ? 0 : currentTick.bid - stopLoss * _Point;
      double tp = takeProfit==0 ? 0 : currentTick.bid + takeProfit * _Point;
      if(!NormalizePrice(sl)){return;}
      if(!NormalizePrice(tp)){return;}
      
      trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,lotSize,currentTick.ask,sl,tp,"RSI EA BUY");
   
   }
   
   // check for sell position
   if(sellCount==0 && buffer[1]<=rsiLevel && buffer[0]>rsiLevel && openTimeSell!=iTime(_Symbol,PERIOD_CURRENT,0)){
   
      openTimeSell=iTime(_Symbol,PERIOD_CURRENT,0);
      if(closeSignal){if(!ClosePositions(1)){return;}}
      double sl = stopLoss==0 ? 0 : currentTick.ask + stopLoss * _Point;
      double tp = takeProfit==0 ? 0 : currentTick.ask - takeProfit * _Point;
      if(!NormalizePrice(sl)){return;}
      if(!NormalizePrice(tp)){return;}
      
      trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,lotSize,currentTick.bid,sl,tp,"RSI EA BUY");
   
   }
   
}

//+------------------------------------------------------------------+
//| Custom function                                                  |
//+------------------------------------------------------------------+

// count open positions

bool CountOpenPositions(int &buyCount, int &sellCount){

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

// normalize price
bool NormalizePrice(double &price){
   
   double tickSize=0;
   if(!SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE,tickSize)){
      Print("Failed to get tick size");
      return false;
   }
   price = NormalizeDouble(MathRound(price/tickSize)*tickSize,_Digits);
   
   return true;
}


// close positions
// 0 = all; 1 = buys; 2 = sells;

bool ClosePositions(int all_buy_sell){
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