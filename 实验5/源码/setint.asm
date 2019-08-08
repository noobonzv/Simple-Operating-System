
	states db 0
	 char1 db '|'
	char2 db '/'
	char3 db '\'
	delay0 equ 4
	delay_count db delay0

	
Timer:
    push ax		
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	dec byte ptr [delay_count]		; 递减计数变量
	
	jnz end0
	
	mov byte ptr [delay_count],delay0	; 减到0之后再赋值
	
	inc byte ptr [states]
	
	cmp byte ptr [states],1
	jz c1
	
	cmp byte ptr [states],2
	jz c2
	
	cmp byte ptr [states],3
	jz c3
	
c1:
	mov bp,offset char1
	jmp show00
c2:
	mov bp,offset char2
	jmp show00
c3:	
	mov bp,offset char3
	mov byte ptr [states],0					; 到3个状态后归零
	jmp show00
	
show00:
    mov ah,13h 	                    	;es:bp
	mov al,0                     	
	mov bl,0Fh 	                      
	mov bh,0 	                    
	mov dh,24 	                      
	mov dl,78 	                    
	mov cx,1 	                     
	int 10h 
	
	jmp end0
	
end0:
	mov al,20h			; AL = EOI
	out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
	pop ds
	pop es 
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	iret			; 从中断返回





public _setMyInt
_setMyInt proc

	push ax		
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
	xor ax,ax
	mov es,ax
	push [es:9*4]									;保护中断，用来后面恢复
	pop [es:24*4]
	push [es:9*4+2]
	pop [es:24*4+2]
	
	push [es:33*4]	
	pop [es:25*4]
	push [es:33*4+2]
	pop [es:25*4+2]
	
	
	mov word ptr [es:33*4], offset myint_21		       ;装填中断向量表 
	mov ax,cs 
	mov word ptr [es:33*4+2],ax
	
	
	mov word ptr [es:9*4], offset myint_09		       ;装填中断向量表 
	mov ax,cs 
	mov word ptr [es:9*4+2],ax



	pop ds
	pop es 
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	ret

_setMyInt endp


public _resetInt
_resetInt proc

	push ax		
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
	xor ax,ax
	mov es,ax
	push [es:24*4]			; 恢复被修改的中断
	pop [es:9*4]
	push [es:24*4+2]
	pop [es:9*4+2]
	
	push [es:33*4]	
	pop [es:25*4]
	push [es:33*4+2]
	pop [es:25*4+2]

	pop ds
	pop es 
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	ret

_resetInt endp


myint_09:
    mov ah,4
	int 21h
	iret

	
myint_21:
	
	STI
	cmp ah,0
	jz helpJumpFun0
	
	cmp ah,1
	jz helpJumpFun1

	cmp ah,2
	jz helpJumpFun2

	cmp ah,3
	jz helpJumpFun3
	
	cmp ah,4
	jz helpJumpFun4
	
	cmp ah,5
	jz helpJumpFun5
	
	cmp ah,6
	jz helpJumpFun6

	cmp ah,7
	jz helpJumpFun7
	
	cmp ah,8
	jz helpJumpFun8
	
helpJumpFun0:
	jmp fun0
	
helpJumpFun1:
	jmp fun1
	
helpJumpFun2:
	jmp fun2

helpJumpFun3:
	jmp fun3

helpJumpFun4:
	jmp fun4
	
helpJumpFun5:
	jmp fun5

helpJumpFun6:
	jmp fun6

helpJumpFun7:
	jmp fun7

helpJumpFun8:
	jmp fun8

fun0:
	push ax								
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	
    mov ah,13h 	                        ; 功能号
	mov al,0                     		; 光标返回起始位置
	mov bl,0Eh 	                        ; 0000：黑底、1111：亮白字
	mov bh,0 	                    	; 
	mov dh,6 	                        ; 行
	mov dl,10 	                        ; 列
	mov cx,25 	                        ; 串长
	mov bp,offset hello0
	int 10h

	mov cx,60000
loop01:
	mov dx,60000				;延时
	
loop02:	
	dec dx
	jnz loop02

	dec cx
	jnz loop01


	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

hello0 db "OS OS OS!!!! AH=0 int 21h"

	
fun1:
	push ax								
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	
    mov ah,13h 	                        ; 功能号
	mov al,0                     		; 光标返回起始位置
	mov bl,0Eh 	                        ; 0000：黑底、1111：亮白字
	mov bh,0 	                    	; 
	mov dh,6 	                        ; 行
	mov dl,50 	                        ; 列
	mov cx,27 	                        ; 串长
	mov bp,offset hello1
	int 10h
	
	mov cx,60000
loop11:
	mov dx,60000				;延时
	
loop12:	
	dec dx
	jnz loop12

	dec cx
	jnz loop11


	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

hello1 db "HELLO! WELCOME! 1st int 21h"

	
fun2:
	
	push ax								
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	
    mov ah,13h 	                        ; 功能号
	mov al,0                     		; 光标返回起始位置
	mov bl,0Eh 	                        ; 0000：黑底、1111：亮白字
	mov bh,0 	                    	; 
	mov dh,18	                        ; 行
	mov dl,10 	                        ; 列
	mov cx,24 	                        ; 串长
	mov bp,offset hello2
	int 10h

	mov cx,60000
loop21:
	mov dx,60000				;延时
	
loop22:	
	dec dx
	jnz loop22

	dec cx
	jnz loop21
	

	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

hello2 db "OS SUCKS!!!! 2ed int 21h"

	
fun3:
	
		
	push ax								
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	
    mov ah,13h 	                        ; 功能号
	mov al,0                     		; 光标返回起始位置
	mov bl,0Eh 	                        ; 0000：黑底、1111：亮白字
	mov bh,0 	                    	; 
	mov dh,18 	                        ; 行
	mov dl,50 	                        ; 列
	mov cx,22 	                        ; 串长
	mov bp,offset hello3
	int 10h

	mov cx,60000
loop31:
	mov dx,60000				;延时
	
loop32:	
	dec dx
	jnz loop32

	dec cx
	jnz loop31
	

	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

hello3 db "TEST TEST! 3rd int 21h"

fun4:

	;int 09实现
	;保护现场
    push ax								
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	mov ax,cs
	mov ds,ax
	mov es,ax
	
    mov ah,13h 	                        ; 功能号
	mov al,0                     		; 光标返回起始位置
	mov bl,0Eh 	                        ; 0000：黑底、1111：亮白字
	mov bh,0 	                    	; 
	mov dh,24 	                        ; 行
	mov dl,50 	                        ; 列
	mov cx,23	                        ; 串长
	mov bp,offset ouch
	int 10h

	
	mov cx,20000
loop1:
	mov dx,12000				;延时
	
loop2:	
	dec dx
	jnz loop2

	dec cx
	jnz loop1

	;清除该ouch位置的字符串
	mov ah,6
    mov al,0
	mov ch,24				;
	mov cl,50				;起始列
	mov dh,24
	mov dl,73				;最后列
	mov bh,7
	int 10H
    
	
    in al,60h
	mov al,20h					    ; AL = EOI
	out 20h,al						; 发送EOI到主8529A
	out 0A0h,al					    ; 发送EOI到从8529A

	
;还原现场
	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

ouch db "OUCH! OUCH! From int21h"
clearchar db "xxxxxxxxxxx"


fun5:
	call _cls
	iret

fun6:
	call _printChar
	iret

fun7:
	call _getChar
	iret

fun8:			;shutdown
    mov        ax, 2001h
    mov        dx, 1004h
    out        dx,ax
    iret