#include <stdio.h>
#include <stdint.h>
#include "User_function.c"
#include "d_can.h"
#include "can.c"



//     Device clock: 020.000000 MHz
//     Sampling Frequency: 5000 Hz
// Filter setup:
//     Filter kind: FIR
//     Filter type: Lowpass filter
//     Filter order: 10
//     Filter window: Kaiser
//     Filter borders:
//       Wpass:4000 Hz
//       Ap: 1 dB
//       As: 60 dB
//       Aa: 1 dB
//       Wp: 4000 Hz
//       Ws: 6000 Hz
//       Wp2: 7500 Hz
//       Ws2: 8000 Hz

/*********************************************VARIABILI GLOBALI PRIVATE*******************************************/
static unsigned Channel_Index = 0;
static unsigned inext = 0;
static unsigned CurrentValue;
static unsigned CHANNEL = 0;
static unsigned ADC_CONT, TMR5_CONT = 0;

ydata unsigned input[N_CHANNEL][BUFFFER_SIZE];             	// Input buffer, must be in Y data space
int16_t data_buffer[N_CHANNEL];                 		    // Current value buffer, da essere inviato tramite bus
int16_t *buffer_adc;


const unsigned COEFF_B[FILTER_ORDER+1] = {
      0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x6666,
      0x0000, 0x0000, 0x0000, 0x0000, 0x0000};

/*****************************************************************************************************************/

void canInterrupt() iv IVT_ADDR_C1INTERRUPT ics ICS_AUTO {			

    Can_clearInterrupt();
}

void TIMER5_INT() iv IVT_ADDR_T5INTERRUPT ics ICS_AUTO { //fare lo switch dau

  switch (DAU_ID){

  	case DAU_REAR : 

  	Can_resetWritePacket();
      Can_addIntToWritePacket(data_buffer[LINEAR_RL]);
      Can_addIntToWritePacket(data_buffer[LC_L]);                                                            
      Can_addIntToWritePacket(data_buffer[LINEAR_RR]);                                                             
      Can_addIntToWritePacket(data_buffer[LC_R]);                                                              
      Can_write(DAU_REAR_ID);                                                
                                                                                                             
	Can_resetWritePacket();                                                                                      
      Can_addIntToWritePacket(data_buffer[IR_RL_1]);
      Can_addIntToWritePacket(data_buffer[IR_RL_2]);
      Can_addIntToWritePacket(data_buffer[IR_RL_3]);
      Can_write(IR_RL_ID);

	Can_resetWritePacket();
      Can_addIntToWritePacket(data_buffer[IR_RR_1]);
      Can_addIntToWritePacket(data_buffer[IR_RR_2]);
      Can_addIntToWritePacket(data_buffer[IR_RR_3]);
      Can_write(IR_RR_ID);

      break;

    case DAU_FR : 

    Can_resetWritePacket();
      Can_addIntToWritePacket(data_buffer[LINEAR_FR]);
      Can_addIntToWritePacket(data_buffer[LC_L]);                                                            
      Can_addIntToWritePacket(data_buffer[BPS_F]);                                                                                                                          
      Can_write(DAU_FR_ID);                                                
                                                                                                             
	Can_resetWritePacket();                                                                                      
      Can_addIntToWritePacket(data_buffer[APPS1]);
      Can_addIntToWritePacket(data_buffer[APPS2]);
      Can_write(DAU_FR_APPS_ID);

	Can_resetWritePacket();
      Can_addIntToWritePacket(data_buffer[IR_FR_1]);
      Can_addIntToWritePacket(data_buffer[IR_FR_2]);
      Can_addIntToWritePacket(data_buffer[IR_FR_3]);
      Can_write(IR_FR_ID);

      break;

    case DAU_FL : 

    Can_resetWritePacket();
      Can_addIntToWritePacket(data_buffer[LINEAR_FL]);
      Can_addIntToWritePacket(data_buffer[LC_L]);                                                            
      Can_addIntToWritePacket(data_buffer[BPS_R]);    
      Can_addIntToWritePacket(data_buffer[STEER_ANGLE]);    //i valori dello sterzo devono essere corretti prima di essere inviati, da implementare                                                                                                                  
      Can_write(DAU_FL_ID);                                                
                                                                                                             
	Can_resetWritePacket();                                                                                      
      Can_addIntToWritePacket(data_buffer[IR_FL_1]);
      Can_addIntToWritePacket(data_buffer[IR_FL_2]);
      Can_addIntToWritePacket(data_buffer[IR_FL_3]);
      Can_write(IR_FL_ID);

      break;

	}

/*resta da implementare la funzione di conversione e invio dei dati di dbug della scheda, alla quale oltre a temp e corrente si potrebbero aggiungere gli errori di scheda*/
if (TMR5_CONT > 1000){
    TMR5_CONT = 0;
    ToggleLEDBLUE();
  }
  TMR5_CONT++;

  IFS1bits.T5IF = 0;

}

void ADC_INT() iv IVT_ADDR_ADCINTERRUPT ics ICS_AUTO {  //non vorrei che le operazioni svolte qui dentro fosero troppe per una interrupt, forse andrebbero delegate a un'altra funzione

	for (Channel_Index = 0; Channel_Index < N_CHANNEL; Channel_Index ++){
		buffer_adc = &ADCBUF0;

		input[Channel_Index][inext] = *buffer_adc + Channel_Index;          // Fetch sample

	    CurrentValue = FIR_Radix(FILTER_ORDER+1,      		                // ordine del filtro
	                              COEFF_B,            		                // coefficenti del filtro
	                              BUFFFER_SIZE,       		                // lunghezza del buffer
	                              input[Channel_Index],                   // Input buffer
	                              inext);            		                  // sample corrente

	    data_buffer[Channel_Index] = CurrentValue;                        //salvo i dati filtrati nel buffer
	}

	inext = (inext+1) & (BUFFFER_SIZE-1);   			    // inext = (inext + 1) mod BUFFFER_SIZE;
  	IFS0bits.ADIF     = 0b0;                				//clear interrupt flag


  if (ADC_CONT > 1000){
    ADC_CONT = 0;
   	ToggleLEDRED();
  }
    ADC_CONT++;

}

void TIMER4_INT() iv IVT_ADDR_T4INTERRUPT ics ICS_AUTO {

  ADCON1bits.ADON = 1;
  IFS1bits.T4IF = 0;

}


void main() {
                  
  Clear_buffer(Input);        
  DAU_ID_CHECK =  dau_set_ID(&DAU_ID);                     
  ADC_CHECK    =  adc_init();
  tmr4_init();
  can_bus_init();
  tmr5_init();
  io_init();


	while(1){          

		if (DAU_ID_CHECK == DAU_ID_ERROR) 
  		{
  			set_LEDRED();
  			set_LEDBLUE();
  			delay_ms(1000);
  			DAU_STATE_BUFFER[DAU_LOCATION] = DAU_ID_CHECK;
  			DAU_ID_CHECK =  dau_set_ID(&DAU_ID);
  		}

		if (ADC_CHECK == ADC_ERROR)
  		{
  			DAU_STATE_BUFFER[ADC_STATE] = ADC_ERROR;
  			ADC_CHECK    =  adc_init();
  		}
		
	}


}