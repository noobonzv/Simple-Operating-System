;程序源代码（myos1.asm）
org  7c00h		
OffSetOfUserPrg1 equ 0A100h

start:
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
	
	mov ax,0600h				;清窗口
    mov ch,0					;左上角行					
    mov cl,0					;左上角列	
    mov dh,24					;右下行		
    mov dl,79					;右下列
    mov bx,0007h				;黑底白
    int 10h
	
	
	; ; pop cx				;延时，测试
	; push cx
	; mov ah,86h
    ; mov cx,10h
    ; mov dx,0x8480     
    ; int 15h 
	; pop cx 
	
	mov	bp, Message		 	; BP=当前串的偏移地址
	mov	ax, ds		  		; ES:BP = 串地址
	mov	es, ax		 		; 置ES=DS
	
	mov	cx, MessageLength   ; CX = 串长
	mov	ax, 1301h		 	; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 	; 页号为0(BH = 0) 黑底白字(BL = 07h)
    mov dh, 0		        ; 行号=0
	mov	dl, 0			 	; 列号=0
	int	10h			 		; BIOS的10h功能：显示一行字符
		  
	mov	dx,0B800h				; 文本窗口显存起始地址
	mov	gs,dx					; GS = B800h

	
	mov cx,4				;显示几行
	mov ax, mess1
	mov si,ax
	mov bp,2400+84			;2个字节
row1:
	push cx
	mov cx,8				;一行的字符数
	
char1:	
	mov ah,07h				
	mov al,[si]				; AL=显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax
	inc si
	add bp,2
	loop char1
	
	add bp,144				;(80-字符数)*2
	pop cx
	loop row1
	
LoadnEx:
      
	mov ax,0
loop1:	  
	mov ah,00h 					;检测键盘	
    int 16h  					;字符在al
	cmp al,0
	jz loop1     				;字符在al
	
	mov bp,152	
	mov ah,07h					;
	mov word[gs:bp],ax
	add bp,2
	sub al,48
	mov bx, OffSetOfUserPrg1    ;偏移地址; 存放数据的内存偏移地址
	cmp al,1
	jz read
	cmp al,2
	jz p2
	cmp al,3
	jz p3
	cmp al,4
	jz p4
p2:
	add bx,200h
	jmp read
p3:
	add bx,400h
	jmp read	
p4:
	add bx,600h
	jmp read
	
read:		
	mov cl,al
	inc cl
	mov ah,2              ; 功能号
	mov al,1              ;扇区数
	mov dl,0              ;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov dh,0              ;磁头号 ; 起始编号为0
	mov ch,0              ;柱面号 ; 起始编号为0
	;mov cl,2             ;起始扇区号 ; 起始编号为1
	int 13H ;             调用读磁盘BIOS的13h功能
						; 用户程序a.com已加载到指定内存区域中
AfterRun:
    jmp bx

Message db "Press 1,2,3 or 4 to show you my OS. It will jump back automatically."
MessageLength  equ ($-Message)
mess1 db "17341189"
mess2 db "  Yao   "
mess3 db "  Sen   "
mess4 db "  Jian  "
      times 510-($-$$) db 0
      db 0x55,0xaa

