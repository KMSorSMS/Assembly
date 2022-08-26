assume cs:code
code segment
start:
mov ax,0
mov es,ax
mov di,0200h
mov es:[4*7ch],di
mov es:[4*7ch+2],es
mov ax,cs
mov ds,ax
mov si,offset d7
mov cx,offset d7end-offset d7
rep movsb
mov ax,4c00h
int 21h
d7:
push bp
mov bp,sp
dec cx
jcxz ok1
add [bp+2],bx
ok1:
pop bp
iret
d7end:nop
code ends
end start