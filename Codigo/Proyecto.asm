.model small
.data
;Cadenas de texto
proyecto DB 'PROYECTO 1$'
pedirNum DB 'Ingrese un número entre 1 y 100 en el siguiente formato: ###$'
errorNum DB 'Este número está fuera del rango aceptado (1-100)$'
coordenada DB 'Los números solicitados y coordenadas son: $'
;Numeros para leer y el total
centenas DB ?
decenas DB ?
unidades DB ? 
total DB ?
;Variables para las coordenadas y contador
cInicial DB 01h
nActual DB 00h
coordenadaX DB 00h
coordenadaY DB 00h
.stack
.code

;Iniciar programa

	programa:
		MOV AX, @DATA
		MOV DS, AX

		;imprimir ejercicio y leer primer ejercicio
		MOV DX, offset proyecto
		MOV AH, 09h
		INT 21h

		;Enter
		MOV DL, 0Ah
		MOV AH, 02h
		INT 21h
		
		MOV DX, offset pedirNum
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
		CALL sonNumeros

		MOV AH, 01h
		INT 21h
		SUB AL, 30h
		MOV decenas, AL
		CALL sonNumeros

		MOV AH, 01h
		INT 21h
		SUB AL, 30h
		MOV unidades, AL
		CALL sonNumeros
		
		CALL primeraValidacion
	
	;UNIR LOS VALORES PARA FORMAR UN NÚMERO TOTAL
	;Multiplicación de las centenas por cien, decenas por diez y unidades como están, sumarlo todo
	formarNumero:
		XOR AX,AX
		MOV AL, centenas
		MUL 64h
		MOV total, AL
	
		XOR AX,AX
		MOV AL, decenas
		MUL 0Ah
		ADD total, AL
	
		MOV AL, unidades
		ADD total, AL
	
	;Llamar al primer caso
	llamarCasos:
		CALL primerCaso
	
	;VALIDACIÓN DE LOS NÚMEROS
	;Valida que sean caracteres validos entre 0 y 9
	sonNumeros PROC NEAR
		CMP AL, 0h
		JL mostrarError
		CMP AL, 09h
		JG mostrarError
	ret
	sonNumeros ENDP
	
	;Primero ver si las centenas es 0 o 1
	primeraValidacion PROC NEAR
		CMP centenas, 01h
		JE validacionCien
		CMP decenas, 01h
		JNE validacionUnidades
		JGE formarNumero
		JMP mostrarError
	primeraValidacion ENDP
	
	;Validación en el caso que las centenas sea 1, las decenas y unidades deben ser 0
	validacionCien PROC NEAR
		CMP decenas, 01h
		JGE mostrarError
		CMP unidades, 01h
		JGE mostrarError
		JMP formarNumero
	validacionCien ENDP
	
	;Validacion que no ingrese 000, no seria valido
	validacionUnidades PROC NEAR
		CMP unidades, 01h
		JL mostrarError
		JMP formarNumero
	validacionUnidades ENDP
	
	;Mostrar número ingresado no es correcto
	mostrarError PROC NEAR
		;Enter
		MOV DL, 0Ah
		MOV AH, 02h
		INT 21h
	
		MOV DX, offset errorNum
		MOV AH, 09h
		INT 21h
		JMP Fin
	mostrarError ENDP
	
	;PROCEDIMIENTOS PARA ENCONTRAR LAS COORDENADAS
	;Primer caso: numeros iguales con signo positivo
	primerCaso PROC NEAR
		XOR AX,AX
		MOV AL, coordenadaX
		SUB 01h
		MOV coordenadaX, AL
		
		CALL imprimirActual
		CMP total, 01h
		JL Fin
		
		;Verificacion si sigue en el mismo caso
		MOV AL, cInicial
		NEG AL
		TEST coordenadaX, AL
		JS segundoCaso
		CALL primerCaso
	primerCaso ENDP
	
	;Segundo caso: numeros iguales con signo negativo-positivo
	segundoCaso PROC NEAR
		XOR AX,AX
		MOV AL, coordenadaY
		SUB 01h
		MOV coordenadaY, AL
		
		CALL imprimirActual
		CMP total, 01h
		JL Fin
		
		;Verificacion si sigue en el mismo caso
		MOV AL, cInicial
		NEG AL
		TEST coordenadaY, AL
		JS tercerCaso
		CALL segundoCaso
	segundoCaso ENDP
	
	;Tercer caso: numeros iguales con signo negativo-negativo
	tercerCaso PROC NEAR
		XOR AX,AX
		MOV AL, coordenadaX
		ADD 01h
		MOV coordenadaX, AL
		
		CALL imprimirActual
		CMP total, 01h
		JL Fin
		
		;Verificacion si sigue en el mismo caso
		TEST coordenadaX, cInicial
		JS aumentarUnoX
		CALL tercerCaso
	tercerCaso ENDP
	
	;Cuarto caso: numeros iguales con signo positivo-negativo
	cuartoCaso PROC NEAR
		XOR AX,AX
		MOV AL, coordenadaY
		ADD 01h
		MOV coordenadaY, AL
		
		CALL imprimirActual
		CMP total, 01h
		JL Fin
		
		;Verificacion si sigue en el mismo caso
		TEST coordenadaY, coordenadaX
		JS primerCaso
		CALL cuartoCaso
	cuartoCaso ENDP
	
	aumentarUnoX PROC NEAR 
		XOR AX,AX
		MOV AL, coordenadaX
		ADD 01h
		MOV coordenadaX, AL
		
		XOR AX,AX
		MOV AL, cInicial
		ADD 01h
		MOV cInicial, AL
		
		CALL imprimirActual
		JMP cuartoCaso
	aumentarUnoX ENDP
	
	;IMPRESION NUMEROS Y COORDENADAS
	;Impresion del numero actual
	imprimirActual PROC NEAR
		XOR AX,AX
		MOV AL, total
		SUB 01h
		MOV total, AL
		
		XOR AX,AX
		MOV AL, nActual
		DIV 64h
		
		
	imprimirActual ENDP
	
	;Impresion de la coordenada
	imprimirCoordenada PROC NEAR
		;Abrir parentesis
		MOV DL, 28h
		MOV AH, 02h
		INT 21h
		
		;Coordenada x
		
		;Coma
		MOV DL, 2Ch
		MOV AH, 02h
		INT 21h
		
		;Coordenada y 
		
		;Cerrar parentesis
		MOV DL, 29h
		MOV AH, 02h
		INT 21h
	imprimirCoordenada ENDP
	
	;Finalizar programa
	Fin:
		MOV AH,4CH			    
		INT 21h  

	END programa