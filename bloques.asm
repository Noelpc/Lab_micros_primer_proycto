section .data
	cons_linehor: db '    +-------------------+ ',0xa		; Linea Horizontal
	cons_lifes:db '<3 ',0xa                             ; Corazones
	cons_esquina:db '+ ',0xa                    
	cons_line:db '- ',0xa                             ;linea de techo
	cons_label:db 'lifes: ',0xa                  ; letrero
	cons_skip:db '', 0xa                          ;salto de linea
	cons_space:db '   ',0xa                   ; Espacio entre bloques
	cons_space2:db '   ',0xa                   ; Espacio entre bloques
	cons_linever:db '    | / / / / / / / / / | ',0xa                 ;Area
	cons_wall:db '| ',0xa                                   ;x=4 , x=165
	cons_nothing: db '                          ',0xa	; Vacio
	cons_won: db '                                                                 Felicidades Ganaste                                                 ',0xa
	cons_won_line: equ $-cons_won	
section .bss
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
section .text
	global _start		
_start:
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
	%assign vidasx 3
vidas:
	mov r14,vidasx              ;y ejecuccion de cantidad de vidas y letrero
	;jz perdiste                 ;si vidas=0 perdiste
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_label          	
	mov rdx,6        
	syscall
cantidad:                          ; muestra de vidas
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_lifes          	
	mov rdx,2        
	syscall
	dec r14
	jz techo
	jmp cantidad
techo:                                  ; Hacer el techo
	mov rax,1					
	mov rdi,1					
	mov rsi, cons_skip     	
	mov rdx,1        
	syscall
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_space2         	
	mov rdx,3       
	syscall
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_esquina          	
	mov rdx,1        
	syscall
	mov r14,159
repeticion:
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_line          	
	mov rdx, 1      
	syscall
	dec r14
	jz fin_line
	jmp repeticion
fin_line:
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_esquina          	
	mov rdx,1       
	syscall			
	mov rax,1		
	mov rdi,1		
	mov rsi, cons_space2 
	mov rdx,3 
	syscall
recrear_cajas:                 ;empezamo a crear cajas
	mov r12,0                  ;Contador de nada "nothings"
	mov r13,0                   ;Bloques por linea
	mov r14,0                  ;Verifica cada booleano por caja
	mov r8,13                  ;Cantidad de hileras
begin_box:                        ;Definimos cantidad de hileras
	dec r8
	jz done
	mov r9,3                 ;Altura de las cajas
	add r13,6
begin_line	:
	sub r13,6
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_space2          	
	mov rdx,3        
	syscall
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
decrement:                    ; comparacion para conocer si es medio de bloque o no
	cmp r9,2
	je area
loop:
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_linehor         
	mov rdx,26        
	syscall
	dec r10
	jz line
	jmp bloques
area:
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_linever         
	mov rdx,26       
	syscall
	dec r10
	jz line
	jmp bloques
nothing:
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_nothing         
	mov rdx,26       
	syscall
	inc r12
	dec r10
	jz line
	jmp bloques
line:                             ; Se crea un espacio
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_space     	
	mov rdx,3        
	syscall
end_line:                   ; Pared y fin de linea
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_wall          	
	mov rdx,1       
	syscall			
	mov rax,1		
	mov rdi,1		
	mov rsi, cons_space2  
	mov rdx,3        
	syscall
boo:
	;cmp r12,54            ; se coloca el numero total de vacios  18*(r8 inicial-1)
	;je you_won
	dec r9
	jz begin_box
	jmp begin_line
you_won:                    ; Aqui se coloca la ejeccuccion de si ganaste
	mov rax,1					
	mov rdi,1					
	mov rsi,cons_won          	
	mov rdx,cons_won_line       
	syscall
	jmp done
done:                           ; Se termino de crear cajas
	mov r10,0
	mov r11,0
	mov r12,0
	mov r13,0
	mov r14,0
	mov rax,60
	mov rdi,0	
	syscall	




