//+------------------------------------------------------------------+
//|                                                        P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//TYPES
#include "../shared/types/candleStructs.mqh"
#include "../shared/types/tradeStructs.mqh"
#include "../shared/types/killZoneStructs.mqh"

//+------------------------------------------------------------------+
//| Common Globals                                                   |
//+------------------------------------------------------------------+
enum KeyStructureType {
    KEY_STRUCTURE_HH,
    KEY_STRUCTURE_LL
};

//+------------------------------------------------------------------+
//| Pip Action Types                                                 |
//+------------------------------------------------------------------+
enum PipActionTypes {
   ADD,
   SUBTRACT
};