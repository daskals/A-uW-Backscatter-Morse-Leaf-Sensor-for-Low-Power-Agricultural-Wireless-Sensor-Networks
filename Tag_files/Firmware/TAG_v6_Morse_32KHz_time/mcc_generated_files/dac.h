/**
  DAC Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    dac.h

  @Summary
    This is the generated header file for the DAC driver using PIC10 / PIC12 / PIC16 / PIC18 MCUs 

  @Description
    This header file provides APIs for driver for DAC.
    Generation Information :
        Product Revision  :  PIC10 / PIC12 / PIC16 / PIC18 MCUs  - 1.45
        Device            :  PIC16LF1459
        Driver Version    :  2.00
    The generated drivers are tested against the following:
        Compiler          :  XC8 1.35
        MPLAB             :  MPLAB X 3.40
*/

/*
    (c) 2016 Microchip Technology Inc. and its subsidiaries. You may use this
    software and any derivatives exclusively with Microchip products.

    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
    EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
    WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
    PARTICULAR PURPOSE, OR ITS INTERACTION WITH MICROCHIP PRODUCTS, COMBINATION
    WITH ANY OTHER PRODUCTS, OR USE IN ANY APPLICATION.

    IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
    WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
    BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
    FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
    ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
    THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.

    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF THESE
    TERMS.
*/

#ifndef _DAC_H
#define _DAC_H

/**
  Section: Included Files
*/

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
  Section: DAC APIs
*/

/**
  @Summary
    Initializes the DAC

  @Description
    This routine initializes the DAC.
    This routine must be called before any other DAC routine is called.
    This routine should only be called once during system initialization.

  @Preconditions
    None

  @Param
    None

  @Returns
    None

  @Comment
    

  @Example
    <code>
    DAC_Initialize();
    </code>
*/
void DAC_Initialize(void);

/**
  @Summary
    Set Input data into DAC.

  @Description
    This routine pass the digital input data into
    DAC voltage reference control register.

  @Preconditions
    The DAC_Initialize() routine should be called
    prior to use this routine.

  @Param
    inputData - 8bit digital data to DAC.

  @Returns
    None

  @Example
    <code>
    uint8_t count=0;

    DAC_Initialize();

    for(count=0; count<=30; count++)
    {
        DAC_SetOutput(count);
    }

    while(1)
    {
    }
    </code>
*/
void DAC_SetOutput(uint8_t inputData);

#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif // _DAC_H
/**
 End of File
*/
