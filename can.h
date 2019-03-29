//
// Created by Aaron Russo on 03/07/16.
//

#ifndef DP8_DISPLAY_CONTROLLER_CAN_H
#define DP8_DISPLAY_CONTROLLER_CAN_H

#define CAN_RETRY_LIMIT 50
#define CAN_DEFAULT_FLAGS _CAN_TX_STD_FRAME & _CAN_TX_NO_RTR_FRAME

#define onCanInterrupt void CAN_Interrupt() iv IVT_ADDR_C1INTERRUPT

#define CAN_INTERRUPT_OCCURRED IFS1BITS.C1IF
#define CAN_INTERRUPT_ONB1_OCCURRED C1INTFBITS.RXB1IF
#define CAN_INTERRUPT_ONB0_OCCURRED C1INTFBITS.RXB0IF

#define CAN_PRIORITY_HIGH _CAN_TX_PRIORITY_0
#define CAN_PRIORITY_MEDIUM _CAN_TX_PRIORITY_1
#define CAN_PRIORITY_LOW _CAN_TX_PRIORITY_2
#define CAN_PRIORITY_VERYLOW _CAN_TX_PRIORITY_3


//>From silicon errdata: avoiding interrupts on certain can settings and values assignments
#define DISABLE_IT asm DISI #0X3FF

#define SET_CPU_IPL(ipl){ \
int DISI_save; \
\
DISI_save = DISICNT; \
DISABLE_IT;\
SRbits.IPL = ipl; \
asm {nop}; \
asm {nop}; \
DISICNT = DISI_save; } (void) 0;

#define SET_AND_SAVE_CPU_IPL(save_to, ipl){ \
save_to = SRbits.IPL; \
SET_CPU_IPL(ipl); } (void) 0;
#define RESTORE_CPU_IPL(saved_to) SET_CPU_IPL(saved_to)

#define INTERRUPT_PROTECT(x) { \
int save_sr; \
SET_AND_SAVE_CPU_IPL(save_sr, 7);\
x; \
RESTORE_CPU_IPL(save_sr); } (void) 0;
//>

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

#endif //DP8_DISPLAY_CONTROLLER_CAN_H
