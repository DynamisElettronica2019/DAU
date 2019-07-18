
_Can_init:

;can.c,28 :: 		void Can_init() {
;can.c,29 :: 		unsigned int Can_Init_flags = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
;can.c,36 :: 		CAN1Initialize(2,2,6,5,8,Can_Init_flags);          // SJW,BRP,PHSEG1,PHSEG2,PROPSEG
	MOV	#5, W13
	MOV	#6, W12
	MOV	#2, W11
	MOV	#2, W10
	MOV	#253, W0
	PUSH	W0
	MOV	#8, W0
	PUSH	W0
	CALL	_CAN1Initialize
	SUB	#4, W15
;can.c,37 :: 		CAN1SetOperationMode(_CAN_MODE_CONFIG,0xFF);
	MOV	#255, W11
	MOV	#4, W10
	CALL	_CAN1SetOperationMode
;can.c,39 :: 		CAN1SetMask(_CAN_MASK_B1, AUX_MASK, _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_STD_MSG);
	MOV	#255, W13
	MOV	#4088, W11
	MOV	#0, W12
	CLR	W10
	CALL	_CAN1SetMask
;can.c,40 :: 		CAN1SetFilter(_CAN_FILTER_B1_F1, AUX_FILTER, _CAN_CONFIG_STD_MSG);
	MOV	#255, W13
	MOV	#2032, W11
	MOV	#0, W12
	CLR	W10
	CALL	_CAN1SetFilter
;can.c,41 :: 		CAN1SetFilter(_CAN_FILTER_B1_F2, 0, _CAN_CONFIG_STD_MSG);
	MOV	#255, W13
	CLR	W11
	CLR	W12
	MOV	#1, W10
	CALL	_CAN1SetFilter
;can.c,43 :: 		CAN1SetMask(_CAN_MASK_B2, 0, _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_STD_MSG);
	MOV	#255, W13
	CLR	W11
	CLR	W12
	MOV	#1, W10
	CALL	_CAN1SetMask
;can.c,44 :: 		CAN1SetFilter(_CAN_FILTER_B2_F1, 0, _CAN_CONFIG_STD_MSG);
	MOV	#255, W13
	CLR	W11
	CLR	W12
	MOV	#2, W10
	CALL	_CAN1SetFilter
;can.c,46 :: 		CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);
	MOV	#255, W11
	CLR	W10
	CALL	_CAN1SetOperationMode
;can.c,48 :: 		Can_initInterrupt();
	CALL	_Can_initInterrupt
;can.c,49 :: 		Can_setWritePriority(CAN_PRIORITY_MEDIUM);
	MOV	#253, W10
	CALL	_Can_setWritePriority
;can.c,50 :: 		}
L_end_Can_init:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Can_init

_Can_read:
	LNK	#2

;can.c,52 :: 		void Can_read(unsigned long int *id, char dataBuffer[], unsigned int *dataLength, unsigned int *inFlags) {
	PUSH	W13
	MOV	W13, [W14+0]
;can.c,53 :: 		if (Can_B0hasBeenReceived()) {
	CALL	_Can_B0hasBeenReceived
	CP0.B	W0
	BRA NZ	L__Can_read17
	GOTO	L_Can_read0
L__Can_read17:
;can.c,54 :: 		Can_clearB0Flag();
	CALL	_Can_clearB0Flag
;can.c,55 :: 		Can1Read(id, dataBuffer, dataLength, &inFlags);
	ADD	W14, #0, W0
	MOV	W0, W13
	CALL	_CAN1Read
;can.c,56 :: 		}
	GOTO	L_Can_read1
L_Can_read0:
;can.c,57 :: 		else if (Can_B1hasBeenReceived()) {
	CALL	_Can_B1hasBeenReceived
	CP0.B	W0
	BRA NZ	L__Can_read18
	GOTO	L_Can_read2
L__Can_read18:
;can.c,58 :: 		Can_clearB1Flag();
	CALL	_Can_clearB1Flag
;can.c,59 :: 		Can1Read(id, dataBuffer, dataLength, &inFlags);
	ADD	W14, #0, W0
	MOV	W0, W13
	CALL	_CAN1Read
;can.c,60 :: 		}
L_Can_read2:
L_Can_read1:
;can.c,61 :: 		}
L_end_Can_read:
	POP	W13
	ULNK
	RETURN
; end of _Can_read

