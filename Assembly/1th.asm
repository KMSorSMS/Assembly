assume cs:codesg

codesg segment

    mov ax,bx
    mov bx,1000h
    add ax,bx
    add ax,ax

    mov ax,4c00h
    int 21H

codesg ends

end