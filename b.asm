%macro impr_texto 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro
;-------------------------  MACRO #4  ----------------------------------
;Macro-4: leer stdin_termios.
;	Captura la configuracion del stdin
;	recibe 2 parametros:
;		%1 es el valor de stdin
;		%2 es el valor de termios
;-----------------------------------------------------------------------
%macro read_stdin_termios 2
        push rax
        push rbx
        push rcx
        push rdx

        mov eax, 36h
        mov ebx, %1
        mov ecx, 5401h
        mov edx, %2
        int 80h

        pop rdx
        pop rcx
        pop rbx
        pop rax
%endmacro
;------------------------- FIN DE MACRO --------------------------------


;-------------------------  MACRO #5  ----------------------------------
;Macro-5: escribir stdin_termios.
;	Captura la configuracion del stdin
;	recibe 2 parametros:
;		%1 es el valor de stdin
;		%2 es el valor de termios
;-----------------------------------------------------------------------
%macro write_stdin_termios 2
        push rax
        push rbx
        push rcx
        push rdx

        mov eax, 36h
        mov ebx, %1
        mov ecx, 5402h
        mov edx, %2
        int 80h

        pop rdx
        pop rcx
        pop rbx
        pop rax
%endmacro
;------------------------- FIN DE MACRO --------------------------------

%macro canonical_off 2
	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
        read_stdin_termios stdin,termios

	;Se escribe el nuevo valor de ICANON en EAX, para apagar el modo canonico
        push rax
        mov eax, %1
        not eax
        and [%2 + 12], eax
        pop rax

	;Se escribe la nueva configuracion de TERMIOS
        write_stdin_termios stdin,termios
%endmacro

%macro canonical_on 2

	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
	read_stdin_termios stdin,termios

        ;Se escribe el nuevo valor de modo Canonico
        or dword [%2 + 12], %1

	;Se escribe la nueva configuracion de TERMIOS
        write_stdin_termios stdin,termios
%endmacro
;-------------------------  MACRO #2  ----------------------------------
;Macro-2: leer_texto.
;	Lee un mensaje desde teclado y se almacena en la variable que se
;	pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion de memoria donde se guarda el texto
;		%2 es la cantidad de bytes a guardar
;-----------------------------------------------------------------------
%macro leer_texto 2 	;recibe 2 parametros
	mov rax,0	;sys_read
	mov rdi,0	;std_input
	mov rsi,%1	;primer parametro: Variable
	mov rdx,%2	;segundo parametro: Tamano 
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------

%macro limpiar_pantalla 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: caracteres especiales para limpiar la pantalla
	mov rdx,%2	;segundo parametro: Tamano 
	syscall
%endmacro

