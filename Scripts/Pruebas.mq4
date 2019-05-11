//+------------------------------------------------------------------+
//|                                                      Pruebas.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Alert("MODE_LOTSTEP: ",DoubleToStr(MarketInfo(Symbol(),MODE_LOTSTEP)));
   Alert("-----");
   Alert("Tick Value: ",DoubleToStr(MarketInfo(Symbol(),MODE_TICKVALUE)));
   //Alert("SYMBOL_CURRENCY_PROFIT: ",SymbolInfoString(Symbol(),SYMBOL_CURRENCY_PROFIT));
   Alert("tick size: ",DoubleToStr(MarketInfo(Symbol(),MODE_TICKSIZE)));
   //Alert("lot size: ",DoubleToStr(MarketInfo(Symbol(),MODE_LOTSIZE)));
   // Alert("ultimo cierre: ",Close[1]); 
   //Alert("Min lot size: ",DoubleToStr(MarketInfo(Symbol(),MODE_MINLOT)));
   //Alert("Max lot size: ",DoubleToStr(MarketInfo(Symbol(),MODE_MAXLOT)));
   //Alert("Margin Init: ",DoubleToStr(MarketInfo(Symbol(),MODE_MARGININIT)));
   Alert("Margin require for 1 lot size: ",DoubleToStr(MarketInfo(Symbol(),MODE_MARGINREQUIRED)));
   //Alert("Maintenance margin Required: ", DoubleToStr(MarketInfo(Symbol(),MODE_MARGINMAINTENANCE)));
   //Alert("Margin Hedged: ",DoubleToStr(MarketInfo(Symbol(),MODE_MARGINHEDGED)));
   //Alert("Margin Call Mode: ",DoubleToStr(MarketInfo(Symbol(),MODE_MARGINCALCMODE)));
   Alert(Symbol());
   Alert("-----");
   
   //Alert("Spread: ", DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD)));
   //Alert("Ask: ", Ask);
   //Alert("Bid: ", Bid);
   //Alert("Account Leverage: ", AccountLeverage());
   
   //Alert(DoubleToStr(5 *( Point*10)));
   //Alert(OrdersTotal()); 
   
   /*
   int initialtick = 34;
   
   
   
   int x = 20;
   int startanalisis = initialtick + x;




   double avg = 0;

   for (int i = startanalisis; i > initialtick ; i --)
   {
      avg += MathAbs(Close[i] - Open[i]);
   }
   
   avg /= x;
   
   Alert("el promedio de las ultimas velas fue: ", DoubleToStr(avg));
   */





   // BUSCAR EL DIA DE LA SEMANA SEPARANDO LA DIFERENCIA HORARIA
   /*
   datetime diferenciaHoraria = TimeCurrent()-TimeLocal();
   datetime nycHour = TimeCurrent() - diferenciaHoraria;
   
   Alert(TimeMinute(nycHour));
   */
   /*Alert("--------");
   Alert("Account Balance Function: ", AccountBalance());
   Alert("Account Equity: ", AccountEquity());
   Alert("Account Leverage: ", AccountLeverage());
  
   Alert("Account Free Margin: ", AccountFreeMargin());*/
   
   
   
   
    //Alert("Account Balance constant: ", AccountInfoDouble(ACCOUNT_BALANCE));
   /* 
   Alert("Account Credit: ", AccountCredit());
    
   
   Alert("Account Server: ", AccountServer());
   Alert("Account Name: ", AccountName());
   Alert("Account Number: ", AccountNumber());*/
   
   
   
      
  /* Alert ("Cantidad de Ordenes: ",IntegerToString(OrdersTotal())); 
   Alert ("Cantidad de Ordenes en la historia: ",IntegerToString(OrdersHistoryTotal())); 
   Alert ("Account Margin: ",  AccountInfoDouble(ACCOUNT_MARGIN)); 
   Alert ("Account Leverage: ",  AccountInfoInteger(ACCOUNT_LEVERAGE));
   Alert ("Account Equity: ",  AccountInfoDouble(ACCOUNT_EQUITY));
   Alert ("Account Margin Level: ", AccountInfoDouble(ACCOUNT_MARGIN_LEVEL));*/
   //printf("this is printf"); esto aparecera en el experts message tab
   
   //Alert( Time[0] );
   //Alert(Time[0] + Period()*60);
   
   
   //Alert("En NYC is day: " + IntegerToString(TimeDayOfWeek(nycHour)) + " of weak");
   //Alert("En Server is day: " + IntegerToString(TimeDayOfWeek(TimeCurrent())) + " of weak");
   
   /////////////////////////////////////////////////////////////////////////////
   /*
   *
   */
   //Alert(Period());
   //Alert(TimeGMT());
   //Alert("Tiempo Servidor: "+ TimeToString(TimeCurrent()));
   //Alert("Tiempo Local: "+ TimeToString(TimeLocal()));
   //datetime dif = TimeCurrent()-TimeLocal();
   
   //MqlTick dd;
   //SymbolInfoTick(Symbol(),dd);
   
   //Alert("Hora del Servidor: " + TimeToString(TimeCurrent()));
   //Alert("Index 0: " + TimeToString(Time[0]));
   //Alert("Index 1: " + TimeToString(Time[1]));
   //Alert("Index 2: " + TimeToString(Time[2]));
   
   //Alert(dd.time);
   //Alert(GetTickCount()/1000);
   //Alert(dif);
   //Alert("Hora Server: "+ TimeToString(TimeLocal()+dif));
   //Alert("Hora real servidor: "+TimeToString(TimeCurrent()));
   //Alert(TimeGMTOffset());
   
   
   //Alert(TimeCurrent());
//   Alert(ChartFirst());
  }
//+------------------------------------------------------------------+
