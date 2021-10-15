
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
    double sensor0=0;
    double sensor1=0;
    
    int NODE_ID=1;
    int SENSORID=0;
    
    int sleep=0;
    
    
    // Morse character codes: last 5  bits dits/dahs, fist 3 bits - length
const unsigned char m[] = {
  0b11111101 //0    -----
 ,0b01111101 //1   	.----
 ,0b00111101 //2 	..---
 ,0b00011101 //3	...--
 ,0b00001101 //4    ....-
 ,0b00000101 //5	.....
 ,0b10000101 //6	-....
 ,0b11000101 //7 	--...
 ,0b11100101 //8 	---..
 ,0b11110101 //9 	----.
 ,0,0,0,0,0,0,0 // other chars - handled in the switch block
 ,0b00001010 //A 	.-
 ,0b01000100 //B 	-...
 ,0b01010100 //C 	-.-.
 ,0b00100011 //D 	-..
 ,0b00000001 //E	.
 ,0b00010100 //F	..-.
 ,0b00110011 //G	--.
 ,0b00000100 //H	....
 ,0b00000010 //I	..
 ,0b00111100 //J	.---
 ,0b00101011 //K	-.-
 ,0b00100100 //L	.-..
 ,0b00011010 //M	--
 ,0b00010010 //N	-.
 ,0b00111011 //O	---
 ,0b00110100 //P	.--.
 ,0b01101100 //Q	--.-
 ,0b00010011 //R	.-.
 ,0b00000011 //S	...
 ,0b00001001 //T	-
 ,0b00001011 //U	..-
 ,0b00001100 //V	...-
 ,0b00011011 //W	.--
 ,0b01001100 //X	-..-
 ,0b01011100 //Y	-.--
 ,0b01100100 //Z	--..
};
    
const unsigned char m2[] = {
  11111 //0    -----
 ,01111 //1   	.----
 ,00111 //2 	..---
 ,00011 //3	...--
 ,00001 //4    ....-
 ,00000 //5	.....
 ,10000 //6	-....
 ,11000 //7 	--...
 ,11100 //8 	---..
 ,11110 //9 	----.
};

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
         ADC0mVolt1 =(voltref/ADCres)*sensor0; 
       
         
         //air temp
         sensor1= ADC_GetConversion(channel_AN9);
         ADC0mVolt2 =(voltref/ADCres)*sensor1; 
            
         
         //Close adc  
         ADCON0 = 0x00; 
         LATC3=0;
         
          ADC0mVolt2 =995.050;
          ADC0mVolt1 =992.227;

         TemporC1 = (double)FactorA*pow(ADC0mVolt1,3)+ (double)FactorB*pow(ADC0mVolt1,2)+ (double)FactorC*(ADC0mVolt1) + FactorD;
         TemporC2 = (double)FactorA*pow(ADC0mVolt2,3)+ (double)FactorB*pow(ADC0mVolt2,2)+ (double)FactorC*(ADC0mVolt2) + FactorD;
         TempDIFF=(TemporC2-TemporC1+6)*100;
         
         //printf("%f\n", TempDIFF);
         
           TempDIFF *= 10000;//250625.
	       temp = (double)TempDIFF;//250625

	       tens = temp/100000;//2
	       remainder = temp - tens*100000;//50625
	       units = remainder/10000;//5
           
	      // remainder = remainder - units*10000;//625
	      // tenths = remainder/1000;//0
	      // remainder = remainder - tenths*1000;//625
	      // hundredths = remainder/100;//6
   
       //sprintf(str8, "%d%d%d%d", tens, units, tenths, hundredths);
         
       sprintf(str8,"%d%d", tens,units );

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
           else
          {
            int waitind; 
             for(waitind = 0; waitind<0; waitind++){  
               _nop();
               _nop();
            }
 
          }
           
    }
    
}


  
          // Add your application code
             //LATC4=~LATC4; 
             //DACCON1  = 31 ;//mexri 31 paei 
            //_nop();
            //DACCON1  = 30;



/////////////////////////////////////////////////////////////////////////////////CW Part////////////////////////////////////////////////////////
void key(unsigned char a)
{
    
    int i;
 unsigned char n = a & 7; // beep count // metraxei poses fores tha xtipisei
 for( n = n + 2; n > 2; n--)
 {
 unsigned char mask = ( 1 << n );
 if( a & mask )
 {
	 dit_dah(3);
 }
 else
 {
     dit_dah(1);
 }
 }
 //-----------//////////////////////////////////////////////////////////////////////////////--------
 //pause(2); // 3 dots between characters, 1 was already after the beep
 for(i = 0; i < delay; ++i){
         	  _nop();
		      _nop();
		      _nop();
		      _nop();
         	}// gia na ftiaxo tous idios xronous
 for(i = 0; i < delay; ++i){
         	_nop();
		      _nop();
		      _nop();
		      _nop();
         	}// gia na ftiaxo tous idios xronous
//---------------///////////////////////////////////////////////////////////////////////////////////--------


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
		      _nop();
		      _nop();
		      _nop();
		      
              LATC4=~LATC4;
		 }
	}
	if(index==3)
	{
		for(i = 0; i < delay; ++i)
		{
		         	_nop();
		            _nop();
		            _nop();
		            _nop();
		         	
              LATC4=~LATC4;
		}
		for(i = 0; i < delay; ++i)
		{
			 _nop();
		      _nop();
		      _nop();
		      _nop();
				  
              LATC4=~LATC4;
		}
		for(i = 0; i < delay; ++i)
		{
			  _nop();
		      _nop();
		      _nop();
		      _nop();
				 
              LATC4=~LATC4;
		}

	}
              LATC4=0;
	 for(i = 0; i < delay; ++i)
	 {
	          _nop();
		      _nop();
		      _nop();
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
 else if  (a=='-'){
 dit_dah(3); dit_dah(1); dit_dah(1); dit_dah(1); dit_dah(1); dit_dah(3);
 }
 else if  (a=='.'){
 dit_dah(1);dit_dah(3); dit_dah(1); dit_dah(3); dit_dah(1); dit_dah(3);
 }

 
  //-----------//////////////////////////////////////////////////////////////////////////////--------
 //pause(2); // 3 dots between characters, 1 was already after the beep
  for(i = 0; i < delay; ++i){
         	  _nop();
		     
         	}// gia na ftiaxo tous idios xronous
 for(i = 0; i < delay; ++i){
         	  _nop();
		     
         	}// gia na ftiaxo tous idios xronous
 
}