section .data
	;configuraciones iniciales
	limpiar    db 0x1b, "[2J", 0x1b, "[H" ;limpiar pantalla
	limpiar_tam equ $ - limpiar
	italic   db  0x1b, "[3m", 
	italic_tam  equ $ - italic
	Letra   db  0x1b, "[30m", 
	Letra_tam  equ $ - Letra
	Fondo   db  0x1b, "[47m", 
	Fondo_tam  equ $ - Fondo
	
	;posiciones importantes para ser actualizadas
	Pos_vidas db 0x1b, "[23;43f"
	Pos_vidas_tam equ $ - Pos_vidas
	
	Pos_inicial db 0x1b, "[1B"   
	Pos_inicial_tam equ $ - Pos_inicial

	;posiciòn de las filas para bloques en la segunda pantalla 
	Pos_f1 db 0x1b, "[2;1f"  
	Pos_f2 db 0x1b, "[3;1f"
	Pos_f3 db 0x1b, "[4;1f"
	
	;posiciones de cada bloque 
	Pos_b1 db 0x1b, "[2;2f"
	tam_p equ $ - Pos_b1
	Pos_b2 db 0x1b, "[3;2f"
	tam_p2 equ $ - Pos_b2
	Pos_b3 db 0x1b, "[4;2f"
	tam_p3 equ $ - Pos_b3
	Pos_b4 db 0x1b, "[2;12f"
	tam_p4 equ $ - Pos_b4
	Pos_b5 db 0x1b, "[3;12f"
	tam_p5 equ $ - Pos_b5
	Pos_b6 db 0x1b, "[4;12f"
	tam_p6 equ $ - Pos_b6
	Pos_b7 db 0x1b, "[2;22f"
	tam_p7 equ $ - Pos_b7
	Pos_b8 db 0x1b, "[3;22f"
	tam_p8 equ $ - Pos_b8
	Pos_b9 db 0x1b, "[4;22f"
	tam_p9 equ $ - Pos_b9
	Pos_b10 db 0x1b, "[2;32f"
	tam_p10 equ $ - Pos_b10
	Pos_b11 db 0x1b, "[3;32f"
	tam_p11 equ $ - Pos_b11
	Pos_b12 db 0x1b, "[4;32f"
	tam_p12 equ $ - Pos_b12
	Pos_b13 db 0x1b, "[2;42f"
	tam_p13 equ $ - Pos_b13
	Pos_b14 db 0x1b, "[3;42f"
	tam_p14 equ $ - Pos_b14
	Pos_b15 db 0x1b, "[4;42f"
	tam_p15 equ $ - Pos_b15
	Pos_b16 db 0x1b, "[2;52f"
	tam_p16 equ $ - Pos_b16
	Pos_b17 db 0x1b, "[3;52f"
	tam_p17 equ $ - Pos_b17
	Pos_b18 db 0x1b, "[4;52f"
	tam_p18 equ $ - Pos_b18


	Pos db 0x1b, "[25;80f"
	tam_pos equ $ - Pos

	;posiciones de los mensajes para la primera y segunda pantalla
	Posm1 db 0x1b, "[3;29f"
	tam_posm1 equ $ - Posm1
	Posm2 db 0x1b, "[10;13f"
	tam_posm2 equ $ - Posm2
	Posm3 db 0x1b, "[17;25f"
	tam_posm3 equ $ - Posm3
	Posm4 db 0x1b, "[15;1f"
	tam_posm4 equ $ - Posm4
	Posnom db 0x1b, "[18;35f"
	tam_posnom equ $ - Posnom
	Pos_final db 0x1b, "[25;1f"
	tam_final equ $ - Pos_final
		
		


	;Definicion de las lineas especiales de texto
	linea_m1: 	    db 'Bienvenido a Micronoid', 0xa
	tam_m1 equ $ - linea_m1
	linea_m2: 	     	db 'IL-4313-Lab. Estructura de Microprocesadores 2S-20116', 0xa
	tam_m2 equ $ - linea_m2
	linea_m3:	db 'Ingrese el nombre del jugador: ', 0xa
	tam_m3 equ $ - linea_m3

	linea_m4:	db '|                  Presione X para iniciar', 0xa
	tam_m4 equ $ - linea_m4


	linea_blanco: 		db '|                                                            |', 0xa
	
	tamano_linea equ $ - linea_blanco
	linea_techo: 		db '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%', 0xa
	linea_llena: 		db '||########||########||########||########||########||########||', 0xa
	


	linea_gano: 	    db 'Felicidades, juego terminado - Presione Enter', 0xa
	linea_gracias: 	    db 'Gracias por jugar Micronoid', 0xa
	linea_terminar: 	    db 'Presione Enter para terminar', 0xa
	
	linea_perdio: 	    db 'Juego finalizado. Mejor suerte la pròxima vez - Presione Enter', 0xa
	
	linea_perderv: 	    db 'Intento fallido -Pierde una vida', 0xa
	

	juan: db 'Juan Carlos Sanchez 20124727', 0xa
	tamano_juan equ $ - juan
	noel: db '            Noel Perez 2013000570', 0xa
	tamano_noel equ $ - noel
	pablo: db '            Pablo Valenciano 201242320', 0xa
	tamano_pablo equ $ - pablo
	mainor: db '            Mainor Lizano 201165008', 0xa
	tamano_mainor equ $ - mainor

	linea_bloque: 		db '|########|'
	

	linea_bloquen: 		db '          '
	
	vidass: db 'Cantidad de vidas: 3',0xa
	vidas_tam: equ $ - vidass
	vidas2: db 'Cantidad de vidas: 2',0xa
	vidas1: db 'Cantidad de vidas: 1',0xa
	;**********************************************************************************************
	inicial: db 0x1b,"[00;00H"			;set cursor 
	inicial_long: equ $-inicial

	bolita: db 0x1b, "[1m", 48
	bolita_long: equ $-bolita

	espacio: db ' '
	espacio_long: equ $-espacio

	movx: db 0x1b, "[1C"				;mov a los lados
	movx_long: equ $-movx

	movy: db 0x1b, "[1E"				;mov. hacia abajo
	movy_long: equ $-movy

	cond: db 0
	
	espaciox: db '    ' 
	long_espaciox: equ $-espaciox
	;**********************************************************************************************
	
	;Definicion de constantes para manejar el modo canonico y el echo
	termios:	times 36 db 0	;Estructura de 36bytes que contiene el modo de operacion de la consola
	stdin:		equ 0		;Standard Input (se usa stdin en lugar de escribir manualmente los valores)
	ICANON:		equ 1<<1	;ICANON: Valor de control para encender/apagar el modo canonico
	ECHO:           equ 1<<3	;ECHO: Valor de control para encender/apagar el modo de eco

	

        

