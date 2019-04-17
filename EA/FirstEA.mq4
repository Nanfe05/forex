//+------------------------------------------------------------------+
//|                                                      FirstEA.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//COMENTARIOS POR HACER:
//    ** chekear despues horarios de invierno -> TimeDayLightSavings()
//    ** por ahora solo avisa si hay cruces de MA recientes, pero podria mostrar dos tipos de senal, una para cruce reciente y otra solo para tendencia bullish or bearish

// DECLARE FUNCTIONS
datetime NextTick();


// Variables opcionales desde el editor
extern int extMACorto = 20 ; 
extern int extMALargo = 100 ; // tambien usada para promedio,max,min de acercamiento
extern int maxCruceCounter = 10; // evalua que tan lejos(antiguo) sera tomado encuenta un cruce. Numero de velas .. maximo valor para evaluar la veracidad del cruce


// Declare needed Variables for executing strategy
bool cruceReciente = false; // Cruce entre MA corto y largo
int cruceCounter = 0;      // cuenta cuantas velas han transcurrido desde el ultimo cruce 
string tendencia; // describe la tendencia actual ("bullish","bearish","flatten") - tendencia corta basada en MA corto
double aproxAvgMax; // promedio de aproximacion to MA corto - VALOR MAXIMO // calculado con ultimas (MA largo) velas
double aproxAvg;     // promedio de aproximacion to MA corto - VALOR PROMEDIO // calculado con ultimas (MA largo) velas
double aproxAvgMin;  // promedio de aproximacion to MA corto - VALOR MINIMO // calculado con ultimas (MA largo) velas




// 1. Declarar cual es la vela que sigue
      datetime nextTick = NextTick();

int OnInit()
  {
//---
       Alert(" --- ");
       Alert("Inicio EA, NEXT TICK: " + GritarTiempo(nextTick));
       Alert("Vela Actual: " + GritarTiempo(TimeCurrent()));
       Alert(" --- ");
//---
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
//---
   bool esJornadaLaborable = JornadaLaborable();
   if (esJornadaLaborable)
   {                              
     // execute strategy 
     Alert(" --- ");
                           
     Alert("Executing Custom Code ...");
      // Call for iMA - teniendo en cuenta la ultima vela cerrada [1]
      double valMACorto = iMA(Symbol(), Period(),extMACorto, 0,0,0,1);
      double valMALargo = iMA(Symbol(), Period(),extMALargo, 0,0,0,1);
                  Alert("El MA Corto es: " + PrintNumber(valMACorto));
                  Alert("El MA Largo es: " + PrintNumber(valMALargo));
                  Alert(" --- ");
   }
   
   
  }
//+------------------------------------------------------------------+

 //Asigna la siguiente vela teniendo encuenta la presente - retorna la siguiente vela
  datetime NextTick()
  {
   datetime val1 = Time[0] + (Period()*60/*Convierte Minutos To Segundos*/);
   return val1;
  }
  
 // Evalua si estamos en una jornada laborable - retorna boolean
 bool JornadaLaborable()
 {          //Estamos en esa Vela o no 
           if(TimeCurrent() >= nextTick)
           { nextTick = NextTick();  
            //Ajustar Diferencia Horaria
            datetime nycTimeDate = TimeLocal() ;// Since TimeLocal in Bogota is the same as NYC, we dont have to calculate it or adjust time difference
            int dia_semana = TimeDayOfWeek(nycTimeDate);  // Establece dia de la semana
            // Checkea que no es Viernes,Sabado o Domingo
            if(dia_semana != 0 || dia_semana != 5 || dia_semana != 6)
            {  //Chekea Hora de Negociacion NYC
               int horaActual = TimeHour(nycTimeDate);
               int minutoActual = TimeMinute(nycTimeDate);
               if( horaActual >= 7 && horaActual <= 15)// Hora apertura Bolsa NYC -> 7:30 AM - Hora cierre Bolsa NYC -> 16PM
               {
                  // Checkear minuto de apertura mayor a 30 a las 7 am
                  bool minApertura ;
                     if (horaActual == 7)
                     {  if(minutoActual >= 30)
                        { minApertura = true; }
                        else 
                        { minApertura = false; }
                     }else
                     {  minApertura = true;  }
                  if(minApertura)// Min apertura 30
                  { return true; } 
                  else 
                  {  return false; }
               }
            }
           }
           return false;   
 }
 // Evalua cruces MA - retorna boolean indicando primer filtro de compra
         
  
  
  
  
//=============================== FUNCIONES PARA DEBUG ============================
// Solo para ensayos
string GritarTiempo(datetime val1)
{ return TimeToString(val1); }
// Debug Numbers
string PrintNumber(double val1)
{ return DoubleToString(val1); }