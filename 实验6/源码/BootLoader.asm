org 7c00h
OS_OFFSET equ 0A100h	

start:
	mov ax,cs
	mov ds,ax
	mov es,ax

ReadOS:
	;OS OFFSET
	mov bx, OS_OFFSET
	mov ah, 2 ; 读扇区
	mov al, 0Ah ; 扇区数不止加载一个扇区！!!!!!!!!!	3-12
	mov dl, 0 ; floppy
	mov dh, 0 ; 磁头
	mov ch, 0 ; 柱面
	mov cl, 3 ; 内核的起始扇区
	int 13h
	
	jmp 0A00h:100h

	jmp $

times 510 - ($ - $$) db 0
db 0x55
db 0xaa
incbin 'data'
incbin 'OS.COM'
times 2400h - ($ - $$) db 0
incbin '1'
times 2800h - ($ - $$) db 0
incbin '2'
times 2c00h - ($ - $$) db 0
incbin '3'
times 3000h - ($ - $$) db 0
incbin '4'
times 3400h - ($ - $$) db 0
incbin '5'
times 3800h - ($ - $$) db 0
times 1474560 - ($ - $$) db 0