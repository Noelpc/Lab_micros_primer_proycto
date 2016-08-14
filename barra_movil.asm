 
;##############################################
;Ejemplo#5 - Captura inmediata de teclas
;EL4313 - Laboratorio de Estructura de Microprocesadores
;2S2016-LCRA
;##############################################
;Este programa contiene una serie de funciones y utilidades para
;apagar/encender los diferentes modos de operacion del teclado
;en Linux.
;Cada función se explica en detalle abajo
;
;NOTA IMPORTANTE: Al final del archivo se muestra el uso basico de las funciones
;
;##############################################

;--------------------Segmento de datos--------------------

section .data
	linea: db 0x1b,"[10A", 0x1b,"[2J",'********************' 
	long_linea: equ $-linea

	tecla_derecha: db 'a'
	

	tecla_izquierda: db 'd'
	long_tecla_izquierda:equ $-tecla_izquierda
	
	espacio: db 0x1b,"[10A", 0x1b,"[2J",'                   ' 
        long_espacio: equ $-espacio
 
  
	msj_aviso: db 0x1b,"[70;27f",'Marque por favor las teclas -a- o -d- para moverse ' 
        long_msj_aviso: equ $-msj_aviso

	msj_intro: db 0x1b,"[70;54f",'Marque una X para empezar: '
	long_msj_intro: equ $-msj_intro
	
	limpiar:db 0x1b, "[2J", 0x1b, "[H"
        limpiar_tam: equ $-limpiar

	numde:equ 5
	numiz:equ 1
	
	 linea3: db 0x1b,"[2J", 0x1b,"[120;54f",'******************* ' 
        long_linea3: equ $-linea3

	cons_der: equ 5
	cons_izq: equ 7

	cons_banner: db 'Modo Canonico Apagado - Presione tecla derecha:  '		; Banner para el usuario
	cons_tamano_banner: equ $-cons_banner					; Longitud del banner

	cons_salida: db 'Usted presiono la tecla:  '					; Banner para el usuario
	cons_tamano_salida: equ $-cons_salida					; Longitud del banner

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
v        mov eax, ICANON
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
;	global _leer
;	global _derecha
;	global _izquierda

;###################################################
; AQUI EMPIEZA EL CODIGO DE PRUEBAS
;En este codigo de pruebas, solamente se va a apagar el modo canonico
;para demostrar la captura inmediata de las teclas, sin esperar el ENTER
;###################################################

_start:


;_paso1:
;	call canonical_off
;	mov rax,1							;rax = "sys_write"
;	mov rdi,1							;rdi = 1 (standard output = pantalla)
;	mov rsi,linea		;rsi = mensaje a imprimir
;	mov rdx,long_linea	;rdx=tamano del string
;	syscall								;Llamar al sistema

;Segundo paso: Capturar una tecla presionada en el teclado
_limpiar:
	call canonical_off
        mov rax,1
        mov rdi,1
        mov rsi,limpiar
        mov rdx,limpiar_tam
        syscall

_intro:
	call canonical_off
	mov rax,1
	mov rdi,1
	mov rsi,msj_intro
	mov rdx,long_msj_intro

	syscall
_leerIntro:
	 call canonical_off
        mov rax,0
        mov rdi,0
        mov rsi,variable
        mov rdx,1
        
	mov r9,[variable]
	mov r8,numde
	
	cmp r9,r8
	jne _intro
	syscall
_leer:
	call canonical_off

	mov rax,0							;rax = "sys_read"
	mov rdi,0							;rdi = 0 (standard input = teclado)
	mov rsi,variable					;rsi = direccion de memoria donde se almacena la tecla capturada
	mov rdx,1						;rdx=1 (cuantos eventos o teclazos capturar)	
	
	syscall
;	mov r9,[variable]
;	mov r8,numiz
;	cmp rsi,r8
;	jne izquierda

;	mov rbx,numde
 ;    	cmp rsi,rbx
	jmp _izquierda
	
	
_aviso:
	call canonical_off
	mov rax,1                                                       ;rax = "sys_read"
        mov rdi,1                                                       ;rdi = 0 (standard input = teclado)
        mov rsi,msj_aviso                                       ;rsi = direccion de memoria donde se almacena la$
        mov rdx,long_msj_aviso  	
	syscall

	jmp _leer							;Llamar al sistema

	
_derecha:
	call canonical_off

	mov rax,1
	mov rdi,1
	mov rsi,linea
	mov rdx,long_linea
	mov rcx,10

	bucle:
	mov rax,1
        mov rdi,1
        mov rsi,linea
        mov rdx,long_linea

        mov r8,long_linea
	mov r9,long_espacio                                                       ;rax = "sys_write"
        inc r8
	inc r9                                                     ;rdi = 1 (standard output = pantalla)
        loop bucle
        syscall
	                                                         ;Llamar al sist
	jmp _leer

;Tercer paso: Imprimir el banner de salida
_izquierda:
	call canonical_off
	
	mov rax,1							;rax = "sys_write"
	mov rdi,1							;rdi = 1 (standard output = pantalla)
	mov rsi,linea				;rsi = mensaje a imprimir
	mov rdx,long_linea	;rdx=tamano del string
	mov rcx,10

	bucle2:
	mov rax,1
        mov rdi,1
        mov rsi,linea
        mov rdx,long_linea

	mov r8,long_linea
        mov r9,long_espacio                                                       ;rax = "sys_write"
        dec r8
	inc r9                                                     ;rdi = 1 (standard output = pantalla)
        loop bucle2
	syscall								;Llamar al sistema
	jmp _leer
;Cuarto paso: Imprimir la tecla capturada
;_paso4:
;	mov rax,1							;rax = "sys_write"
;	mov rdi,1							;rdi = 1 (standard output = pantalla)
;	mov rsi,linea3				;rsi = mensaje a imprimir
;	mov rdx,long_linea3							;rdx=solo se imprime 1 byte
;	syscall								;Llamar al sistema

;Quinto paso: Recuperar el modo canonico a su estado original y finalizacion del programa
	call canonical_on
	mov rax,60				;se carga la llamada 60d (sys_exit) en rax
	mov rdi,0					;en rdi se carga un 0
	syscall						;se llama al sistema.

