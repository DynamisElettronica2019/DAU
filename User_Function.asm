
_tmr5_init:

;User_Function.c,24 :: 		void tmr5_init(void){
;User_Function.c,26 :: 		T5CONbits.TON   = 0b1;
	BSET	T5CONbits, #15
;User_Function.c,27 :: 		T5CONbits.TSIDL = 0b0;     //Continue timer operation in Idle mode
	BCLR	T5CONbits, #13
;User_Function.c,28 :: 		T5CONbits.TGATE = 0b0;     //no gated time
	BCLR	T5CONbits, #6
;User_Function.c,29 :: 		T5CONbits.TCKPS = 0b01;    //prescaler 8
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
;User_Function.c,30 :: 		T5CONbits.TCS   = 0b0;     //Internal clock (FOSC/4)
	BCLR	T5CONbits, #1
;User_Function.c,32 :: 		IPC5bits.T5IP = 0b011;     //interrupt priority 3  ALTA
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC5bits
;User_Function.c,34 :: 		IFS1bits.T5IF = 0b0;       //clear interrupt
	BCLR	IFS1bits, #6
;User_Function.c,35 :: 		IEC1bits.T5IE = 0b1;       //enable interrupt
	BSET	IEC1bits, #6
;User_Function.c,37 :: 		TMR5 = 0b0;
	CLR	TMR5
;User_Function.c,38 :: 		PR5  = 24500;       //25000 * 8 * 50ns -> 0.01 s     //24500 per compensare la durata della routine
	MOV	#24500, W0
	MOV	WREG, PR5
;User_Function.c,40 :: 		}
L_end_tmr5_init:
	RETURN
; end of _tmr5_init

_can_bus_init:

;User_Function.c,43 :: 		void can_bus_init(void){
;User_Function.c,45 :: 		CAN_Init();
	CALL	_Can_init
;User_Function.c,46 :: 		Can_resetWritePacket();
	CALL	_Can_resetWritePacket
;User_Function.c,48 :: 		}
L_end_can_bus_init:
	RETURN
; end of _can_bus_init

_adc_init:

;User_Function.c,51 :: 		uint8_t adc_init(void){
;User_Function.c,53 :: 		IEC0bits.ADIE     = 0b1;               //adc interrupt enable
	BSET	IEC0bits, #11
;User_Function.c,54 :: 		IPC2bits.ADIP     = 0b010;             //adc interrupt priority  2 MEDIA
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;User_Function.c,55 :: 		IFS0bits.ADIF     = 0b0;               //clear interrupt flag
	BCLR	IFS0bits, #11
;User_Function.c,57 :: 		ADPCFG            = 0b000000000000000; //All Analog input pin in Analog mode, port read input disabled, A/D samples pin voltage
	CLR	ADPCFG
;User_Function.c,58 :: 		ADCON3bits.ADCS   = 0b011000;          //set Tad of the ADC          x24Tcy
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
;User_Function.c,59 :: 		ADCON3bits.ADRC   = 0b0;              // clock from system
	BCLR	ADCON3bits, #7
;User_Function.c,60 :: 		ADCON3bits.SAMC   = 0b00010;          // 2Tad
	MOV	#512, W0
	MOV	W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR	W1, [W0], W1
	MOV	#7936, W0
	AND	W1, W0, W1
	MOV	#lo_addr(ADCON3bits), W0
	XOR	W1, [W0], W1
	MOV	W1, ADCON3bits
;User_Function.c,62 :: 		ADCON2bits.ALTS   = 0b0;              //Always use MUX A input multiplexer settings
	BCLR	ADCON2bits, #0
;User_Function.c,63 :: 		ADCON2bits.BUFM   = 0b0;              //Buffer configured as one 16-word buffer ADCBUF(15...0)
	BCLR	ADCON2bits, #1
;User_Function.c,64 :: 		ADCON2bits.SMPI   = 0b1111;            //Interrupts at the completion of conversion for each 16th sample/convert sequence
	MOV	#lo_addr(ADCON2bits), W0
	MOV.B	[W0], W1
	MOV.B	#60, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(ADCON2bits), W0
	MOV.B	W1, [W0]
;User_Function.c,65 :: 		ADCON2bits.CSCNA  = 0b1;              //Scan inputs
	BSET	ADCON2bits, #10
;User_Function.c,66 :: 		ADCON2bits.VCFG   = 0b000;            //internal voltage reference VDD
	MOV	ADCON2bits, W1
	MOV	#8191, W0
	AND	W1, W0, W0
	MOV	WREG, ADCON2bits
;User_Function.c,68 :: 		ADCON1bits.ASAM   = 0b1;              // Sampling begins immediately after last conversion completes. SAMP bit is auto set
	BSET	ADCON1bits, #2
;User_Function.c,69 :: 		ADCON1bits.SSRC   = 0b111;            //Internal counter ends sampling and starts conversion (auto convert)
	MOV	#lo_addr(ADCON1bits), W0
	MOV.B	[W0], W1
	MOV.B	#224, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(ADCON1bits), W0
	MOV.B	W1, [W0]
;User_Function.c,70 :: 		ADCON1bits.FORM   = 0b00;             //data output integer
	MOV	ADCON1bits, W1
	MOV	#64767, W0
	AND	W1, W0, W0
	MOV	WREG, ADCON1bits
;User_Function.c,71 :: 		ADCON1bits.ADSIDL = 0b0;              // Continue module operation in Idle mode
	BCLR	ADCON1bits, #13
;User_Function.c,72 :: 		ADCON1bits.ADON   = 0b0;
	BCLR	ADCON1bits, #15
;User_Function.c,74 :: 		ADCSSL = 0xFFFF;     //scan ALL inputs
	MOV	#65535, W0
	MOV	WREG, ADCSSL
;User_Function.c,75 :: 		ADCHSbits.CH0NA = 0; //negative input for sampling Vref-
	BCLR	ADCHSbits, #4
;User_Function.c,77 :: 		return ADC_OK;
	CLR	W0
;User_Function.c,79 :: 		}
L_end_adc_init:
	RETURN
