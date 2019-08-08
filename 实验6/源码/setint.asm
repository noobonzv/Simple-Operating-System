extrn _Current_Process
extrn _Save_Process
extrn _Schedule
extrn _Have_Program
extrn _special
extrn _Program_Num
extrn _CurrentPCBno
extrn _Segment


Finite dw 0
Timer:
;*****************************************
;*                Save                   *
; ****************************************
    cmp word ptr[_Program_Num],0	; 检查是否有程序要运行
	jnz Save						; 如果有，就保存其数据，做相应的操作
	jmp No_Progress					; 如果没有，就去执行风火轮程序
Save:
	inc word ptr[Finite]			; 检查是否已达到运行次数的限制
	cmp word ptr[Finite],120		;
	jnz Pass_agru 					; 没有就传参，调用PCB.H中的save函数，保存数据
    mov word ptr[_CurrentPCBno],0	; 当1600次调度完成后，将_CurrentPCBno置0，运行内核程序
	mov word ptr[Finite],0			; 重新计数
	mov word ptr[_Program_Num],0	; 当前程序改为0
	mov word ptr[_Segment],1000h	; 可以确保顺序正确
	jmp Pre							; 准备数据，准备恢复运行
Pass_agru:							; 传参
    push ss
	push ax
	push bx
	push cx
	push dx
	push sp	 	;sp已经被改变，保存的sp有误
				;cs，ip，flags + 前5个push，故需要+16来修正，栈是向低生长的
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process		;进入timer时，原cs，ip，flag已在栈中，调用save()函数
	call near ptr _Schedule 		;保存完数据，调用schedule()函数
	
Pre:
	mov ax, cs						
	mov ds, ax
	mov es, ax
	
	call near ptr _Current_Process	; 得到现在将要运行的进程的PCB地址
	mov bp, ax						; Current_Process的起始地址

	mov ss,word ptr ds:[bp+0]  		; Current_Process的栈      
	mov sp,word ptr ds:[bp+16]		; Current_Process的sp

	cmp word ptr ds:[bp+32],0 		; new?
	jnz No_First_Time				; 如果不是第一次运行，需要调整sp

;*****************************************
;*                Restart                *
; ****************************************
Restart:
    call near ptr _special
	
	push word ptr ds:[bp+30]		;flag
	push word ptr ds:[bp+28]		;cs
	push word ptr ds:[bp+26]		;ip
	
									;ss   	在前面已经特殊处理了
	push word ptr ds:[bp+2]			;gs
	push word ptr ds:[bp+4]			;fs
	push word ptr ds:[bp+6]			;es
	push word ptr ds:[bp+8]			;ds
	push word ptr ds:[bp+10]		;di
	push word ptr ds:[bp+12]		;si
	push word ptr ds:[bp+14]		;bp		
									;sp		在前面改了，由于需要修正，单独处理
	push word ptr ds:[bp+18]		;dx
	push word ptr ds:[bp+20]		;cx
	push word ptr ds:[bp+22]		;bx
	push word ptr ds:[bp+24]		;ax

	pop ax
	pop bx
	pop cx
	pop dx
	pop bp
	pop si
	pop di
	pop ds
	pop es
	.386
	pop fs
	pop gs
	.8086

	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret

No_First_Time:	
	add sp,16 		;修正
	jmp Restart
	
No_Progress:
    call another_Timer
	
	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret
	

another_Timer:
    push ax
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
	mov ax,cs
	mov ds,ax

	cmp byte ptr [ds:count],0
	jz case1
	cmp byte ptr [ds:count],1
	jz case2
	cmp byte ptr [ds:count],2
	jz case3
	
case1:	
    inc byte ptr [ds:count]
	mov al,'/'
	jmp show
case2:	
    inc byte ptr [ds:count]
	mov al,'\'
	jmp show
case3:	
    mov byte ptr [ds:count],0
	mov al,'|'
	jmp show
	
show:
    mov bx,0b800h
	mov es,bx
	mov ah,0ah
	mov es:[((80*24+78)*2)],ax
	
	pop ax
	mov ds,ax
	pop ax
	mov es,ax
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	ret

	count db 0




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
	mov dh,23 	                        ; 行
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
	mov ch,23				;
	mov cl,50				;起始列
	mov dh,23
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