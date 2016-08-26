 
;##############################################
;Movimiento de la barra del juego Arkanoid
;EL4313 - Laboratorio de Estructura de Microprocesadores
;2 semestre 2016
;##############################################
;En este código se presenta la forma en que la
;plataforma del juego Arkanoid se moverá en función
;a las teclas -z- para derecha o -c- para izquierda
;##############################################

;--------------------Segmento de datos--------------------

section .data
	
	linea: db 0x1b,"[1;63m",'================',0xa 
	long_linea: equ $-linea

	
        act_linea: db 0x1b,"[35;00H",0x1b,"[2K"
        leng_act_linea: equ 12
	
	espacio: db '    ' 
        long_espacio: equ $-espacio
 
  
	msj_aviso: db 0x1b,"[20;35f",'Marque por favor las teclas -z- o -c- para moverse ' 
        long_msj_aviso: equ $-msj_aviso

	msj_intro: db 0x1b,"[20;54f",'Marque una X para empezar: '
	long_msj_intro: equ $-msj_intro
	
	limpiar:db 0x1b, "[2J"
        limpiar_tam: equ 4
	

		

	cons_banner: db 'Modo Canonico Apagado - Presione tecla derecha:  '		; Banner para el usuario
	cons_tamano_banner: equ $-cons_banner					; Longitud del banner

	
	cons_final: db 0xa,'Fin del programa. ',0xa					; Banner para el usuario
	cons_tamano_final: equ $-cons_final						; Longitud del banner

	variable: db''													;Almacenamiento de la tecla capturada

	termios:        times 36 db 0									;Estructura de 36bytes que contiene el modo de operacion de la consola
	stdin:          	  equ 0												;Standard Input (se usa stdin en lugar de escribir manualmente los valores)
	ICANON:      equ 1<<1											;ICANON: Valor de control para encender/apagar el modo canonico
	ECHO:           equ 1<<3											;ECHO: Valor de control para encender/apagar el modo de eco

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
canonical_off:

	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
        call read_stdin_termios

	;Se escribe el nuevo valor de ICANON en EAX, para apagar el modo canonico
        push rax
        mov eax, ICANON
        not eax
        and [termios+12], eax
        pop rax

	;Se escribe la nueva configuracion de TERMIOS
        call write_stdin_termios
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
        call read_stdin_termios

        ;Se escribe el nuevo valor de ECHO en EAX para apagar el echo
        push rax
        mov eax, ECHO
        not eax
        and [termios+12], eax
        pop rax

	;Se escribe la nueva configuracion de TERMIOS
        call write_stdin_termios
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
canonical_on:

	;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
	;TERMIOS son los parametros de configuracion que usa Linux para STDIN
        call read_stdin_termios

        ;Se escribe el nuevo valor de modo Canonico
        or dword [termios+12], ICANON

	;Se escribe la nueva configuracion de TERMIOS
        call write_stdin_termios
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
        call read_stdin_termios

        ;Se escribe el nuevo valor de modo echo
        or dword [termios+12], ECHO

	;Se escribe la nueva configuracion de TERMIOS
        call write_stdin_termios
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
read_stdin_termios:
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
write_stdin_termios:
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



;--------------------Declaracion de codigo para pruebas--------------------------------------------
section .text
	global _start		;Definicion de la etiqueta inicial
;###################################################
; Aqui empieza el programa que hace mover la barra
;###################################################

_start:
call canonical_off
call echo_off
mov r10,15
syscall
;Limpia la pantalladel juego
_limpiar:
        mov rax,1					;Modo escritura
        mov rdi,1					;Modo pantalla
        mov rsi,limpiar					;Imprime secuencia de escape de limpieza
        mov rdx,limpiar_tam				;tamaño
        syscall						;llamado del sistema
				
;subrutina que actualiza la linea de la barra	
_intro:
	mov rax,1
	mov rdi,1
	mov rsi,act_linea	
	mov rdx,leng_act_linea
	syscall
	

;Imprime espacios que permiten el movimiento de la barra
_espacio:
	push r9
	mov r9,1
	_bucle:
	cmp r9,r10
	je _barra
	mov rax,1
	mov rdi,1
	mov rsi,espacio
	mov rdx,long_espacio
	
	syscall

	inc r9
	loop _bucle	

;imprime la barra o plataforma
_barra:
	pop r9
	mov rax,1
	mov rdi,1
	mov rsi,linea
	mov rdx,long_linea
	syscall

;En esta sección se captura la tecla para la desición de izquierda o derecha
_leer:
        mov rax,0				;modo lectura
        mov rdi,0				;modo de teclado activo
        mov rsi,variable			;guarda el dato en la direccion de variable
        mov rdx,1				; el tamaño es de 1
	syscall					;llama al sistema

	push r8
	push r9

	;aquí se empieza con las comparaciones
	mov r8,[variable]
	mov r9,'z'
	cmp r9,r8
	je _izquierda
	mov r9,'c'
	cmp r9,r8
	je _derecha
	mov [variable],rax
	


_aviso:
	mov rax,1                                                       ;rax = "sys_read"
        mov rdi,1                                                       ;rdi = 0 (standard input = teclado)
        mov rsi,msj_aviso                                       ;rsi = direccion de memoria donde se almacena la$
        mov rdx,long_msj_aviso  	
	syscall
	
	jmp _limpiar							;Llamar al sistema

	
_derecha:

;	pop r8
;	pop r9
	cmp r10,22						;Limite derecho
	je _leer
	inc r10
	mov [variable],rax
        jmp _intro

_izquierda:
 ;       pop r8
  ;      pop r9

        cmp r10,2						;Límite izquierdo
        je _leer
        dec r10
        mov [variable],rax
        jmp _intro

;#############################################################################
