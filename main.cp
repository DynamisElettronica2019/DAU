#line 1 "C:/Users/SimoGein/Desktop/git/DAU/main.c"
#line 1 "c:/program files/mikroc pro for dspic/include/stdio.h"
#line 1 "c:/program files/mikroc pro for dspic/include/stdint.h"




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
#line 1 "c:/users/simogein/desktop/git/dau/user_function.h"
#line 1 "c:/program files/mikroc pro for dspic/include/stdio.h"
#line 1 "c:/program files/mikroc pro for dspic/include/stdint.h"
#line 53 "c:/users/simogein/desktop/git/dau/user_function.h"
void Clear_buffer(ydata unsigned **input);
void tmr5_init(void);
void can_bus_init(void);
uint8_t adc_init(void);
void tmr4_init(void);
void io_init(void);
uint8_t dau_set_ID(uint8_t * DAU_ID);

void Toggle_LEDRED(void);
void Toggle_LEDBLUE(void);
void Set_LEDRED(void);
void set_LEDBLUE(void);
void set_LEDGREEN(void);
#line 1 "c:/users/simogein/desktop/git/dau/d_can.h"
#line 1 "c:/users/simogein/desktop/git/dau/can.h"
#line 48 "c:/users/simogein/desktop/git/dau/can.h"
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
#line 27 "C:/Users/SimoGein/Desktop/git/DAU/main.c"
extern uint8_t DAU_ID;

static unsigned Channel_Index = 0;
static unsigned inext = 0;
static unsigned CurrentValue;
static unsigned CHANNEL = 0;
static unsigned ADC_CONT, TMR5_CONT = 0;

ydata unsigned input[ (uint8_t)16 ][ (uint8_t)32 ];
int16_t data_buffer[ (uint8_t)16 ];
int16_t *buffer_adc;


const unsigned COEFF_B[ (uint8_t)10 +1] = {
 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x6666,
 0x0000, 0x0000, 0x0000, 0x0000, 0x0000};



void canInterrupt() iv IVT_ADDR_C1INTERRUPT ics ICS_AUTO {

 Can_clearInterrupt();
}

void TIMER5_INT() iv IVT_ADDR_T5INTERRUPT ics ICS_AUTO {

 switch (DAU_ID){

 case  0b10  :

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 1 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 2 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 3 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 4 ]);
 Can_write( 0b11001010010 );

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 7 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 8 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 9 ]);
 Can_write( 0b11001010110 );

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 10 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 11 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 12 ]);
 Can_write( 0b11001010111 );

 break;

 case  0b01  :

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 1 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 2 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 3 ]);
 Can_write( 0b11001010000 );

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 4 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 5 ]);
 Can_write( 0b11001010011 );

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 7 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 8 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 9 ]);
 Can_write( 0b11001010101 );

 break;

 case  0b00  :

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 1 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 2 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 3 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 4 ]);
 Can_write( 0b11001010001 );

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 7 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 8 ]);
 Can_addIntToWritePacket(data_buffer[ (uint8_t) 9 ]);
 Can_write( 0b11001010100 );

 break;

 }


if (TMR5_CONT > 1000){
 TMR5_CONT = 0;
 }
 TMR5_CONT++;

 IFS1bits.T5IF = 0;

}

void ADC_INT() iv IVT_ADDR_ADCINTERRUPT ics ICS_AUTO {

 for (Channel_Index = 0; Channel_Index <  (uint8_t)16 ; Channel_Index ++){
 buffer_adc = &ADCBUF0;

 input[Channel_Index][inext] = *buffer_adc + Channel_Index;

 CurrentValue = FIR_Radix( (uint8_t)10 +1,
 COEFF_B,
  (uint8_t)32 ,
 input[Channel_Index],
 inext);

 data_buffer[Channel_Index] = CurrentValue;
 }

 inext = (inext+1) & ( (uint8_t)32 -1);
 IFS0bits.ADIF = 0b0;


 if (ADC_CONT > 1000){
 ADC_CONT = 0;
 }
 ADC_CONT++;

}

void TIMER4_INT() iv IVT_ADDR_T4INTERRUPT ics ICS_AUTO {

 ADCON1bits.ADON = 1;
 IFS1bits.T4IF = 0;

}


void main() {


 set_LEDGREEN();
 Clear_buffer(Input);
 dau_set_ID(&DAU_ID);
 adc_init();
 tmr4_init();
 can_bus_init();
 tmr5_init();
 io_init();


 while(1){
#line 193 "C:/Users/SimoGein/Desktop/git/DAU/main.c"
 }

}