;--------------------Declaracion de funciones y utilidades ---------------------------------------------

;####################################################
;canonical_off
;Esta es una funcion que sirve para apagar el modo canonico en Linux
;Cuando el modo canonico se apaga, Linux NO espera un ENTER para
;procesar lo que se captura desde el teclado, sino que se hace de forma
;directa e inmediata
;
;Para apagar el modo canonico, simplemente use: call canonical_off
;###################################################
ccanonical_off:

	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
        call rread_stdin_termios

	;Se escribe el nuevo valor de ICANON en EAX, para apagar el modo canonico
        push rax
        mov eax, ICANON
        not eax
        and [termios+12], eax
	     pop rax

	;Se escribe la nueva configuracion de TERMIOS
        call wwrite_stdin_termios
        ret
        ;Final de la funcion
;###################################################


;####################################################
;echo_off
;Esta es una funcion que sirve para apagar el modo echo en Linux
;Cuando el modo echo se apaga, Linux NO muestra en la pantalla la tecla que
;se acaba de presionar.
;
;Para apagar el modo echo, simplemente use: call echo_off
;###################################################
eecho_off:

	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
        call rread_stdin_termios

        ;Se escribe el nuevo valor de ECHO en EAX para apagar el echo
        push rax
        mov eax, ECHO
        not eax
        and [termios+12], eax
        pop rax

	;Se escribe la nueva configuracion de TERMIOS
        call wwrite_stdin_termios
        ret
        ;Final de la funcion
;###################################################


;####################################################
;canonical_on
;Esta es una funcion que sirve para encender el modo canonico en Linux
;Cuando el modo canonico se enciende, Linux espera un ENTER para
;procesar lo que se captura desde el teclado
;
;Para encender el modo canonico, simplemente use: call canonical_on
;###################################################
ccanonical_on:

	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
        call rread_stdin_termios

        ;Se escribe el nuevo valor de modo Canonico
        or dword [termios+12], ICANON
	;Se escribe la nueva configuracion de TERMIOS
        call wwrite_stdin_termios
        ret
        ;Final de la funcion
;###################################################


;####################################################
;echo_on
;Esta es una funcion que sirve para encender el echo en Linux
;Cuando el echo se enciende, Linux muestra en la pantalla (stdout) cada tecla
;que se recibe del teclado (stdin)
;
;Para encender el modo echo, simplemente use: call echo_on
;###################################################
eecho_on:

	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
        call rread_stdin_termios

        ;Se escribe el nuevo valor de modo echo
        or dword [termios+12], ECHO

	;Se escribe la nueva configuracion de TERMIOS
        call wwrite_stdin_termios
        ret
        ;Final de la funcion
;###################################################


;####################################################
;read_stdin_termios
;Esta es una funcion que sirve para leer la configuracion actual del stdin o 
;teclado directamente de Linux
;Esta configuracion se conoce como TERMIOS (Terminal Input/Output Settings)
;Los valores del stdin se cargan con EAX=36h y llamada a la interrupcion 80h
;
;Para utilizarlo, simplemente se usa: call read_stdin_termios
;###################################################
rread_stdin_termios:
        push rax
        push rbx
        push rcx
        push rdx

        mov eax, 36h
        mov ebx, stdin
        mov ecx, 5401h
        mov edx, termios
        int 80h

        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret
        ;Final de la funcion
;###################################################


;####################################################
;write_stdin_termios
;Esta es una funcion que sirve para escribir la configuracion actual del stdin o 
;teclado directamente de Linux
;Esta configuracion se conoce como TERMIOS (Terminal Input/Output Settings)
;Los valores del stdin se cargan con EAX=36h y llamada a la interrupcion 80h
;
;Para utilizarlo, simplemente se usa: call write_stdin_termios
;###################################################
wwrite_stdin_termios:
        push rax
        push rbx
        push rcx
        push rdx

        mov eax, 36h
        mov ebx, stdin
        mov ecx, 5402h
        mov edx, termios
        int 80h

        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret
        ;Final de la funcion
