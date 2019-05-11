
_canInterrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;main.c,46 :: 		void canInterrupt() iv IVT_ADDR_C1INTERRUPT ics ICS_AUTO {
;main.c,48 :: 		Can_clearInterrupt();
	CALL	_Can_clearInterrupt
;main.c,49 :: 		}
L_end_canInterrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _canInterrupt

_TIMER5_INT:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;main.c,51 :: 		void TIMER5_INT() iv IVT_ADDR_T5INTERRUPT ics ICS_AUTO { //fare lo switch dau
;main.c,53 :: 		switch (DAU_ID){
	PUSH	W10
	PUSH	W11
	GOTO	L_TIMER5_INT0
;main.c,55 :: 		case DAU_REAR :
L_TIMER5_INT2:
;main.c,57 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,58 :: 		Can_addIntToWritePacket(data_buffer[LC_1]);
	MOV	_data_buffer+2, W10
	CALL	_Can_addIntToWritePacket
;main.c,59 :: 		Can_addIntToWritePacket(data_buffer[LC_2]);
	MOV	_data_buffer+4, W10
	CALL	_Can_addIntToWritePacket
;main.c,60 :: 		Can_addIntToWritePacket(data_buffer[IN_1]);
	MOV	_data_buffer+6, W10
	CALL	_Can_addIntToWritePacket
;main.c,61 :: 		Can_addIntToWritePacket(data_buffer[IN_2]);
	MOV	_data_buffer+8, W10
	CALL	_Can_addIntToWritePacket
;main.c,62 :: 		Can_write(DAU_REAR_ID);
	MOV	#1618, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,64 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,65 :: 		Can_addIntToWritePacket(data_buffer[IR1]);
	MOV	_data_buffer+14, W10
	CALL	_Can_addIntToWritePacket
;main.c,66 :: 		Can_addIntToWritePacket(data_buffer[IR2]);
	MOV	_data_buffer+16, W10
	CALL	_Can_addIntToWritePacket
;main.c,67 :: 		Can_addIntToWritePacket(data_buffer[IR3]);
	MOV	_data_buffer+18, W10
	CALL	_Can_addIntToWritePacket
;main.c,68 :: 		Can_write(IR_RL_ID);
	MOV	#1622, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,70 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,71 :: 		Can_addIntToWritePacket(data_buffer[IR4]);
	MOV	_data_buffer+20, W10
	CALL	_Can_addIntToWritePacket
;main.c,72 :: 		Can_addIntToWritePacket(data_buffer[IR5]);
	MOV	_data_buffer+22, W10
	CALL	_Can_addIntToWritePacket
;main.c,73 :: 		Can_addIntToWritePacket(data_buffer[IR6]);
	MOV	_data_buffer+24, W10
	CALL	_Can_addIntToWritePacket
;main.c,74 :: 		Can_write(IR_RR_ID);
	MOV	#1623, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,76 :: 		break;
	GOTO	L_TIMER5_INT1
;main.c,78 :: 		case DAU_FR :
L_TIMER5_INT3:
;main.c,80 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,81 :: 		Can_addIntToWritePacket(data_buffer[LC_1]);
	MOV	_data_buffer+2, W10
	CALL	_Can_addIntToWritePacket
;main.c,82 :: 		Can_addIntToWritePacket(data_buffer[LC_2]);
	MOV	_data_buffer+4, W10
	CALL	_Can_addIntToWritePacket
;main.c,83 :: 		Can_addIntToWritePacket(data_buffer[IN_1]);
	MOV	_data_buffer+6, W10
	CALL	_Can_addIntToWritePacket
;main.c,84 :: 		Can_write(DAU_FR_ID);
	MOV	#1616, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,86 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,87 :: 		Can_addIntToWritePacket(data_buffer[IN_2]);
	MOV	_data_buffer+8, W10
	CALL	_Can_addIntToWritePacket
;main.c,88 :: 		Can_addIntToWritePacket(data_buffer[IN_5_J3]);
	MOV	_data_buffer+10, W10
	CALL	_Can_addIntToWritePacket
;main.c,89 :: 		Can_write(DAU_FR_APPS_ID);
	MOV	#1619, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,91 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,92 :: 		Can_addIntToWritePacket(data_buffer[IR1]);
	MOV	_data_buffer+14, W10
	CALL	_Can_addIntToWritePacket
;main.c,93 :: 		Can_addIntToWritePacket(data_buffer[IR2]);
	MOV	_data_buffer+16, W10
	CALL	_Can_addIntToWritePacket
;main.c,94 :: 		Can_addIntToWritePacket(data_buffer[IR3]);
	MOV	_data_buffer+18, W10
	CALL	_Can_addIntToWritePacket
;main.c,95 :: 		Can_write(IR_FR_ID);
	MOV	#1621, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,97 :: 		break;
	GOTO	L_TIMER5_INT1
;main.c,99 :: 		case DAU_FL :
L_TIMER5_INT4:
;main.c,101 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,102 :: 		Can_addIntToWritePacket(data_buffer[LC_1]);
	MOV	_data_buffer+2, W10
	CALL	_Can_addIntToWritePacket
;main.c,103 :: 		Can_addIntToWritePacket(data_buffer[LC_2]);
	MOV	_data_buffer+4, W10
	CALL	_Can_addIntToWritePacket
;main.c,104 :: 		Can_addIntToWritePacket(data_buffer[IN_1]);
	MOV	_data_buffer+6, W10
	CALL	_Can_addIntToWritePacket
;main.c,105 :: 		Can_addIntToWritePacket(data_buffer[IN_2]);    //i valori dello sterzo devono essere corretti prima di essere inviati, da implementare
	MOV	_data_buffer+8, W10
	CALL	_Can_addIntToWritePacket
;main.c,106 :: 		Can_write(DAU_FL_ID);
	MOV	#1617, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,108 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,109 :: 		Can_addIntToWritePacket(data_buffer[IR1]);
	MOV	_data_buffer+14, W10
	CALL	_Can_addIntToWritePacket
;main.c,110 :: 		Can_addIntToWritePacket(data_buffer[IR2]);
	MOV	_data_buffer+16, W10
	CALL	_Can_addIntToWritePacket
;main.c,111 :: 		Can_addIntToWritePacket(data_buffer[IR3]);
	MOV	_data_buffer+18, W10
	CALL	_Can_addIntToWritePacket
;main.c,112 :: 		Can_write(IR_FL_ID);
	MOV	#1620, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,114 :: 		break;
	GOTO	L_TIMER5_INT1
;main.c,116 :: 		}
L_TIMER5_INT0:
	MOV	#lo_addr(_DAU_ID), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__TIMER5_INT14
	GOTO	L_TIMER5_INT2
L__TIMER5_INT14:
	MOV	#lo_addr(_DAU_ID), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__TIMER5_INT15
	GOTO	L_TIMER5_INT3
L__TIMER5_INT15:
	MOV	#lo_addr(_DAU_ID), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__TIMER5_INT16
	GOTO	L_TIMER5_INT4
L__TIMER5_INT16:
L_TIMER5_INT1:
;main.c,119 :: 		if (TMR5_CONT > 1000){
	MOV	main_TMR5_CONT, W1
	MOV	#1000, W0
	CP	W1, W0
	BRA GTU	L__TIMER5_INT17
	GOTO	L_TIMER5_INT5
L__TIMER5_INT17:
;main.c,120 :: 		TMR5_CONT = 0;
	CLR	W0
	MOV	W0, main_TMR5_CONT
;main.c,121 :: 		}
L_TIMER5_INT5:
;main.c,122 :: 		TMR5_CONT++;
	MOV	#1, W1
	MOV	#lo_addr(main_TMR5_CONT), W0
	ADD	W1, [W0], [W0]
;main.c,124 :: 		IFS1bits.T5IF = 0;
	BCLR	IFS1bits, #6
;main.c,126 :: 		}
L_end_TIMER5_INT:
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _TIMER5_INT

