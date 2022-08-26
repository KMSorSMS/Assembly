assume cs:code,ds:data,ss:stack


data segment
    db 'I am sorry for what I have done'
    db 11000110b,00001001b,11000111b

data ends

stack segment
db 10 dup (0)
stack ends

code segment 
    
start: mov ax,data
    mov ds,ax

    mov ax,stack
    mov ss,ax
    mov sp,8
    
    mov bx,0h

    mov ax,0b800h
    mov es,ax

    mov bp,0780h
    mov di,54

    mov si,31

    mov cx,3
s2: push cx
    mov cx,31

s1: mov al,[bx]
    mov ah,[si]
    mov es:[bp+di],ax
    add di,2
    inc bx

    loop s1

    pop cx
    inc si
    mov bx,0h
    mov di,54
    add bp,00a0h

    loop s2
    mov ax,4c00h
    int 21h

code ends
end start