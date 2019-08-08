
extern  macro %1    ;统一用extern导入外部标识符
	extrn %1
endm


extern _cmain:near

.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
DGROUP group _TEXT,_DATA,_BSS
org 100h


start:

setTimer:
	mov al,34h   ; 设控制字值 
    out 43h,al   ; 写控制字到控制字寄存器 
    mov ax,63830 ; 每秒 20 次中断（50ms 一次） 原来是 29830
    out 40h,al   ; 写计数器 0 的低字节 
    mov al,ah    ; AL=AH 
    out 40h,al   ; 写计数器 0 的高字节 
	
	mov word ptr [es:20h], offset Timer		        ; int 8H定时器
	mov ax,cs 
	mov word ptr [es:22h],ax		
		
	mov ax,cs
	mov ds,ax; DS = CS
	mov es,ax; ES = CS
	mov ss,ax; SS = cs
	
	mov sp, 100h    
	
	call near ptr _cmain
	jmp $	


	include setint.asm	
	include syscll.asm
	
		



_TEXT ends

_DATA segment word public 'DATA'

_DATA ends

_BSS	segment word public 'BSS'
_BSS ends

end start
