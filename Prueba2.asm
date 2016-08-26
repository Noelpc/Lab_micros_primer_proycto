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

	limpiar    db 0x1b, "[2J", 0x1b, "[H"
	limpiar_tam equ $ - limpiar
	italic   db  0x1b, "[3m", 
	italic_tam  equ $ - italic
	Letra   db  0x1b, "[30m", 
	Letra_tam  equ $ - Letra
	Fondo   db  0x1b, "[47m", 
	Fondo_tam  equ $ - Fondo
	Pos_vidas db 0x1b, "[1;40f"
	Pos_vidas_tam equ $ - Pos_vidas
	Pos_inicial db 0x1b, "[1B"
	Pos_inicial_tam equ $ - Pos_inicial
	
	;Definicion de las lineas especiales de texto para diujar el area de juego
	linea_techo: 		db '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%', 0xa
	linea_lblanco: 		db '                                                               ', 0xa
	linea_blanco: 		db '|                                                             |', 0xa
	linea_bloque: 		db '|  ########  ########  ########  ########  ########  ######## |', 0xa
	linea_cubo: 		db '|                              &                              |', 0xa
	linea_plataforma:	db '|                           =======                           |', 0xa
	linea_piso:		    db '|%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|', 0xa

	cons_linehor: db '  ######## ',0xa		; Linea Horizontal
	cons_lifes:db '<3 ',0xa                             ; Corazones
	cons_esquina:db '+ ',0xa                    
	cons_line:db '- ',0xa                             ;linea de techo
	cons_label:db 'Cantidad de Vidas: ',0xa                  ; letrero
	cons_skip:db  0xa                          ;salto de linea
	cons_space:db '   ',0xa                   ; Espacio entre bloques
	cons_space2:db '   ',0xa                   ; Espacio entre bloques
	cons_linever:db '  ######## ',0xa                 ;Area
	cons_wall:db '| ',0xa                                   
	cons_nothing: db '            ',0xa	; Vacio
	cons_won: db 'Felicidades. Juego Terminado. Presione Enter',0xa
	cons_won_line: equ $-cons_won	
	cons_lost: db 'Juego finalizado. Mejor suerte la próxima vez -Presione Enter',0xa
	cons_lost_line: equ $-cons_lost
	cons_fin: db 'Gracias por jugar Arkanoid Revoluton v.2',0xa, 'Juan Carlos Sanchez 201247237 ',0xa,'Pablo Valenciano Blanco 201242320',0xa, 'Mainor Lizano Jimenez 201165008',0xa, 'Noel Perez Caceres 2013000570',0xa
	cons_fin_line: equ $-cons_fin
	;Definicion de los mensajes especiales en lineas de texto para mostrar en el area de juego
	vidas: db 'Cantidad de vidas: ',0xa
	vidas_tam: equ $ - vidas
	linea_inicio:	    db '                     Arkanoid Revolution v.2                   ', 0xa
	linea_identificacion:	db '                 Digite el nombre del jugador                   ', 0xa
	linea_bienvenida:	db '|                    Arkanoid Revolution v.2                  |', 0xa
	linea_condicion:	db '|                   Digite "X" para continuar                 |', 0xa
	linea_vida_menos:	db '|         Perdio una vida - Presione X para continuar         |', 0xa
	linea_game_over:	db '|         Fin del Juego   - Presione X para continuar         |', 0xa
	
	;Todas las lineas anteriores son del mismo tamano, por lo que se maneja como una constante
	tamano_linea: 		equ 64
	
	
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
	
	linea: db 0x1b,"[1;35m",'================',0xa 
	long_linea: equ $-linea

	
        act_linea: db 0x1b,"[35;00H",0x1b,"[2K"
        leng_act_linea: equ $-act_linea
	
	espaciox: db '    ' 
        long_espaciox: equ $-espaciox
	cons_banner: db 'Modo Canonico Apagado - Presione tecla derecha:  '		; Banner para el usuario
	cons_tamano_banner: equ $-cons_banner
	variable: db''

	;Definicion de constantes para manejar el modo canonico y el echo
	termios:	times 36 db 0	;Estructura de 36bytes que contiene el modo de operacion de la consola
	stdin:		equ 0		;Standard Input (se usa stdin en lugar de escribir manualmente los valores)
	ICANON:		equ 1<<1	;ICANON: Valor de control para encender/apagar el modo canonico
	ECHO:           equ 1<<3	;ECHO: Valor de control para encender/apagar el modo de eco
	vtime: equ 4
	vmin: equ 5
	CC_C: equ 18	
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
	mov byte[termios + CC_C + vmin], 0                 
	mov byte [termios + CC_C + vtime],1 
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
echo_off:

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
	mov byte[termios + CC_C + vmin], 1
	mov byte[termios + CC_C + vtime], 0

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
echo_on:

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
	vidasx:resb 1


