    org 09000h					; 程序加载到100h，可用于生成COM

	push ax
	push bx
	push cx
	push dx
	push ds
	push es
	push si
	push bp

start:
	xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
    mov ax,cs					; 开机这些寄存器都为0
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h

	mov cx,2					;显示几行
	mov ax, str0
	mov si,ax
	mov bp,250					;2个字节
row1:
	push cx
	mov cx,29					;一行的字符数
	
char1:	
	mov ah,6Fh					;
	mov al,[si]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax
	inc si
	add bp,2
	loop char1
	add bp,102			;(80-字符数)*2
	pop cx
	loop row1

	mov cx,8

loop1:
	push cx
	mov ah,6
    mov al,0
    mov ch,3
	mov cl,40
	mov dh,12
	mov dl,79
	mov bh,17h
	int 10h
	
	mov ah,86h
    mov cx,01h
    mov dx,4240h     
    int 15h
	
	mov ah,6
    mov al,0
    mov ch,3
	mov cl,40
	mov dh,12
	mov dl,79
	mov bh,17h
	int 10h
	
	mov ah,86h
    mov cx,01h
    mov dx,4240h     
    int 15h

	mov ah,6
    mov al,0
    mov ch,3
	mov cl,40
	mov dh,12
	mov dl,79
	mov bh,27h
	int 10h
	jmp con
	
helpout:
	pop cx
	loop loop1
	
	mov	ax, 600h	; AH = 6,  AL = 0
	mov	bx, 700h	; 黑底白字(BL = 7)
	mov	cx, 0		; 左上角: (0, 0)
	mov	dx, 184fh	; 右下角: (24, 79)
	int	10h		; 显示中断	
	
	
	pop bp
	pop si
	pop es
	pop ds
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
con:
	mov ah,86h
    mov cx,01h
    mov dx,4240h     
    int 15h

	mov ah,6
    mov al,0
     mov ch,3
	mov cl,40
	mov dh,12
	mov dl,79
	mov bh,47h
	int 10h

	mov ah,86h
    mov cx,01h
    mov dx,4240h     
    int 15h
	
	mov ah,6
    mov al,0
    mov ch,3
	mov cl,40
	mov dh,12
	mov dl,79
	mov bh,67h
	int 10h
	
	mov ah,86h
    mov cx,01h
    mov dx,4240h     
    int 15h
	
	mov ah,6
    mov al,0
    mov ch,3
	mov cl,40
	mov dh,12
	mov dl,79
	mov bh,77h
	int 10h

	jmp helpout
		
str0 db "TURN OFF THE LIGHTS          "   
STR1 db "YOU WILL BE IN THE DANCE HALL"
times 1022-($-$$) db 0
    db 0x00,0x00
