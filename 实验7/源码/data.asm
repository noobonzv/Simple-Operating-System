fun1:
    name1 db "1.com"
    times 8-($-$$) db 0
    pos1 db "19"
    times 12-($-$$) db 0
    size1 db '2'
    times 16-($-$$) db 0
fun2:
    name2 db "2.com"
    times 24-($-$$) db 0
    pos2 db "21"
    times 28-($-$$) db 0
    size2 db "2"
    times 32-($-$$) db 0
fun3:
    name3 db "3.com"
    times 40-($-$$) db 0
    pos3 db "23"
    times 44-($-$$) db 0
    size3 db "2"
    times 48-($-$$) db 0
fun4:
    name4 db "4.com"
    times 56-($-$$) db 0
    pos4 db "25"
    times 60-($-$$) db 0
    size4 db "2"
    times 64-($-$$) db 0


script:
    cmd1 db "r 1 2 4 1"
    times 96-($-$$) db 0

times 512-($-$$) db 0