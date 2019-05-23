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

//    ********************* EN ESTA SEGUNDA VERSION SE DESHABILITA EL TAKE PROFIT EN LA OPERACION Y SE IMPLEMENTA STOPLOSS TRAILING PARA CERRAR LAS OPERACIONES *******************




// DECLARE FUNCTIONS
datetime NextTick();


// Variables opcionales desde el editor
extern int extMACorto = 40 ;              //extMACorto -> 20
extern int extMALargo = 200 ;             //extMALargo // tambien usada para promedio,max,min de acercamiento  -> 200
extern int maxCruceCounter = 20;          //maxCruceCounter // evalua que tan lejos(antiguo) sera tomado encuenta un cruce. Numero de velas .. maximo valor para evaluar la veracidad del cruce -> 60
extern int percentageTickBody = 60 ;      //percentageTickBody // porcentaje para evaluar si una vela es un velon    -> 80
extern int percentageTickShadow = 30 ;    //percentageTickShadow // porcentaje para evaluar si la sombra de un vela la convierte en un martillo   -> 70
extern int thresholdEnterPrice = 1;       //thresholdEnterPrice // diferencia con el ultimo cierre si es mayor o menor entrar en operacion en pips   -> 2
extern double maxRiskPerTrade = 11;      //maxRiskPerTrade // maximo valor del balance que se esta dispuesto a perder por transaccion   -> 1.5
extern int takeProfit = 0;                //takeProfit // in pips amount, if take profit = 0 -> calcular stoploss * riskToRewardRatio   -> 0
extern int stopLoss = 30;                  //stopLoss // in pips , if equal to 0 stopLoss = takeProfit * riskToRewardRatio   -> 0
extern double riskToRewardRatio = 11.5;      //riskToRewardRatio// multiplica stoploss * this number   -> 2
extern int slippage = 1;                  //slippage// for buy and sell orders    -> 2
extern double minTickBodySize = 10 ;      //minTickBodySize// to avoid velas de incertidumbre   -> 15
extern double minPosibleStopLoss = 45;    //minPosibleStopLoss// if for some reason stoploss is less than it, it will be fixed   -> 10

extern double horaInicioJornada = 7 ;     //horaInicioJornada//inicialmente    -> 7
extern double horaFinJornada = 12;        //horaFinJornada // inicialmente    -> 15
extern double minutoInicioJornada = 30 ;  //minutoInicioJornada// inicialmente    -> 30


// Declare needed Variables for executing strategy
bool cruceReciente = false; // Cruce entre MA corto y largo
int cruceCounter = 0;      // cuenta cuantas velas han transcurrido desde el ultimo cruce 
int tendencia; // describe la tendencia actual ("bullish"-2,"bearish"-0,"flatten"-1) - tendencia corta basada en MA corto
double aproxAvgMax; // promedio de aproximacion to MA corto - VALOR MAXIMO // calculado con ultimas (MA largo) velas
double aproxAvg;     // promedio de aproximacion to MA corto - VALOR PROMEDIO // calculado con ultimas (MA largo) velas
double aproxAvgMin;  // promedio de aproximacion to MA corto - VALOR MINIMO // calculado con ultimas (MA largo) velas
double aproxAvg20Ma; // variable para evaluar como esta la aproximacion rapida dentro de la lenta 
bool enEstadoDeCompra = false;


// 1. Declarar cual es la vela que sigue
datetime nextTick = NextTick();