;###################################################
;segmento de datos no-inicializados, que se pueden usar para capturar variables 
;del usuario, por ejemplo: desde el teclado
section .bss
	tecla_capturada: resb 1
	Nombre_jugador: resb 15
	vidas: resb 2
	intro: resb 15
	bloque1: resb 1                 
	bloque2: resb 1                 
	bloque3: resb 1                 
	bloque4: resb 1                 
	bloque5: resb 1                 
	bloque6: resb 1                 
	bloque7: resb 1                 
	bloque8: resb 1                 
	bloque9: resb 1                 
	bloque10: resb 1                 
	bloque11: resb 1                 
	bloque12: resb 1                 
	bloque13: resb 1                 
	bloque14: resb 1                 
	bloque15: resb 1                 
	bloque16: resb 1                 
	bloque17: resb 1                 
	bloque18: resb 1         
	lsup: resb 2         
      

section .text
	global _start		;Definicion de la etiqueta inicial

_start:                         ;poner luego de presionar x, pantalla 2
	%assign bloque1 1            ; valores iniciales de booleanos
	%assign bloque2 1            
	%assign bloque3 1            
	%assign bloque4 1            
	%assign bloque5 1           
	%assign bloque6 1            
	%assign bloque7 1            
	%assign bloque8 1            
	%assign bloque9 1            
	%assign bloque10 1           
	%assign bloque11 1           
	%assign bloque12 1           
	%assign bloque13 1           
	%assign bloque14 1           
	%assign bloque15 1           
	%assign bloque16 1           
	%assign bloque17 1           
	%assign bloque18 1        

	%assign vidas 3        ;valor inicial de las vidas 
  	%assign lsup 5          ;valor inicial del limmite superior 
         
  	
	;Limpiar la pantalla
	limpiar_pantalla limpiar,limpiar_tam

	_Primera_Pantalla:
		impr_texto italic,italic_tam  ;se carga la configuraciòn
		impr_texto Fondo,Fondo_tam
		impr_texto Letra,Letra_tam
		
		impr_texto Posm1, tam_posm1		; se posicionan e imprimen los 3 msjs iniciales
		impr_texto linea_m1, tam_m1

		impr_texto Posm2, tam_posm2
		impr_texto linea_m2, tam_m2

		impr_texto Posm3, tam_posm3
		impr_texto linea_m3, tam_m3

		impr_texto Posnom, tam_posnom
		leer_texto Nombre_jugador,15     ; se recive el nombre del jugador
;********************************************** se limpian la pantalla, inicia la de juego 
	_Segunda_Pantalla:
		limpiar_pantalla limpiar,limpiar_tam 	;Limpiar la pantalla
		canonical_off ICANON,termios            ;Apagar el modo canonico
		call eecho_off                           ;apagar el modo ECHO
		impr_texto linea_techo,tamano_linea
		mov r8,0
		loop_1:
			impr_texto linea_blanco,tamano_linea  ;una altura de 20 espacios
			inc r8
			cmp r8, 20
			jne loop_1
		impr_texto linea_techo,tamano_linea      ; el fondo del escenario de juego
		impr_texto Nombre_jugador,15			 
		impr_texto Pos_vidas,Pos_vidas_tam		; ubica el cursor para imprimir las vidas 
		impr_texto vidass, vidas_tam
		impr_texto Pos_f1, tam_p                  ; posicioan las finasl en las que se imprimen los bloques en la primera pantalla
		impr_texto linea_llena, tamano_linea
		impr_texto Pos_f2, tam_p2
		impr_texto linea_llena, tamano_linea
		impr_texto Pos_f3, tam_p3
		impr_texto linea_llena, tamano_linea
		
	
		

_leer_opcion:
		impr_texto Posm4, tam_posm4
		impr_texto linea_m4, tam_m4               ;se imprime el msj de presionar x

		impr_texto Pos_final, tam_final

		leer_texto tecla_capturada,1
		mov al,[tecla_capturada]
		cmp  al , 'x'               ;aqui se comprueba que la tecla capturada es una "x"
		jne _leer_opcion				
		impr_texto Posm4, tam_posm4
		impr_texto linea_blanco,tamano_linea   ; se borra esa linea luego de presionar x
