
_FIR_filter:

;main.c,56 :: 		int FIR_filter(int Channel_Index_Filter, int time_index_filter){
;main.c,57 :: 		int sample = 0;                                 // Posizione nell array di data_buffer, incrementa fino a scorrere tutto l'array. La scelta del giusto coefficiente e' gestita da coeff_index
;main.c,58 :: 		int result = 0;
;main.c,59 :: 		unsigned long int sum_temp = 0;
; sum_temp start address is: 14 (W7)
	CLR	W7
	CLR	W8
;main.c,60 :: 		for (sample=0; sample<FILTER_ORDER+1; sample++){
; sample start address is: 12 (W6)
	CLR	W6
; sum_temp end address is: 14 (W7)
; sample end address is: 12 (W6)
L_FIR_filter0:
; sample start address is: 12 (W6)
; sum_temp start address is: 14 (W7)
	MOV	#51, W0
	CP	W6, W0
	BRA LT	L__FIR_filter33
	GOTO	L_FIR_filter1
L__FIR_filter33:
;main.c,61 :: 		sum_temp += (data_buffer[Channel_Index_Filter][sample])*(coeff[time_index_filter]);   // sommatoria del prodotto di tutti i sample per il relativo coefficiente
	MOV	#204, W0
	MUL.UU	W0, W10, W2
	MOV	#lo_addr(_data_buffer), W0
	ADD	W0, W2, W1
	SL	W6, #2, W0
	ADD	W1, W0, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	SL	W11, #2, W1
	MOV	#lo_addr(_coeff), W0
	ADD	W0, W1, W2
	MOV.D	[W2], W0
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Multiply_32x32
	ADD	W7, W0, W7
	ADDC	W8, W1, W8
;main.c,62 :: 		if (time_index_filter == 0) time_index_filter = FILTER_ORDER;
	CP	W11, #0
	BRA Z	L__FIR_filter34
	GOTO	L_FIR_filter3
L__FIR_filter34:
	MOV	#50, W11
	GOTO	L_FIR_filter4
L_FIR_filter3:
;main.c,63 :: 		else time_index_filter--;
	SUB	W11, #1, W0
	MOV	W0, W11
L_FIR_filter4:
;main.c,60 :: 		for (sample=0; sample<FILTER_ORDER+1; sample++){
	INC	W6
;main.c,64 :: 		}
; sample end address is: 12 (W6)
	GOTO	L_FIR_filter0
L_FIR_filter1:
;main.c,66 :: 		result = ceil(sum_temp/filter_factor);
	PUSH.D	W10
; sum_temp end address is: 14 (W7)
	MOV	W7, W0
	MOV	W8, W1
	MOV	_filter_factor, W2
	MOV	_filter_factor+2, W3
	CLR	W4
	CALL	__Divide_32x32
	CALL	__Long2Float
	MOV.D	W0, W10
	CALL	_ceil
	CALL	__Float2Longint
	POP.D	W10
;main.c,67 :: 		return result;
;main.c,68 :: 		}
L_end_FIR_filter:
	RETURN
; end of _FIR_filter

_canInterrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;main.c,72 :: 		void canInterrupt() iv IVT_ADDR_C1INTERRUPT ics ICS_AUTO {
;main.c,74 :: 		Can_clearInterrupt();
	CALL	_Can_clearInterrupt
;main.c,75 :: 		}
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
	LNK	#2
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;main.c,79 :: 		void TIMER5_INT() iv IVT_ADDR_T5INTERRUPT ics ICS_AUTO {
;main.c,81 :: 		int t_send = time_index;
	PUSH	W10
	PUSH	W11
; t_send start address is: 4 (W2)
	MOV	_time_index, W2
;main.c,82 :: 		int Channel_Index_send = 0;
;main.c,85 :: 		for (Channel_Index_send = 0; Channel_Index_send < N_CHANNEL; Channel_Index_send++){
; Channel_Index_send start address is: 6 (W3)
	CLR	W3
; Channel_Index_send end address is: 6 (W3)
L_TIMER5_INT5:
; Channel_Index_send start address is: 6 (W3)
; t_send start address is: 4 (W2)
; t_send end address is: 4 (W2)
	CP	W3, #16
	BRA LT	L__TIMER5_INT37
	GOTO	L_TIMER5_INT6
L__TIMER5_INT37:
; t_send end address is: 4 (W2)
;main.c,87 :: 		data_out[Channel_Index_send] = FIR_filter(Channel_Index_send, t_send);
; t_send start address is: 4 (W2)
	SL	W3, #1, W1
	MOV	#lo_addr(_data_out), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+0]
	PUSH.D	W2
	MOV	W2, W11
	MOV	W3, W10
	CALL	_FIR_filter
	POP.D	W2
	MOV	[W14+0], W1
	MOV	W0, [W1]
;main.c,85 :: 		for (Channel_Index_send = 0; Channel_Index_send < N_CHANNEL; Channel_Index_send++){
	INC	W3
;main.c,89 :: 		}
; t_send end address is: 4 (W2)
; Channel_Index_send end address is: 6 (W3)
	GOTO	L_TIMER5_INT5
L_TIMER5_INT6:
;main.c,91 :: 		switch (DAU_ID){
	GOTO	L_TIMER5_INT8
;main.c,93 :: 		case DAU_REAR :
L_TIMER5_INT10:
;main.c,95 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,96 :: 		Can_addIntToWritePacket(data_out[IN_1]);                        //lineare rear left
	MOV	_data_out+4, W10
	CALL	_Can_addIntToWritePacket
;main.c,97 :: 		Can_addIntToWritePacket(data_out[LC_1]);                        //load cell  rear left
	MOV	_data_out, W10
	CALL	_Can_addIntToWritePacket
;main.c,98 :: 		Can_addIntToWritePacket(data_out[IN_5_J3]);                //lineare rear right
	MOV	_data_out+8, W10
	CALL	_Can_addIntToWritePacket
;main.c,99 :: 		Can_addIntToWritePacket(data_out[LC_2]);                        //load cell rear rigth
	MOV	_data_out+2, W10
	CALL	_Can_addIntToWritePacket
;main.c,100 :: 		Can_write(DAU_REAR_ID);                                 //0x652
	MOV	#1618, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,102 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,103 :: 		Can_addIntToWritePacket(data_out[IR1]);
	MOV	_data_out+16, W10
	CALL	_Can_addIntToWritePacket
;main.c,104 :: 		Can_addIntToWritePacket(data_out[IR2]);
	MOV	_data_out+18, W10
	CALL	_Can_addIntToWritePacket
;main.c,105 :: 		Can_addIntToWritePacket(data_out[IR3]);
	MOV	_data_out+20, W10
	CALL	_Can_addIntToWritePacket
;main.c,106 :: 		Can_addIntToWritePacket(data_out[IN_2]);                        //BREAKE IR RL
	MOV	_data_out+6, W10
	CALL	_Can_addIntToWritePacket
;main.c,107 :: 		Can_write(DAU_REAR_IR_RL_ID);                           //0x656
	MOV	#1622, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,109 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,110 :: 		Can_addIntToWritePacket(data_out[IR4]);
	MOV	_data_out+22, W10
	CALL	_Can_addIntToWritePacket
;main.c,111 :: 		Can_addIntToWritePacket(data_out[IR5]);
	MOV	_data_out+24, W10
	CALL	_Can_addIntToWritePacket
;main.c,112 :: 		Can_addIntToWritePacket(data_out[IR6]);
	MOV	_data_out+26, W10
	CALL	_Can_addIntToWritePacket
;main.c,113 :: 		Can_addIntToWritePacket(data_out[IN_6_J4]);                //BREAKE IR RR
	MOV	_data_out+10, W10
	CALL	_Can_addIntToWritePacket
;main.c,114 :: 		Can_write(DAU_REAR_IR_RR_ID);                           //0x657
	MOV	#1623, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,117 :: 		break;
	GOTO	L_TIMER5_INT9
;main.c,119 :: 		case DAU_FR :
L_TIMER5_INT11:
;main.c,121 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,122 :: 		Can_addIntToWritePacket(data_out[IN_1]);
	MOV	_data_out+4, W10
	CALL	_Can_addIntToWritePacket
;main.c,123 :: 		Can_addIntToWritePacket(data_out[LC_1]);
	MOV	_data_out, W10
	CALL	_Can_addIntToWritePacket
;main.c,124 :: 		Can_addIntToWritePacket(data_out[IR6]);
	MOV	_data_out+26, W10
	CALL	_Can_addIntToWritePacket
;main.c,125 :: 		Can_addIntToWritePacket(data_out[IN_6_J4]);
	MOV	_data_out+10, W10
	CALL	_Can_addIntToWritePacket
;main.c,126 :: 		Can_write(DAU_FR_ID);                             //0x650
	MOV	#1616, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,128 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,129 :: 		Can_addIntToWritePacket(data_out[IR1]);
	MOV	_data_out+16, W10
	CALL	_Can_addIntToWritePacket
;main.c,130 :: 		Can_addIntToWritePacket(data_out[IR2]);
	MOV	_data_out+18, W10
	CALL	_Can_addIntToWritePacket
;main.c,131 :: 		Can_addIntToWritePacket(data_out[IR3]);
	MOV	_data_out+20, W10
	CALL	_Can_addIntToWritePacket
;main.c,132 :: 		Can_addIntToWritePacket(data_out[IN_2]);
	MOV	_data_out+6, W10
	CALL	_Can_addIntToWritePacket
;main.c,133 :: 		Can_write(DAU_FR_IR_ID);                          //0x655
	MOV	#1621, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,135 :: 		break;
	GOTO	L_TIMER5_INT9
;main.c,137 :: 		case DAU_FL :
L_TIMER5_INT12:
;main.c,139 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,140 :: 		Can_addIntToWritePacket(data_out[IN_1]);
	MOV	_data_out+4, W10
	CALL	_Can_addIntToWritePacket
;main.c,141 :: 		Can_addIntToWritePacket(data_out[LC_1]);
	MOV	_data_out, W10
	CALL	_Can_addIntToWritePacket
;main.c,142 :: 		Can_addIntToWritePacket(data_out[IN_5_J3]);
	MOV	_data_out+8, W10
	CALL	_Can_addIntToWritePacket
;main.c,143 :: 		Can_addIntToWritePacket(data_out[IN_6_J4]);    //SE SENSORE STEER MONTATO STORTO VANNO CORRETTI I VALORI
	MOV	_data_out+10, W10
	CALL	_Can_addIntToWritePacket
;main.c,144 :: 		Can_write(DAU_FL_ID);                    //0x651
	MOV	#1617, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,146 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,147 :: 		Can_addIntToWritePacket(data_out[IR1]);
	MOV	_data_out+16, W10
	CALL	_Can_addIntToWritePacket
;main.c,148 :: 		Can_addIntToWritePacket(data_out[IR2]);
	MOV	_data_out+18, W10
	CALL	_Can_addIntToWritePacket
;main.c,149 :: 		Can_addIntToWritePacket(data_out[IR3]);
	MOV	_data_out+20, W10
	CALL	_Can_addIntToWritePacket
;main.c,150 :: 		Can_addIntToWritePacket(data_out[IN_2]);   //SAREBBE LA TEMPERATURA FRENO. E OK QUI?
	MOV	_data_out+6, W10
	CALL	_Can_addIntToWritePacket
;main.c,151 :: 		Can_write(DAU_FL_IR_ID);                 //0x654
	MOV	#1620, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,153 :: 		break;
	GOTO	L_TIMER5_INT9
;main.c,155 :: 		}
L_TIMER5_INT8:
	MOV	#lo_addr(_DAU_ID), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__TIMER5_INT38
	GOTO	L_TIMER5_INT10
L__TIMER5_INT38:
	MOV	#lo_addr(_DAU_ID), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__TIMER5_INT39
	GOTO	L_TIMER5_INT11
L__TIMER5_INT39:
	MOV	#lo_addr(_DAU_ID), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__TIMER5_INT40
	GOTO	L_TIMER5_INT12
L__TIMER5_INT40:
L_TIMER5_INT9:
;main.c,159 :: 		TMR5_CONT++;
	MOV	#1, W1
	MOV	#lo_addr(_TMR5_CONT), W0
	ADD	W1, [W0], [W0]
;main.c,161 :: 		ADC_CONT = 0;                                // RESETTA IL CONTEGGIO DI SAMPLE ADC
	CLR	W0
	MOV	W0, _ADC_CONT
;main.c,162 :: 		IFS1bits.T5IF = 0;
	BCLR	IFS1bits, #6
;main.c,164 :: 		}
L_end_TIMER5_INT:
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	ULNK
	RETFIE
; end of _TIMER5_INT

_TIMER1_INT:
	LNK	#8
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;main.c,166 :: 		void TIMER1_INT() iv IVT_ADDR_T1INTERRUPT ics ICS_AUTO {                        //interrupt responsabile dell'invio dei dati di debug sul can
;main.c,168 :: 		float currentConverted, tempConverted = 0;
	PUSH	W10
	PUSH	W11
;main.c,169 :: 		if (TMR1_CONT > 5){
	MOV	_TMR1_CONT, W0
	CP	W0, #5
	BRA GT	L__TIMER1_INT42
	GOTO	L_TIMER1_INT13
L__TIMER1_INT42:
;main.c,171 :: 		TMR1_CONT = 0;
	CLR	W0
	MOV	W0, _TMR1_CONT
;main.c,174 :: 		currentConverted = (float)data_out[CURRENT_SENSE] * LSB_1000;                        //vout in mV
	MOV	_data_out+28, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	#18885, W2
	MOV	#16284, W3
	CALL	__Mul_FP
;main.c,175 :: 		currentConverted = (currentConverted/INA_GAIN)/SHUNT_RESISTOR;                         //risultato in mA
	MOV	#0, W2
	MOV	#17096, W3
	CALL	__Div_FP
	MOV	#62390, W2
	MOV	#15741, W3
	CALL	__Div_FP
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;main.c,177 :: 		tempConverted = (float)data_out[TEMP_SENSE] * LSB_1000;                                        //Vout in mV
	MOV	_data_out+30, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	#18885, W2
	MOV	#16284, W3
	CALL	__Mul_FP
;main.c,178 :: 		tempConverted = (tempConverted - TEMP_OFFSET)/TEMP_RATE;                                //risultato in gradi
	MOV	#0, W2
	MOV	#17402, W3
	CALL	__Sub_FP
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
;main.c,180 :: 		switch (DAU_ID){
	GOTO	L_TIMER1_INT14
;main.c,183 :: 		case DAU_REAR :
L_TIMER1_INT16:
;main.c,184 :: 		Toggle_LEDRED();
	CALL	_Toggle_LEDRED
;main.c,186 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,187 :: 		Can_addIntToWritePacket((int)tempConverted);
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	CALL	__Float2Longint
	MOV	W0, W10
	CALL	_Can_addIntToWritePacket
;main.c,188 :: 		Can_addIntToWritePacket((int)currentConverted);
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	CALL	__Float2Longint
	MOV	W0, W10
	CALL	_Can_addIntToWritePacket
;main.c,189 :: 		Can_write(DAU_REAR_DEBUG_ID);
	MOV	#788, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,190 :: 		break;
	GOTO	L_TIMER1_INT15
;main.c,192 :: 		case DAU_FL :
L_TIMER1_INT17:
;main.c,193 :: 		Toggle_LEDRED();
	CALL	_Toggle_LEDRED
;main.c,195 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,196 :: 		Can_addIntToWritePacket((int)tempConverted);
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	CALL	__Float2Longint
	MOV	W0, W10
	CALL	_Can_addIntToWritePacket
;main.c,197 :: 		Can_addIntToWritePacket((int)currentConverted);
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	CALL	__Float2Longint
	MOV	W0, W10
	CALL	_Can_addIntToWritePacket
;main.c,198 :: 		Can_write(DAU_FL_DEBUG_ID);           //0x313
	MOV	#787, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,199 :: 		break;
	GOTO	L_TIMER1_INT15
;main.c,201 :: 		case DAU_FR :
L_TIMER1_INT18:
;main.c,202 :: 		Toggle_LEDRED();
	CALL	_Toggle_LEDRED
;main.c,204 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;main.c,205 :: 		Can_addIntToWritePacket((int)tempConverted);
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	CALL	__Float2Longint
	MOV	W0, W10
	CALL	_Can_addIntToWritePacket
;main.c,206 :: 		Can_addIntToWritePacket((int)currentConverted);
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	CALL	__Float2Longint
	MOV	W0, W10
	CALL	_Can_addIntToWritePacket
;main.c,207 :: 		Can_write(DAU_FR_DEBUG_ID);
	MOV	#786, W10
	MOV	#0, W11
	CALL	_Can_write
;main.c,208 :: 		break;
	GOTO	L_TIMER1_INT15
;main.c,209 :: 		}
L_TIMER1_INT14:
	MOV	#lo_addr(_DAU_ID), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__TIMER1_INT43
	GOTO	L_TIMER1_INT16
L__TIMER1_INT43:
	MOV	#lo_addr(_DAU_ID), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__TIMER1_INT44
	GOTO	L_TIMER1_INT17
L__TIMER1_INT44:
	MOV	#lo_addr(_DAU_ID), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__TIMER1_INT45
	GOTO	L_TIMER1_INT18
L__TIMER1_INT45:
L_TIMER1_INT15:
;main.c,211 :: 		}
L_TIMER1_INT13:
;main.c,212 :: 		TMR1_CONT++;
	MOV	#1, W1
	MOV	#lo_addr(_TMR1_CONT), W0
	ADD	W1, [W0], [W0]
;main.c,213 :: 		IFS0bits.T1IF = 0;
	BCLR	IFS0bits, #3
;main.c,214 :: 		}
L_end_TIMER1_INT:
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	ULNK
	RETFIE
; end of _TIMER1_INT

_ADC_INT:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;main.c,216 :: 		void ADC_INT() iv IVT_ADDR_ADCINTERRUPT ics ICS_AUTO {  //non vorrei che le operazioni svolte qui dentro fosero troppe per una interrupt, forse andrebbero delegate a un'altra funzione
;main.c,217 :: 		int Channel_Index = 0;
;main.c,220 :: 		for (Channel_Index = 0; Channel_Index < N_CHANNEL; Channel_Index ++){     //SALVA TUTTE LE LETTURE DEI CANALI AL NUOVO TIME_INDEX
; Channel_Index start address is: 8 (W4)
	CLR	W4
; Channel_Index end address is: 8 (W4)
L_ADC_INT19:
; Channel_Index start address is: 8 (W4)
	CP	W4, #16
	BRA LT	L__ADC_INT47
	GOTO	L_ADC_INT20
L__ADC_INT47:
;main.c,221 :: 		buffer_adc = (&ADCBUF0 + Channel_Index);
	SL	W4, #1, W2
	MOV	#lo_addr(ADCBUF0), W1
	MOV	#lo_addr(_buffer_adc), W0
	ADD	W1, W2, [W0]
;main.c,222 :: 		data_buffer[Channel_Index][time_index] = *buffer_adc;
	MOV	#204, W0
	MUL.UU	W0, W4, W2
	MOV	#lo_addr(_data_buffer), W0
	ADD	W0, W2, W1
	MOV	_time_index, W0
	SL	W0, #2, W0
	ADD	W1, W0, W2
	MOV	_buffer_adc, W0
	MOV	[W0], W0
	ASR	W0, #15, W1
	MOV.D	W0, [W2]
;main.c,220 :: 		for (Channel_Index = 0; Channel_Index < N_CHANNEL; Channel_Index ++){     //SALVA TUTTE LE LETTURE DEI CANALI AL NUOVO TIME_INDEX
	INC	W4
;main.c,223 :: 		}
; Channel_Index end address is: 8 (W4)
	GOTO	L_ADC_INT19
L_ADC_INT20:
;main.c,225 :: 		if (time_index == FILTER_ORDER) time_index = 0;
	MOV	#50, W1
	MOV	#lo_addr(_time_index), W0
	CP	W1, [W0]
	BRA Z	L__ADC_INT48
	GOTO	L_ADC_INT22
L__ADC_INT48:
	CLR	W0
	MOV	W0, _time_index
	GOTO	L_ADC_INT23
L_ADC_INT22:
;main.c,226 :: 		else time_index++;
	MOV	#1, W1
	MOV	#lo_addr(_time_index), W0
	ADD	W1, [W0], [W0]
L_ADC_INT23:
;main.c,228 :: 		ADC_CONT++;
	MOV	#1, W1
	MOV	#lo_addr(_ADC_CONT), W0
	ADD	W1, [W0], [W0]
;main.c,230 :: 		IFS0bits.ADIF     = 0b0;        //clear interrupt flag
	BCLR	IFS0bits, #11
;main.c,231 :: 		}
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

;main.c,233 :: 		void TIMER4_INT() iv IVT_ADDR_T4INTERRUPT ics ICS_AUTO {
;main.c,235 :: 		ADCON1bits.ADON = 1;
	BSET	ADCON1bits, #15
;main.c,236 :: 		IFS1bits.T4IF = 0;
	BCLR	IFS1bits, #5
;main.c,238 :: 		}
L_end_TIMER4_INT:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _TIMER4_INT

_Clear_buffer:

;main.c,241 :: 		void Clear_buffer(){
;main.c,242 :: 		int Ch_Index, Buffer_Index = 0;
;main.c,243 :: 		for (Ch_Index = 0; Ch_Index < N_CHANNEL; Ch_Index++){
; Ch_Index start address is: 8 (W4)
	CLR	W4
; Ch_Index end address is: 8 (W4)
L_Clear_buffer24:
; Ch_Index start address is: 8 (W4)
	CP	W4, #16
	BRA LT	L__Clear_buffer51
	GOTO	L_Clear_buffer25
L__Clear_buffer51:
;main.c,244 :: 		for(Buffer_Index = 0; Buffer_Index < FILTER_ORDER+1; Buffer_Index++){
; Buffer_Index start address is: 10 (W5)
	CLR	W5
; Buffer_Index end address is: 10 (W5)
; Ch_Index end address is: 8 (W4)
L_Clear_buffer27:
; Buffer_Index start address is: 10 (W5)
; Ch_Index start address is: 8 (W4)
	MOV	#51, W0
	CP	W5, W0
	BRA LT	L__Clear_buffer52
	GOTO	L_Clear_buffer28
L__Clear_buffer52:
;main.c,245 :: 		data_buffer[Ch_Index][Buffer_Index] = 0;
	MOV	#204, W0
	MUL.UU	W0, W4, W2
	MOV	#lo_addr(_data_buffer), W0
	ADD	W0, W2, W1
	SL	W5, #2, W0
	ADD	W1, W0, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;main.c,244 :: 		for(Buffer_Index = 0; Buffer_Index < FILTER_ORDER+1; Buffer_Index++){
	INC	W5
;main.c,246 :: 		}
; Buffer_Index end address is: 10 (W5)
	GOTO	L_Clear_buffer27
L_Clear_buffer28:
;main.c,247 :: 		data_out[Ch_Index]=0;                               //INIZIALIZZA ANCHE DATA OUT
	SL	W4, #1, W1
	MOV	#lo_addr(_data_out), W0
	ADD	W0, W1, W1
	CLR	W0
	MOV	W0, [W1]
;main.c,243 :: 		for (Ch_Index = 0; Ch_Index < N_CHANNEL; Ch_Index++){
	INC	W4
;main.c,248 :: 		}
; Ch_Index end address is: 8 (W4)
	GOTO	L_Clear_buffer24
L_Clear_buffer25:
;main.c,249 :: 		}
L_end_Clear_buffer:
	RETURN
; end of _Clear_buffer

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;main.c,251 :: 		void main() {
;main.c,253 :: 		io_init();
	PUSH	W10
	CALL	_io_init
;main.c,254 :: 		Clear_buffer();
	CALL	_Clear_buffer
;main.c,255 :: 		dau_set_ID(&DAU_ID);
	MOV	#lo_addr(_DAU_ID), W10
	CALL	_dau_set_ID
;main.c,256 :: 		LEDGREEN = 1;
	BSET	LATGbits, #14
;main.c,257 :: 		can_bus_init();
	CALL	_can_bus_init
;main.c,258 :: 		adc_init();
	CALL	_adc_init
;main.c,259 :: 		tmr4_init();
	CALL	_tmr4_init
;main.c,260 :: 		tmr5_init();
	CALL	_tmr5_init
;main.c,261 :: 		tmr1_init();
	CALL	_tmr1_init
;main.c,264 :: 		while(1){
L_main30:
;main.c,281 :: 		}
	GOTO	L_main30
;main.c,283 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
