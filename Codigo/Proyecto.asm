﻿.model small
.data
iproyecto DB 'PROYECTO 1: Ingrese un numero entre 1 y 100, siguiendo el formato ###$'
errorNum DB 'Este numero no es valido$'
pruebaNum DB 'El numero es valido$'
primera DB '(0,0)$'
segunda DB '(1,0)$'
tercera DB '(1,1)$'
coordenadaX DB 01h
coordenadaY DB 01h
bandera DB 01h
contador DB 01h
residuoA DB ?
resi DB ?
diez DB 0Ah
centenas DB ?
decenas DB ?
unidades DB ? 
total DB ?
.stack
.code

;Iniciar programa

	programa:
	MOV AX, @DATA
	MOV DS, AX

	;imprimir ejercicio y leer primer ejercicio
	MOV DX, offset iproyecto
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
	
	;Formar el número
	formarNumero:
	XOR AX,AX
	MOV AL, 64h
	MUL centenas
	MOV total, AL
	
	XOR AX,AX
	MOV AL, 0Ah
	MUL decenas
	ADD total, AL
	
	MOV AL, unidades
	ADD total, AL

	CMP total, 00h
	JG llamarCasos
	JMP llamarFinal		
	
	;LLAMAR CASOS
	llamarCasos proc near
	CALL imprimirEnter
	
	;imprimir primera coordenada
	CALL imprimirActual
	MOV DX, offset primera
	MOV AH, 09h
	INT 21h
	
	CALL restaTotal
	JLE llamarFinal
	CALL imprimirEnter

	;imprimir segunda coordenada
	CALL imprimirActual
	MOV DX, offset segunda
	MOV AH, 09h
	INT 21h

	CALL restaTotal
	JLE llamarFinal
	CALL imprimirEnter
	
	;imprimir tercera coordenada
	CALL imprimirActual
	MOV DX, offset tercera
	MOV AH, 09h
	INT 21h

	CALL restaTotal
	JLE llamarFinal	
	JMP primerCasoResta
	
	llamarCasos endp	
	
	;ENTER
	imprimirEnter proc near
		MOV DL, 0Ah
		MOV AH, 02h
		INT 21h
	ret
	imprimirEnter endp	
	
	;RESTAR
	restaTotal proc near
		MOV BH, total
		SUB BH, 01h
		MOV total, BH
	ret
	restaTotal endp

	;LLAMAR FINAL	
	llamarFinal:
		JMP Fin

	;PRIMER CASO
	primerCasoResta proc near
		XOR AX,AX
		MOV AL, coordenadaX
		SUB AL, 01h
		DIV diez
		MOV coordenadaX, AH
		
		CALL imprimirCoordenada
		CALL restaTotal
		JLE llamarFinal
		
		CMP coordenadaX, 01h
		JL primerCasoSuma
		JMP primerCasoResta
	primerCasoResta endp	
	
	primerCasoSuma proc near
		XOR AX,AX
		MOV AL, coordenadaX
		ADD AL, 01h
		DIV diez
		MOV coordenadaX, AH

		CALL imprimirCoordenadaN
		CALL restaTotal
		JLE llamarFinal

		XOR AX, AX
		MOV AL, bandera
		CMP coordenadaX, AL
		JE segundoCasoResta
		JMP primerCasoSuma
	primerCasoSuma endp	

	segundoCasoResta proc near
		XOR AX,AX
		MOV AL, coordenadaY
		SUB AL, 01h
		DIV diez
		MOV coordenadaY, AH
		
		CALL imprimirCoordenadaN
		CALL restaTotal
		JLE llamarFinal
		
		CMP coordenadaY, 01h
		JL segundoCasoSuma
		JMP segundoCasoResta
	segundoCasoResta endp
	
	lPrimerCasoResta:
		JMP primerCasoResta

	segundoCasoSuma proc near
		XOR AX,AX
		MOV AL, coordenadaY
		ADD AL, 01h
		DIV diez
		MOV coordenadaY, AH

		CALL imprimirCoordenadaNN
		CALL restaTotal
		JLE llamarFinal

		XOR AX, AX
		MOV AL, bandera
		CMP coordenadaY, AL
		JE tercerCasoResta
		JMP segundoCasoSuma
	segundoCasoSuma endp	
	
	tercerCasoResta proc near
		XOR AX,AX
		MOV AL, coordenadaX
		SUB AL, 01h
		DIV diez
		MOV coordenadaX, AH
		
		CALL llamarImpresion
		CALL restaTotal
		JLE llamarFin2
		
		CMP coordenadaX, 01h
		JL tercerCasoSuma
		JMP tercerCasoResta
	tercerCasoResta endp	

	tercerCasoSuma proc near
		XOR AX,AX
		MOV AL, coordenadaX
		ADD AL, 01h
		DIV diez
		MOV coordenadaX, AH
		
		CALL imprimirCoordenadaaN
		CALL restaTotal
		JLE llamarFin2
		
		XOR AX, AX
		MOV AL, bandera
		CMP coordenadaX, AL
		JE aumentarBandera
		JMP tercerCasoSuma
	tercerCasoSuma endp	

	llamarFin2:
		JMP Fin	

	aumentarBandera proc near
		XOR AX,AX
		MOV AL, bandera
		ADD AL, 01h
		DIV diez
		MOV bandera, AH
		MOV coordenadaX, AH

		CALL imprimirCoordenadaaN
		CALL restaTotal
		JLE llamarFin4
		
		CMP bandera, 02h
		JE intermedio
		JMP cuartoCasoResta
	aumentarBandera endp
	
	intermedio proc near
		XOR AX,AX
		MOV AL, coordenadaY
		SUB AL, 01h
		DIV diez
		MOV coordenadaY, AH
		
		CALL imprimirCoordenada
		CALL restaTotal
		JLE llamarFin4
		JMP cuartoCasoSuma
	intermedio endp

	llamarPrimerCasoResta:
		JMP lPrimerCasoResta

	cuartoCasoResta proc near
		XOR AX,AX
		MOV AL, coordenadaY
		SUB AL, 01h
		DIV diez
		MOV coordenadaY, AH
		
		CALL llamarImprimirCoor
		CALL restaTotal
		JLE llamarFin4

		CMP coordenadaY, 01h
		JE intermedio
		JMP cuartoCasoResta
	cuartoCasoResta endp

	cuartoCasoSuma proc near
		XOR AX,AX
		MOV AL, coordenadaY
		ADD AL, 01h
		DIV diez
		MOV coordenadaY, AH
		
		CALL imprimirCoordenada
		CALL restaTotal
		JLE llamarFin4
		
		XOR AX, AX
		MOV AL, bandera
		CMP coordenadaY, AL
		JE llamarPrimerCasoResta
		JMP cuartoCasoSuma
	cuartoCasoSuma endp		

	llamarFin4:
		JMP Fin

	;IMPRIMIR NUMEROS Y PARENTESIS
	imprimirCoordenada proc near 
		CALL imprimirEnter
		CALL imprimirActual
		;parentesis
		XOR DX, DX
		MOV DL, 28h
		MOV AH, 02h
		INT 21h
		
		XOR DX, DX
		MOV DL, coordenadaX
		ADD DL, 30h
		MOV AH, 02h
		INT 21h

		;Coma
		XOR DX, DX
		MOV DL, 2Ch
		MOV AH, 02h
		INT 21h
		
		XOR DX, DX
		MOV DL, coordenadaY
		ADD DL, 30h
		MOV AH, 02h
		INT 21h

		;parentesis
		XOR DX, DX
		MOV DL, 29h
		MOV AH, 02h
		INT 21h
	ret
	imprimirCoordenada endp

	llamarFin3:
		JMP Fin	

	llamarImpresion proc near
		CMP coordenadaY, 01h
		JLE llamarImpresion2
		JG imprimirCoordenadaNN
	ret
	llamarImpresion endp

	llamarImprimirCoor proc near
		CALL imprimirCoordenadaaN
	ret
	llamarImprimirCoor endp	

	imprimirCoordenadaN proc near 
		CALL imprimirEnter
		CALL imprimirActual
		;parentesis
		XOR DX, DX
		MOV DL, 28h
		MOV AH, 02h
		INT 21h

		;menos
		XOR DX, DX
		MOV DL, 2Dh
		MOV AH, 02h
		INT 21h	

		XOR DX, DX
		MOV DL, coordenadaX
		ADD DL, 30h
		MOV AH, 02h
		INT 21h

		;Coma
		XOR DX, DX
		MOV DL, 2Ch
		MOV AH, 02h
		INT 21h
		
		XOR DX, DX
		MOV DL, coordenadaY
		ADD DL, 30h
		MOV AH, 02h
		INT 21h

		;parentesis
		XOR DX, DX
		MOV DL, 29h
		MOV AH, 02h
		INT 21h
	ret
	imprimirCoordenadaN endp
	
	llamarImpresion2 proc near
		JMP imprimirCoordenadaaN
	ret
	llamarImpresion2 endp
	
	imprimirCoordenadaNN proc near 
		CALL imprimirEnter
		CALL imprimirActual
		;parentesis
		XOR DX, DX
		MOV DL, 28h
		MOV AH, 02h
		INT 21h

		;menos
		XOR DX, DX
		MOV DL, 2Dh
		MOV AH, 02h
		INT 21h	

		XOR DX, DX
		MOV DL, coordenadaX
		ADD DL, 30h
		MOV AH, 02h
		INT 21h

		;Coma
		XOR DX, DX
		MOV DL, 2Ch
		MOV AH, 02h
		INT 21h
		
		;menos
		XOR DX, DX
		MOV DL, 2Dh
		MOV AH, 02h
		INT 21h

		XOR DX, DX
		MOV DL, coordenadaY
		ADD DL, 30h
		MOV AH, 02h
		INT 21h

		;parentesis
		XOR DX, DX
		MOV DL, 29h
		MOV AH, 02h
		INT 21h
	ret
	imprimirCoordenadaNN endp

	imprimirCoordenadaaN proc near 
		CALL imprimirEnter
		CALL imprimirActual
		;parentesis
		XOR DX, DX
		MOV DL, 28h
		MOV AH, 02h
		INT 21h

		XOR DX, DX
		MOV DL, coordenadaX
		ADD DL, 30h
		MOV AH, 02h
		INT 21h

		;Coma
		XOR DX, DX
		MOV DL, 2Ch
		MOV AH, 02h
		INT 21h
		
		;menos
		XOR DX, DX
		MOV DL, 2Dh
		MOV AH, 02h
		INT 21h

		XOR DX, DX
		MOV DL, coordenadaY
		ADD DL, 30h
		MOV AH, 02h
		INT 21h

		;parentesis
		XOR DX, DX
		MOV DL, 29h
		MOV AH, 02h
		INT 21h
	ret
	imprimirCoordenadaaN endp
	
	imprimirActual proc near
		XOR AX, AX
		MOV AL, contador
		MOV BL, 64h
		DIV BL

		MOV residuoA, AH

		MOV DL, AL
		ADD DL, 30h
		MOV AH, 02h
		INT 21h

		XOR AX, AX
		MOV AL, residuoA
		MOV BL, diez
		DIV BL

		MOV residuoA, AH
	
		MOV DL, AL
		ADD DL, 30h
		MOV AH, 02h
		INT 21h
	
		MOV DL, residuoA
		ADD DL, 30h
		MOV AH, 02h
		INT 21h

		;Space
		XOR DX, DX
		MOV DL, 20h
		MOV AH, 02h
		INT 21h

		;Flecha
		XOR DX, DX
		MOV DL, 3Eh
		MOV AH, 02h
		INT 21h

		;Space
		XOR DX, DX
		MOV DL, 20h
		MOV AH, 02h
		INT 21h

		XOR AX, AX 
		MOV AL, contador
		ADD AL, 01h
		MOV contador, AL
	ret
	imprimirActual endp	

	;LLAMAR FORMAR NUMERO
	llamarFormarNumero:
		JMP formarNumero

	;VALIDACIÓN DE LOS NÚMEROS
	sonNumeros proc near
		CMP AL, 00h
		JL mostrarError
		CMP AL, 09h
		JG mostrarError
	ret
	sonNumeros endp
	
	;Primero ver si las centenas es 0 o 1
	primeraValidacion proc near
		CMP centenas, 01h
		JE validacionCien
		CMP decenas, 01h
		JL validacionUnidades
		JGE llamarFormarNumero
		JMP mostrarError
	primeraValidacion endp
	
	;Validación en el caso que las centenas sea 1, las decenas y unidades deben ser 0
	validacionCien proc near
		CMP decenas, 01h
		JGE mostrarError
		CMP unidades, 01h
		JGE mostrarError
		JMP formarNumero
	validacionCien endp

	;Validación en el caso que las centenas y decenas sean 0, unidades tiene que ser mínimo 1
	validacionUnidades proc near
		CMP unidades, 01h
		JL mostrarError
		JMP formarNumero
	validacionUnidades endp

	;Mostrar número ingresado no es correcto
	mostrarError proc near
		;Enter
		MOV DL, 0Ah
		MOV AH, 02h
		INT 21h

		MOV DX, offset errorNum
		MOV AH, 09h
		INT 21h
		JMP Fin
	mostrarError endp

	;Finalizar programa
	Fin:
		MOV AH,4CH			    
		INT 21h  

	END programa