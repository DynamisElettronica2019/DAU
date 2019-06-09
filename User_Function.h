#ifndef User_Function_H
#define User_Function_H

#include <stdio.h>
#include <stdint.h>

#define LEDRED   LATGbits.LATG12
#define LEDBLUE  LATGbits.LATG13
#define LEDGREEN LATGbits.LATG14

#define SELBIT0 PORTFbits.RF4
#define SELBIT1 PORTFbits.RF5

/*define per verifica errori*/
#define DAU_ID_OK (uint8_t) 0
#define DAU_ID_ERROR (uint8_t)1
#define ADC_OK (uint8_t)0
#define ADC_ERROR (uint8_t)1

/*define per il buffer di stato*/
#define DAU_STATE_BUFFER_LENGTH (uint8_t)5
#define DAU_LOCATION (uint8_t)0                          
#define ADC_STATE (uint8_t)1


/*ID per la localizzazione delle schede*/
#define DAU_FL 0b00
#define DAU_FR 0b01
#define DAU_REAR 0b10

/*define per la conversione dei dati debug*/
#define INA_GAIN		100
#define SHUNT_RESISTOR	0.03 									/*ohm			*/
#define TEMP_OFFSET		500										/*mV			*/
#define TEMP_RATE		10										/*mV			*/
#define LSB_1000		1.2210012210012210						/*(5V / (2^12 - 1) )*1000*/



/*define dei canali associati ai sensori*/               //MODIFICATE LE DEFINE, DA RICONTROLLARE
#define LC_1                    (uint8_t) 0
#define LC_2                    (uint8_t) 1
#define IN_1                    (uint8_t) 2
#define IN_2                    (uint8_t) 3
#define IN_5_J3                 (uint8_t) 4
#define IN_6_J4                 (uint8_t) 5
#define IR1                     (uint8_t) 8
#define IR2                     (uint8_t) 9
#define IR3                     (uint8_t) 10
#define IR4                     (uint8_t) 11
#define IR5                     (uint8_t) 12
#define IR6                     (uint8_t) 13
#define CURRENT_SENSE           (uint8_t) 14
#define TEMP_SENSE              (uint8_t) 15


/*define dei parametri utilizzati per calcolari i coefficienti del filtro*/
//Fs = 5 KHz
//Fc = 100 Hz   frequenza di taglio
#define FILTER_ORDER                       50
#define N_CHANNEL                          16

/**************************************************************************/

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




#endif