section .text
	global _start		;Definicion de la etiqueta inicial

_start:
	
	;Limpiar la pantalla
	limpiar_pantalla limpiar,limpiar_tam

	_Identificacion:
	impr_texto italic,italic_tam
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
		impr_texto Pos_inicial,Pos_inicial_tam
		;Apagar el modo canonico
		canonical_off ICANON,termios
		impr_texto linea_techo,tamano_linea
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

_finalizar_inicio:
	limpiar_pantalla limpiar,limpiar_tam
_valor_inicial:
	%assign vidasx 3
_reinicio:
	%assign bloque1 0            ; valores iniciales de booleanos
	%assign bloque2 1
	%assign bloque3 1
	%assign bloque4 1
	%assign bloque5 1
	%assign bloque6 1
	%assign bloque7 1
	%assign bloque8 0
	%assign bloque9 1
	%assign bloque10 1
	%assign bloque11 1
	%assign bloque12 1
	%assign bloque13 1
	%assign bloque14 1
	%assign bloque15 1
	%assign bloque16 1
	%assign bloque17 1
	%assign bloque18 0
	call ccanonical_off
	call echo_off

techo:                                  ; Hacer el techo
	impr_texto Nombre_jugador,15
	impr_texto Pos_inicial,Pos_inicial_tam
	;Apagar el modo canonico
	canonical_off ICANON,termios
	impr_texto linea_techo,tamano_linea
	impr_texto linea_blanco,tamano_linea

recrear_cajas:                 ;empezamo a crear cajas
	mov r12,0                  ;Contador de cajas
	mov r13,0                   ;Bloques por linea
	mov r14,0                  ;Verifica cada booleano por caja
	mov r8,14                  ;Cantidad de hileras
begin_box:                        ;Definimos cantidad de hileras
	dec r8
	jz done2
	mov r9,1                ;Altura de las cajas
	add r13,6
begin_line	:
	sub r13,6
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_wall          	
	mov rdx,1        
	syscall
	mov r10,6
bloques:                  ;Se idenpedizan las cajas
	inc r13
	cmp r13,1
	je bloque_1
	cmp r13,2
	je bloque_2
	cmp r13,3
	je bloque_3
	cmp r13,4
	je bloque_4
	cmp r13,5
	je bloque_5
	cmp r13,6
	je bloque_6
	cmp r13,7
	je bloque_7
	cmp r13,8
	je bloque_8
	cmp r13,9
	je bloque_9
	cmp r13,10
	je bloque_10
	cmp r13,11
	je bloque_11
	cmp r13,12
	je bloque_12
	cmp r13,13
	je bloque_13
	cmp r13,14
	je bloque_14
	cmp r13,15
	je bloque_15
	cmp r13,16
	je bloque_16
	cmp r13,17
	je bloque_17
	cmp r13,18
	je bloque_18
	jmp nothing
bloque_1:                      ;Posicion 9,3 a 29,5        Se verifica a cada caja si existe o no.
	mov r14,bloque1
	cmp r14,0
	je nothing
	jmp decrement
bloque_2:                      ;Posicion 35,3 a 55,5
	mov r14,bloque2
	cmp r14,0
	je nothing
	jmp decrement
bloque_3:                      ;Posicion 61,3 a 81,5
	mov r14,bloque3
	cmp r14,0
	je nothing
	jmp decrement
