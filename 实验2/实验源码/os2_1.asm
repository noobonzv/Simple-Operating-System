	org 0a100h
start:
	xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
    mov ax,cs					; 开机这些寄存器都为0
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h

	mov ah,6					;清屏
    mov al,0
    mov ch,1
	mov cl,0
	mov dh,12
	mov dl,38
	mov bh,17h
	int 10h

	
	mov word[y],6				;进度条
	mov word[x],12
	
	mov cx,8					;显示几行
	mov ax, str0
	mov si,ax
	mov bp,332					;2个字节
row1:
	push cx
	mov cx,25					;一行的字符数
	
char1:	
	mov ah,4Fh					;
	mov al,[si]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax
	inc si
	add bp,2
	loop char1
	add bp,110		;(80-字符数)*2
	pop cx
	loop row1
	
	mov cx,25			; 进度条长度	
loop1:					;延时
	push cx
	mov ah,86h
    mov cx,02h
    mov dx,0x8480     
    int 15h 
	pop cx
	
	mov dx,cx
	test dx,01h			;偶数跳show2
	jz show2

	
show1:					;loading..
	push cx
	mov al,1
	mov ah,13h
	mov bl,1fh
	mov bh,0
	mov dh,11			;行
	mov dl,14			;列
	mov cx,11			;长度
	mov bp,strc
	int 10h
	pop cx
	jmp show
	
show2:
	push cx
	mov al,1
	mov ah,13h
	mov bl,1fh
	mov bh,0
	mov dh,11
	mov dl,14
	mov cx,11
	mov bp,strz
	int 10h
	pop cx
	jmp show

	
show:	
    xor ax,ax                 ; 计算显存地址
    mov ax,word[x]			  ; (80*x+y)*2Byte   x是row，y是column
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	mov ah,2Fh					;  
	mov al,byte[char]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值
	inc word[y]
	loop loop1
	
return0: 
  
	jmp 7c00h
	


datadef:	
    x    dw 6
    y    dw 11
    char db ' '				
	str0 db  "   17341189 YaoSenjian   "
	str4 db  "                         "
	str1 db  "    welcome to my OS!    "
	str3 db  "                         "
	str6 db  "          ** **          "
	str7 db  "         *******         "
	str2 db  "          *****          "
	str8 db  "            *            "
	strc db  "LOADING..  "
	strz db  "LOADING...."
times 510-($-$$) db 0
    db 0x00,0x00

	