_Can_writeByte:

;can.c,63 :: 		void Can_writeByte(unsigned long int id, unsigned char dataOut) {
;can.c,64 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;can.c,65 :: 		Can_addByteToWritePacket(dataOut);
	PUSH.D	W10
	MOV.B	W12, W10
	CALL	_Can_addByteToWritePacket
	POP.D	W10
;can.c,66 :: 		Can_write(id);
	CALL	_Can_write
;can.c,67 :: 		}
L_end_Can_writeByte:
	RETURN
; end of _Can_writeByte

_Can_writeInt:

;can.c,69 :: 		void Can_writeInt(unsigned long int id, int dataOut) {
;can.c,70 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;can.c,71 :: 		Can_addIntToWritePacket(dataOut);
	PUSH.D	W10
	MOV	W12, W10
	CALL	_Can_addIntToWritePacket
	POP.D	W10
;can.c,72 :: 		Can_write(id);
	CALL	_Can_write
;can.c,73 :: 		}
L_end_Can_writeInt:
	RETURN
; end of _Can_writeInt

_Can_addIntToWritePacket:

;can.c,75 :: 		void Can_addIntToWritePacket(int dataOut) {                                      /*questa funzione aggiunge il dato dataOut sul buffer out del can*/
;can.c,76 :: 		Can_addByteToWritePacket((unsigned char) (dataOut >> 8));                    /*in un primo momento faccio le conversioni giuste per evitare errori di tipo*/
	PUSH	W10
	ASR	W10, #8, W0
	PUSH	W10
	MOV.B	W0, W10
	CALL	_Can_addByteToWritePacket
	POP	W10
;can.c,77 :: 		Can_addByteToWritePacket((unsigned char) (dataOut & 0xFF));                  /**/
	MOV	#255, W0
	AND	W10, W0, W0
	MOV.B	W0, W10
	CALL	_Can_addByteToWritePacket
;can.c,78 :: 		}                                                                                 /**/
L_end_Can_addIntToWritePacket:
	POP	W10
	RETURN
; end of _Can_addIntToWritePacket

_Can_addByteToWritePacket:

;can.c,80 :: 		void Can_addByteToWritePacket(unsigned char dataOut) {                            /*<----- appoggiandosi a questa funzione che fa la scrittura effettiva*/
;can.c,81 :: 		can_dataOutBuffer[can_dataOutLength] = dataOut;                               /**/
	MOV	#lo_addr(_can_dataOutBuffer), W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], W0
	MOV.B	W10, [W0]
;can.c,82 :: 		can_dataOutLength += 1;
	MOV	#1, W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], [W0]
;can.c,83 :: 		}
L_end_Can_addByteToWritePacket:
	RETURN
; end of _Can_addByteToWritePacket

_Can_write:
	LNK	#2

;can.c,85 :: 		void Can_write(unsigned long int id) {
;can.c,87 :: 		do {
	PUSH	W12
	PUSH	W13
L_Can_write3:
;can.c,88 :: 		sent = CAN1Write(id, can_dataOutBuffer, can_dataOutLength, Can_getWriteFlags());        /*dove cazzo + questa CAN1write??*/
	CALL	_Can_getWriteFlags
	PUSH.D	W10
	MOV	_can_dataOutLength, W13
	MOV	#lo_addr(_can_dataOutBuffer), W12
	PUSH	W0
	CALL	_CAN1Write
	SUB	#2, W15
	POP.D	W10
;can.c,89 :: 		i += 1;
	MOV	#1, W2
	ADD	W14, #0, W1
	ADD	W2, [W1], [W1]
;can.c,90 :: 		} while ((sent == 0) && (i < CAN_RETRY_LIMIT));
	CP	W0, #0
	BRA Z	L__Can_write24
	GOTO	L__Can_write14
L__Can_write24:
	MOV	#50, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GTU	L__Can_write25
	GOTO	L__Can_write13
L__Can_write25:
	GOTO	L_Can_write3
L__Can_write14:
L__Can_write13:
;can.c,91 :: 		if (i == CAN_RETRY_LIMIT) {
	MOV	#50, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA Z	L__Can_write26
	GOTO	L_Can_write8
L__Can_write26:
;can.c,92 :: 		can_err++;
	MOV	#1, W1
	MOV	#lo_addr(_can_err), W0
	ADD	W1, [W0], [W0]
;can.c,93 :: 		}
L_Can_write8:
;can.c,94 :: 		}
L_end_Can_write:
	POP	W13
	POP	W12
	ULNK
	RETURN
