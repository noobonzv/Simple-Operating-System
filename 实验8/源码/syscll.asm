
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;                              mysyscall.asm
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


; 导入全局变量
extern	_save
extern  _readdata


;****************************
; SCOPY@                    *
;****************************
;局部字符串带初始化作为实参问题补钉程序
public SCOPY@
SCOPY@ proc 
		arg_0 = dword ptr 6
		arg_4 = dword ptr 0ah
		push bp
			mov bp,sp
		push si
		push di
		push ds
			lds si,[bp+arg_0]
			les di,[bp+arg_4]
			cld
			shr cx,1
			rep movsw
			adc cx,cx
			rep movsb
		pop ds
		pop di
		pop si
		pop bp
		retf 8
SCOPY@ endp



;****************************
; void _cls()               *
;****************************

public _cls
_cls proc 
; 清屏
        push ax
        push bx
        push cx
        push dx		
			mov	ax, 600h	; AH = 6,  AL = 0
			mov	bx, 700h	; 黑底白字(BL = 7)
			mov	cx, 0		; 左上角: (0, 0)
			mov	dx, 184fh	; 右下角: (24, 79)
				int	10h		; 显示中断
		pop dx
		pop cx
		pop bx
		pop ax
        ;mov [_disp_pos],0					;光标问题，清屏之后不知会不会出现问题
		ret
_cls endp

;********************************************************
; void _printChar(char ch)                              *
;********************************************************


public _printChar
_printChar proc 
	push bp
    push es
	push ax
    	mov bp,sp
		;***
        mov ax,0b800h
		mov es,ax
		mov al,byte ptr [bp+2+2+2+2] ;pos\ch\IP\bp\es\ax
		mov ah,00Fh
		mov di,[bp+2+2+2+2+2]									;;;;;pos 寻址方式不知道对不对 !!!!!!!!!!!!!!!!!!!!!!!!!!!
		mov	es:[di], ax
		;***
		mov sp,bp
    pop ax
	pop es
	pop bp
	ret
_printChar endp


public _showChar
_showChar proc
	push bp
    push es
	push ax
	push bx
		mov bp,sp
		mov ax,[bp+2+2+2+2+2] ; ASCII码ch\IP\bp\es\ax\bx
		mov ah,0eh ; 显示字符，推进光标
		mov bh,0	; 页码 ???????????????
		mov bl,0 ; Bl设为0
		int 10H ; 调用中断
		mov sp,bp
	pop bx
    pop ax
	pop es
	pop bp
	ret
_showChar endp


;****************************
; void _getChar()           *
;****************************

public _getChar
_getChar proc
	mov ah,0	;等待键盘输入,字符的ASCII码放入AL中。若AL＝0，则AH为输入的扩展码
	int 16h
	mov byte ptr [_save],al
	ret
_getChar endp

ip0 dw 100h
cs0 dw 1000h

public _loadp
_loadp proc	
    push ax		
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
		mov bp,sp
		
		mov ax,word ptr[bp+2+2+2+2+2+2+2+2] 	; 从左起第一个参数	 也就是seg	
		mov ds,ax
		mov es,ax								; 段地址
		mov cl,byte ptr[bp+2+2+2+2+2+2+2+2+2]	; 起始扇区 1 3 5 7
		mov bx,100h			  ;偏移地址
		mov ah,2              ; 功能号
		mov al,2              ;扇区数
		mov dl,0              ;驱动器号 ; 软盘为0，硬盘和U盘为80H
		mov dh,1              ;磁头号 ; 起始编号为0
		mov ch,0              ;柱面号 ; 起始编号为0
		int 13H ;             调用读磁盘BIOS的13h功能				
		
		
		mov ax,cs
		mov ds,ax
		mov word ptr [cs0],es
		mov word ptr [ip0],bx
		mov bx,offset ip0
		call dword ptr ds:[bx]
		
		
	pop ds
	pop es 
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	ret
_loadp endp


public _justLoadp			; for multiprocess
_justLoadp proc	
    push ax		
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
		mov bp,sp
		
		mov ax,word ptr[bp+2+2+2+2+2+2+2+2] 	; 从左起第一个参数	 也就是seg	
		mov ds,ax
		mov es,ax								; 段地址
		mov cl,byte ptr[bp+2+2+2+2+2+2+2+2+2]	; 起始扇区 1 3 5 7
		mov bx,100h			  ;偏移地址
		mov ah,2              ; 功能号
		mov al,2              ;扇区数
		mov dl,0              ;驱动器号 ; 软盘为0，硬盘和U盘为80H
		mov dh,1              ;磁头号 ; 起始编号为0
		mov ch,0              ;柱面号 ; 起始编号为0
		int 13H ;             调用读磁盘BIOS的13h功能	
		
	pop ds
	pop es 
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	ret
_justLoadp endp



public _progInfo
_progInfo proc

	push cx
	push ax
	push dx
	push bx
		
		mov ah,2              ; 功能号
		mov bx,8000h
		mov al,1              ;扇区数
		mov dl,0              ;驱动器号 ; 软盘为0，硬盘和U盘为80H
		mov dh,0              ;磁头号 ; 起始编号为0
		mov ch,0              ;柱面号 ; 起始编号为0
		mov cl,2             ;起始扇区号 ; 起始编号为1
		mov [_readdata],bx 
		int 13H ;             调用读磁盘BIOS的13h功能	

	pop bx
	pop dx
	pop ax
	pop cx
	ret

_progInfo endp



public _shutDown
_shutDown proc

	call _setMyInt
	mov ah,8
	int 21h
	call _resetInt
	ret
_shutDown endp

; ***************************
; 实验7
; ***************************

;加载进程代码
public _run_test_of_7_or_8
_run_test_of_7_or_8 proc
    push ax
	push bp
	
	mov bp,sp
	
    mov ax,[bp+6]      	;段地址 ; 存放数据的内存基地址
	mov es,ax          	;设置段地址（不能直接mov es,段地址）
	mov bx,100h        	;偏移地址; 存放数据的内存偏移地址
	mov ah,2           	;功能号
	mov al,2          	;扇区数 实验7的测试程序要两个扇区
	mov dl,0          	;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov dh,1          	;磁头号 ; 起始编号为0
	mov ch,0          	;柱面号 ; 起始编号为0	*************
	mov cl,[bp+8]       ;起始扇区号 ; 起始编号为1
	int 13H          	; 调用中断
	
	pop bp
	pop ax
	
	ret
_run_test_of_7_or_8 endp




public _stackcopy
_stackcopy proc
    push ds
    push es
    push di
    push si
    push cx
    push ax
    push bp
    mov bp, sp
    mov ax, word ptr [bp+18]   ; 源地址，也就是父进程
    mov ds, ax
    mov ax, word ptr [bp+16]   ; 目的地址,也就是子进程
    mov es, ax
    mov di, 0
    mov si, 0
    mov cx, 100h-4			   ; 全部栈
loop_copy:
    mov al, byte ptr ds:[si]
    mov byte ptr es:[di], al
    inc di
    inc si
    loop loop_copy
    pop bp
    pop ax
    pop cx
    pop si
    pop di
    pop es
    pop ds
    ret
_stackcopy endp




