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
extern int extMALargo = 200 ; // tambien usada para promedio,max,min de acercamiento
extern int maxCruceCounter = 60; // evalua que tan lejos(antiguo) sera tomado encuenta un cruce. Numero de velas .. maximo valor para evaluar la veracidad del cruce


// Declare needed Variables for executing strategy
bool cruceReciente = false; // Cruce entre MA corto y largo
int cruceCounter = 0;      // cuenta cuantas velas han transcurrido desde el ultimo cruce 
int tendencia; // describe la tendencia actual ("bullish"-2,"bearish"-0,"flatten"-1) - tendencia corta basada en MA corto
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

// First check open positions 


// then...
   if (JornadaLaborable())
   {                              
     // execute strategy 
     Alert(" --- ");
     if (EvaluationMA())
     {                      
        Alert("Executing Custom Code ...");
        Alert (tendencia);
        Alert("Ahora Actual: ", GritarTiempo(TimeCurrent()));
     }else
     {
        //Alert("Nothing to Execute ... ");
        Alert("Ahora Actual: ", GritarTiempo(TimeCurrent()));
     }
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
 bool EvaluationMA ()
 {
   // declarar MA's a utilizar (default 200 && 20) -> teniendo en cuenta la ultima vela cerrada [1]
   double valMACorto, valMALargo;
   
   // Lista para evaluar un posible cambio de tendencia
   int tendency[];
   ArrayResize(tendency, maxCruceCounter);
   int y = 0 ; // variable para controlar la lista de tendencias
   
   cruceReciente = false;
   cruceCounter = 0 ; // realmente necesito resetear esto ? /////////////////////////////////
   
// evaluar si recientemente ha cambiado la tendencia -> desde vela mas antigua a actual
      for (int i = maxCruceCounter; i > 0 ; i--)
      {
               valMACorto = iMA(Symbol(), Period(),extMACorto, 0,0,0,i);
               valMALargo = iMA(Symbol(), Period(),extMALargo, 0,0,0,i);
               
               if (valMACorto >= valMALargo)
               {  tendencia = 2; }
               else
               { tendencia = 0;} 
               ArrayFill(tendency,y,1,tendencia);
               if (y >= 1)//(ArraySize(tendency) >= 2 )
               {
                  if (tendency[y] != tendency[y-1])
                  {
                     tendencia = tendencia == 2 ?  0 :  2; 
                     cruceReciente = true ;
                  }
               }
               y ++;
               if (cruceReciente)
               {
                  cruceCounter ++;
               }        
         }
         ArrayFree(tendency); 
   if (cruceCounter <= maxCruceCounter && cruceCounter > 0)
   {
         // testear si la tendencia coincide con los promdios de los MA 
         AvgMA(aproxAvgMax, aproxAvg, aproxAvgMin);
         double tempTickClose = Close[1];
         
         Alert("Precio de Cierre: ",DoubleToStr(Close[1]));
         Alert("Avg Max: ", DoubleToStr(aproxAvgMax));
         Alert("Avg: ", DoubleToStr(aproxAvg));
         Alert("Avg Min: ", DoubleToStr(aproxAvgMin));
         return true;
         
         // TEMPORALY COMMENT FOR DEBUGGING REASONS
         /*if( tendencia == 2 && tempTickClose > aproxAvg && tempTickClose < aproxAvgMax)
         {
         return true;
         }
         else if (tendencia == 0 && tempTickClose > aproxAvgMin && tempTickClose < aproxAvg)
         {
         return true;
         }*/
   }
   return false;
}        

// Average MA distances to decide if entries are good or no 
void AvgMA(double &maxAvg, double &avg , double &minAvg)
{
   int sizeToAvg = extMALargo;
   double maCorto, maLargo;
    
   double diferencias[];
   ArrayResize(diferencias,sizeToAvg);
   
   double dif;
   double sumatoriaavg = 0;

   for (int i = (sizeToAvg-1) ; i > 0 ; i-- )// no puede llegar a 0 porque es la vela que no se ha terminado de formar
   {
      maCorto = iMA(Symbol(), Period(),sizeToAvg, 0,0,0,i);
      maLargo = iMA(Symbol(), Period(),sizeToAvg, 0,0,0,i);
      
      dif = MathAbs(maLargo - maCorto);
      sumatoriaavg += dif;
      ArrayFill(diferencias,i,1,dif);
   }
   // ASIGNANDO VARIABLES DE SALIDA
   ArraySort(diferencias,WHOLE_ARRAY,0,MODE_DESCEND);
   maxAvg =  diferencias[1];
   
   avg = (sumatoriaavg/sizeToAvg); // assign average of distances
   
   ArraySort(diferencias,WHOLE_ARRAY,0,MODE_ASCEND);
   minAvg = diferencias[1];
}  
  
  
//=============================== FUNCIONES PARA DEBUG ============================
// Solo para ensayos
string GritarTiempo(datetime val1)
{ return TimeToString(val1); }
// Debug Numbers
string PrintNumber(double val1)
{ return DoubleToString(val1); }