_ADC_INT:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;main.c,128 :: 		void ADC_INT() iv IVT_ADDR_ADCINTERRUPT ics ICS_AUTO {  //non vorrei che le operazioni svolte qui dentro fosero troppe per una interrupt, forse andrebbero delegate a un'altra funzione
;main.c,130 :: 		for (Channel_Index = 0; Channel_Index < N_CHANNEL; Channel_Index ++){
	CLR	W0
	MOV	W0, main_Channel_Index
L_ADC_INT6:
	MOV	main_Channel_Index, W0
	CP	W0, #16
	BRA LTU	L__ADC_INT19
	GOTO	L_ADC_INT7
L__ADC_INT19:
;main.c,131 :: 		buffer_adc = &ADCBUF0;
	MOV	#lo_addr(ADCBUF0), W0
	MOV	W0, _buffer_adc
;main.c,133 :: 		input[Channel_Index][inext] = *buffer_adc + Channel_Index;          // Fetch sample
	MOV	main_Channel_Index, W0
	SL	W0, #6, W1
	MOV	#lo_addr(_input), W0
	ADD	W0, W1, W1
	MOV	main_inext, W0
	SL	W0, #1, W0
	ADD	W1, W0, W2
	MOV	_buffer_adc, W0
	MOV	[W0], W1
	MOV	#lo_addr(main_Channel_Index), W0
	ADD	W1, [W0], [W2]
;main.c,138 :: 		input[Channel_Index],                   // Input buffer
	MOV	main_Channel_Index, W0
	SL	W0, #6, W1
	MOV	#lo_addr(_input), W0
	ADD	W0, W1, W0
;main.c,139 :: 		inext);                                              // sample corrente
	PUSH	main_inext
;main.c,138 :: 		input[Channel_Index],                   // Input buffer
	PUSH	W0
;main.c,137 :: 		BUFFER_SIZE,                                       // lunghezza del buffer
	MOV	#32, W0
	PUSH	W0
;main.c,136 :: 		COEFF_B,                                            // coefficenti del filtro
	MOV	#lo_addr(_COEFF_B), W0
	PUSH	W0
;main.c,135 :: 		CurrentValue = FIR_Radix(FILTER_ORDER+1,                                      // ordine del filtro
	MOV	#11, W0
	PUSH	W0
;main.c,139 :: 		inext);                                              // sample corrente
	CALL	_FIR_Radix
	SUB	#10, W15
	MOV	W0, main_CurrentValue
;main.c,141 :: 		data_buffer[Channel_Index] = CurrentValue;                        //salvo i dati filtrati nel buffer
	MOV	main_Channel_Index, W1
	SL	W1, #1, W2
	MOV	#lo_addr(_data_buffer), W1
	ADD	W1, W2, W1
	MOV	W0, [W1]
;main.c,130 :: 		for (Channel_Index = 0; Channel_Index < N_CHANNEL; Channel_Index ++){
	MOV	#1, W1
	MOV	#lo_addr(main_Channel_Index), W0
	ADD	W1, [W0], [W0]
;main.c,142 :: 		}
	GOTO	L_ADC_INT6
L_ADC_INT7:
;main.c,144 :: 		inext = (inext+1) & (BUFFER_SIZE-1);                               // inext = (inext + 1) mod BUFFFER_SIZE;
	MOV	main_inext, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(main_inext), W0
	AND	W1, #31, [W0]
;main.c,145 :: 		IFS0bits.ADIF     = 0b0;                                                //clear interrupt flag
	BCLR	IFS0bits, #11
;main.c,148 :: 		if (ADC_CONT > 1000){
	MOV	main_ADC_CONT, W1
	MOV	#1000, W0
	CP	W1, W0
	BRA GTU	L__ADC_INT20
	GOTO	L_ADC_INT9
L__ADC_INT20:
;main.c,149 :: 		ADC_CONT = 0;
	CLR	W0
	MOV	W0, main_ADC_CONT
;main.c,150 :: 		}
L_ADC_INT9:
;main.c,151 :: 		ADC_CONT++;
	MOV	#1, W1
	MOV	#lo_addr(main_ADC_CONT), W0
	ADD	W1, [W0], [W0]
;main.c,153 :: 		}
L_end_ADC_INT:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _ADC_INT

