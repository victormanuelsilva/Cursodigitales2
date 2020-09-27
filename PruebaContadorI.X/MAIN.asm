    LIST p=16F887
    INCLUDE <P16F887.INC>

; CONFIG1
; __config 0xF0F1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

    
;***** VARIABLE DEFINITIONS

v1 EQU 0x27
v2 EQU 0x20
temporal EQU 0x21
unidad EQU 0x22
v3 EQU 0x23
limite equ 0x24
inverso equ 0x25
cont equ 0x26

    ORG 0x00 ; Inicio de programa
    goto init
 ;**** Configurar el puerto****
init
	bsf STATUS,RP0
	bcf STATUS,RP1
	movlw b'00101000'
	movwf OPTION_REG
	bsf STATUS,5 ; Cambia al Banco 1
	movlw 00h ; Configura los pines del puerto B ...
	movwf TRISB ; ...como salidas.
	movwf TRISC ; ...como salidas.

	bcf STATUS,5 ; Vuelve al Banco 0
	movlw 00h ; Configura nuestro registro w con 02h
	movwf PORTB ; ...como salidas.
	movwf PORTC ; ...como salidas.
	movlw b'00111111'
	movwf PORTC
	movlw b'01001111'
	movwf PORTB
	clrf TMR0

MAIN
	MOVLW b'00000000'
	MOVWF cont
	MOVLW b'00011110'
	MOVWF inverso
	MOVFW TMR0
	SUBWF inverso,f
	MOVWF temporal
	MOVLW B'00011110'
	MOVWF limite
	XORWF temporal
	BTFSS STATUS,Z
	GOTO MOSTRAR
	MOVLW b'01001111'
	MOVWF PORTC
	MOVLW b'00111111'
	MOVWF PORTB
	CLRF TMR0
	GOTO MAIN	

MOSTRAR
	MOVLW b'00001010'
	MOVWF unidad
	SUBWF inverso,F
	BTFSC STATUS,C
	GOTO $+.4
	CALL DISPLAY_PORTB
	MOVWF PORTB
	GOTO $+.3
	INCF cont,F
	GOTO $-.9
	MOVFW unidad
	ADDWF inverso,W
	CALL DISPLAY_PORTC
	MOVWF PORTC
	CALL RETARDO
	GOTO MAIN
	
;--------------------------------------------------------------------------
; NUMBERIC LOOKUP TABLE FOR 7 SEG
;--------------------------------------------------------------------------
DISPLAY_PORTC
	ADDWF PCL,f
	RETLW 3Fh ; //Hex value to display the number 0.
	RETLW 06h ; //Hex value to display the number 1.
	RETLW 5Bh ; //Hex value to display the number 2.
	RETLW 4Fh ; //Hex value to display the number 3.
	RETLW 66h ; //Hex value to display the number 4.
	RETLW 6Dh ; //Hex value to display the number 5.
	RETLW 7Ch ; //Hex value to display the number 6.
	RETLW 07h ; //Hex value to display the number 7.
	RETLW 7Fh ; //Hex value to display the number 8.
	RETLW 6Fh ; //Hex value to display the number 9.
;**** Aquí está nuestra subrutina

DISPLAY_PORTB
	MOVFW cont
	ADDWF PCL,F
	RETLW 3Fh ; //Hex value to display the number 0.
	RETLW 06h ; //Hex value to display the number 1.
	RETLW 5Bh ; //Hex value to display the number 2.
	RETLW 4Fh ; //Hex value to display the number 3.
	RETLW 66h ; //Hex value to display the number 4.
	RETLW 6Dh ; //Hex value to display the number 5.
	RETLW 7Ch ; //Hex value to display the number 6.
	RETLW 07h ; //Hex value to display the number 7.
	RETLW 7Fh ; //Hex value to display the number 8.
	RETLW 6Fh ; //Hex value to display the number 9.
RETARDO
    movlw d'10'
    movwf v3
    movlw d'100'
    movwf v2
    movlw d'250'
    movwf v1
    nop
    decfsz v1,f
    goto $-.2
    decfsz v2,f
    goto $-.6
    decfsz v3,f
    goto $-.10
    return
END