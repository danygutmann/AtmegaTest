


#define Line1_Led_alarm PC5			; led für alarm
#define Line1_Led_ok PC4			; led für alles ist gut
#define Line1_Sensor PD7			; eingang alarm
#define System_reset PD6			; eingang reset

init:
	; Ausgänge - der rest ist automatisch ein Eingang   
	ldi r16, 1<<Line1_Led_alarm | 1<<Line1_Led_ok
    out DDRC, r16     
	
	; setzen der internen pull-up widerstände
	ldi r16, 1<<Line1_Sensor | 1<<System_reset 
	out PORTD, r16    
	rjmp startupAndReset

loop:
	sbis PIND, Line1_Sensor			; wenn sensor high
	rcall loop_alarm				; springe in Alarmschleife
	rjmp loop


loop_alarm:							; wird im alarmfall aufgerufen
	cbi PORTC, Line1_Led_ok			; Alles ok aus
	sbi PORTC, Line1_Led_alarm		; Alarmleuchte an
	rcall timer						; pause
	cbi PORTC, Line1_Led_alarm		; alarm blink aus
	rcall timer						; pause

	sbis PIND, System_reset			; wenn reset high
	rjmp startupAndReset			; springe zum Reset

	rjmp loop_alarm

startupAndReset:
	sbi PORTC, Line1_Led_ok			; Alles ok an
	cbi PORTC, Line1_Led_alarm		; Alarm LED aus
	rjmp loop

timer:
    ldi r16,0                   
    ldi r17,0
    ldi r18,1

timer2:
    inc r16                    
    brne timer2					
    inc r17                    
    brne timer2					
    dec r18	
    brne timer2
    ret   
