//+------------------------------------------------------------------+
//|                                                 MoveArTester.mq5 |
//|                                                          Rachamv |
//|                                https://github.com/Rachamv/Meta5- |
//+------------------------------------------------------------------+
#property copyright "Rachamv"
#property link      "https://github.com/Rachamv/Meta5-"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>

input double Lots = 0.1;
input int TpPoints = 100;
input int SlPoints = 100;

input int Ma1Period = 20;
input ENUM_MA_METHOD Ma1Method = MODE_EMA;


input int Ma2Period = 100;
input ENUM_MA_METHOD Ma2Method = MODE_EMA;

int handleMa1;
int handleMa2;

int barsTotal;

CTrade trade;

int OnInit()
  {
   handleMa1 = iMA(_Symbol,PERIOD_CURRENT,Ma1Period,0,Ma1Method,PRICE_CLOSE);
   handleMa2 = iMA(_Symbol,PERIOD_CURRENT,Ma2Period,0,Ma2Method,PRICE_CLOSE);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   int bars = iBars(_Symbol,PERIOD_CURRENT);
   if(barsTotal != bars){
      barsTotal = bars;
      
      double ma1[], ma2[];
      CopyBuffer(handleMa1,MAIN_LINE,1,2,ma1);
      CopyBuffer(handleMa2,MAIN_LINE,1,2,ma2);
   
      if(ma1[1] > ma2[1] && ma1[0] < ma2[0]){
         printf(__FUNCTION__," >  buy crossover.....");
         
         double entry = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         entry = NormalizeDouble(entry,_Digits);

         double tp = entry + TpPoints * _Point;
         tp = NormalizeDouble(tp,_Digits);

         double sl = entry - SlPoints * _Point;
         sl = NormalizeDouble(sl,_Digits);

         trade.Buy(Lots,_Symbol, entry,sl,tp);

      }if(ma1[1] < ma2[1] && ma1[0] > ma2[0]){
         printf(__FUNCTION__," >  sell crossover.....");

         double entry = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         entry = NormalizeDouble(entry,_Digits);

         double tp = entry - TpPoints * _Point;
         tp = NormalizeDouble(tp,_Digits);

         double sl = entry + SlPoints * _Point;
         sl = NormalizeDouble(sl,_Digits);

         trade.Sell(Lots,_Symbol, entry,sl,tp);
      }
   }
  }
//+------------------------------------------------------------------+
