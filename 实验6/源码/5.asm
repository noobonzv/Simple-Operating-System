	;org 09c00h
	org 100h
	push ax
	push bx
	push cx
	push dx
	push ds
	push es
	push si
	push bp
	
	xor ax,ax					
    mov ax,cs					
	mov es,ax					
	mov ds,ax					
	mov es,ax

	mov ah,0		;test0
	int 21h
	
	mov ah,1		;test1
	int 21h
	
	mov ah,5		;test5 clear screen
	int 21h
	
	mov ah,2		;test2
	int 21h
	
	mov ah,3		;test3
	int 21h

	pop bp
	pop si
	pop es
	pop ds
	pop dx
	pop cx
	pop bx
	pop ax
	
	jmp $



 times 1022-($-$$) db 0
     db 0x00,0x00
	
	

	