bloque_4:                      ;Posicion 87,3 a 107,5
	mov r14,bloque4
	cmp r14,0
	je nothing
	jmp decrement
bloque_5:                      ;Posicion 113,3 a 133,5
	mov r14,bloque5
	cmp r14,0
	je nothing
	jmp decrement
bloque_6:                      ;Posicion 139,3 a 159,5
	mov r14,bloque6
	cmp r14,0
	je nothing
	jmp decrement
bloque_7:                      ;Posicion 9,5 a 29,8
	mov r14,bloque7
	cmp r14,0
	je nothing
	jmp decrement
bloque_8:                      ;Posicion 35,5 a 55,8
	mov r14,bloque8
	cmp r14,0
	je nothing
	jmp decrement
bloque_9:                      ;Posicion 61,5 a 81,8
	mov r14,bloque9
	cmp r14,0
	je nothing
	jmp decrement
bloque_10:                      ;Posicion 87,5 a 107,8
	mov r14,bloque10
	cmp r14,0
	je nothing
	jmp decrement
bloque_11:                      ;Posicion 113,5 a 133,8
	mov r14,bloque11
	cmp r14,0
	je nothing
	jmp decrement
bloque_12:                      ;Posicion 139,5 a 159,8
	mov r14,bloque12
	cmp r14,0
	je nothing
	jmp decrement
bloque_13:                      ;Posicion 9,8 a 29,11
	mov r14,bloque13
	cmp r14,0
	je nothing
	jmp decrement
bloque_14:                      ;Posicion 35,8 a 55,11
	mov r14,bloque14
	cmp r14,0
	je nothing
	jmp decrement
bloque_15:                      ;Posicion 61,8 a 81,11
	mov r14,bloque15
	cmp r14,0
	je nothing
	jmp decrement
bloque_16:                      ;Posicion 87,8 a 107,11
	mov r14,bloque16
	cmp r14,0
	je nothing
	jmp decrement
bloque_17:                      ;Posicion 113,8 a 133,11
	mov r14,bloque17
	cmp r14,0
	je nothing
	jmp decrement
bloque_18:                      ;Posicion 139,8 a 159,11
	mov r14,bloque18
	cmp r14,0
	je nothing
	jmp decrement
decrement:
	inc r12
loop:
	impr_texto cons_linehor,10
	dec r10
	jz line
	jmp bloques
nothing:
	impr_texto cons_nothing,10
	dec r10
	jz line
	jmp bloques
line:                             ; Se crea un espacio
	impr_texto cons_space,1
end_line:                   ; Pared y fin de linea
	impr_texto cons_wall,1
	impr_texto cons_skip,1
boo:
	dec r9
	jz begin_box
	jmp begin_line
you_won:                    ; Aqui se coloca la ejeccuccion de si ganaste
	limpiar_pantalla limpiar,limpiar_tam
	impr_texto cons_won,cons_won_line						
	jmp done
perdiste:
	limpiar_pantalla limpiar,limpiar_tam
	impr_texto cons_lost,cons_lost_line
	jmp done
done2:                           ; Se termino de crear cajas
	cmp r12,0           
	je you_won
barra:
bola:
	call ccanonical_off
	call echo_off
	mov r10,15
	mov r13, 32 				;posicion en x inicial
	mov r12, 15				;posicion en y inicial
	mov r8, 0x0				;primer valor deco
	push r13
	syscall

;limpia la pantalla del juego

;cuenta inicial en x y y
_cuentainicio:				;posiciones		
	mov r15, 1 			;contador x
	mov r14, 1 			;contador y	
	pop r13

;subrutina que actualiza la linea de la barra	

_cambia_y:
	cmp r14, r12
	je _cambia_x

	mov rax, 1
	mov rdi,1
	mov rsi, movy
	mov rdx, movy_long
	syscall

	inc r14
	jmp _cambia_y

_cambia_x:
	cmp r15,r13
	je _ver_bolita
	mov rax, 1
	mov rdi, 1
	mov rsi, movx
	mov rdx, movx_long
	syscall
	inc r15
	jmp _cambia_x

