#include <stdio.h>
#include <stdint.h>
#include "User_function.h"
#include "id_can.h"
#include "can.h"


//     Device clock: 080.000000 MHz
//     Sampling Frequency: 5000 Hz

/****************************************************
ALGORITMO DI FUNZIONAMENTO ACQUISIZIONE E FILTRAGGIO:

- TMR4 SCATTA A 6000Hz E AVVIA L'ADC
- QUANDO L'ADC HA FINITO LA CONVERSIONE DI TUTTI I 16 CANALI VIENE CHIAMATO L'INTERRUPT
- NELL'ARRAY 2D data_buffer VENGONO SALVATI I DATI LETTI DALL'ADC. OGNI CANALE HA UNA RIGA E AD OGNI COLONNA CORRISPONDE
UN ISTANTE DI TEMPO.
- data_buffer HA DIMENSIONI [NUMERO DI CANALI][ORDINE DEL FILTRO+1] (OVVERO NUMERO DEI COEFFICIENTI)
- LA COLONNA DOVE VENGONO SALVATI I DATI DELLA LETTURA ATTUALE E' time_index, PERCHE' INDICA LA POSIZIONE IN CUI E' SALVATO
IL DATO PIU' RECENTE.
- data_buffer E' CIRCOLARE, OVVERO DOPO ESSER STATI SALVATI I DATI VIENE ***INCREMENTATO*** time_index, FINO ALLA FINE 
DELL'ARRAY PER POI RIPARTIRE DA 0
- TMR5 SCATTA A 100Hz PER L'INVIO SU CAN
- PRIMA DELL INVIO SU CAN, PER OGNI CANALE VIENE CHIAMATA LA FUNZIONE DI FILTRAGGIO FIR_filter
- A QUESTO INTERRUPT VA ASSOCIATA UNA PRIORITA' PIU ALTA CHE A TMR4 IN MODO CHE PER TUTTA LA DURATA DELL'INVIO IL time_index SIA LO STESSO
- AD ESSA VIENE PASSATO IL time_index ATTUALE, CHE INDICA IN QUALE POSIZIONE SONO SALVATI I DATI PIU' RECENTI
- LA FUNZIONE ESEGUE LA SOMMATORIA DEI PRODOTTI SAMPLE*COEFFICIENTEfiltro PRENDENDO I SAMPLE IN ORDINE CRESCENTE DALLO 0 AL MAX,
MENTRE IL COEFFICIENTE E' PRESO PARTENDO DA QUELLO IN POSIZIONE time_index ATTUALE A ***DECREMENTARE***.
IN QUESTO MODO LA CORRISPONDENZA TRA CAMPIONE E COEFFICIENTE E' CORRETTA.
- IL RISULTATO DEL FILTRAGGIO PER OGNI CANALE E' SALVATO NELL ARRAY data_out

/*********************************************VARIABILI GLOBALI*******************************************/

extern uint8_t DAU_ID;

int time_index = 0;
int CHANNEL = 0;
int ADC_CONT, TMR5_CONT = 0;

unsigned long int data_buffer[N_CHANNEL][FILTER_ORDER+1];                      //data_buffer[ch, time_index]
int16_t data_out[N_CHANNEL];                                     // Current value buffer, da essere inviato tramite bus
int16_t *buffer_adc;


unsigned long int coeff[FILTER_ORDER+1] = { 0, 0, 2, 7, 20, 48, 103, 201, 362, 613, 981, 1498,
    2192, 3087, 4194, 5513, 7027, 8698, 10472, 12274, 14019, 15615, 16972, 18007,
    18656, 18877, 18656, 18007, 16972, 15615, 14019, 12274, 10472, 8698, 7027,
    5513, 4194, 3087, 2192, 1498, 981, 613, 362, 201, 103, 48, 20, 7, 2, 0, 0 };
    
unsigned long int filter_factor = 299999;            //VALORE DI SCALA PER I COEFFICIENTI DEL FILTRO [=SUM(coeff)]
    
/*****************************************************************************************************************/

/**********************************************FUNZIONE DI FILTRO*************************************************/

int FIR_filter(int Channel_Index_Filter, int time_index_filter){
    int sample = 0;                                 // Posizione nell array di data_buffer, incrementa fino a scorrere tutto l'array. La scelta del giusto coefficiente e' gestita da coeff_index
    int result = 0;
    unsigned long int sum_temp = 0;
    for (sample=0; sample<FILTER_ORDER+1; sample++){
        sum_temp += (data_buffer[Channel_Index_Filter][sample])*(coeff[time_index_filter]);   // sommatoria del prodotto di tutti i sample per il relativo coefficiente
        if (time_index_filter == 0) time_index_filter = FILTER_ORDER;
        else time_index_filter--;
    }

    result = ceil(sum_temp/filter_factor);
    return result;
}

/*********************************************************************************************/

void canInterrupt() iv IVT_ADDR_C1INTERRUPT ics ICS_AUTO {                        

    Can_clearInterrupt();
}

/***************************TIMER DI INVIO SU CAN****************************/

