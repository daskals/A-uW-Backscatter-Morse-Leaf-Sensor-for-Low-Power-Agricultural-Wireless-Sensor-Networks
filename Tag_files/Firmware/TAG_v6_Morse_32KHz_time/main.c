/*
Spiros Daskalakis 
Last Version: 31/1/2018
Email: daskalakispiros@gmail.com
Website: www.daskalakispiros.com
*/

#include <stdio.h>
#include <string.h>
#include "mcc_generated_files/mcc.h"
#include "BackscatterComm.h"
#include "main.h"
#include "pic16lf1459.h"
#include <math.h>


    
    char str8[10]=0;
    int delay=4;  
      int v;
    int NODE_ID=1;
    int SENSORID=0;
    int sleep=0;
    int sensor0=0;
    int sensor1=0;
void main(void)
{
 
  
    // initialize the device
    SYSTEM_Initialize();
    uint8_t count=0;
    
//FVR_Initialize();
  
    // When using interrupts, you need to set the Global and Peripheral Interrupt Enable bits
    // Use the following macros to:
    if (sleep==1)
    {    
       // Enable the Global Interrupts
       INTERRUPT_GlobalInterruptEnable();
    }
    else
    {
      // Disable the Global Interrupts
    INTERRUPT_GlobalInterruptDisable();
    }   
    
    //INTERRUPT_GlobalInterruptEnable();
        
    // Enable the Peripheral Interrupts
    //INTERRUPT_PeripheralInterruptEnable();

    // Disable the Peripheral Interrupts
    //INTERRUPT_PeripheralInterruptDisable();
   ADC_Initialize();
   DAC_Initialize();
     
   printf("Start\n");
    while (1)
    {
         
         DACEN=0;
         //LATC3=1;
         //leaf temp
         
         sensor0= ADC_GetConversion(channel_AN8); 
        
         
         //air temp
         sensor1= ADC_GetConversion(channel_AN9);
         
         //Close adc  
         ADCON0 = 0x00; 
         
         //sprintf(str8,"%dE%d", sensor0,sensor1);
        //sprintf(str8,"%dE%d", ADC_GetConversion(channel_AN8), ADC_GetConversion(channel_AN9));
         
         
         
         //LATC3=0;
       
        DACEN=0;  
        DACCON1  = 0 ; //mexri 31 paei  
        LATB4 = 1;
         
       sprintf(str8,"%dE%d", 2, 4);

       char *c = str8;
       for( ; *c ; c++ ) 
       {
            sendChar( *c );
       }
	
       DACEN=0;  // Close DAC 
       LATB4 = 0; // Close timer 
         if (sleep==1) { 
             
             
             SLEEP(); // go to sleep ->interupt at pin 15 
           }
       
       for(v = 0; v < 250; ++v)
	    {
		      _nop();
	   }
       
    
    }
    
}

void dot()
{
    int i;
    LATC3=1;
	
	for(i = 0; i < delay; ++i)
	{
		      _nop();
	}
     LATC3=0;
	 for(i = 0; i < delay; ++i)
	 {
	          _nop();
	 }
}

void dash()
{
    int i;
    LATC3=1;
	
	
		for(i = 0; i < delay; ++i)
		{
		      _nop();
		}
    for(i = 0; i < delay; ++i)
		{
		      _nop();
		}
		
    for(i = 0; i < delay; ++i)
		{
		      _nop();
		}

     LATC3=0;
	 for(i = 0; i < delay; ++i)
	 {
	          _nop();
	 }
}



void sendChar(unsigned char a)
{
 int i;
 if (a=='0'){
  dash();dash();dash();dash();dash();}
 else if  (a=='1'){
  dot(); dash(); dash(); dash(); dash();}
 else if  (a=='2'){
  dot();  dot(); dash(); dash(); dash();}
  else if  (a=='3'){
    dot();  dot(); dot(); dash(); dash();}
 else if  (a=='4'){
  dot(); dot(); dot(); dot(); dash();}
 else if  (a=='5'){
  dot();  dot(); dot(); dot(); dot();}
 else if  (a=='6'){
  dash(); dot(); dot(); dot(); dot();}
 else if  (a=='7'){
   dash(); dash();  dot(); dot(); dot();}
  else if  (a=='8'){
    dash();dash();dash();  dot(); dot(); }
 else if  (a=='9'){
     dash();dash();dash();dash(); dot();}
 else if  (a=='E'){
      dot();}
 
 //pause(2); // 3 dots between characters, 1 was already after the beep
 for(i = 0; i < delay; ++i){
         	  _nop();		     
         	}// gia na ftiaxo tous idios xronous
 for(i = 0; i < delay; ++i){
         	  _nop();

         	}// gia na ftiaxo tous idios xronous 
}

