assume cs:code

code segment
;安装7ch流程
start:
mov ax,0
mov es,ax
mov di,0200h
mov ax,cs
mov ds,ax
mov si,offset int7chend-offset int7ch 

cld
rep movsb

mov word ptr es:[4*7ch],0200h
mov word ptr es:[4*7ch+2],0

mov ax,4c00h
int 21h

int7ch:

push cx
push es
push dx
push bx
push ax

mov ax,dx
mov dx,0
mov bx,18*80
div bx
mov bx,18
push ax ;面号
mov ax,dx
mov dx,0
div bx
push ax ;磁道号
inc dx  ;扇区号
pop cx
mov cl,dl

pop dx
mov dl,0    ;驱动器号

pop ax
pop bx
int 13h
pop dx
pop es
pop cx

iret

int7chend:nop
code ends
end start