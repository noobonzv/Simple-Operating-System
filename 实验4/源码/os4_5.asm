	org 09c00h
	
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
	
	int 33
	
	int 34
	
	int 35
	
	int 36

	pop bp
	pop si
	pop es
	pop ds
	pop dx
	pop cx
	pop bx
	pop ax
	ret




 times 1022-($-$$) db 0
     db 0x00,0x00
	
	

	

