/* 
 * File:   BackscatterComm.h
 * Author: Daskals
 *
 * Created on November 17, 2017, 10:56 AM
 */

#ifndef BACKSCATTERCOMM_H
#define	BACKSCATTERCOMM_H

#ifdef	__cplusplus
extern "C" {
#endif

#define TAG ID 1
#define PREAMBLE_LENGTH 10
#define ID_LENGTH 2
#define UTILITY_LENGTH 1
#define DUMMYBIT 1
#define HAMMINGBITS 6
    
#define HEADER_LENGTH (PREAMBLE_LENGTH+ID_LENGTH+UTILITY_LENGTH)

#define GEN_MATRIX_ROWS 12
//Uncoded
#define CODEWORD_LENGTH 10
#define INFOWORD_LENGTH 10
    
#define PACKETLENGTH (HEADER_LENGTH+INFOWORD_LENGTH+DUMMYBIT)
#define PACKETLENGTHHAMMING (HEADER_LENGTH+INFOWORD_LENGTH+HAMMINGBITS+DUMMYBIT)


#ifdef	__cplusplus
}
#endif

#endif	/* BACKSCATTERCOMM_H */

