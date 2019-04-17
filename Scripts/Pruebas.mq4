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
   // BUSCAR EL DIA DE LA SEMANA SEPARANDO LA DIFERENCIA HORARIA
   /*
   datetime diferenciaHoraria = TimeCurrent()-TimeLocal();
   datetime nycHour = TimeCurrent() - diferenciaHoraria;
   
   Alert(TimeMinute(nycHour));
   */
   
   Alert( Time[0] );
   Alert(Time[0] + Period()*60);
   
   
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
