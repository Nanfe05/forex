//+------------------------------------------------------------------+
//|                                                     pruebas2.mq4 |
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
   //Alert(OrdersTotal());
   
   
   //Alert(DoubleToStr(50*Point));
   Alert("------");   
   //Alert("Spread: ", DoubleToStr(Ask - Bid));
  Alert(DoubleToStr(NormalizeDouble((3*Point),Digits)));
  
  /*
   for (int i = 0 ; i < OrdersTotal() ; i++ )
   {
      if( OrderSelect(i,SELECT_BY_POS,MODE_TRADES) )
      {
       double price = OrderType() == 0 ? Bid : Ask ;
      
         if(OrderType() == 0)
         {
            bool orderTrailed = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(price - (10 * Point),Digits),OrderTakeProfit(),0, CLR_NONE);
            if(orderTrailed){Alert("Order Trailed");}else{Alert("Order NOT Trailed: ", GetLastError());}
         }
         else
         {
            bool orderTrailed = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(price + (10 * Point),Digits),OrderTakeProfit(),0, CLR_NONE);
            if(orderTrailed){Alert("Order Trailed");}else{Alert("Order NOT Trailed: ", GetLastError());}
         }
       
      }
   }
   */
   /*
   //ORIGINAL CODE TO TRAILING
   for (int i = 0 ; i < OrdersTotal() ; i++ )
   {
      if( OrderSelect(i,SELECT_BY_POS,MODE_TRADES) )
      {
       double price = OrderType() == 0 ? Bid : Ask ;
       if ((i%2) == 0 )
       {
      
      
      Alert("Order Type: ", OrderType());  
         if(OrderType() == 0)
         {
            bool orderTrailed = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(price - (10 * Point),Digits),OrderTakeProfit(),0, CLR_NONE);
            if(orderTrailed){Alert("Order Trailed");}else{Alert("Order NOT Trailed: ", GetLastError());}
         }
         else
         {
            bool orderTrailed = OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(price + (10 * Point),Digits),OrderTakeProfit(),0, CLR_NONE);
            if(orderTrailed){Alert("Order Trailed");}else{Alert("Order NOT Trailed: ", GetLastError());}
         }
       }
      }
   }
   */
  }
//+------------------------------------------------------------------+
