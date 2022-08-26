assume cs:code 

code segment
start: mov ax,0h 
    mov dx,1h
    mov cx,9h
    call divdw

    mov ax,4c00h
    int 21h

divdw: push di 
       push bp 
       push bx

       mov di,dx
       mov bx,ax
       mov ax,dx
       mov dx,0
       div cx
       mov bp,ax
       mov ax,bx
       div cx
       mov cx,dx
       mov dx,bp

       pop bx
       pop bp
       pop di

       ret
code ends
end start