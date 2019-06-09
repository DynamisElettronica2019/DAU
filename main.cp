#line 1 "C:/Users/SimoGein/Desktop/git/DAU/DAU/main.c"
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
#line 1 "c:/users/simogein/desktop/git/dau/dau/user_function.h"
#line 1 "c:/program files/mikroc pro for dspic/include/stdio.h"
#line 1 "c:/program files/mikroc pro for dspic/include/stdint.h"
#line 65 "c:/users/simogein/desktop/git/dau/dau/user_function.h"
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
#line 1 "c:/users/simogein/desktop/git/dau/dau/id_can.h"
#line 1 "c:/users/simogein/desktop/git/dau/dau/can.h"
#line 48 "c:/users/simogein/desktop/git/dau/dau/can.h"
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
#line 34 "C:/Users/SimoGein/Desktop/git/DAU/DAU/main.c"
extern uint8_t DAU_ID;

int time_index = 0;
int CHANNEL = 0;
int ADC_CONT, TMR5_CONT, TMR1_CONT= 0;

unsigned long int data_buffer[ 16 ][ 50 +1];
int16_t data_out[ 16 ];
int16_t *buffer_adc;


unsigned long int coeff[ 50 +1] = { 0, 0, 2, 7, 20, 48, 103, 201, 362, 613, 981, 1498,
 2192, 3087, 4194, 5513, 7027, 8698, 10472, 12274, 14019, 15615, 16972, 18007,
 18656, 18877, 18656, 18007, 16972, 15615, 14019, 12274, 10472, 8698, 7027,
 5513, 4194, 3087, 2192, 1498, 981, 613, 362, 201, 103, 48, 20, 7, 2, 0, 0 };

unsigned long int filter_factor = 299999;





int FIR_filter(int Channel_Index_Filter, int time_index_filter){
 int sample = 0;
 int result = 0;
 unsigned long int sum_temp = 0;
 for (sample=0; sample< 50 +1; sample++){
 sum_temp += (data_buffer[Channel_Index_Filter][sample])*(coeff[time_index_filter]);
 if (time_index_filter == 0) time_index_filter =  50 ;
 else time_index_filter--;
 }

 result = ceil(sum_temp/filter_factor);
 return result;
}



void canInterrupt() iv IVT_ADDR_C1INTERRUPT ics ICS_AUTO {

 Can_clearInterrupt();
}



void TIMER5_INT() iv IVT_ADDR_T5INTERRUPT ics ICS_AUTO {

 int t_send = time_index;
 int Channel_Index_send = 0;


 for (Channel_Index_send = 0; Channel_Index_send <  16 ; Channel_Index_send++){
 data_out[Channel_Index_send] = FIR_filter(Channel_Index_send, t_send);
 }

 switch (DAU_ID){

 case  0b10  :

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_out[ (uint8_t) 2 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 0 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 3 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 1 ]);
 Can_write( 0x652 );

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_out[ (uint8_t) 8 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 9 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 10 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 4 ]);
 Can_write( 0x656 );

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_out[ (uint8_t) 11 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 12 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 13 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 5 ]);
 Can_write( 0x657 );


 break;

 case  0b01  :

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_out[ (uint8_t) 2 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 0 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 4 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 5 ]);
 Can_write( 0x650 );

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_out[ (uint8_t) 8 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 9 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 10 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 3 ]);
 Can_write( 0x655 );

 break;

 case  0b00  :

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_out[ (uint8_t) 2 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 0 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 4 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 5 ]);
 Can_write( 0x651 );

 Can_resetWritePacket();
 Can_addIntToWritePacket(data_out[ (uint8_t) 8 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 9 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 10 ]);
 Can_addIntToWritePacket(data_out[ (uint8_t) 3 ]);
 Can_write( 0x654 );

 break;

 }



 TMR5_CONT++;

 ADC_CONT = 0;
 IFS1bits.T5IF = 0;

}

void TIMER1_INT() iv IVT_ADDR_T1INTERRUPT ics ICS_AUTO {

 float currentConverted, tempConverted = 0;
 if (TMR1_CONT > 5){

 TMR1_CONT = 0;


 currentConverted = (float)data_out[ (uint8_t) 14 ] *  1.2210012210012210 ;
 currentConverted = (currentConverted/ 200 )/ 0.03 ;

 tempConverted = (float)data_out[ (uint8_t) 15 ] *  1.2210012210012210 ;
 tempConverted = (tempConverted -  500 )/ 10 ;

 switch (DAU_ID){


 case  0b10  :
 Toggle_LEDRED();

 Can_resetWritePacket();
 Can_addIntToWritePacket((int)currentConverted);
 Can_addIntToWritePacket((int)tempConverted);
 Can_write( 0x314 );
 break;

 case  0b00  :
 Toggle_LEDRED();

 Can_resetWritePacket();
 Can_addIntToWritePacket((int)currentConverted);
 Can_addIntToWritePacket((int)tempConverted);
 Can_write( 0x313 );
 break;

 case  0b01  :
 Toggle_LEDRED();

 Can_resetWritePacket();
 Can_addIntToWritePacket((int)currentConverted);
 Can_addIntToWritePacket((int)tempConverted);
 Can_write( 0x312 );
 break;
 }

 }
 TMR1_CONT++;
 IFS0bits.T1IF = 0;
}

void ADC_INT() iv IVT_ADDR_ADCINTERRUPT ics ICS_AUTO {
 int Channel_Index = 0;


 for (Channel_Index = 0; Channel_Index <  16 ; Channel_Index ++){
 buffer_adc = (&ADCBUF0 + Channel_Index);
 data_buffer[Channel_Index][time_index] = *buffer_adc;
 }

 if (time_index ==  50 ) time_index = 0;
 else time_index++;

 ADC_CONT++;

 IFS0bits.ADIF = 0b0;
}

void TIMER4_INT() iv IVT_ADDR_T4INTERRUPT ics ICS_AUTO {

 ADCON1bits.ADON = 1;
 IFS1bits.T4IF = 0;

}


void Clear_buffer(){
 int Ch_Index, Buffer_Index = 0;
 for (Ch_Index = 0; Ch_Index <  16 ; Ch_Index++){
 for(Buffer_Index = 0; Buffer_Index <  50 +1; Buffer_Index++){
 data_buffer[Ch_Index][Buffer_Index] = 0;
 }
 data_out[Ch_Index]=0;
 }
}

void main() {

 io_init();
 Clear_buffer();
 dau_set_ID(&DAU_ID);

 can_bus_init();
 adc_init();
 tmr4_init();
 tmr5_init();
 tmr1_init();


 while(1){
#line 279 "C:/Users/SimoGein/Desktop/git/DAU/DAU/main.c"
 }

}
