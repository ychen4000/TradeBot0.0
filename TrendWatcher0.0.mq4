//+------------------------------------------------------------------+
//|                                                TrendWatcher .mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

bool ShortTrendUp = false;
bool ShortTrendDown = false;
bool ifOrderOpened = false;
string MyShortTrend = "null";
string LastTrade = "null";  // Win or loose 
string Status = "null"; // There are three status: main, correction, level2Correction. 
double MyATR = 0;
double HC = 0;   // Highest close
double LC = 1;
double CP = 0;  // current price
double LastClose = 0; // last close price. 
double TheCloseBeforeLast = 0; 
int TrendCounter = 0; // find the highest or lowest close price within this range. 
int BarsCounter = 0; // count the number of bars.  
int ticket = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
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
   //      
        MyATR = GetATR( ); // get current ATR value. 
        
        CP = Close[0]; // get current pair price. 
        
        LastClose = Close[1]; // get last close price. 
        TheCloseBeforeLast = Close[2]; 
      
      // Check the current trend is going up or down.   
        if(MyShortTrend == "null")
        {
          if (CP - LastClose > MyATR)
          {
             MyShortTrend = "Up";
          
          }
          
          if (LastClose - CP > MyATR)
          {
             MyShortTrend = "Down";
          
          }
        
        }
        
        
        //
        if (MyShortTrend == "Up")
        {
        
           // Track the highest close price in this "Up" trend. 
            if (LastClose > HC)
            {
               HC = LastClose;
            
            }
            
         
           // waiting for short trend chage to down, and chage all the variables to down status. 
             if (HC-CP>MyATR)
         { 
         
            // send message to user
             SendNotification("4H NZDUSD sell time" );
             
           
            
              // change the trend status 
            MyShortTrend = "Down";
            
           
            //sell this currency pair, set stop lost and take profit positions 
           //buy this currency pair, set stop lost and take profit positions 
          // if (iSAR(NULL,0,0.02,0.2,0) > CP)
             iOpenOrders("Sell",1,MyATR*100000 + 50,MyATR*100000);      
          
       
            HC = 0;
          LC = 1;
          
         
         }
        
        
        }
        
        
        
           if (MyShortTrend == "Down")
        {
        
           // Track the highest close price in this "Up" trend. 
            if (LastClose < LC)
            {
               LC = LastClose;
            
            }
           // waiting for short trend chage to down
             if (CP-LC>MyATR)
         { 
         
            // send message to user
             SendNotification("4H NZDUSD buy time" );
             
           
            
              // change the trend status 
            MyShortTrend = "Up";
            
           
            //sell this currency pair, set stop lost and take profit positions 
           //buy this currency pair, set stop lost and take profit positions 
        //  if (iSAR(NULL,0,0.02,0.2,0) < CP)
             iOpenOrders("Buy",1,MyATR*100000 + 50,MyATR*100000);      
         
       
           
          HC = 0;
          LC = 1;
         
         }
        
        
        }
        
     /*   
      // 改写4H线计算方式，特定时间，counter + 1; 
        if (Minute() == 59)
        {
         //  BarsCounter = iBars(NULL,0);
           TrendCounter++;
           SendNotification("the 4H bar has increased by one" + BarsCounter+"TrendCouter = " + TrendCounter + "ATR ="+ MyATR);
           Print ( "++" );
        }
        
        
       
      
        
    // If 4H trend is going up, then waiting for the signal of possible going down, then sell
       if(ShortTrendUp == true && ShortTrendDown == false)
       {
         HC = FindRecentHighestClosePrice(); 
        
     //   SendNotification(HC + "XXX"+ CP);
         if (HC-CP>MyATR)
         { 
         
            // send message to user
             SendNotification("4H NZDUSD sell time" );
             
            TrendCounter = 0; // reset the counter; 
            
              // change the trend status 
            ShortTrendUp = false;
            ShortTrendDown = true;
            
            
            //sell this currency pair, set stop lost and take profit positions 
           //buy this currency pair, set stop lost and take profit positions 
             iOpenOrders("Sell",1,200,200);      
       
           
          
         
         }
         
         }
       
       
       
        // If 4H trend is going down, then waiting for the signal of possible going down, then buy
       if(ShortTrendUp == false && ShortTrendDown == true)
       {
       
         
         LC = FindRecentLowestClosePrice(); 
        
         
         if (CP-LC>MyATR)
         {
         
         // send message to user
            // SendNotification("4H NZDUSD BUY time" + CP + " XXX "+HC + " XXX "+ MyATR);
          TrendCounter = 0; // reset the counter; 
          
            // change the trend status 
            ShortTrendUp = true;
            ShortTrendDown = false;
              //buy this currency pair, set stop lost and take profit positions 
             iOpenOrders("Buy",1,200,200);            
          
             Print("buy");
            
          
           
         }
         
         
       
       
       }
       
         if (ShortTrendUp == false && ShortTrendDown == false)
         {
            ShortTrendUp = true;
         
         }
         */
}

   
  
//+------------------------------------------------------------------+

double FindRecentHighestClosePrice ( )
{
   double MyClose = 0;
 
    // Find the highest close price in last 10 4H candles. 
       // for each of the ten candles 
            for(int i = 1; i <= 10 ; i++)
            {
                if (MyClose < Close[i])
                  {
                    MyClose = Close[i];
                  }
                                                                                                                                                      
            
            }
            
           // Print ("Recent highest close price is" + MyClose);
           // if TemClose > MyClose, then MyClose = TemClose
              // Next TemClose
 
   return(MyClose);
}

double FindRecentLowestClosePrice ( )
{
   double MyClose = 1;
 
    // Find the highest close price in last 10 4H candles. 
      for(int i = 0; i < 10 ; i++)
            {
                if (MyClose > Close[i])
                  {
                    MyClose = Close[i];
                  }
                                                                                                                                                      
            
            }
            
        //    Print ("Recent lowest close price is" + MyClose);
       // MyClose = TemClose 
         // for each of the ten candles 
           // if TemClose  MyClose, then MyClose = TemClose
              // Next TemClose
 
   return(MyClose);
}

double GetATR( )
{
   double MyATR = 0;
   
   // Get ATR at 0 or 1
   MyATR = iATR(NULL,0,21,1);
   
   return(MyATR);
}


void iOpenOrders(string myType, double myLots, int myLossStop, int myTakeProfit)
{
  int mySpread = MarketInfo(Symbol(),MODE_SPREAD); // 获取市场滑点
  double BuyLossStop=Ask-myLossStop*Point;
  double BuyTakeProfit=Ask+myTakeProfit*Point;  
  double SellLossStop = Bid + myLossStop*Point;
  double SellTakeProfit = Bid - myTakeProfit*Point;
  
  if (myLossStop<=0) // 如果止损，参数为0
  {
     BuyLossStop = 0;
     SellLossStop = 0;
  
  }
   
    if (myTakeProfit<=0) // 如果止赢，参数为0
  {
     BuyTakeProfit = 0;
     SellTakeProfit = 0;
  
  }
   
   if (myType == "Buy")
     { OrderSend(Symbol(),OP_BUY,myLots,Ask,mySpread,BuyLossStop,BuyTakeProfit);}
      
      if (myType == "Sell")
     { OrderSend(Symbol(),OP_SELL,myLots,Bid,mySpread,SellLossStop,SellTakeProfit);}

}