_TIMER4_INT:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;main.c,155 :: 		void TIMER4_INT() iv IVT_ADDR_T4INTERRUPT ics ICS_AUTO {
;main.c,157 :: 		ADCON1bits.ADON = 1;
	BSET	ADCON1bits, #15
;main.c,158 :: 		IFS1bits.T4IF = 0;
	BCLR	IFS1bits, #5
;main.c,160 :: 		}
L_end_TIMER4_INT:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _TIMER4_INT

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;main.c,163 :: 		void main() {
;main.c,166 :: 		set_LEDGREEN();
	PUSH	W10
	CALL	_set_LEDGREEN
;main.c,167 :: 		Clear_buffer(Input);
	MOV	#lo_addr(_input), W10
	CALL	_Clear_buffer
;main.c,168 :: 		dau_set_ID(&DAU_ID);
	MOV	#lo_addr(_DAU_ID), W10
	CALL	_dau_set_ID
;main.c,169 :: 		adc_init();
	CALL	_adc_init
;main.c,170 :: 		tmr4_init();
	CALL	_tmr4_init
;main.c,171 :: 		can_bus_init();
	CALL	_can_bus_init
;main.c,172 :: 		tmr5_init();
	CALL	_tmr5_init
;main.c,173 :: 		io_init();
	CALL	_io_init
;main.c,176 :: 		while(1){
L_main10:
;main.c,193 :: 		}
	GOTO	L_main10
;main.c,195 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
