;   NASM汇编格式
    Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
    delay equ 2000
									; 计时器延迟计数,用于控制画框的速度


    org 7C00h					
start:
	xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
    mov ax,cs					; 开机这些寄存器都为0
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h
	
	mov cx,6					;显示6行
	mov ax, str0				;首地址
	mov si,ax	
	mov bp,860					;第一个字符在显存中的位置
	row1:
		push cx						;保护
		mov cx,19					;一行的字符数
		
	char1:	
		mov ah,4Fh					;字符属性
		mov al,[si]					;  AL = 显示字符值（默认值为20h=空格符）
		mov word[gs:bp],ax			;显存
		inc si						;字符串偏移量
		add bp,2					;一个字符需要2个字节才能在显存中显示
		loop char1					
		add bp,122					;(80-字符数)*2 换行
		pop cx
		loop row1
	
loop1:			;应该叫延时，不应该loop1，懒得改了
	push cx		;保护
	mov cx,word[count]	;loop2 循环count次
loop2:
	push cx		;保护
	
	mov cx,word[count]
loop3:
    loop loop3
	
	pop cx
	loop loop2
	pop cx

    mov al,1
      cmp al,byte[rdul]			
	jz  DnRt
      mov al,2
      cmp al,byte[rdul]
	jz  UpRt
      mov al,3
      cmp al,byte[rdul]
	jz  UpLt
      mov al,4
      cmp al,byte[rdul]
	jz  DnLt
      jmp 7C00H	

DnRt:
	inc word[x]
	inc word[y]
	mov bx,word[x]
	mov ax,25					
	sub ax,bx				;到底了，也就是25行
      jz  dr2ur
	mov bx,word[y]
	mov ax,80
	sub ax,bx				;到最右边，也就是80列
      jz  dr2dl				;右下反弹左下
	jmp show
dr2ur:						;到底了，也就是25行，最低到24，即23 24 23
      mov word[x],23
      mov byte[rdul],Up_Rt	;右下反弹右上
      jmp show
dr2dl:
      mov word[y],78		;右下反弹左下，最右到79，即 78 79 78
      mov byte[rdul],Dn_Lt	
      jmp show
	  
	  

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[x]				;x判断在前
	mov ax,12					;最上为0， 0 1 0
	sub ax,bx
      jz  ur2dr
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  ur2ul

	jmp show
ur2ul:
      mov word[y],78
      mov byte[rdul],Up_Lt	
      jmp show
ur2dr:
      mov word[x],14
      mov byte[rdul],Dn_Rt	
      jmp show

	
	
UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,12
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,-1				;Y
	sub ax,bx
      jz  ul2ur
	jmp show

ul2dl:
      mov word[x],14
      mov byte[rdul],Dn_Lt	
      jmp show
ul2ur:
      mov word[y],1
      mov byte[rdul],Up_Rt	
      jmp show

	
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,25
	sub ax,bx
      jz  dl2ul
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  dl2dr

	jmp show

dl2dr:
      mov word[y],1
      mov byte[rdul],Dn_Rt	
      jmp show
	
dl2ul:
      mov word[x],23
      mov byte[rdul],Up_Lt	
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
	jmp loop1
	

	

	
end:
    jmp $                   ; 停止画框，无限循环 
	
datadef:	
	count dw delay
    rdul db Dn_Rt         ; 初始为1
    x    dw 13			
    y    dw 0
    char db '#'				
	str0 db  "17341189 YaoSenjian"
	str1 db  " welcome to my OS! "
	str6 db  "        ** **      "
	str7 db  "       *******     "
	str2 db  "        *****      "
	str8 db  "          *        "


	