_ver_bolita:
	push r13
	mov rax, [cond]
	cmp rax,1			
	je _ocultabola
	mov rax, 1
	mov [cond], rax
	mov rax, 1				
	mov rdi, 1
	mov rsi, bolita
	mov rdx, bolita_long
	syscall
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
	mov rax, 1		
	mov rdi, 1
	mov rsi, espacio
	mov rdx, espacio_long
	syscall
	call _cursor_inicio ;
choques:
push r12
push r13
cmp r12,8
ja _cuentainicio   ;movimiento normal
cmp r12,7
je bloques_grandes
cmp r12,6
je bloques_med
cmp r12,5
je bloques_peq
bloques_grandes:
cmp r13,4
jb _cuentainicio
cmp r13,12
jb bloque_13x
cmp r13,14
jb _cuentainicio
cmp r13,22
jb bloque_14x
cmp r13,24
jb _cuentainicio
cmp r13,32
jb bloque_15x
cmp r13,34
jb _cuentainicio
cmp r13,42
jb bloque_16x
cmp r13,44
jb _cuentainicio
cmp r13,52
jb bloque_17x
cmp r13,54
jb _cuentainicio
cmp r13,62
jb bloque_18x
jmp _cuentainicio
bloques_med:
cmp r13,4
jb _cuentainicio
cmp r13,12
jb bloque_7x
cmp r13,14
jb _cuentainicio
cmp r13,22
jb bloque_8x
cmp r13,24
jb _cuentainicio
cmp r13,32
jb bloque_9x
cmp r13,34
jb _cuentainicio
cmp r13,42
jb bloque_10x
cmp r13,44
jb _cuentainicio
cmp r13,52
jb bloque_11x
cmp r13,54
jb _cuentainicio
cmp r13,62
jb bloque_12x
jmp _cuentainicio
bloques_peq:
cmp r13,4
jb _cuentainicio
cmp r13,12
jb bloque_1x
cmp r13,14
jb _cuentainicio
cmp r13,22
jb bloque_2x
cmp r13,24
jb _cuentainicio
cmp r13,32
jb bloque_3x
cmp r13,34
jb _cuentainicio
cmp r13,42
jb bloque_4x
cmp r13,44
jb _cuentainicio
cmp r13,52
jb bloque_5x
cmp r13,54
jb _cuentainicio
cmp r13,62
jb bloque_6x
jmp _cuentainicio
bloque_1x:
mov r12, bloque1
jz _cuentainicio
%assign bloque1 0
cmp r13,4
je _cambia_x
cmp r13,11
je _cambia_x
jmp _cambia_y
bloque_2x:
mov r12, bloque2
jz _cuentainicio
%assign bloque2 0
cmp r13,14
je _cambia_x
cmp r13,21
je _cambia_x
jmp _cambia_y
bloque_3x:
mov r12, bloque3
jz _cuentainicio
%assign bloque3 0
cmp r13,24
je _cambia_x
cmp r13,31
je _cambia_x
jmp _cambia_y
bloque_4x:
mov r12, bloque4
jz _cuentainicio
%assign bloque4 0
cmp r13,34
je _cambia_x
cmp r13,41
je _cambia_x
jmp _cambia_y
bloque_5x:
mov r12, bloque5
jz _cuentainicio
%assign bloque5 0
cmp r13,44
je _cambia_x
cmp r13,51
je _cambia_x
jmp _cambia_y
bloque_6x:
mov r12, bloque6
jz _cuentainicio
%assign bloque6 0
cmp r13,54
je _cambia_x
cmp r13,61
je _cambia_x
jmp _cambia_y
bloque_7x:
mov r12, bloque7
jz _cuentainicio
%assign bloque7 0
cmp r13,4
je _cambia_x
cmp r13,11
je _cambia_x
jmp _cambia_y
bloque_8x:
mov r12, bloque8
jz _cuentainicio
%assign bloque8 0
cmp r13,14
je _cambia_x
cmp r13,21
je _cambia_x
jmp _cambia_y
bloque_9x:
mov r12, bloque9
jz _cuentainicio
%assign bloque9 0
cmp r13,24
je _cambia_x
cmp r13,31
je _cambia_x
jmp _cambia_y
bloque_10x:
mov r12, bloque10
jz _cuentainicio
%assign bloque10 0
cmp r13,34
je _cambia_x
cmp r13,41
je _cambia_x
jmp _cambia_y
bloque_11x:
mov r12, bloque11
jz _cuentainicio
%assign bloque11 0
cmp r13,44
je _cambia_x
cmp r13,51
je _cambia_x
jmp _cambia_y
bloque_12x:
mov r12, bloque12
jz _cuentainicio
%assign bloque12 0
cmp r13,54
je _cambia_x
cmp r13,61
je _cambia_x
jmp _cambia_y
bloque_13x:
mov r12, bloque13
jz _cuentainicio
%assign bloque13 0
cmp r13,4
je _cambia_x
cmp r13,11
je _cambia_x
jmp _cambia_y
bloque_14x:
mov r12, bloque14
jz _cuentainicio
%assign bloque14 0
cmp r13,14
je _cambia_x
cmp r13,21
je _cambia_x
jmp _cambia_y
bloque_15x:
mov r12, bloque15
jz _cuentainicio
%assign bloque15 0
cmp r13,24
je _cambia_x
cmp r13,31
je _cambia_x
jmp _cambia_y
bloque_16x:
mov r12, bloque16
jz _cuentainicio
%assign bloque16 0
cmp r13,34
je _cambia_x
cmp r13,41
je _cambia_x
jmp _cambia_y
bloque_17x:
mov r12, bloque17
jz _cuentainicio
%assign bloque17 0
cmp r13,44
je _cambia_x
cmp r13,51
je _cambia_x
jmp _cambia_y
bloque_18x:
mov r12, bloque18
jz _cuentainicio
%assign bloque18 0
cmp r13,54
je _cambia_x
cmp r13,61
je _cambia_x
jmp _cambia_y