; end of _adc_init

_tmr4_init:

;User_Function.c,83 :: 		void tmr4_init(void){
;User_Function.c,85 :: 		T4CONbits.TON   = 0b1;
	BSET	T4CONbits, #15
;User_Function.c,86 :: 		T4CONbits.TSIDL = 0b0;     //Continue timer operation in Idle mode
	BCLR	T4CONbits, #13
;User_Function.c,87 :: 		T4CONbits.TGATE = 0b0;     //no gated time
	BCLR	T4CONbits, #6
;User_Function.c,88 :: 		T4CONbits.TCKPS = 0b00;    //prescaler
	MOV	#lo_addr(T4CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#207, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(T4CONbits), W0
	MOV.B	W1, [W0]
;User_Function.c,89 :: 		T4CONbits.TCS = 0b0;       //Internal clock (FOSC/4)
	BCLR	T4CONbits, #1
;User_Function.c,92 :: 		T4CONbits.T32 = 0b0;       //16 bit timer, separated from timer5
	BCLR	T4CONbits, #3
;User_Function.c,93 :: 		IPC5bits.T4IP = 0b001;     //interrupt priority 1 BASSA
	MOV.B	#16, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#112, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;User_Function.c,95 :: 		IFS1bits.T4IF = 0b0;       //clear interrupt
	BCLR	IFS1bits, #5
;User_Function.c,96 :: 		IEC1bits.T4IE = 0b1;       //enable interrupt
	BSET	IEC1bits, #5
;User_Function.c,98 :: 		TMR4 = 0b0;
	CLR	TMR4
;User_Function.c,99 :: 		PR4  = 0b0000110100000101;       // 3333 * 50ns = 167 us --> 6 KHz
	MOV	#3333, W0
	MOV	WREG, PR4
;User_Function.c,101 :: 		}
L_end_tmr4_init:
	RETURN
; end of _tmr4_init

_tmr1_init:

;User_Function.c,103 :: 		void tmr1_init(void){
;User_Function.c,105 :: 		T1CONbits.TON   = 0b1;
	BSET	T1CONbits, #15
;User_Function.c,106 :: 		T1CONbits.TSIDL = 0b0;     //Continue timer operation in Idle mode
	BCLR	T1CONbits, #13
;User_Function.c,107 :: 		T1CONbits.TGATE = 0b0;     //no gated time
	BCLR	T1CONbits, #6
;User_Function.c,108 :: 		T1CONbits.TCKPS = 0b11;    //prescaler : 256
	MOV	#lo_addr(T1CONbits), W0
	MOV.B	[W0], W1
	MOV.B	#48, W0
	IOR.B	W1, W0, W1
	MOV	#lo_addr(T1CONbits), W0
	MOV.B	W1, [W0]
;User_Function.c,109 :: 		T1CONbits.TCS = 0b0;       //Internal clock (FOSC/4)
	BCLR	T1CONbits, #1
;User_Function.c,112 :: 		IPC0bits.T1IP = 0b011;     //interrupt priority 3 ALTA
	MOV	#12288, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;User_Function.c,114 :: 		IFS0bits.T1IF = 0b0;       //clear interrupt
	BCLR	IFS0bits, #3
;User_Function.c,115 :: 		IEC0bits.T1IE = 0b1;       //enable interrupt
	BSET	IEC0bits, #3
;User_Function.c,117 :: 		TMR1 = 0b0;
	CLR	TMR1
;User_Function.c,118 :: 		PR1  = 0b0011110100001001;       // 15625 * 50ns * 256 = 0.2 s --> 5Hz
	MOV	#15625, W0
	MOV	WREG, PR1
;User_Function.c,120 :: 		}
L_end_tmr1_init:
	RETURN
; end of _tmr1_init

_io_init:

;User_Function.c,124 :: 		void io_init(void){
;User_Function.c,126 :: 		TRISGbits.TRISG12 = 0;             //LED IOPORT AS OUPUT
	BCLR	TRISGbits, #12
;User_Function.c,127 :: 		TRISGbits.TRISG13 = 0;
	BCLR	TRISGbits, #13
;User_Function.c,128 :: 		TRISGbits.TRISG14 = 0;
	BCLR	TRISGbits, #14
;User_Function.c,132 :: 		}
L_end_io_init:
	RETURN
