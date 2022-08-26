assume cs:code

data segment
db 'I am very sad',0
data ends


code segment
start:mov dh,25
mov dl,80
mov cl,11001101b
mov ax,data
mov ds,ax
mov si,0
call show_str

mov ax,4c00h
int 21h

show_str:
push di
push dx
push cx
push es 
push ax
push si
dec dh
dec dl

mov al,dh
mov dh,0a0h

mul dh
mov dh,0
add dl,dl
add ax,dx
mov bx,0b800h
mov es,bx
mov bx,ax
mov dx,cx
mov di,0

s: mov cl,[si]
mov ch,0
jcxz ok
mov cl,[si]
mov es:[bx+di],cl

inc si
inc di

mov es:[bx+di],dl
inc di

loop s

ok:
pop si
pop ax
pop es
pop cx
pop dx
pop di
ret

code ends
end start