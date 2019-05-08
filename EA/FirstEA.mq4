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
extern int percentageTickBody = 80 ; // porcentaje para evaluar si una vela es un velon 
extern int percentageTickShadow = 70 ; // porcentaje para evaluar si la sombra de un vela la convierte en un martillo

// Declare needed Variables for executing strategy
bool cruceReciente = false; // Cruce entre MA corto y largo
int cruceCounter = 0;      // cuenta cuantas velas han transcurrido desde el ultimo cruce 
int tendencia; // describe la tendencia actual ("bullish"-2,"bearish"-0,"flatten"-1) - tendencia corta basada en MA corto
double aproxAvgMax; // promedio de aproximacion to MA corto - VALOR MAXIMO // calculado con ultimas (MA largo) velas
double aproxAvg;     // promedio de aproximacion to MA corto - VALOR PROMEDIO // calculado con ultimas (MA largo) velas
double aproxAvgMin;  // promedio de aproximacion to MA corto - VALOR MINIMO // calculado con ultimas (MA largo) velas
double aproxAvg20Ma; // variable para evaluar como esta la aproximacion rapida dentro de la lenta 



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
     //Alert(" --- ");
     if (EvaluationMA())
     {   
        // Chekear si es una buena vela para entrar en posicion
        if(IsRightTick(tendencia))
        {              
           Alert(" --- ");     
           Alert("Executing Custom Code ...");
           Alert ("tendencia : ", IntegerToString(tendencia));
           Alert("Ahora Actual: ", GritarTiempo(TimeCurrent()));
           Alert(" --- ");
        }
     }else
     {
        //Alert("Nothing to Execute ... ");
        //Alert("Ahora Actual: ", GritarTiempo(TimeCurrent()));
     }
     //Alert(" --- ");
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
         AvgMA(aproxAvgMax, aproxAvg, aproxAvgMin, aproxAvg20Ma);
         
         // not using it currently
         // double tempTickClose = Close[1];
         
         
         // debugging 
         //Alert("tendencia: ",IntegerToString(tendencia));
         //Alert("Cierre: ", DoubleToStr(tempTickClose));
         //Alert("aproxAvg: ", DoubleToStr(aproxAvg));
         /*Alert("aproxAvgCorto: ", DoubleToStr(aproxAvg20Ma));
         Alert("aproxAvgMax: ",DoubleToStr(aproxAvgMax));
         Alert("aproxAvgMin: ", DoubleToStr(aproxAvg));*/
         
         
         // prueba usando la difernecia ma.corto-ma.largo con el conteo largo "200"
         // usando un promedio de diferencias basico si es mayor o menor a .5 aun no aplico si es mayor a .8
         // o menor a .3 porque limita las posibilidades del trading
         double mediaAproxAvg = ((aproxAvgMax+aproxAvgMin)/2);
         //Alert("mediaAproxAvg: ", DoubleToStr(mediaAproxAvg));
          
         if( tendencia == 2 && aproxAvg > mediaAproxAvg && aproxAvg < aproxAvgMax)
         {
         return true;
         }
         else if (tendencia == 0 && aproxAvg > aproxAvgMin && aproxAvg < mediaAproxAvg)
         {
         return true;
         }
   }
   return false;
}        

// Average MA distances to decide if entries are good or no 
void AvgMA(double &maxAvg, double &avg , double &minAvg , double &avgLenta)
{
   int sizeToAvg = extMALargo; // este es el sizeToAvgMax
   int sizeToAvgMin = extMACorto;
   
   double maCorto, maLargo;
   
   // almacena diferencias de MA largo, se almacenan diferencias en array para luego identificar la 
   // de mayor y menor magnitud y deducir si segun el historial la tendencia esta cerca o alejada
   double diferencias[];
   ArrayResize(diferencias,sizeToAvg);
   
   double dif;
   double sumatoriaavg = 0;
   // almacena diferenciad de MA corto 
   double sumatoriaAvgMin = 0 ;
   
   int counterLargo =  0;
   int counterCorto = 0;
   
   
   for (int i = (sizeToAvg-1) ; i >= 0 ; i-- )// no puede llegar a 0 porque es la vela que no se ha terminado de formar
   {
      maCorto = iMA(Symbol(), Period(),sizeToAvgMin, 0,0,0,i);
      maLargo = iMA(Symbol(), Period(),sizeToAvg, 0,0,0,i);
      
      
      dif = (maLargo - maCorto); //MathAbs(maLargo - maCorto);
      // Debug
      // Alert("Diferencia: ", DoubleToStr(dif));
      
      sumatoriaavg += dif;
      ArrayFill(diferencias,i,1,dif);
      
      // agregando valor al promedio corto 
      if (i <= (sizeToAvgMin -1) )
      {
         sumatoriaAvgMin += dif;
         counterCorto ++;
      }
      
      counterLargo++;
      
      
   }
   // ASIGNANDO VARIABLES DE SALIDA
   ArraySort(diferencias,WHOLE_ARRAY,0,MODE_DESCEND);
   maxAvg =  diferencias[1];
   
   avg = (sumatoriaavg/counterLargo); // assign average of distances
   avgLenta = (sumatoriaAvgMin/counterCorto);// assign average of distances short
     
   ArraySort(diferencias,WHOLE_ARRAY,0,MODE_ASCEND);
   minAvg = diferencias[1];
   
  // for debugging ...
  // Alert("Counter Largo: ", IntegerToString(counterLargo) );
  // Alert ("Counter Corto: ", IntegerToString(counterCorto) );
}  
  

// Funcion para identificar velones o martillos en tendencias up / down 
bool IsRightTick(int tendency)
{
   // color o direccion de movimiento de la vela
   int tickDirection = ( Close[1]>Open[1] ? 2 : 0 ) ; // como solo es color de la vela no hay posibilidad de que sea flatten -> 2 up 0 down
   // Center of the tick
   double center =  ((Open[1] + Close[1])/2);
   // 100% of the tick 
   double fullTick = High[1] - Low[1];
   // Size of Body 
   double bodySize = MathAbs(Open[1]-Close[1]);
   // Size Shadow High
   double shSize = (High[1]-center) - (bodySize/2);
   // Size Shadow Low 
   double slSize = (center - Low[1]) - (bodySize/2);
   
   
   //Sanitation Line of code 
   fullTick = ( fullTick==0 ? 1*Point : fullTick );
   // Body Percentage 
   double bodyP = (bodySize*100)/fullTick;
   // Shadow High Percentage 
   double shP = (shSize*100)/fullTick;
   // Shadow Low Percentage 
   double slP = (slSize*100)/fullTick;
   
   // for debbuging purposes
   /*Alert("Tick body percentage: ", DoubleToStr(bodyP));
   Alert("Tick Shadow High percentage: ", DoubleToStr(shP));
   Alert("Tick Shadow Low percentage: ", DoubleToStr(slP));*/
   
   if (tendency == 2 &&  tickDirection == 2)
   {
      if(bodyP >= percentageTickBody || slP >= percentageTickShadow)
      {
        return true; // la inversion se basa en la direccion de la tendencia         
      }
   }
   else if (tendency == 0 && tickDirection == 0)
   {
      if(bodyP >= percentageTickBody || shP >= percentageTickShadow)
      {
        return true; // la inversion se basa en la direccion de la tendencia 
      }
   }
   
   
   
   return false;
}

//=============================== FUNCIONES PARA DEBUG ============================
// Solo para ensayos
string GritarTiempo(datetime val1)
{ return TimeToString(val1); }
// Debug Numbers
string PrintNumber(double val1)
{ return DoubleToString(val1); }
//