_Comparaciones:                                ;modulo encargado de actualizar los bloques, vidas y pantallas de ganar o perder

		_com_vidas:                                ;actualiza vidas y en caso de perder temrina el programa
			_compv3:
	            mov r14, vidas
	            cmp r14, 3
	            jne _compv2
	            impr_texto Pos_vidas,Pos_vidas_tam
	            impr_texto vidass, vidas_tam
	            jmp _com_ganar
	        _compv2:
	            mov r14, vidas
	            cmp r14, 2
	            jne _compv1
	            impr_texto Pos_vidas,Pos_vidas_tam
	            impr_texto vidas2, vidas_tam
	            jmp _com_ganar
	        _compv1:
	            mov r14, vidas
	            cmp r14, 0
	            je _perder
	            impr_texto Pos_vidas,Pos_vidas_tam
	            impr_texto vidas1, vidas_tam
	            jmp _com_ganar

	       _perder:
	       		limpiar_pantalla limpiar,limpiar_tam 	;Limpiar la pantalla
				canonical_on ICANON,termios;Recuperar el modo canonico
				impr_texto Posm2, tam_posm2
				impr_texto linea_perdio, 63
				leer_texto intro,15     ; se recive la tecla Enter
				limpiar_pantalla limpiar,limpiar_tam 	;Limpiar la pantalla
				jmp _salir                            ;salta a limpiar los registros 


		
		_com_ganar:                                    ;lògica combinacional si todos los bloques estàn en 0 el jugador ganò
			mov r14, bloque1
			cmp r14, 0
			jne _comp1
			mov r14, bloque1
			mov r10, bloque2
			cmp r14, r10
			jne _comp1			 
			mov r14, bloque2
			mov r10, bloque3
			cmp r14, r10
			jne _comp1
			mov r14, bloque3
			mov r10, bloque4
			cmp r14, r10
			jne _comp1
			mov r14, bloque4
			mov r10, bloque5
			cmp r14, r10
			jne _comp1
			mov r14, bloque5
			mov r10, bloque6
			cmp r14, r10
			jne _comp1
			mov r14, bloque6
			mov r10, bloque7
			cmp r14, r10
			jne _comp1
			mov r14, bloque7
			mov r10, bloque8
			cmp r14, r10
			jne _comp1
			mov r14, bloque8
			mov r10, bloque9
			cmp r14, r10
			jne _comp1
			mov r14, bloque9
			mov r10, bloque10
			cmp r14, r10
			jne _comp1
			mov r14, bloque10
			mov r10, bloque11
			cmp r14, r10
			jne _comp1
			mov r14, bloque11
			mov r10, bloque12
			cmp r14, r10
			jne _comp1
			mov r14, bloque12
			mov r10, bloque13
			cmp r14, r10
			jne _comp1
			mov r14, bloque13
			mov r10, bloque14
			cmp r14, r10
			jne _comp1
			mov r14, bloque14
			mov r10, bloque15
			cmp r14, r10
			jne _comp1
			mov r14, bloque15
			mov r10, bloque16
			cmp r14, r10
			jne _comp1
			mov r14, bloque16
			mov r10, bloque17
			cmp r14, r10
			jne _comp1
			mov r14, bloque17
			mov r10, bloque18
			cmp r14, r10
			jne _comp1
			limpiar_pantalla limpiar,limpiar_tam 	;Limpiar la pantalla
			canonical_on ICANON,termios;Recuperar el modo canonico
			impr_texto Posm2, tam_posm2
			impr_texto linea_gano, 45
			leer_texto intro,15     ; se recive la tecla Enter
			limpiar_pantalla limpiar,limpiar_tam 	;Limpiar la pantalla
			_salir:
			impr_texto Posm1, tam_posm1           ;pantalla con los datos de los integrantes del grupo
			impr_texto linea_gracias, 27
			impr_texto Posm2, tam_posm2
			impr_texto juan, tamano_juan
			impr_texto noel, tamano_noel
			impr_texto pablo, tamano_pablo
			impr_texto mainor, tamano_mainor
			impr_texto Posm3, tam_posm3
			impr_texto linea_terminar, 28
			leer_texto intro, 15
			jmp _final


		;comparaciones en el estado de cada bloque, para ser borrado o pintado	
		_comp1:
			mov r14, bloque1
			cmp r14, 1
			jne _comp1n
			impr_texto Pos_b1, tam_p
			impr_texto linea_bloque, 10
			jmp _comp2
		_comp1n:
			impr_texto Pos_b1, tam_p
			impr_texto linea_bloquen, 10

		_comp2:
			mov r14, bloque2
			cmp r14, 1
			jne _comp2n
			impr_texto Pos_b2, tam_p2
			impr_texto linea_bloque, 10
			jmp _comp3
		_comp2n:
			impr_texto Pos_b2, tam_p2
			impr_texto linea_bloquen, 10
			
		_comp3:
			mov r14, bloque3
			cmp r14, 1
			jne _comp3n
			impr_texto Pos_b3, tam_p3
			impr_texto linea_bloque, 10
			jmp _comp4
		_comp3n:
			impr_texto Pos_b3, tam_p3
			impr_texto linea_bloquen, 10

		_comp4:
			mov r14, bloque4
			cmp r14, 1
			jne _comp4n
			impr_texto Pos_b4, tam_p4
			impr_texto linea_bloque, 10
			jmp _comp5
		_comp4n:
			impr_texto Pos_b4, tam_p4
			impr_texto linea_bloquen, 10

		_comp5:
			mov r14, bloque5
			cmp r14, 1
			jne _comp5n
			impr_texto Pos_b5, tam_p5
			impr_texto linea_bloque, 10
			jmp _comp6
		_comp5n:
			impr_texto Pos_b5, tam_p5
			impr_texto linea_bloquen, 10

		_comp6:
			mov r14, bloque6
			cmp r14, 1
			jne _comp6n
			impr_texto Pos_b6, tam_p6
			impr_texto linea_bloque, 10
			jmp _comp7
		_comp6n:
			impr_texto Pos_b6, tam_p6
			impr_texto linea_bloquen, 10

		_comp7:
			mov r14, bloque7
			cmp r14, 1
			jne _comp7n
			impr_texto Pos_b7, tam_p7
			impr_texto linea_bloque, 10
			jmp _comp8
		_comp7n:
			impr_texto Pos_b7, tam_p7
			impr_texto linea_bloquen, 10

		_comp8:
			mov r14, bloque8
			cmp r14, 1
			jne _comp8n
			impr_texto Pos_b8, tam_p8
			impr_texto linea_bloque, 10
			jmp _comp9
		_comp8n:
			impr_texto Pos_b8, tam_p8
			impr_texto linea_bloquen, 10

		_comp9:
			mov r14, bloque9
			cmp r14, 1
			jne _comp9n
			impr_texto Pos_b9, tam_p9
			impr_texto linea_bloque, 10
			jmp _comp10
		_comp9n:
			impr_texto Pos_b9, tam_p9
			impr_texto linea_bloquen, 10

		_comp10:
			mov r14, bloque10
			cmp r14, 1
			jne _comp10n
			impr_texto Pos_b10, tam_p10
			impr_texto linea_bloque, 10
			jmp _comp11
		_comp10n:
			impr_texto Pos_b10, tam_p10
			impr_texto linea_bloquen, 10

		_comp11:
			mov r14, bloque11
			cmp r14, 1
			jne _comp11n
			impr_texto Pos_b11, tam_p11
			impr_texto linea_bloque, 10
			jmp _comp12
		_comp11n:
			impr_texto Pos_b11, tam_p11
			impr_texto linea_bloquen, 10

		_comp12:
			mov r14, bloque12
			cmp r14, 1
			jne _comp12n
			impr_texto Pos_b12, tam_p12
			impr_texto linea_bloque, 10
			jmp _comp13
		_comp12n:
			impr_texto Pos_b12, tam_p12
			impr_texto linea_bloquen, 10

		_comp13:
			mov r14, bloque13
			cmp r14, 1
			jne _comp13n
			impr_texto Pos_b13, tam_p13
			impr_texto linea_bloque, 10
			jmp _comp14
		_comp13n:
			impr_texto Pos_b13, tam_p13
			impr_texto linea_bloquen, 10

		_comp14:
			mov r14, bloque14
			cmp r14, 1
			jne _comp14n
			impr_texto Pos_b14, tam_p14
			impr_texto linea_bloque, 10
			jmp _comp15
		_comp14n:
			impr_texto Pos_b14, tam_p14
			impr_texto linea_bloquen, 10

		_comp15:
			mov r14, bloque15
			cmp r14, 1
			jne _comp15n
			impr_texto Pos_b15, tam_p15
			impr_texto linea_bloque, 10
			jmp _comp16
		_comp15n:
			impr_texto Pos_b15, tam_p15
			impr_texto linea_bloquen, 10

		_comp16:
			mov r14, bloque16
			cmp r14, 1
			jne _comp16n
			impr_texto Pos_b16, tam_p16
			impr_texto linea_bloque, 10
			jmp _comp17
		_comp16n:
			impr_texto Pos_b16, tam_p16
			impr_texto linea_bloquen, 10

		_comp17:
			mov r14, bloque17
			cmp r14, 1
			jne _comp17n
			impr_texto Pos_b17, tam_p17
			impr_texto linea_bloque, 10
			jmp _comp18
		_comp17n:
			impr_texto Pos_b17, tam_p17
			impr_texto linea_bloquen, 10

		_comp18:
			mov r14, bloque18
			cmp r14, 1
			jne _comp18n
			impr_texto Pos_b18, tam_p18
			impr_texto linea_bloque, 10
			jmp _bola
		_comp18n:
			impr_texto Pos_b18, tam_p18
			impr_texto linea_bloquen, 10		

