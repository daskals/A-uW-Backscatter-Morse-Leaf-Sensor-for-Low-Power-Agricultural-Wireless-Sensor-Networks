
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

/*
                         Main application
 *///
    char  packet1[PACKETLENGTH]=0;
    char  packet2[PACKETLENGTHHAMMING]=0;
    char  nocodedbit[ID_LENGTH+UTILITY_LENGTH+INFOWORD_LENGTH]=0;
     
    char   *preamble="1010101111";
    char   *Fixeddata="0111100011";
    char   *packet="1010101111010100111100011" ;
    char   *message = "2.";
    
    char str8[6]=0;
    
    double temp=0;
    int hundreds=0;
    int tens=0; 
    int units=0;
    int tenths=0;
    int hundredths=0;
    int thousandths=0; 
    int tenthousandths=0;
    
	 double remainder=0;
     
     
    double IN_STRAY_CAP_TO_GND=26.70;
    double IN_EXTRA_CAP_TO_GND=0.0;
    double IN_CAP_TO_GND=0.0;
    double capacitance=0.0;
    
    double FactorA= -1.064200E-09;
	double FactorB= -5.759725E-06;
	double FactorC= -1.789883E-01;
	double FactorD=  2.048570E+02;
    double TemporC1=0;
    double TemporC2=0;
    double TempDIFF=0;
    
    double ADC0mVolt=0;
    double ADC1mVolt=0;
        
    double ADC0mVolt1=0;
    double ADC0mVolt2=0;

    double voltref=2042;
    int ADCres=1023;
    int delay=20;
    int sensor0=0;
    int sensor1=0;
    
    int NODE_ID=1;
    int SENSORID=0;
    
    int sleep=0;
    
    
    // Morse character codes: last 5  bits dits/dahs, fist 3 bits - length


void main(void)
{
    int i=0;
  
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
     
   printf("Start\n");
    while (1)
    {
        // Take data from sensors 
        
          *packet1=0;

         LATC3=1;
         //leaf temp
         sensor0= ADC_GetConversion(channel_AN8); 
         
         sensor0=2; 
         
         //air temp
         sensor1= ADC_GetConversion(channel_AN9);
         
         sensor1=4;  
         
         //Close adc  
         ADCON0 = 0x00; 
         LATC3=0;
         
       sprintf(str8,"%dE%d", sensor0, sensor1);

       char *c = str8;
       for( ; *c ; c++ ) 
       {
            sendChar( *c );
           // printf("%c \n", *c );
       }
	
        
          if (sleep==1)
          {     
           SLEEP(); // go to sleep ->interupt at pin 15 
           }
          
 
          
           
    }
    
}


void dit_dah(int index)
{
	
    int i;
    LATC4=1;
	if (index==1)
	{
		for(i = 0; i < delay; ++i)
		{
		      _nop();
              LATC4=~LATC4;
		 }
	}
	if(index==3)
	{
		for(i = 0; i < delay; ++i)
		{
		      _nop();
              LATC4=~LATC4;
		}
		for(i = 0; i < delay; ++i)
		{
			  _nop();	  
              LATC4=~LATC4;
		}
		for(i = 0; i < delay; ++i)
		{
			  _nop();
              LATC4=~LATC4;
		}
	}
     LATC4=0;
	 for(i = 0; i < delay; ++i)
	 {
	          _nop();
	 }
}


void sendChar(unsigned char a)
{
 int i;
 if (a=='0'){
 dit_dah(3); dit_dah(3); dit_dah(3); dit_dah(3);  dit_dah(3);}
 else if  (a=='1'){
 dit_dah(1);dit_dah(3); dit_dah(3); dit_dah(3);  dit_dah(3);}
 else if  (a=='2'){
 dit_dah(1);dit_dah(1); dit_dah(3); dit_dah(3);  dit_dah(3);}
  else if  (a=='3'){
 dit_dah(1);dit_dah(1); dit_dah(1);  dit_dah(3);  dit_dah(3);}
 else if  (a=='4'){
 dit_dah(1);dit_dah(1); dit_dah(1);  dit_dah(1); dit_dah(3);}
 else if  (a=='5'){
 dit_dah(1);dit_dah(1); dit_dah(1);dit_dah(1);  dit_dah(1);}
 else if  (a=='6'){
 dit_dah(3);dit_dah(1); dit_dah(1);dit_dah(1);  dit_dah(1);}
 else if  (a=='7'){
 dit_dah(3);dit_dah(3); dit_dah(1);dit_dah(1);  dit_dah(1);}
  else if  (a=='8'){
 dit_dah(3);dit_dah(3); dit_dah(3);dit_dah(1);  dit_dah(1);}
 else if  (a=='9'){
 dit_dah(3);dit_dah(3); dit_dah(3);dit_dah(3);  dit_dah(1);}
 else if  (a=='E'){
 dit_dah(1); 
 }


 //pause(2); // 3 dots between characters, 1 was already after the beep
 for(i = 0; i < delay; ++i){
         	  _nop();		     
         	}// gia na ftiaxo tous idios xronous
 for(i = 0; i < delay; ++i){
         	  _nop();

         	}// gia na ftiaxo tous idios xronous
 
}

