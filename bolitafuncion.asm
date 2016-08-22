section .data
	limpia: db 0x1b, '[2J',0x1b, '[00;00H',0x1b ,'[?25l'
	limpia_long: equ $-limpia
	
	inicial: db 0x1b,'[00;00H'			;set cursor 
	inicial_long: equ $-inicial

	bolita: db 0x1b, '[1m', 48
	bolita_long: equ $-bolita

	espacio: db ' '
	espacio_long: equ $-espacio

	movx: db 0x1b, "[1C"				;mov a los lados
	movx_long: equ $-movx

	movy: db 0x1b, "[1E"				;mov. hacia abajo
	movy_long: equ $-movy

	cond: db 0

section .text
	global _start

_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, limpia
	mov rdx, limpia_long
	syscall

 	mov r13, 55 				;posicion en x inicial
 	mov r12, 35				;posicion en y inicial
 	mov r8, 0x0				;primer valor deco
 	push r13
;cuenta inicial en x y y
_cuentainicio:				;posiciones		
	mov r15, 1 			;contador x
	mov r14, 1 			;contador y	
	pop r13

;movimiento en y
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

;funcion que muestra la bolita
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
 	cmp r13, 100000000	;cantidad de tiempo de espera
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

;aquí empiezan los procesos para a combinación de los límites 
	cmp r8, 0x0			;cod en 0
	je _ciclo1
	cmp r8, 0x1
	je _ciclo2
	cmp r8, 0x2
	je _ciclo3
	cmp r8, 0x3
	je _ciclo4
	jmp _cerrar_programa

_ciclo1:
	mov r8, 0x0
	cmp r15, 110				;
	je _ciclo2
	cmp r14, 8					;limite superior
	je _ciclo4
	dec r12						;y
	inc r13						;x
	push r13
	jmp _cuentainicio

_ciclo2:
	mov r8, 0x1
	cmp r12, 8					;limite superior
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
	cmp r12, 36					;limite inferior
	je _ciclo2	
	dec r13
	inc r12
	push r13
	jmp _cuentainicio

_ciclo4:
	mov r8, 0x3
	cmp r13, 110				;limite derecho
	je _ciclo3
	cmp r12, 35					;limite inferior
	je _ciclo1
	inc r12
	inc r13
	push r13
	jmp _cuentainicio
_cerrar_programa:
 	;Para salir
 	mov rax, 1
	mov rdi,1
	mov rsi, movy
	mov rdx, movy_long
	syscall
 	mov rax,60
 	mov rdi,0
 	syscall

_cursor_inicio:
	mov rax, 1			
	mov rdi, 1
	mov rsi, inicial
	mov rdx, inicial_long
	syscall
	ret



