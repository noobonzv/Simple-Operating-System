   org 0a500h
message db ' SYSU' 

start:
	xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
    mov ax,cs					; 开机这些寄存器都为0
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h
 
    mov bp,message  ;
    mov ah,13h      ;在teletype模式下显示字符串
    mov al,1   		;表示字符串中仅包含字符，不包含属性，属性在BL中，移动光标
    mov bl,0   		;属性初始值
    mov bh,0  		;页码
    mov dh,12   	;从12行开始


    mov cx,12   	;循环12行

loop1: 			    ;外层循环

    push cx   		;保护
    mov dl,0  		;属性，列
    mov cx,8  		;循环8次
	
	push cx
	push dx
	push ax			;int 13h
	mov ah,86h
    mov cx,01h
    mov dx,0x8480     
    int 15h 
	pop ax		
	pop dx
	pop cx
	
loop2:        	    ;内层循环
    push cx   		;保护
    mov cx,5  		;字符串长度
    int 10h  		;BIOS中断调用
    inc bl    		;属性值增加1
    add dl,5  		;列值增加5 
    pop cx
    loop loop2 	    ;内层循环

    pop cx
    inc dh    		;改变行，行增加1  
    loop loop1  	;外层循环


	mov ah,86h
    mov cx,10h
    mov dx,0x8480     
    int 15h 

	
	jmp 7c00h
	
times 510-($-$$) db 0
    db 0x00,0x00