; end of _Can_write

_Can_setWritePriority:

;can.c,96 :: 		void Can_setWritePriority(unsigned int txPriority) {
;can.c,97 :: 		can_txPriority = txPriority;
	MOV	W10, _can_txPriority
;can.c,98 :: 		}
L_end_Can_setWritePriority:
	RETURN
; end of _Can_setWritePriority

_Can_resetWritePacket:

;can.c,100 :: 		void Can_resetWritePacket(void) {
;can.c,101 :: 		for (can_dataOutLength = 0; can_dataOutLength < CAN_PACKET_SIZE; can_dataOutLength += 1) {
	CLR	W0
	MOV	W0, _can_dataOutLength
L_Can_resetWritePacket9:
	MOV	_can_dataOutLength, W0
	CP	W0, #8
	BRA LTU	L__Can_resetWritePacket29
	GOTO	L_Can_resetWritePacket10
L__Can_resetWritePacket29:
;can.c,102 :: 		can_dataOutBuffer[can_dataOutLength] = 0;
	MOV	#lo_addr(_can_dataOutBuffer), W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;can.c,101 :: 		for (can_dataOutLength = 0; can_dataOutLength < CAN_PACKET_SIZE; can_dataOutLength += 1) {
	MOV	#1, W1
	MOV	#lo_addr(_can_dataOutLength), W0
	ADD	W1, [W0], [W0]
;can.c,103 :: 		}
	GOTO	L_Can_resetWritePacket9
L_Can_resetWritePacket10:
;can.c,104 :: 		can_dataOutLength = 0;
	CLR	W0
	MOV	W0, _can_dataOutLength
;can.c,105 :: 		}
L_end_Can_resetWritePacket:
	RETURN
; end of _Can_resetWritePacket

_Can_getWriteFlags:

;can.c,107 :: 		unsigned int Can_getWriteFlags(void) {
;can.c,108 :: 		return CAN_DEFAULT_FLAGS & can_txPriority;
	MOV	#255, W1
	MOV	#lo_addr(_can_txPriority), W0
	AND	W1, [W0], W0
;can.c,109 :: 		}
L_end_Can_getWriteFlags:
	RETURN
; end of _Can_getWriteFlags

_Can_B0hasBeenReceived:

;can.c,111 :: 		unsigned char Can_B0hasBeenReceived(void) {
;can.c,112 :: 		return CAN_INTERRUPT_ONB0_OCCURRED == 1;
	CLR.B	W0
	BTSC	C1INTFbits, #0
	INC.B	W0
	CP.B	W0, #1
	CLR.B	W0
	BRA NZ	L__Can_B0hasBeenReceived32
	INC.B	W0
L__Can_B0hasBeenReceived32:
;can.c,113 :: 		}
L_end_Can_B0hasBeenReceived:
	RETURN
; end of _Can_B0hasBeenReceived

_Can_B1hasBeenReceived:

;can.c,115 :: 		unsigned char Can_B1hasBeenReceived(void) {
;can.c,116 :: 		return CAN_INTERRUPT_ONB1_OCCURRED == 1;
	CLR.B	W0
	BTSC	C1INTFbits, #1
	INC.B	W0
	CP.B	W0, #1
	CLR.B	W0
	BRA NZ	L__Can_B1hasBeenReceived34
	INC.B	W0
L__Can_B1hasBeenReceived34:
;can.c,117 :: 		}
L_end_Can_B1hasBeenReceived:
	RETURN
; end of _Can_B1hasBeenReceived

_Can_clearB0Flag:

;can.c,119 :: 		void Can_clearB0Flag(void) {
;can.c,120 :: 		CAN_INTERRUPT_ONB0_OCCURRED = 0;
	BCLR	C1INTFbits, #0
;can.c,121 :: 		}
L_end_Can_clearB0Flag:
	RETURN
; end of _Can_clearB0Flag

_Can_clearB1Flag:

;can.c,123 :: 		void Can_clearB1Flag(void) {
;can.c,124 :: 		CAN_INTERRUPT_ONB1_OCCURRED = 0;
	BCLR	C1INTFbits, #1
;can.c,125 :: 		}
L_end_Can_clearB1Flag:
	RETURN