_bola:
	mov r13, 31 				;posicion en x inicial
	mov r12, 21				;posicion en y inicial
	mov r8, 0x0				;primer valor deco
	push r13
	syscall

_cuentainicio:				;posiciones	
	mov r15, 1 			;contador x
	mov r14, 1 			;contador y	
	pop r13

_cambia_y:
	cmp r14, r12
	je _cambia_x
	impr_texto movy, movy_long
	inc r14
	jmp _cambia_y

_cambia_x:
	cmp r15,r13
	je _ver_bolita
	impr_texto movx, movx_long
	inc r15
	jmp _cambia_x

_ver_bolita:
	push r13
	mov rax, [cond]
	cmp rax,1			
	je _ocultabola
	mov rax, 1
	mov [cond], rax
	impr_texto bolita, bolita_long
	call _cursor_inicio 				
	mov r13, 0

;duracion del proceso		;resetea contador
_velocidad:			;generador del delay 
 	cmp r13, 50000000	;cantidad de tiempo de espera
 	je _cuentainicio
 	inc r13
 	jmp _velocidad		;

_ocultabola:
	pop r13
	mov rax, 0
	mov [cond], rax
	impr_texto espacio, espacio_long
	call _cursor_inicio ;

;aquÃ­ empiezan los procesos para a combinaciÃ³n de los lÃ­mites 
	cmp r8, 0x0			;cod en 0
	je _ciclo1
	cmp r8, 0x1
	je _ciclo2
	cmp r8, 0x2
	je _ciclo3
	cmp r8, 0x3
	je _ciclo4


