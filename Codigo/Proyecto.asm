.model small
.data
proyecto DB 'PROYECTO 1$'
centenas DB ?
decenas DB ?
unidades DB ? 
.stack
.code

;Iniciar programa

	programa:

	;imprimir ejercicio y leer primer ejercicio
	MOV DX, offset proyecto
	MOV AH, 09h
	INT 21h

	;Enter
	MOV DL, 0Ah
	MOV AH, 02h
	INT 21h

	;leer el numero
	MOV AH, 01h
	INT 21h
	SUB AL, 30h
	MOV centenas, AL

	MOV AH, 01h
	INT 21h
	SUB AL, 30h
	MOV decenas, AL

	MOV AH, 01h
	INT 21h
	SUB AL, 30h
	MOV unidades, AL

	;Finalizar programa
	Fin:
	MOV AH,4CH			    
	INT 21h  

	END programa