; end of _Can_clearB1Flag

_Can_clearInterrupt:

;can.c,127 :: 		void Can_clearInterrupt(void) {
;can.c,128 :: 		CAN_INTERRUPT_OCCURRED = 0;
	BCLR	IFS1bits, #11
;can.c,129 :: 		}
L_end_Can_clearInterrupt:
	RETURN
; end of _Can_clearInterrupt

_Can_initInterrupt:

;can.c,131 :: 		void Can_initInterrupt(void) {
;can.c,133 :: 		INTERRUPT_PROTECT(IEC1BITS.C1IE = 1);
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W0
	MOV.B	W0, W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	ZE	W1, W0
	LSR	W0, #5, W1
; save_sr start address is: 4 (W2)
	ZE	W1, W2
; DISI_save start address is: 6 (W3)
	MOV	DISICNT, W3
	DISI	#1023
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(SRbits), W0
	MOV.B	W1, [W0]
	NOP
	NOP
	MOV	W3, DISICNT
; DISI_save end address is: 6 (W3)
	BSET	IEC1bits, #11
; DISI_save start address is: 8 (W4)
	MOV	DISICNT, W4
	DISI	#1023
	MOV.B	W2, W3
; save_sr end address is: 4 (W2)
	MOV.B	#5, W0
	ZE	W3, W1
	SE	W0, W2
	SL	W1, W2, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV.B	#224, W0
	AND.B	W3, W0, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV	#lo_addr(SRbits), W0
	MOV.B	W3, [W0]
	NOP
	NOP
	MOV	W4, DISICNT
; DISI_save end address is: 8 (W4)
;can.c,134 :: 		INTERRUPT_PROTECT(C1INTEBITS.RXB0IE = 1); //An interrupt is generated everytime that a message passes through the mask in buffer 0
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W0
	MOV.B	W0, W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	ZE	W1, W0
	LSR	W0, #5, W1
; save_sr start address is: 4 (W2)
	ZE	W1, W2
; DISI_save start address is: 6 (W3)
	MOV	DISICNT, W3
	DISI	#1023
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(SRbits), W0
	MOV.B	W1, [W0]
	NOP
	NOP
	MOV	W3, DISICNT
; DISI_save end address is: 6 (W3)
	BSET.B	C1INTEbits, #0
; DISI_save start address is: 8 (W4)
	MOV	DISICNT, W4
	DISI	#1023
	MOV.B	W2, W3
; save_sr end address is: 4 (W2)
	MOV.B	#5, W0
	ZE	W3, W1
	SE	W0, W2
	SL	W1, W2, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV.B	#224, W0
	AND.B	W3, W0, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV	#lo_addr(SRbits), W0
	MOV.B	W3, [W0]
	NOP
	NOP
	MOV	W4, DISICNT
; DISI_save end address is: 8 (W4)
;can.c,135 :: 		INTERRUPT_PROTECT(C1INTEBITS.RXB1IE = 1); //Suddividere gli ID da ricevere nei due buffer
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W0
	MOV.B	W0, W1
	MOV.B	#224, W0
	AND.B	W1, W0, W1
	ZE	W1, W0
	LSR	W0, #5, W1
; save_sr start address is: 4 (W2)
	ZE	W1, W2
; DISI_save start address is: 6 (W3)
	MOV	DISICNT, W3
	DISI	#1023
	MOV	#lo_addr(SRbits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(SRbits), W0
	MOV.B	W1, [W0]
	NOP
	NOP
	MOV	W3, DISICNT
; DISI_save end address is: 6 (W3)
	BSET.B	C1INTEbits, #1
; DISI_save start address is: 8 (W4)
	MOV	DISICNT, W4
	DISI	#1023
	MOV.B	W2, W3
; save_sr end address is: 4 (W2)
	MOV.B	#5, W0
	ZE	W3, W1
	SE	W0, W2
	SL	W1, W2, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV.B	#224, W0
	AND.B	W3, W0, W3
	MOV	#lo_addr(SRbits), W0
	XOR.B	W3, [W0], W3
	MOV	#lo_addr(SRbits), W0
	MOV.B	W3, [W0]
	NOP
	NOP
	MOV	W4, DISICNT
; DISI_save end address is: 8 (W4)
;can.c,137 :: 		}
L_end_Can_initInterrupt:
	RETURN
; end of _Can_initInterrupt
