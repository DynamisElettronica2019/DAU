#include <stdio.h>
#include <stdint.h>
#include "d_can.h"
#include "can.c"


#define LEDRED   LATGbits.LATG12
#define LEDBLUE  LATGbits.LATG13
#define LEDGREEN LATGbits.LATG14

#define SELBIT0 PORTFbits.RF4
#define SELBIT1 PORTFbits.RF5

/*define per verifica errori*/
#define DAU_ID_OK 0
#define DAU_ID_ERROR 1
#define ADC_OK 0
#define ADC_ERROR 1

/*define per il buffer di stato*/
#define DAU_STATE_BUFFER_LENGTH 5
#define DAU_LOCATION 0  			
#define ADC_STATE 1


/*ID per la localizzazione delle schede*/
#define DAU_FL 0b00
#define DAU_FR 0b01
#define DAU_REAR 0b10

/*define dei canali associati ai sensori*/

	/*dau rear*/
#define LINEAR_RL
#define LC_L
#define LINEAR_RR
#define LC_R
#define IR_RL_1
#define IR_RL_2
#define IR_RL_3
#define IR_RR_1
#define IR_RR_2
#define IR_RR_3

	/*dau front left*/
#define LINEAR_FL
#define LC_L
#define BPS_R
#define STEER_ANGLE
#define IR_FL_1
#define IR_FL_2
#define IR_FL_3

	/*dau front right*/
#define LINEAR_FR
#define LC_L
#define BPS_F
#define APPS1
#define APPS2
#define IR_FR_1
#define IR_FR_2
#define IR_FR_3

/*define degli ID da inviare su CAN*/

#define DAU_REAR_ID
#define IR_RL_ID
#define IR_RR_ID
#define DAU_FR_ID
#define DAU_FR_APPS_ID
#define IR_FR_ID
#define DAU_FL_ID
#define IR_FL_ID




/*****************************DEFINIZIONE VARIABILI GLOBALI COMUNI**********************************/
const unsigned BUFFFER_SIZE  = 32;
const unsigned FILTER_ORDER  = 10;
const unsigned N_CHANNEL = 16;


uint8_t DAU_ID;
uint8_t DAU_ID_CHECK = DAU_ID_ERROR;
uint8_t ADC_CHECK = ADC_ERROR;
uint8_t DAU_STATE_BUFFER[DAU_STATE_BUFFER_LENGTH];


/****************************************************************************************************/




/*inizializza la matrice che contiene i dati delle acquisizioni*/
void Clear_buffer(ydata unsigned **input){
	int Channel_Index, Buffer_Index = 0;

	for (Channel_Index = 0; Channel_Index < N_CHANNEL; Channel_Index++){
		for(Buffer_Index = 0; Buffer_Index < BUFFER_SIZE; Buffer_Index++){

			input[Channel_Index][Buffer_Index] = 0;
		}
	}
}

/*inizializzazione del timer 5, responsabile della scrittura dati su can @ 100Hz */
void tmr5_init(void){

T5CONbits.TON   = 0b1;
T5CONbits.TSIDL = 0b0;     //Continue timer operation in Idle mode
T5CONbits.TGATE = 0b0;     //no gated time
T5CONbits.TCKPS = 0b01;    //prescaler 8
T5CONbits.TCS   = 0b0;     //Internal clock (FOSC/4)

IPC5bits.T5IP = 0b011;     //interrupt priority 3

IFS1bits.T5IF = 0b0;       //clear interrupt
IEC1bits.T5IE = 0b1;       //enable interrupt

TMR5 = 0b0;
PR5  = 0b0110000110101000;       //25000 * 8 * 50ns -> 0.01 s

}

/*inizializzazione del can bus*/
void can_bus_init(void){          

	CAN_Init();
	Can_resetWritePacket();

}

/*inizializzazione degli adc*/
uint8_t adc_init(void){

IEC0bits.ADIE     = 0b1;               //adc interrupt enable
IPC2bits.ADIP     = 0b001;             //adc interrupt priority
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
IPC5bits.T4IP = 0b011;     //interrupt priority 3

IFS1bits.T4IF = 0b0;       //clear interrupt
IEC1bits.T4IE = 0b1;       //enable interrupt

TMR4 = 0b0;
PR4  = 0b0000110100000101;       // 3333 * 50ns = 167 us --> 6 KHz

}

void io_init(void){

	TRISGbits.TRISG12 = 0;             //LED IOPORT AS OUPUT
	TRISGbits.TRISG13 = 0;
	TRISGbits.TRISG14 = 0;

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
else 			LEDRED = 0;

}

void Toggle_LEDBLUE(void){

if(LEDBLUE == 0) LEDBLUE = 1;
else 			 LEDBLUE = 0;

}

void Set_LEDRED(void){
	LEDRED = 1;
}

void set_LEDBLUE(void){
	LEDBLUE = 1;
}