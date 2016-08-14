section .data
	cons_bola: db 0x1b,"[2J", 0x1b,"[5;3f",'* '
	cons_len equ $-cons_bola
	;posicion: db 
section .text
	global _start
_start:
datos_inicio:
	%assign vx 1
	%assign vy 1
	%assign acumulador 9
	%assign dx 1
	%assign dy 1
	%assign function 0
	%defstr meme(a,b) db 0x1b,"[2J", 0x1b,"["a";"b,'* ' 
	mov r12,0
	mov r13,0
	mov r9,0
	jmp moviendo

funcion_1:
	%assign vx -vx  ;contra la pared |
	jmp moviendo
function_2:                 ;contra barra y techo -
	%assign vy -vy
	jmp moviendo
function_3:                ;Contra la esquina de juego +
	%assign vx -vx
	%assign vy -vy
	jmp moviendo
moviendo:              Movimiento de l bola
	%assign dx dx+vx
	%assign dy dy+vy
posicionando:         Se coloca y se compara si toca pared o esquinas de la sala de juego incompleta
	mov r12,dy
	cmp r12,2
	je function_6
	;cmp r12,11
	;jl lista
	mov r13,dx
	cmp r13,4
	je function_7
	cmp r13,164
	je function_8
;lista:
;lista_menores:
	;mov r13,dx
	;cmp r13,acumulador
	;je funct
	;$assign acumulador acumulador+26
	
	;jl 
	;cmp r13,29

	;jg lista_mayores
	;cmp r13,61
	;jg lista_mayores
	;cmp r13,87
	;jg lista_mayores
	;cmp r13,113
	;jg lista_mayores
	;cmp r13,139
	;jg lista_mayores
;lista_mayores:
	;cmp r13,9
	;jl lista_funciones
	;cmp r13,9
	;jg lista_funciones 	
	;r13,9
	;jg lista_funciones
	;cmp r13,9
	;jg lista_funciones
	;cmp r13,9
	;jg lista_funciones
	;cmp r13,9
	;jg lista_funciones
escribiendo:
	mov rax,1					
	mov rdi,1					
	mov rsi,meme(dy,dx)		;Antes de esto hay que convertir dy y dx en strings
	mov rdx,cons_len
	syscall			
done:
	mov r12,0
	mov r13,0
	mov r9,0
	mov rax,60
	mov rdi,0	
	syscall					