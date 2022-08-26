assume cs:codesg

codesg segment
    dw 0001h,0002h,0003h,0004h,0005h,0006h,0007h,0008h
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


start:mov ax,cs
    mov bx,0
    mov ss,ax
    mov sp,30h

    mov bx,0
    mov cx,8

s: push cs:[bx]
   add bx,2
   loop s

s0: pop cs:[bx]
    add bx,2
    loop s0

    mov ax,4c00h
    int 21h
codesg ends
end start
