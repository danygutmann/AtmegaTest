


#define Line1_Led_alarm PC5			;led für alarm
#define Line1_Led_ok PC4			;led für alles ist gut
#define Line1_Sensor PD7
#define System_reset PC6

init:
	; Ausgänge - der rest ist automatisch ein Eingang   
	ldi r16, 1<<Line1_Led_alarm | 1<<Line1_Led_ok
    out DDRC, r16     
	
	; setzen der internen pull-up widerstände
	ldi r16, 1<<Line1_Sensor 
	out PORTD, r16        

	rjmp startup

loop:
	sbi PORTC, Line1_Led_ok			;Alles ok an
	cbi PORTC, Line1_Led_alarm		;Alarm LED aus
	sbis PIND, Line1_Sensor
	rcall alarm1

	rjmp loop

startup:
	sbi PORTC, Line1_Led_ok			;Alles ok an
	cbi PORTC, Line1_Led_alarm		;Alarm LED aus

	rjmp loop

; wird im alarmfall aufgerufen
alarm:
	cbi PORTC, Line1_Led_ok			;Alles ok aus
	sbi PORTC, Line1_Led_alarm		;Alarmleuchte an
	rjmp loop