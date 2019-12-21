;EDUARDO DÍAZ DEL CASTILLO 
; PRIORIDAD DE INTERRUPCIONES
; INTERRUPCION A DISPLAY 7 SEGMENTOS CON TRAP,7.5, 6.5 y 5.5
; PRUEBA TRAP=66MILISEGUNDOS		7.5=1000MILISEGUNDOS		6.5=200MILISEGUNDOS		5.5=100MILISEGUNDOS
;
;------------------------ DEFINE VARIALBLES Y CONSTANTES
		.define
		SIETES 09h			; Dir siete segmentos
		NULL 00h			; NULL
		UNI 8000h			; Unidades
		DEC 8001h			; Decenas
		CEN 8002h			; Centenas
		SEG 8003h			; Segundos
		MIN 8004h			; Minutos
		HOR 8005h			; Horas
		INT75 8006h			; 8006h/8007h
		INT65 8009h			; 8009h/800Ah
		INT55 800Bh			; 800Bh/800Ch
		INTTRAP 800Dh		; 800Dh/800Eh
		CONTEO1 8012h		;
		CONTEO2 8013h		;
		CONTEO3 8014h		;
		CONTEO4 8015h		;

;------------------------ TABLAS
		.data 1000h			; Defino la tabla
		TAB7S:			; Tabla 7 segmentos
		db 77h,44h,3Eh,6Eh,4Dh,6Bh,7Bh,46h,7Fh,4Fh
;========================= MAIN

		.org 0000h			; Inicio de ensamble
		lxi SP,0000h		; Set puntero de pila
		jmp MAIN			;

; Vectores de interrupcion

		.org 0024h			; Int TRAP
		push H			;
		lhld INTTRAP		;	
		pchl				; Va a DCRE2

		.org 002Ch			; Int 5.5
		push H			;
		lhld INT55			;	
		pchl				; Va a ASCE2

		.org 0034h			; Int 6.5
		push H			;
		lhld INT65			;	
		pchl				; Va a DCRE1

		.org 003Ch			; Int 7.5
		push H			;
		lhld INT75			;	
		pchl				; Va a ASCE1

; Redireccion de interrupcion

MAIN:

		lxi H,DCRE2			; hl=dir. DCRE2
		shld INTTRAP		; INTERRUPTOR TRAP

		lxi H,ASCE1			; HL= dir de ASCE1
		shld INT75			; INTERRUPTOR 7.5

		lxi H,DCRE1			; HL= dir de DCRE1
		shld INT65			; INTERRUPTOR 6.5

		lxi H,ASCE2			; HL= dir de ASCE2
		shld INT55			; INTERRUPTOR 5.5

		mvi A,00011000b		; 7.5, 6.5 y 5.5
		sim				; sin mascara

		mvi A,0			; MUEVE 0 EN A
		sta CONTEO1			;
		sta CONTEO2			;
		sta CONTEO3			;
		sta CONTEO4			;

		ei				; Habilita interrupciones

LOOP:
		jmp LOOP			; En espera de una tecla o interrupcion

;------------------------ Controlador 7.5
;INCREMENTA LOS VALORES Y CUANDO ES 99 VA A ES1001 Y REEMPLAZA 0 EN EL REGISTRO A
ASCE1:
		push PSW			; Save A&SR
		push H			;
		lda CONTEO1			; CARGAR REGISTRO
		inr A				;INCREMENTAR EL REGISTRO
		cpi 100			; COMPRARAR SI ES IGUAL A 99
		jz ES1001			; SALTAR SI ES1001 ES 0
DCNT110:
		sta CONTEO1			; ALMACENA EL REGITRO EN CONTEO1
		lxi H,1000h			; CARGA LOS REGISTROS H Y L
		call BINDEC			; LLAMO A BINDEC (SUBRUTINA)
		lda DEC			;
		ani 00001111b		; AND LOGICO
		mov L,A			; MUEVE EL CONTENIDO DE A AL REGISTRO L
		mov A,M			; MUEVE M AL REGISTRO A
		out SIETES+0		; SALIDA DEL REGISTRO AL PUERTO SIETES
		lda UNI			;
		ani 00001111b		;
		mov L,A			;
		mov A,M			;
		out SIETES+1		;SALIDA DEL REGITRO AL ESPACIO QUE SIGUE DE SIETES+0
		pop H				;
		pop PSW			;
		pop H				;
		ei				; HABILITAR INTERRUPCION 7.5
		ret
ES1001:
		mvi A,0			; REINICIA EL CONTADOR A 0
		jmp DCNT110			; SALTA A LA SUBRUTINA DCNT110 
