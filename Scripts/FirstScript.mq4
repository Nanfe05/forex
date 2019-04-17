//+------------------------------------------------------------------+
//|                                                  FirstScript.mq4 |
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

// chekear despues horarios de invierno -> TimeDayLightSavings()


// DECLARE FUNCTIONS
datetime NextTick();

void OnStart()
  {
//---
   //GritarTiempo(nextTick);
   
   // 2. Estamos en esa Vela o no 
     if(TimeCurrent() == nextTick)
     {
      nextTick = NextTick();
      
      //Ajustar Diferencia Horaria
      datetime diferenciaHoraria = TimeCurrent()-TimeLocal();
      datetime nycTimeDate = TimeCurrent() - diferenciaHoraria;
      int dia_semana = TimeDayOfWeek(nycTimeDate);  // Establece dia de la semana
      
      Alert(nycTimeDate);
      Alert(dia_semana);
      
      // Chekea que no es Viernes,Sabado o Domingo
      if(dia_semana != 0 || dia_semana != 5 || dia_semana != 6)
      {
         //Chekea Hora de Negociacion NYC
         int horaActual = TimeHour(nycTimeDate);
         int minutoActual = TimeMinute(nycTimeDate);
         
         //Alert(horaActual);
         
         if( horaActual >= 7 && minutoActual > 30)// Hora apertura Bolsa NYC -> 7:30 AM
         {
         
            if(horaActual <= 15)// Hora cierre Bolsa NYC -> 16PM
            {
               // execute strategy 
               
               Alert("Hi this is me!");
            }
         }
      }
      
     }    
    

  }
  
  // 1. Declarar cual es la vela que sigue
  datetime nextTick = NextTick();
  
  
  
  datetime NextTick()
  {
   datetime val1 = Time[0] + (Period()*60/*Convierte Minutos To Segundos*/);
   return val1;
  }
    
  void GritarTiempo(datetime val1)
  {
   Alert(TimeToString(val1));
  }
//+------------------------------------------------------------------+
