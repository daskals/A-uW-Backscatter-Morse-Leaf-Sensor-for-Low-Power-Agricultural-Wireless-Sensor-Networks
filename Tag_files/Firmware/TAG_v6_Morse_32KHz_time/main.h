/* 
 * File:   main.h
 * Author: Daskals
 *
 * Created on November 17, 2017, 10:57 AM
 */

#ifndef MAIN_H
#define	MAIN_H

#ifdef	__cplusplus
extern "C" {
#endif

//Scatter Communication
void Sympol(int nowsym);
void createPacket(unsigned char  *txdata, int SensorID, int16_t Value);
void createPacketHamming(unsigned char  *txdata, unsigned char  *nocoded, int SensorID, int16_t Value);
void int_to_binary(unsigned char  *array, unsigned int value, unsigned int len, unsigned int index);
void SendFIXEDBits(void);
void backscatter_transmit_packet_FM0(unsigned char  *txdata, unsigned char  length);
void backscatter_transmit_packet_FM0_HAMM(unsigned char  *txdata, unsigned char  length);
void backscatter_transmit_packet_4PAM_ASS(unsigned char  *txdata, unsigned char  length);
void dit_dah(int index);
void sendString(const char *str );
void sendChar(unsigned char a);
void dash();
void dot();
#ifdef	__cplusplus
}
#endif

#endif	/* MAIN_H */

