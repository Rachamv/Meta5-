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

class CMovingAverageStrategy : public  CObject {
  // input variables
 private: 
   double Lots;
   int TpPoints;
   int SlPoints;
   
   int Ma1Period;
   ENUM_MA_METHOD Ma1Method;
   
   
   int Ma2Period;
   ENUM_MA_METHOD Ma2Method;
   
 public:
      CMovingAverageStrategy(double lots, int tpPoints, int slPoints, int ma1Period, ENUM_MA_METHOD ma1Method, int ma2Period, ENUM_MA_METHOD ma2Method){
         Lots = lots;
         TpPoints = tpPoints;
         SlPoints = slPoints;
         
         Ma1Period = ma1Period;
         Ma1Method = ma1Method;
         
         Ma2Period = ma2Period;
         Ma2Method = ma2Method;
         
      }
   
 private:
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
};

int OnTick(){
   return INIT_SUCCEEDED;
}

