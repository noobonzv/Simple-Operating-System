    org 09800h					; 程序加载到100h，可用于生成COM
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
	
	mov cx,11					;显示几行
	mov ax, str0
	mov si,ax
	mov bp,2160					;2个字节
	
row1:
	mov dx,39					;一行的字符数
	
char1:	
	mov ah,4Fh					;
	mov al,[si]					;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax
	inc si
	add bp,2
	dec dx
	jnz char1
	
	add bp,82			;(80-字符数)*2

	dec cx
	jnz row1
	
	mov ah,86h
    mov cx,2ah
    mov dx,4240h     
    int 15h
	
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
	
	
datadef:
str0 db "                 _oo0oo_               "                  
str1 db "                o8888888o              "                 
str2 db " 17341189       88' . '88              "                 
str3 db "   Yao         (|  - -  |)             "             
str4 db "   Sen          0\  =  /0              "
str5 db "   Jian       ___/`---'\___            "
str6 db "            .' \\|  :  |// '.          "
str8 db "          / _||||| /:\ |||||- \        "
strq db "         | \_|  ''\---/''  |_/ |       "
stri db "                                       "
strp db "~~The buddha bless you away from bugs~~" 

	

times 1022-($-$$) db 0
    db 0x00,0x00
    