; end of _io_init

_dau_set_ID:

;User_Function.c,135 :: 		uint8_t dau_set_ID(uint8_t * DAU_ID){
;User_Function.c,136 :: 		if (SELBIT0 == 0 && SELBIT1 == 0){
	BTSC.B	PORTFbits, #4
	GOTO	L__dau_set_ID20
	BTSC.B	PORTFbits, #5
	GOTO	L__dau_set_ID19
L__dau_set_ID18:
;User_Function.c,137 :: 		*DAU_ID = DAU_FL;
	CLR	W0
	MOV.B	W0, [W10]
;User_Function.c,138 :: 		return DAU_ID_OK;
	CLR	W0
	GOTO	L_end_dau_set_ID
;User_Function.c,136 :: 		if (SELBIT0 == 0 && SELBIT1 == 0){
L__dau_set_ID20:
L__dau_set_ID19:
;User_Function.c,140 :: 		else if (SELBIT0 == 1 && SELBIT1 == 0){
	BTSS.B	PORTFbits, #4
	GOTO	L__dau_set_ID22
	BTSC.B	PORTFbits, #5
	GOTO	L__dau_set_ID21
L__dau_set_ID17:
;User_Function.c,141 :: 		*DAU_ID = DAU_FR;
	MOV.B	#1, W0
	MOV.B	W0, [W10]
;User_Function.c,142 :: 		return DAU_ID_OK;
	CLR	W0
	GOTO	L_end_dau_set_ID
;User_Function.c,140 :: 		else if (SELBIT0 == 1 && SELBIT1 == 0){
L__dau_set_ID22:
L__dau_set_ID21:
;User_Function.c,144 :: 		else if(SELBIT0 == 0 && SELBIT1 == 1){
	BTSC.B	PORTFbits, #4
	GOTO	L__dau_set_ID24
	BTSS.B	PORTFbits, #5
	GOTO	L__dau_set_ID23
L__dau_set_ID16:
;User_Function.c,145 :: 		*DAU_ID = DAU_REAR;
	MOV.B	#2, W0
	MOV.B	W0, [W10]
;User_Function.c,146 :: 		return DAU_ID_OK;
	CLR	W0
	GOTO	L_end_dau_set_ID
;User_Function.c,144 :: 		else if(SELBIT0 == 0 && SELBIT1 == 1){
L__dau_set_ID24:
L__dau_set_ID23:
;User_Function.c,148 :: 		else return DAU_ID_ERROR;
	MOV.B	#1, W0
;User_Function.c,149 :: 		}
L_end_dau_set_ID:
	RETURN
; end of _dau_set_ID

_Toggle_LEDRED:

;User_Function.c,156 :: 		void Toggle_LEDRED(void){
;User_Function.c,158 :: 		if(LEDRED == 0) LEDRED = 1;
	BTSC	LATGbits, #12
	GOTO	L_Toggle_LEDRED12
	BSET	LATGbits, #12
	GOTO	L_Toggle_LEDRED13
L_Toggle_LEDRED12:
;User_Function.c,159 :: 		else                         LEDRED = 0;
	BCLR	LATGbits, #12
L_Toggle_LEDRED13:
;User_Function.c,161 :: 		}
L_end_Toggle_LEDRED:
	RETURN
; end of _Toggle_LEDRED

_Toggle_LEDBLUE:

;User_Function.c,163 :: 		void Toggle_LEDBLUE(void){
;User_Function.c,165 :: 		if(LEDBLUE == 0) LEDBLUE = 1;
	BTSC	LATGbits, #13
	GOTO	L_Toggle_LEDBLUE14
	BSET	LATGbits, #13
	GOTO	L_Toggle_LEDBLUE15
L_Toggle_LEDBLUE14:
;User_Function.c,166 :: 		else                          LEDBLUE = 0;
	BCLR	LATGbits, #13
L_Toggle_LEDBLUE15:
;User_Function.c,168 :: 		}
L_end_Toggle_LEDBLUE:
	RETURN
; end of _Toggle_LEDBLUE

_Set_LEDRED:

;User_Function.c,170 :: 		void Set_LEDRED(void){
;User_Function.c,171 :: 		LEDRED = 1;
	BSET	LATGbits, #12
;User_Function.c,172 :: 		}
L_end_Set_LEDRED:
	RETURN
; end of _Set_LEDRED

_set_LEDBLUE:

;User_Function.c,174 :: 		void set_LEDBLUE(void){
;User_Function.c,175 :: 		LEDBLUE = 1;
	BSET	LATGbits, #13
;User_Function.c,176 :: 		}
L_end_set_LEDBLUE:
	RETURN
; end of _set_LEDBLUE

_set_LEDGREEN:

;User_Function.c,178 :: 		void set_LEDGREEN(void){
;User_Function.c,179 :: 		LEDGREEN = 1;
	BSET	LATGbits, #14
;User_Function.c,180 :: 		}
L_end_set_LEDGREEN:
	RETURN
; end of _set_LEDGREEN