void TIMER5_INT() iv IVT_ADDR_T5INTERRUPT ics ICS_AUTO {

     int t_send = time_index;
     int Channel_Index_send = 0;

     for (Channel_Index_send = 0; Channel_Index_send < N_CHANNEL; Channel_Index_send++){
             data_out[Channel_Index_send] = FIR_filter(Channel_Index_send, t_send);            //CHIAMATA FUNZIONE FILTRO
          }

      switch (DAU_ID){

          case DAU_REAR :

          Can_resetWritePacket();
      Can_addIntToWritePacket(data_out[IN_1]);
      Can_addIntToWritePacket(data_out[LC_1]);
      Can_addIntToWritePacket(data_out[IN_2]);
      Can_addIntToWritePacket(data_out[LC_2]);
      Can_write(DAU_REAR_ID);                         //0x652

        Can_resetWritePacket();
      Can_addIntToWritePacket(data_out[IR1]);
      Can_addIntToWritePacket(data_out[IR2]);
      Can_addIntToWritePacket(data_out[IR3]);
      Can_addIntToWritePacket(data_out[IN_5_J3]);
      Can_write(DAU_REAR_IR_RL_ID);                   //0x656

        Can_resetWritePacket();
      Can_addIntToWritePacket(data_out[IR4]);
      Can_addIntToWritePacket(data_out[IR5]);
      Can_addIntToWritePacket(data_out[IR6]);
      Can_addIntToWritePacket(data_out[IN_6_J4]);
      Can_write(DAU_REAR_IR_RR_ID);                   //0x657

      if (TMR5_CONT > 100){
         TMR5_CONT = 0;
         Toggle_LEDRED();

         Can_resetWritePacket();
         Can_addIntToWritePacket(data_out[CURRENT_SENSE]);
         Can_addIntToWritePacket(data_out[TEMP_SENSE]);
         Can_write(DAU_REAR_DEBUG_ID);
         }

      break;

    case DAU_FR :

    Can_resetWritePacket();
      Can_addIntToWritePacket(data_out[IN_1]);
      Can_addIntToWritePacket(data_out[LC_1]);
      Can_addIntToWritePacket(data_out[IN_5_J3]);
      Can_addIntToWritePacket(data_out[IN_6_J4]);
      Can_write(DAU_FR_ID);                             //0x650



        Can_resetWritePacket();
      Can_addIntToWritePacket(data_out[IR1]);
      Can_addIntToWritePacket(data_out[IR2]);
      Can_addIntToWritePacket(data_out[IR3]);
      Can_addIntToWritePacket(data_out[IN_2]);
      Can_write(DAU_FR_IR_ID);                          //0x655

      if (TMR5_CONT > 100){
         TMR5_CONT = 0;
         Toggle_LEDRED();

         Can_resetWritePacket();
         Can_addIntToWritePacket(data_out[CURRENT_SENSE]);
         Can_addIntToWritePacket(data_out[TEMP_SENSE]);
         Can_write(DAU_FR_DEBUG_ID);
         }

      break;

    case DAU_FL :

      Can_resetWritePacket();
      Can_addIntToWritePacket(data_out[IN_1]);
      Can_addIntToWritePacket(data_out[LC_1]);
      Can_addIntToWritePacket(data_out[IN_5_J3]);
      Can_addIntToWritePacket(data_out[IN_6_J4]);    //SE SENSORE STEER MONTATO STORTO VANNO CORRETTI I VALORI
      Can_write(DAU_FL_ID);                    //0x651

      Can_resetWritePacket();
      Can_addIntToWritePacket(data_out[IR1]);
      Can_addIntToWritePacket(data_out[IR2]);
      Can_addIntToWritePacket(data_out[IR3]);
      Can_addIntToWritePacket(data_out[IN_2]);   //SAREBBE LA TEMPERATURA FRENO. E OK QUI?
      Can_write(DAU_FL_IR_ID);                 //0x654

      if (TMR5_CONT > 100){
         TMR5_CONT = 0;
         Toggle_LEDRED();
         
         Can_resetWritePacket();
         Can_addIntToWritePacket(data_out[CURRENT_SENSE]);
         Can_addIntToWritePacket(data_out[TEMP_SENSE]);
         Can_write(DAU_FL_DEBUG_ID);           //0x313
         }
      break;

       }



  TMR5_CONT++;

  ADC_CONT = 0;                                // RESETTA IL CONTEGGIO DI SAMPLE ADC
  IFS1bits.T5IF = 0;

}

void ADC_INT() iv IVT_ADDR_ADCINTERRUPT ics ICS_AUTO {  //non vorrei che le operazioni svolte qui dentro fosero troppe per una interrupt, forse andrebbero delegate a un'altra funzione
     int Channel_Index = 0;
     //buffer_adc = &ADCBUF0;

        for (Channel_Index = 0; Channel_Index < N_CHANNEL; Channel_Index ++){     //SALVA TUTTE LE LETTURE DEI CANALI AL NUOVO TIME_INDEX
              buffer_adc = (&ADCBUF0 + Channel_Index);
              data_buffer[Channel_Index][time_index] = *buffer_adc;
          }

      if (time_index == FILTER_ORDER) time_index = 0;
      else time_index++;

    ADC_CONT++;
    
      IFS0bits.ADIF     = 0b0;        //clear interrupt flag
}

void TIMER4_INT() iv IVT_ADDR_T4INTERRUPT ics ICS_AUTO {

  ADCON1bits.ADON = 1;
  IFS1bits.T4IF = 0;

}

/*inizializza la matrice che contiene i dati delle acquisizioni*/
void Clear_buffer(){
        int Ch_Index, Buffer_Index = 0;
        for (Ch_Index = 0; Ch_Index < N_CHANNEL; Ch_Index++){
                for(Buffer_Index = 0; Buffer_Index < FILTER_ORDER+1; Buffer_Index++){
                        data_buffer[Ch_Index][Buffer_Index] = 0;
                }
        data_out[Ch_Index]=0;                               //INIZIALIZZA ANCHE DATA OUT
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


        while(1){          
/*
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
               */ 
        }

}