;------------------------ CONTROLADOR 6.5
;DECREMENTA EL VALOR Y CUANDO ES 0 SALTA A ES2551 Y REEMPLAZA 99 EN EL REGISTRO 99
DCRE1:
		push PSW			; Save A&SR
		push H			;
		lda CONTEO2			; CARGAR REGISTRO
		dcr A				; DECREMENTAR EL REGISTRO
		cpi 255			;
		jz ES2551			; SALTAR SI ES2551 ES 0
DCNT210:
		sta CONTEO2			; ALMACENA EL REGISTRO EN CONTEO2
		lxi H,1000h			; CARGA LOS REGISTROS 1000H EN H
		call BINDEC			; 
		lda DEC			;
		ani 00001111b		; AND LOGICO
		mov L,A			;
		mov A,M			;
		out SIETES+2		;SALIDA DEL REGITRO AL ESPACIO QUE SIGUE DE SIETES+1
		lda UNI			;
		ani 00001111b		;
		mov L,A			;
		mov A,M			;
		out SIETES+3		;SALIDA DEL REGITRO AL ESPACIO QUE SIGUE DE SIETES+2
		pop H				; RECUPERO LOS REGISTROS EN PILA
		pop PSW			; RECUPERO PWS DE LA PILA
		pop H				;
		ei				; HABILITAR INTERRUPCION 6.5
		ret
ES2551:
		mvi A,99			; REINICIA EL CONTADOR EN 99
		jmp DCNT210			;SALTA A LA SUBRUTINA DCNT210 



;------------------------ CONTROLADOR 5.5
;INCREMENTA LOS VALORES Y CUANDO ES 99 VA A ES3000 Y REEMPLAZA 0 EN EL REGISTRO A
ASCE2:
		push PSW			; Save A&SR
		push H			;
		lda CONTEO3			; CARGAR REGISTRO
		inr A				; INCREMENTAR EL REGISTRO
		cpi 100			; COMPRARAR SI ES IGUAL A 99
		jz ES3000			; SALTAR SI ES3000 ES 0


DCNT310:
		sta CONTEO3			; ALMACENA EL REGISTRO EN CONTEO3
		lxi H,1000h			;
		call BINDEC			;
		lda DEC			;
		ani 00001111b		;
		mov L,A			;
		mov A,M			;
		out SIETES+4		;SALIDA DEL REGITRO AL ESPACIO QUE SIGUE DE SIETES+3
		lda UNI			;
		ani 00001111b		;
		mov L,A			;
		mov A,M			;
		out SIETES+5		;SALIDA DEL REGITRO AL ESPACIO QUE SIGUE DE SIETES+4
		pop H				;
		pop PSW			;
		pop H				;
		ei				; HABILITAR INTERRUPCION 5.5
		ret

ES3000:
		mvi A,0			;
		jmp DCNT310			;


;------------------------ CONTROLADOR TRAP
;DECREMENTA EL VALOR Y CUANDO ES 0 SALTA A ES4000 Y REEMPLAZA 99 EN EL REGISTRO 99
DCRE2:
		push PSW			; Save A&SR
		push H			;
		lda CONTEO4			; CARGA REGISTRO
		dcr A				;
		cpi 255			;
		jz ES4000			;

DCNT410:
		sta CONTEO4			; ALMACENA EL REGISTRO EN CONTEO4
		lxi H,1000h			;
		call BINDEC			;
		lda DEC			;
		ani 00001111b		;
		mov L,A			;
		mov A,M			;
		out SIETES+6		;SALIDA DEL REGITRO AL ESPACIO QUE SIGUE DE SIETES+5
		lda UNI			;
		ani 00001111b		;
		mov L,A			;
		mov A,M			;
		out SIETES+7		;SALIDA DEL REGITRO AL ESPACIO QUE SIGUE DE SIETES+6
		pop H				;
		pop PSW			;
		pop H				;
		ei				;
		ret

ES4000:
		mvi A,99			;
		jmp DCNT410			;




;----------------------------- Binario a ascii
BINDEC:
		push PSW			;
		push B			;

		mvi B,0			; Decenas en 0
BINDEC10:
		cpi 10			; Es el residuo mayor  A-10
		jnc BINDEC20		; o igual a 10?
		ori 00110000b		; Residuo final
		sta UNI			; unidades a ascii.
		mov A,B			; Decenas
		ori 00110000b		; a
		sta DEC			; ascii.
		pop B				;
		pop PSW			;
		ret				;
BINDEC20:
		inr B				; Decenas+1
		sui 10			; Residuo-10
		jmp BINDEC10		; Otra vez
