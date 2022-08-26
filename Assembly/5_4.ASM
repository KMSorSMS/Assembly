assume cs:code

code segment

    mov ax,0
    mov bx,200h
    mov ds,ax
    mov cx,40h

s:  mov [bx],bl
    inc bx

    loop s

    mov ax,4c00h
    int 21h
code ends
end
