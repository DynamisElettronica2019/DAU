
_Clear_buffer:

;User_Function.c,22 :: 		void Clear_buffer(ydata unsigned **input){
;User_Function.c,23 :: 		int Channel_Index, Buffer_Index = 0;
;User_Function.c,25 :: 		for (Channel_Index = 0; Channel_Index < N_CHANNEL; Channel_Index++){
; Channel_Index start address is: 4 (W2)
	CLR	W2
; Channel_Index end address is: 4 (W2)
L_Clear_buffer0:
; Channel_Index start address is: 4 (W2)
	CP	W2, #16
	BRA LT	L__Clear_buffer32
	GOTO	L_Clear_buffer1
L__Clear_buffer32:
;User_Function.c,26 :: 		for(Buffer_Index = 0; Buffer_Index < BUFFER_SIZE; Buffer_Index++){
; Buffer_Index start address is: 6 (W3)
	CLR	W3
; Buffer_Index end address is: 6 (W3)
; Channel_Index end address is: 4 (W2)
L_Clear_buffer3:
; Buffer_Index start address is: 6 (W3)
; Channel_Index start address is: 4 (W2)
	MOV	#32, W0
	CP	W3, W0
	BRA LT	L__Clear_buffer33
	GOTO	L_Clear_buffer4
L__Clear_buffer33:
;User_Function.c,28 :: 		input[Channel_Index][Buffer_Index] = 0;
	SL	W2, #1, W0
	ADD	W10, W0, W1
	SL	W3, #1, W0
	ADD	W0, [W1], W1
	CLR	W0
	MOV	W0, [W1]
;User_Function.c,26 :: 		for(Buffer_Index = 0; Buffer_Index < BUFFER_SIZE; Buffer_Index++){
	INC	W3
;User_Function.c,29 :: 		}
; Buffer_Index end address is: 6 (W3)
	GOTO	L_Clear_buffer3
L_Clear_buffer4:
;User_Function.c,25 :: 		for (Channel_Index = 0; Channel_Index < N_CHANNEL; Channel_Index++){
	INC	W2
;User_Function.c,30 :: 		}
; Channel_Index end address is: 4 (W2)
	GOTO	L_Clear_buffer0
L_Clear_buffer1:
;User_Function.c,31 :: 		}
L_end_Clear_buffer:
	RETURN
; end of _Clear_buffer

_tmr5_init:

;User_Function.c,34 :: 		void tmr5_init(void){
;User_Function.c,36 :: 		T5CONbits.TON   = 0b1;
	BSET	T5CONbits, #15
;User_Function.c,37 :: 		T5CONbits.TSIDL = 0b0;     //Continue timer operation in Idle mode
	BCLR	T5CONbits, #13
;User_Function.c,38 :: 		T5CONbits.TGATE = 0b0;     //no gated time
	BCLR	T5CONbits, #6
;User_Function.c,39 :: 		T5CONbits.TCKPS = 0b01;    //prescaler 8
	MOV.B	#16, W0
	MOV.B	W0, W1
	MOV	#lo_addr(T5CONbits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#48, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(T5CONbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(T5CONbits), W0
	MOV.B	W1, [W0]
;User_Function.c,40 :: 		T5CONbits.TCS   = 0b0;     //Internal clock (FOSC/4)
	BCLR	T5CONbits, #1
;User_Function.c,42 :: 		IPC5bits.T5IP = 0b011;     //interrupt priority 3
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC5bits
;User_Function.c,44 :: 		IFS1bits.T5IF = 0b0;       //clear interrupt
	BCLR	IFS1bits, #6
;User_Function.c,45 :: 		IEC1bits.T5IE = 0b1;       //enable interrupt
	BSET	IEC1bits, #6
;User_Function.c,47 :: 		TMR5 = 0b0;
	CLR	TMR5
;User_Function.c,48 :: 		PR5  = 0b0110000110101000;       //25000 * 8 * 50ns -> 0.01 s
	MOV	#25000, W0
	MOV	WREG, PR5
;User_Function.c,50 :: 		}
L_end_tmr5_init:
	RETURN
; end of _tmr5_init

_can_bus_init:

;User_Function.c,53 :: 		void can_bus_init(void){
;User_Function.c,55 :: 		CAN_Init();
	CALL	_Can_init
;User_Function.c,56 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;User_Function.c,58 :: 		}
L_end_can_bus_init:
	RETURN
; end of _can_bus_init

_adc_init:

;User_Function.c,61 :: 		uint8_t adc_init(void){
;User_Function.c,63 :: 		IEC0bits.ADIE     = 0b1;               //adc interrupt enable
	BSET	IEC0bits, #11
;User_Function.c,64 :: 		IPC2bits.ADIP     = 0b001;             //adc interrupt priority
	MOV	#4096, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;User_Function.c,65 :: 		IFS0bits.ADIF     = 0b0;               //clear interrupt flag
	BCLR	IFS0bits, #11
;User_Function.c,67 :: 		ADPCFG            = 0b000000000000000; //All Analog input pin in Analog mode, port read input disabled, A/D samples pin voltage
	CLR	ADPCFG
;User_Function.c,68 :: 		ADCON3bits.ADCS   = 0b011000;          //set Tad of the ADC          x24Tcy
	MOV.B	#24, W0
	MOV.B	W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(ADCON3bits), W0
	MOV.B	W1, [W0]
;User_Function.c,69 :: 		ADCON3bits.ADRC   = 0b0;              // clock from system
	BCLR	ADCON3bits, #7
;User_Function.c,70 :: 		ADCON3bits.SAMC   = 0b00010;          // 2Tad
	MOV	#512, W0
	MOV	W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, ADCON3bits
;User_Function.c,72 :: 		ADCON2bits.ALTS   = 0b0;              //Always use MUX A input multiplexer settings
	BCLR	ADCON2bits, #0
;User_Function.c,73 :: 		ADCON2bits.BUFM   = 0b0;              //Buffer configured as one 16-word buffer ADCBUF(15...0)
	BCLR	ADCON2bits, #1
;User_Function.c,74 :: 		ADCON2bits.SMPI   = 0b1111;            //Interrupts at the completion of conversion for each 16th sample/convert sequence
	MOV	#lo_addr(ADCON2bits), W0
	MOV.B	[W0], W1
	MOV.B	#60, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(ADCON2bits), W0
	MOV.B	W1, [W0]
;User_Function.c,75 :: 		ADCON2bits.CSCNA  = 0b1;              //Scan inputs
	BSET	ADCON2bits, #10
;User_Function.c,76 :: 		ADCON2bits.VCFG   = 0b000;            //internal voltage reference VDD
	MOV	ADCON2bits, W1
	MOV	#8191, W0
	AND	W1, W0, W0
	MOV	WREG, ADCON2bits
;User_Function.c,78 :: 		ADCON1bits.ASAM   = 0b1;              // Sampling begins immediately after last conversion completes. SAMP bit is auto set
	BSET	ADCON1bits, #2
;User_Function.c,79 :: 		ADCON1bits.SSRC   = 0b111;            //Internal counter ends sampling and starts conversion (auto convert)
	MOV	#lo_addr(ADCON1bits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(ADCON1bits), W0
	MOV.B	W1, [W0]
;User_Function.c,80 :: 		ADCON1bits.FORM   = 0b00;             //data output integer
	MOV	ADCON1bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, ADCON1bits
;User_Function.c,81 :: 		ADCON1bits.ADSIDL = 0b0;              // Continue module operation in Idle mode
	BCLR	ADCON1bits, #13
;User_Function.c,82 :: 		ADCON1bits.ADON   = 0b0;
	BCLR	ADCON1bits, #15
;User_Function.c,84 :: 		ADCSSL = 0xFFFF;     //scan ALL inputs
	MOV	#65535, W0
	MOV	WREG, ADCSSL
;User_Function.c,85 :: 		ADCHSbits.CH0NA = 0; //negative input for sampling Vref-
	BCLR	ADCHSbits, #4
;User_Function.c,87 :: 		return ADC_OK;
	CLR	W0
;User_Function.c,89 :: 		}
L_end_adc_init:
	RETURN
; end of _adc_init

_tmr4_init:

;User_Function.c,93 :: 		void tmr4_init(void){
;User_Function.c,95 :: 		T4CONbits.TON   = 0b1;
	BSET	T4CONbits, #15
;User_Function.c,96 :: 		T4CONbits.TSIDL = 0b0;     //Continue timer operation in Idle mode
	BCLR	T4CONbits, #13
;User_Function.c,97 :: 		T4CONbits.TGATE = 0b0;     //no gated time
	BCLR	T4CONbits, #6
;User_Function.c,98 :: 		T4CONbits.TCKPS = 0b00;    //prescaler
	MOV	#lo_addr(T4CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#207, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(T4CONbits), W0
	MOV.B	W1, [W0]
;User_Function.c,99 :: 		T4CONbits.TCS = 0b0;       //Internal clock (FOSC/4)
	BCLR	T4CONbits, #1
;User_Function.c,102 :: 		T4CONbits.T32 = 0b0;       //16 bit timer, separated from timer5
	BCLR	T4CONbits, #3
;User_Function.c,103 :: 		IPC5bits.T4IP = 0b011;     //interrupt priority 3
	MOV.B	#48, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#112, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;User_Function.c,105 :: 		IFS1bits.T4IF = 0b0;       //clear interrupt
	BCLR	IFS1bits, #5
;User_Function.c,106 :: 		IEC1bits.T4IE = 0b1;       //enable interrupt
	BSET	IEC1bits, #5
;User_Function.c,108 :: 		TMR4 = 0b0;
	CLR	TMR4
;User_Function.c,109 :: 		PR4  = 0b0000110100000101;       // 3333 * 50ns = 167 us --> 6 KHz
	MOV	#3333, W0
	MOV	WREG, PR4
;User_Function.c,111 :: 		}
L_end_tmr4_init:
	RETURN
; end of _tmr4_init

_io_init:

;User_Function.c,113 :: 		void io_init(void){
;User_Function.c,115 :: 		TRISGbits.TRISG12 = 0;             //LED IOPORT AS OUPUT
	BCLR	TRISGbits, #12
;User_Function.c,116 :: 		TRISGbits.TRISG13 = 0;
	BCLR	TRISGbits, #13
;User_Function.c,117 :: 		TRISGbits.TRISG14 = 0;
	BCLR	TRISGbits, #14
;User_Function.c,121 :: 		}
L_end_io_init:
	RETURN
; end of _io_init

_dau_set_ID:

;User_Function.c,125 :: 		uint8_t dau_set_ID(uint8_t * DAU_ID){
;User_Function.c,126 :: 		if (SELBIT0 == 0 && SELBIT1 == 0){
	BTSC.B	PORTFbits, #4
	GOTO	L__dau_set_ID26
	BTSC.B	PORTFbits, #5
	GOTO	L__dau_set_ID25
L__dau_set_ID24:
;User_Function.c,127 :: 		*DAU_ID = DAU_FL;
	CLR	W0
	MOV.B	W0, [W10]
;User_Function.c,128 :: 		return DAU_ID_OK;
	CLR	W0
	GOTO	L_end_dau_set_ID
;User_Function.c,126 :: 		if (SELBIT0 == 0 && SELBIT1 == 0){
L__dau_set_ID26:
L__dau_set_ID25:
;User_Function.c,130 :: 		else if (SELBIT0 == 1 && SELBIT1 == 0){
	BTSS.B	PORTFbits, #4
	GOTO	L__dau_set_ID28
	BTSC.B	PORTFbits, #5
	GOTO	L__dau_set_ID27
L__dau_set_ID23:
;User_Function.c,131 :: 		*DAU_ID = DAU_FR;
	MOV.B	#1, W0
	MOV.B	W0, [W10]
;User_Function.c,132 :: 		return DAU_ID_OK;
	CLR	W0
	GOTO	L_end_dau_set_ID
;User_Function.c,130 :: 		else if (SELBIT0 == 1 && SELBIT1 == 0){
L__dau_set_ID28:
L__dau_set_ID27:
;User_Function.c,134 :: 		else if(SELBIT0 == 0 && SELBIT1 == 1){
	BTSC.B	PORTFbits, #4
	GOTO	L__dau_set_ID30
	BTSS.B	PORTFbits, #5
	GOTO	L__dau_set_ID29
L__dau_set_ID22:
;User_Function.c,135 :: 		*DAU_ID = DAU_REAR;
	MOV.B	#2, W0
	MOV.B	W0, [W10]
;User_Function.c,136 :: 		return DAU_ID_OK;
	CLR	W0
	GOTO	L_end_dau_set_ID
;User_Function.c,134 :: 		else if(SELBIT0 == 0 && SELBIT1 == 1){
L__dau_set_ID30:
L__dau_set_ID29:
;User_Function.c,138 :: 		else return DAU_ID_ERROR;
	MOV.B	#1, W0
;User_Function.c,139 :: 		}
L_end_dau_set_ID:
	RETURN
; end of _dau_set_ID

_Toggle_LEDRED:

;User_Function.c,146 :: 		void Toggle_LEDRED(void){
;User_Function.c,148 :: 		if(LEDRED == 0) LEDRED = 1;
	BTSC	LATGbits, #12
	GOTO	L_Toggle_LEDRED18
	BSET	LATGbits, #12
	GOTO	L_Toggle_LEDRED19
L_Toggle_LEDRED18:
;User_Function.c,149 :: 		else                         LEDRED = 0;
	BCLR	LATGbits, #12
L_Toggle_LEDRED19:
;User_Function.c,151 :: 		}
L_end_Toggle_LEDRED:
	RETURN
; end of _Toggle_LEDRED

_Toggle_LEDBLUE:

;User_Function.c,153 :: 		void Toggle_LEDBLUE(void){
;User_Function.c,155 :: 		if(LEDBLUE == 0) LEDBLUE = 1;
	BTSC	LATGbits, #13
	GOTO	L_Toggle_LEDBLUE20
	BSET	LATGbits, #13
	GOTO	L_Toggle_LEDBLUE21
L_Toggle_LEDBLUE20:
;User_Function.c,156 :: 		else                          LEDBLUE = 0;
	BCLR	LATGbits, #13
L_Toggle_LEDBLUE21:
;User_Function.c,158 :: 		}
L_end_Toggle_LEDBLUE:
	RETURN
; end of _Toggle_LEDBLUE

_Set_LEDRED:

;User_Function.c,160 :: 		void Set_LEDRED(void){
;User_Function.c,161 :: 		LEDRED = 1;
	BSET	LATGbits, #12
;User_Function.c,162 :: 		}
L_end_Set_LEDRED:
	RETURN
; end of _Set_LEDRED

_set_LEDBLUE:

;User_Function.c,164 :: 		void set_LEDBLUE(void){
;User_Function.c,165 :: 		LEDBLUE = 1;
	BSET	LATGbits, #13
;User_Function.c,166 :: 		}
L_end_set_LEDBLUE:
	RETURN
; end of _set_LEDBLUE

_set_LEDGREEN:

;User_Function.c,168 :: 		void set_LEDGREEN(void){
;User_Function.c,169 :: 		LEDGREEN = 1;
	BSET	LATGbits, #14
;User_Function.c,170 :: 		}
L_end_set_LEDGREEN:
	RETURN
; end of _set_LEDGREEN