;aquÃ­ empiezan los procesos para a combinaciÃ³n de los lÃ­mites 
	pop r12
	pop r13
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
	cmp r15, 63				;x
	je _ciclo2
	cmp r14, 3				;y	;limite superior
	je _ciclo4
	dec r12						;y
	inc r13						;x
	push r13
	jmp _cuentainicio
_ciclo2:
	mov r8, 0x1
	cmp r12, 3					;límite máximo y
	je _ciclo3
	cmp r13, 1					;limite izquierdo
	je _ciclo1
	dec r12
	dec r13
	push r13
	jmp _cuentainicio

_ciclo3:
	mov r8, 0x2
	cmp r13, 1					;limite izquierdo
	je _ciclo4
	cmp r12, 17					;limite inferior
	je _ciclo2	
	dec r13
	inc r12
	push r13
	jmp _cuentainicio

_ciclo4:
	mov r8, 0x3
	cmp r13, 63				;limite derecho
	je _ciclo3
	cmp r12, 17					;limite inferior
	je _ciclo1
	inc r12
	inc r13
	push r13
	jmp _cuentainicio

_cursor_inicio:
	mov rax, 1			
	mov rdi, 1
	mov rsi, inicial
	mov rdx, inicial_long
	syscall
	ret
 

vidas_inicio:
	impr_texto cons_label,18
	mov r14,vidasx              ;y ejecuccion de cantidad de vidas y letrero
	cmp r14,0
	je perdiste                 ;si vidas=0 perdiste
cantidad:                          ; muestra de vidas
	impr_texto cons_lifes,2
	dec r14
	jz _ver_bolita
	jmp cantidad
done:
	impr_texto cons_skip,1
	leer_texto tecla_capturada,1
	impr_texto cons_fin,cons_fin_line
	
;Recuperar el modo canonico
	canonical_on ICANON,termios
	;Finalmente, se devuelven los recursos del sistema
	;y se termina el programa
_cerrar_programa:
        ;Para salir
	call ccanonical_on
	call echo_on
        mov rax, 1
        mov rdi,1
        mov rsi, movy
        mov rdx, movy_long
	mov r10,0
	mov r11,0
	mov r12,0
	mov r13,0
	mov r14,0
	mov rax,60	;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0	;en rdi se carga un 0
	syscall	


