#line 1 "C:/Users/sofia/Desktop/GIT REPO/DAU/User_Function.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/stdio.h"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;



typedef signed int int_fast8_t;
typedef signed int int_fast16_t;
typedef signed long int int_fast32_t;


typedef unsigned int uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;


typedef signed int intptr_t;
typedef unsigned int uintptr_t;


typedef signed long int intmax_t;
typedef unsigned long int uintmax_t;
#line 1 "c:/users/sofia/desktop/git repo/dau/id_can.h"
#line 1 "c:/users/sofia/desktop/git repo/dau/user_function.h"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/stdio.h"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/stdint.h"
#line 65 "c:/users/sofia/desktop/git repo/dau/user_function.h"
void tmr5_init(void);
void can_bus_init(void);
uint8_t adc_init(void);
void tmr4_init(void);
void tmr1_init(void);
void io_init(void);
uint8_t dau_set_ID(uint8_t * DAU_ID);

void Toggle_LEDRED(void);
void Toggle_LEDBLUE(void);
void Set_LEDRED(void);
void set_LEDBLUE(void);
void set_LEDGREEN(void);
#line 1 "c:/users/sofia/desktop/git repo/dau/can.h"
#line 48 "c:/users/sofia/desktop/git repo/dau/can.h"
void Can_init(void);

void Can_read(unsigned long int *id, char dataBuffer[], unsigned int *dataLength, unsigned int *inFlags);

void Can_writeByte(unsigned long int id, unsigned char dataOut);

void Can_writeInt(unsigned long int id, int dataOut);

void Can_addIntToWritePacket(int dataOut);

void Can_addByteToWritePacket(unsigned char dataOut);

void Can_write(unsigned long int id);

void Can_setWritePriority(unsigned int txPriority);

void Can_resetWritePacket(void);

unsigned int Can_getWriteFlags(void);

unsigned char Can_B0hasBeenReceived(void);

unsigned char Can_B1hasBeenReceived(void);

void Can_clearB0Flag(void);

void Can_clearB1Flag(void);

void Can_clearInterrupt(void);

void Can_initInterrupt(void);
#line 10 "C:/Users/sofia/Desktop/GIT REPO/DAU/User_Function.c"
uint8_t DAU_ID;
uint8_t DAU_ID_CHECK =  (uint8_t)1 ;
uint8_t ADC_CHECK =  (uint8_t)1 ;
uint8_t DAU_STATE_BUFFER[ (uint8_t)5 ];










void tmr5_init(void){

T5CONbits.TON = 0b1;
T5CONbits.TSIDL = 0b0;
T5CONbits.TGATE = 0b0;
T5CONbits.TCKPS = 0b01;
T5CONbits.TCS = 0b0;

IPC5bits.T5IP = 0b011;

IFS1bits.T5IF = 0b0;
IEC1bits.T5IE = 0b1;

TMR5 = 0b0;
PR5 = 24500;

}


void can_bus_init(void){

 CAN_Init();
 Can_resetWritePacket();

}


uint8_t adc_init(void){

IEC0bits.ADIE = 0b1;
IPC2bits.ADIP = 0b010;
IFS0bits.ADIF = 0b0;

ADPCFG = 0b000000000000000;
ADCON3bits.ADCS = 0b011000;
ADCON3bits.ADRC = 0b0;
ADCON3bits.SAMC = 0b00010;

ADCON2bits.ALTS = 0b0;
ADCON2bits.BUFM = 0b0;
ADCON2bits.SMPI = 0b1111;
ADCON2bits.CSCNA = 0b1;
ADCON2bits.VCFG = 0b000;

ADCON1bits.ASAM = 0b1;
ADCON1bits.SSRC = 0b111;
ADCON1bits.FORM = 0b00;
ADCON1bits.ADSIDL = 0b0;
ADCON1bits.ADON = 0b0;

ADCSSL = 0xFFFF;
ADCHSbits.CH0NA = 0;

return  (uint8_t)0 ;

}



void tmr4_init(void){

T4CONbits.TON = 0b1;
T4CONbits.TSIDL = 0b0;
T4CONbits.TGATE = 0b0;
T4CONbits.TCKPS = 0b00;
T4CONbits.TCS = 0b0;


T4CONbits.T32 = 0b0;
IPC5bits.T4IP = 0b001;

IFS1bits.T4IF = 0b0;
IEC1bits.T4IE = 0b1;

TMR4 = 0b0;
PR4 = 0b0000110100000101;

}

void tmr1_init(void){

T1CONbits.TON = 0b1;
T1CONbits.TSIDL = 0b0;
T1CONbits.TGATE = 0b0;
T1CONbits.TCKPS = 0b11;
T1CONbits.TCS = 0b0;


IPC0bits.T1IP = 0b011;

IFS0bits.T1IF = 0b0;
IEC0bits.T1IE = 0b1;

TMR1 = 0b0;
PR1 = 0b0011110100001001;

}



void io_init(void){

 TRISGbits.TRISG12 = 0;
 TRISGbits.TRISG13 = 0;
 TRISGbits.TRISG14 = 0;



}


uint8_t dau_set_ID(uint8_t * DAU_ID){
 if ( PORTFbits.RF4  == 0 &&  PORTFbits.RF5  == 0){
 *DAU_ID =  0b00 ;
 return  (uint8_t) 0 ;
 }
 else if ( PORTFbits.RF4  == 1 &&  PORTFbits.RF5  == 0){
 *DAU_ID =  0b01 ;
 return  (uint8_t) 0 ;
 }
 else if( PORTFbits.RF4  == 0 &&  PORTFbits.RF5  == 1){
 *DAU_ID =  0b10 ;
 return  (uint8_t) 0 ;
 }
 else return  (uint8_t)1 ;
}






void Toggle_LEDRED(void){

if( LATGbits.LATG12  == 0)  LATGbits.LATG12  = 1;
else  LATGbits.LATG12  = 0;

}

void Toggle_LEDBLUE(void){

if( LATGbits.LATG13  == 0)  LATGbits.LATG13  = 1;
else  LATGbits.LATG13  = 0;

}

void Set_LEDRED(void){
  LATGbits.LATG12  = 1;
}

void set_LEDBLUE(void){
  LATGbits.LATG13  = 1;
}

void set_LEDGREEN(void){
  LATGbits.LATG14  = 1;
}