int OnInit()
  {
//---
         
       /*
       Alert(" --- ");
       Alert("Inicio EA, NEXT TICK: " + GritarTiempo(nextTick));
       Alert("Vela Actual: " + GritarTiempo(TimeCurrent()));
       Alert(" --- ");
       */
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

   if (OrdersTotal() == 0)    // por ahora se ejecuta si no hay posiciones abiertas, luego toca adaptarlo para qur trabaje con varias posiciones y si no hay ninguna abierta con esta divisa
   {
         if (JornadaLaborable())
         {                              
           // execute strategy 
           //Alert(" --- ");
           if (EvaluationMA())
           {   
              // Chekear si es una buena vela para entrar en posicion
              if(IsRightTick(tendencia))
              {  
              
                 enEstadoDeCompra = true;
                
                 
              }
              else 
              {
               enEstadoDeCompra = false;
              }
           }
           else
           {
               enEstadoDeCompra = false;
              
           }
           
         }
         else
         {
               enEstadoDeCompra = false;
         }
         
         
         // debe haber algo que me sirva de boolean sin alterar el chekeo constante y se active con  la formula superior 
         if(enEstadoDeCompra)
         {
               switch(tendencia)
                       {
                       
                       
                       case 2:
                        // chekea en cada movimiento si el precio supero el threshold para entrar
                                   //Alert("Close alto: ", Close[0]);
                                   //Alert("Threshold: ",(thresholdEnterPrice*(Point)));
                                   //Alert("a superar: ", (Close[1]+(thresholdEnterPrice*(Point))));
                        if(Close[0] > (Close[1]+(thresholdEnterPrice*(Point))))
                        {
                         Alert("Case 2 Applied");
                           if(Compra())
                           {
                              Alert("Orden de Compra,Ingreso exitoso");
                           }
                        }
                        break;
                       case 0:
                       // chekea en cada movimiento si el precio supero el threshold para entrar
                                   //Alert("Close bajo: ", Close[0]);
                                   //Alert("Threshold: ",(thresholdEnterPrice*(Point)));
                                   //Alert("a superar: ", (Close[1]-(thresholdEnterPrice*(Point))));
                        if (Close[0] < (Close[1]-(thresholdEnterPrice*(Point))))
                        {
                         Alert("Case 0 Applied");
                           if(Venta())
                           {
                              Alert("Orden de Venta,Ingreso exitoso");
                           }
                           
                        }
                        break;
                        
                        
                                
                       } 
                 
                // Alert("Something Interesting ...., tendencia: ", IntegerToString(tendencia));  
         } 
    }
    else
    {
      if(JornadaLaborable())
      {
      EvaluationMA(); // TO UPDATE TENDENCY
         if(IsRightTick(tendencia))// ONLY TRAIL SL IF IS A CONGRUENT TICK
         {
             StopLossTrailing();
         }
         //Alert("Nueva vela with order In");
      }
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
               if( horaActual >= horaInicioJornada && horaActual <= horaFinJornada)// Hora apertura Bolsa NYC -> 7:30 AM - Hora cierre Bolsa NYC -> 16PM
               {
                  // Checkear minuto de apertura mayor a 30 a las 7 am
                  bool minApertura ;
                     if (horaActual == horaInicioJornada)
                     {  if(minutoActual >= minutoInicioJornada)
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
               
               if (valMACorto >= valMALargo) // NOS INTERESA SCALPING OSEA LA TENDENCIA RAPIDA
               {  tendencia = 2; }
               else
               { tendencia = 0;} 
               ArrayFill(tendency,y,1,tendencia);
               if (y >= 2)//(ArraySize(tendency) >= 2 )
               {
                  //if (tendency[y] != tendency[y-1] && tendency[y-2] != tendency[y-1]) // como lo mencionado mas abajo, esta opcion me saca de muchas posiciones pero no arroja errores !!
                  if(tendency[y] != tendency[y-1])// NO CAMBIA SIEMPRE SOLO SI EN EL ANTERIOR NO ES CONSTANTE
                  {
                     tendencia = tendencia == 2 ?  0 :  2; // ES POSIBLE QUE AL DAR UNA TENDENCIA FALSA SI LA TENDENCIA NO ES CONSTANTE ME SAQUE DE OPERACIONES QUE PUEDEN SER VOLATILES
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
         double mediaAproxAvg = ((aproxAvgMax+aproxAvgMin)*0.5);
         //Alert("mediaAproxAvg: ", DoubleToStr(mediaAproxAvg));
         
               if( tendencia == 2 && aproxAvg > mediaAproxAvg && aproxAvg < aproxAvgMax)
               {
               return true;
               }
               else if (tendencia == 0 && aproxAvg > aproxAvgMin && aproxAvg < mediaAproxAvg)
               {
               return true;
               }
         
                     /*
                     // OPCION FIBONACCI 
                     double fibonacciHighAproxAvg = ((aproxAvgMax+aproxAvgMin)*0.618);
                     double fibonacciLowAproxAvg = ((aproxAvgMax+aproxAvgMin)*0.382);
                     
                     if( tendencia == 2 && aproxAvg > mediaAproxAvg && aproxAvg < fibonacciHighAproxAvg)
                     {
                     return true;
                     }
                     else if (tendencia == 0 && aproxAvg > fibonacciLowAproxAvg && aproxAvg < mediaAproxAvg)
                     {
                     return true;
                     }
                     */
         
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
      
      
      dif = (maLargo - maCorto);//MathAbs(maLargo - maCorto) NO ABSOLUTE VALUE PORQUE NO CONOCERIAMOS EL VALOR MINIMO REAL YA QUE SERIA CERCANO A 0, NECESITO LOS DOS VALORES DE ARRIBA Y ABAJO
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
   maxAvg =  diferencias[0];// SERIA EL PRIMER VALOR EN UN ARRAY, ANTES TENIA 1
   
   avg = (sumatoriaavg/counterLargo); // assign average of distances
   avgLenta = (sumatoriaAvgMin/counterCorto);// assign average of distances short
     
   ArraySort(diferencias,WHOLE_ARRAY,0,MODE_ASCEND);
   minAvg = diferencias[0];// SERIA EL PRIMER VALOR EN UN ARRAY, ANTES TENIA 1
   
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
   /*
   Alert("Tick body percentage: ", DoubleToStr(bodyP));
   Alert("Tick Shadow High percentage: ", DoubleToStr(shP));
   Alert("Tick Shadow Low percentage: ", DoubleToStr(slP));
   
   */
   //Alert("CUERPO: ",bodyP);
   if (tendency == 2 &&  tickDirection == 2)
   {
      if(bodyP >= percentageTickBody || (slP >= percentageTickShadow && bodyP > minTickBodySize))
      {
        return true; // la inversion se basa en la direccion de la tendencia         
      }
   }
   else if (tendency == 0 && tickDirection == 0)
   {
      if(bodyP >= percentageTickBody || (shP >= percentageTickShadow && bodyP > minTickBodySize))
      {
        return true; // la inversion se basa en la direccion de la tendencia 
      }
   }
   
   
   
   return false;
}


// Crear orden de Compra
bool Compra()
{
   double ls = LotSize() ;// lot size// use max risk per trade 
   double price = Ask;
   double sl = NormalizeDouble(Bid - (CrearStopLoss()*Point),Digits);
   double tp = NormalizeDouble(Bid + (CrearTakeProfit()*Point),Digits);
   
   
   // Alert("LOT SIZE: ",ls);
   
   if( OrderSend(Symbol(),OP_BUY,ls,price,slippage,sl,tp,"BUY",0,0,clrNONE ) )
   {
   return true;
   }

   return false;
}


// Crear Orden de Venta 
bool Venta ()
{
   double ls = LotSize() ;// lot size// use max risk per trade 
   double price = Bid;
   double sl = NormalizeDouble(Ask + (CrearStopLoss()*Point),Digits);
   double tp = NormalizeDouble(Ask - (CrearTakeProfit()*Point),Digits);
   
   
               /*Alert("StopLoss in order: ", DoubleToStr(CrearStopLoss()*Point));
               Alert("TakeProfit in order: ", DoubleToStr(CrearTakeProfit()*Point));
               Alert("Price: ", DoubleToStr(price));
               Alert("StopLoss in order: ", DoubleToStr(sl));
               Alert("TakeProfit in order: ", DoubleToStr(tp));*/
   // Alert("LOT SIZE: ",ls);
   if( OrderSend(Symbol(),OP_SELL,ls,price,slippage,sl,tp,"SELL",0,0,clrNONE))
   {
   return true;
   }


   return false;
}

double LotSize ()
{
   
   double sl = CrearStopLoss();// CORRECCION EN FORMULA stopLoss != 0 ? stopLoss : CrearStopLoss();
   
   //Alert("StopLoss: ", sl);
   
   double lotSize;
   double tickValue = (MarketInfo(Symbol(),MODE_TICKVALUE));
   // Normalizing tick values
   if (Digits == 5 || Digits == 3)
   {
      tickValue *= 10;
   }
   
   lotSize = ((AccountBalance()*maxRiskPerTrade)/100)/(sl * tickValue);
   lotSize = MathRound(lotSize/MarketInfo(Symbol(),MODE_LOTSTEP))*MarketInfo(Symbol(),MODE_LOTSTEP);
   
   
   //Alert("LOT SIZE: ",lotSize);
   return lotSize;

}

double CrearStopLoss()
{
   double sl;
   
   if(stopLoss != 0)
   {
      sl = stopLoss;
   }
   else
   {
      sl = MathAbs(Close[1] - Open [1])  ;
   }
  
  // Alert("sl Close: ", Close[1]);
  //Alert("sl Open: ", Open[1]);
                    
                    // ESTO PODRIA ***NO*** SER NECESARIO, YA QUE EN COMPRA() Y VENTA () YA SE MULTIPLICA POR POINT
                    /*
                     double tempVal = 1; // valor para multiplicar y redondear  
                     for(int i=1;i <= (Digits) ; i++)
                     {
                        tempVal *= 10;
                     }
                     
                     // debe ser pasado a pips enteros para luego maultiplicar * point
                     sl = sl*tempVal;
                     */
                     
                     
   //Alert("StopLoss: ", sl);
   
   sl = sl <= minPosibleStopLoss ? minPosibleStopLoss : sl ; // if stoploss is not bigger than minPosibleStopLoss it will be fixed
   
   return sl;
}

double CrearTakeProfit()
{
   
   double sl = CrearStopLoss();
   
   double tp = sl * riskToRewardRatio; 
   
   //Alert("TakeProfit: ", tp);
   
   return tp;
}
// TRAILING STOPLOSS
void StopLossTrailing ()
{
   /*
      for (int i = 0 ; i < OrdersTotal() ; i++ )
   {
      if( OrderSelect(i,SELECT_BY_POS,MODE_TRADES) )
      {
       //double price = OrderType() == 0 ? Bid : Ask ;
         
         double sl = CrearStopLoss();
         // Normalize Pips
         sl = NormalizeDouble((sl*Point),Digits);
         
         if(OrderType() == 0)//0 -> BUY
         {
            double newStopLoss =  Low[1] - sl;  // NormalizeDouble(price - (10 * Point),Digits)
            
            if (newStopLoss > OrderStopLoss())
            {
               bool orderTrailed = OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,OrderTakeProfit(),0, CLR_NONE);
               if(orderTrailed){Alert("Order Trailed");}else{Alert("Order NOT Trailed: ", GetLastError());}
            }
         }
         else // 1 -> SELL
         {
            double newStopLoss =  High[1] + sl;  // NormalizeDouble(price + (10 * Point),Digits)
         
            if(newStopLoss > OrderStopLoss())
            {
               bool orderTrailed = OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,OrderTakeProfit(),0, CLR_NONE);
               if(orderTrailed){Alert("Order Trailed");}else{Alert("Order NOT Trailed: ", GetLastError());}
            }
            
         }
       
      }
      */
      
      
       // trail take profit
   for (int i = 0 ; i < OrdersTotal() ; i++ )
   {
      if( OrderSelect(i,SELECT_BY_POS,MODE_TRADES) )
      {
       //double price = OrderType() == 0 ? Bid : Ask ;
         
         double sl = CrearStopLoss();
         // Normalize Pips
         sl = NormalizeDouble((sl*Point),Digits);
         
         if(OrderType() == 0)//0 -> BUY
         {
            double newStopLoss =  Low[1] - sl;  // NormalizeDouble(price - (10 * Point),Digits)
            double newTakeProfit = OrderTakeProfit()+(newStopLoss-OrderStopLoss());
            
            
            if (newStopLoss > OrderStopLoss())
            {
               bool orderTrailed = OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,newTakeProfit,0, CLR_NONE);
               if(orderTrailed){Alert("Order Trailed");}else{Alert("Order NOT Trailed: ", GetLastError());}
            }
         }
         else // 1 -> SELL
         {
            double newStopLoss =  High[1] + sl;  // NormalizeDouble(price + (10 * Point),Digits)
            double newTakeProfit = OrderTakeProfit()+(newStopLoss-OrderStopLoss());
            
            if(newStopLoss > OrderStopLoss())
            {
               bool orderTrailed = OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,newTakeProfit,0, CLR_NONE);
               if(orderTrailed){Alert("Order Trailed");}else{Alert("Order NOT Trailed: ", GetLastError());}
            }
            
         }
       
      }
      
   }

}


//=============================== FUNCIONES PARA DEBUG ============================
// Solo para ensayos
string GritarTiempo(datetime val1)
{ return TimeToString(val1); }
// Debug Numbers
string PrintNumber(double val1)
{ return DoubleToString(val1); }
//