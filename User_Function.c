#include <stdio.h>
#include <stdint.h>
#include "id_can.h"
#include "User_Function.h"
#include "can.h"

/*****************************DEFINIZIONE VARIABILI GLOBALI COMUNI**********************************/


uint8_t DAU_ID;
uint8_t DAU_ID_CHECK = DAU_ID_ERROR;
uint8_t ADC_CHECK = ADC_ERROR;
uint8_t DAU_STATE_BUFFER[DAU_STATE_BUFFER_LENGTH];


/****************************************************************************************************/






/*inizializzazione del timer 5, responsabile della scrittura dati su can @ 100Hz */
void tmr5_init(void){

T5CONbits.TON   = 0b1;
T5CONbits.TSIDL = 0b0;     //Continue timer operation in Idle mode
T5CONbits.TGATE = 0b0;     //no gated time
T5CONbits.TCKPS = 0b01;    //prescaler 8
T5CONbits.TCS   = 0b0;     //Internal clock (FOSC/4)

IPC5bits.T5IP = 0b011;     //interrupt priority 3  ALTA

IFS1bits.T5IF = 0b0;       //clear interrupt
IEC1bits.T5IE = 0b1;       //enable interrupt

TMR5 = 0b0;
PR5  = 24500;       //25000 * 8 * 50ns -> 0.01 s     //24500 per compensare la durata della routine

}

/*inizializzazione del can bus*/
void can_bus_init(void){          

        CAN_Init();
        Can_resetWritePacket();

}

/*inizializzazione degli adc*/
uint8_t adc_init(void){

IEC0bits.ADIE     = 0b1;               //adc interrupt enable
IPC2bits.ADIP     = 0b010;             //adc interrupt priority  2 MEDIA
IFS0bits.ADIF     = 0b0;               //clear interrupt flag

ADPCFG            = 0b000000000000000; //All Analog input pin in Analog mode, port read input disabled, A/D samples pin voltage
ADCON3bits.ADCS   = 0b011000;          //set Tad of the ADC          x24Tcy
ADCON3bits.ADRC   = 0b0;              // clock from system
ADCON3bits.SAMC   = 0b00010;          // 2Tad

ADCON2bits.ALTS   = 0b0;              //Always use MUX A input multiplexer settings
ADCON2bits.BUFM   = 0b0;              //Buffer configured as one 16-word buffer ADCBUF(15...0)
ADCON2bits.SMPI   = 0b1111;            //Interrupts at the completion of conversion for each 16th sample/convert sequence
ADCON2bits.CSCNA  = 0b1;              //Scan inputs
ADCON2bits.VCFG   = 0b000;            //internal voltage reference VDD

ADCON1bits.ASAM   = 0b1;              // Sampling begins immediately after last conversion completes. SAMP bit is auto set
ADCON1bits.SSRC   = 0b111;            //Internal counter ends sampling and starts conversion (auto convert)
ADCON1bits.FORM   = 0b00;             //data output integer
ADCON1bits.ADSIDL = 0b0;              // Continue module operation in Idle mode
ADCON1bits.ADON   = 0b0;

ADCSSL = 0xFFFF;     //scan ALL inputs
ADCHSbits.CH0NA = 0; //negative input for sampling Vref-

return ADC_OK;

}


/*inizializzazione del timer4, responsabile per l'acquisizione degli adc*/
void tmr4_init(void){

T4CONbits.TON   = 0b1;
T4CONbits.TSIDL = 0b0;     //Continue timer operation in Idle mode
T4CONbits.TGATE = 0b0;     //no gated time
T4CONbits.TCKPS = 0b00;    //prescaler
T4CONbits.TCS = 0b0;       //Internal clock (FOSC/4)


T4CONbits.T32 = 0b0;       //16 bit timer, separated from timer5
IPC5bits.T4IP = 0b001;     //interrupt priority 1 BASSA

IFS1bits.T4IF = 0b0;       //clear interrupt
IEC1bits.T4IE = 0b1;       //enable interrupt

TMR4 = 0b0;
PR4  = 0b0000110100000101;       // 3333 * 50ns = 167 us --> 6 KHz

}

void tmr1_init(void){

T1CONbits.TON   = 0b1;
T1CONbits.TSIDL = 0b0;     //Continue timer operation in Idle mode
T1CONbits.TGATE = 0b0;     //no gated time
T1CONbits.TCKPS = 0b11;    //prescaler : 256
T1CONbits.TCS = 0b0;       //Internal clock (FOSC/4)


IPC0bits.T1IP = 0b011;     //interrupt priority 3 ALTA

IFS0bits.T1IF = 0b0;       //clear interrupt
IEC0bits.T1IE = 0b1;       //enable interrupt

TMR1 = 0b0;
PR1  = 0b0011110100001001;       // 15625 * 50ns * 256 = 0.2 s --> 5Hz

}



void io_init(void){

        TRISGbits.TRISG12 = 0;             //LED IOPORT AS OUPUT
        TRISGbits.TRISG13 = 0;
        TRISGbits.TRISG14 = 0;

        /*inizializzare le porte degli adc come analog input*/

}


uint8_t dau_set_ID(uint8_t * DAU_ID){
        if (SELBIT0 == 0 && SELBIT1 == 0){ 
                *DAU_ID = DAU_FL;
                return DAU_ID_OK;
        }
        else if (SELBIT0 == 1 && SELBIT1 == 0){
                *DAU_ID = DAU_FR; 
                return DAU_ID_OK;
        }
        else if(SELBIT0 == 0 && SELBIT1 == 1){
                *DAU_ID = DAU_REAR;
                return DAU_ID_OK;
        }
        else return DAU_ID_ERROR;
}






void Toggle_LEDRED(void){

if(LEDRED == 0) LEDRED = 1;
else                         LEDRED = 0;

}

void Toggle_LEDBLUE(void){

if(LEDBLUE == 0) LEDBLUE = 1;
else                          LEDBLUE = 0;

}

void Set_LEDRED(void){
        LEDRED = 1;
}

void set_LEDBLUE(void){
        LEDBLUE = 1;
}

void set_LEDGREEN(void){
        LEDGREEN = 1;
}