
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
%macro impr_texto 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro
%macro mover_cursor 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro

section .data

	limpiar    db 0x1b, "[2J", 0x1b, "[H"
	limpiar_tam equ $ - limpiar
	italic   db  0x1b, "[3m", 
	italic_tam  equ $ - italic
	Letra   db  0x1b,'[30m' 
	Letra_tam  equ $ - Letra
	Fondo   db  0x1b,'[47m' 
	Fondo_tam  equ $ - Fondo
	Pos_vidas db 0x1b, "[1;40f"
	Pos_vidas_tam equ $ - Pos_vidas
	Pos_inicial db 0x1b, "[1B"
	Pos_inicial_tam equ $ - Pos_inicial
	Pos_nueva db 0x1b, "[7;34f"
	Pos_nueva_tam equ $ - Pos_nueva

	;Definicion de las lineas especiales de texto para diujar el area de juego
	linea_techo: 		db '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%', 0xa
	linea_lblanco: 		db '                                                               ', 0xa
	linea_blanco: 		db '|                                                             |', 0xa
	linea_bloque: 		db '|  [######]  [######]  [######]  [######]  [######]  [######] |', 0xa
	linea_cubo: 		db '|                              &                              |', 0xa
	linea_plataforma:	db '|                           =======                           |', 0xa
	linea_piso:		    db '|%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|', 0xa
	
	;Definicion de los mensajes especiales en lineas de texto para mostrar en el area de juego
	vidas: db 'Cantidad de vidas: ',0xa
	vidas_tam: equ $ - vidas
	linea_inicio:	    db '                     Arkanoid Revolution v.2                   ', 0xa
	linea_identificacion:	db '                 Digite el nombre del jugador                   ', 0xa
	linea_bienvenida:	db '|                    Arkanoid Revolution v.2                  |', 0xa
	linea_condicion:	db '|                   Digite "X" para continuar                 |', 0xa
	linea_vida_menos:	db '|         Perdio una vida - Presione X para continuar         |', 0xa
	linea_game_over:	db '|         Fin del Juego   - Presione X para continuar         |', 0xa

	linea_nueva:	    db 'Prueba finalizar', 0xa
	nueva_tam: equ $ - linea_nueva

	
	;Todas las lineas anteriores son del mismo tamano, por lo que se maneja como una constante
	tamano_linea: 		equ 64

	;Definicion de constantes para manejar el modo canonico y el echo
	termios:	times 36 db 0	;Estructura de 36bytes que contiene el modo de operacion de la consola
	stdin:		equ 0		;Standard Input (se usa stdin en lugar de escribir manualmente los valores)
	ICANON:		equ 1<<1	;ICANON: Valor de control para encender/apagar el modo canonico
	ECHO:           equ 1<<3	;ECHO: Valor de control para encender/apagar el modo de eco

	

;segmento de datos no-inicializados, que se pueden usar para capturar variables 
;del usuario, por ejemplo: desde el teclado
section .bss
	tecla_capturada: resb 1
	Nombre_jugador: resb 15

section .text
	global _start		;Definicion de la etiqueta inicial

_start:
	
	;Limpiar la pantalla
	limpiar_pantalla limpiar,limpiar_tam

	_Identificacion:
	impr_texto Fondo,Fondo_tam
	impr_texto Letra,Letra_tam
	impr_texto linea_inicio,tamano_linea
	;se hace un loop para imprimir 5 lineas de tipo "linea_blanco"
		mov r8,0
		loop_1.2:
			impr_texto linea_lblanco,tamano_linea
			inc r8
			cmp r8,0x5
			jne loop_1.2
			
	impr_texto linea_identificacion,tamano_linea
	leer_texto Nombre_jugador,15

	;Imprimir la pantalla de bienvenida usando los textos previamente definidos
	_Bienvenida:
		;Limpiar la pantalla
		limpiar_pantalla limpiar,limpiar_tam
		impr_texto Nombre_jugador,15
		mover_cursor Pos_vidas,Pos_vidas_tam
		impr_texto vidas, vidas_tam
		mover_cursor Pos_inicial,Pos_inicial_tam
		;Apagar el modo canonico
		canonical_off ICANON,termios
		impr_texto linea_techo,tamano_linea
		impr_texto linea_blanco,tamano_linea
		impr_texto linea_blanco,tamano_linea
		;se hace un loop para imprimir 3 lineas de tipo "linea_bloque"
		mov r8,0
		loop_1:
			impr_texto linea_bloque,tamano_linea
			inc r8
			cmp r8,0x3
			jne loop_1
		;se hace un loop para imprimir 2 lineas de tipo "linea_blanco"
		mov r8,0
		loop_2:
			impr_texto linea_blanco,tamano_linea
			inc r8
			cmp r8,0x2
			jne loop_2
			
		;se imprime el mensaje de bienvenida
		impr_texto linea_bienvenida,tamano_linea
		impr_texto linea_blanco,tamano_linea
		impr_texto linea_condicion,tamano_linea
		;se hace un loop para imprimir 4 lineas de tipo "linea_blanco"
		mov r8,0
		loop_3:
			impr_texto linea_blanco,tamano_linea
			inc r8
			cmp r8,0x4
			jne loop_3
				
		;se imprimen 2 lineas de tipo linea_cubo
		impr_texto linea_cubo,tamano_linea
		;se imprime la linea de la plataforma
		impr_texto linea_plataforma,tamano_linea
		;se imprime la linea del piso
		impr_texto linea_blanco,tamano_linea
		impr_texto linea_piso,tamano_linea

_leer_opcion:
		leer_texto tecla_capturada,1
		mov al,[tecla_capturada]
		cmp  al , 'x'
		jne _leer_opcion				;aqui se comprueba que la tecla capturada es una "x"
		je _finalizar

	

_finalizar:
	mover_cursor Pos_nueva,Pos_nueva_tam
	impr_texto linea_nueva, nueva_tam
	limpiar_pantalla limpiar,limpiar_tam
	impr_texto linea_bienvenida,tamano_linea
	leer_texto tecla_capturada,1

;Recuperar el modo canonico
	canonical_on ICANON,termios

	;Finalmente, se devuelven los recursos del sistema
	;y se termina el programa
		mov rax,60	;se carga la llamada 60d (sys_exit) en rax
		mov rdi,0	;en rdi se carga un 0
		syscall	