_ciclo1:
 	mov r8, 0x0
	cmp r15, 61				;x
	je _ciclo2
	cmp r14, lsup				;y	;limite superior
	je _ciclo4
	dec r12						;y
	inc r13						;x
	push r13
	jmp _cuentainicio
_ciclo2:
	mov r8, 0x1
	cmp r12, lsup					;límite máximo y
	je _ciclo3
	cmp r13, 2					;limite izquierdo
	je _ciclo1
	dec r12
	dec r13
	push r13
	jmp _cuentainicio

_ciclo3:
	mov r8, 0x2
	cmp r13, 2					;limite izquierdo
	je _ciclo4
	cmp r12, 21					;limite inferior
	je _ciclo2	
	dec r13
	inc r12
	push r13
	jmp _cuentainicio

_ciclo4:
	mov r8, 0x3
	cmp r13, 61				;limite derecho
	je _ciclo3
	cmp r12, 21					;limite inferior
	je _ciclo1
	inc r12
	inc r13
	push r13
	jmp _cuentainicio

_cursor_inicio:
	impr_texto inicial, inicial_long
	ret

;En esta sección se captura la tecla para la desición de izquierda o derecha

_cerrar_programa:
        ;Para salir
	call ccanonical_on
	call eecho_on
	impr_texto movy,movy_long

     mov rax,60
     mov rdi,0
     syscall

_final:
	impr_texto Pos_final, tam_final

call eecho_on
canonical_on ICANON,termios;Recuperar el modo canonico
mov rax,60	;se carga la llamada 60d (sys_exit) en rax
mov rdi,0	;en rdi se carga un 0
syscall	


