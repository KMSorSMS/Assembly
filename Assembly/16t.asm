assume cs:code,ds:data

data segment
a db 'checking f1',0
b db 'checking f2',0
c db 'checking f3',0
d db 'checking f4',0
e dw a,b,c,d 
data ends

code segment
start:
mov ah,2
mov al,3
call check
call delay
int 7ch
call delay

mov ah,1
mov al,5
call check
call delay
int 7ch
call delay

mov ah,3
call check
call delay
int 7ch
call delay

mov ah,0
call check
call delay
int 7ch
call delay

mov ax,4c00h
int 21h



delay:
push ax
push bx
pushf

mov bx,1ah
mov ax,0h 

s1:
sub ax,1
sbb bx,0
cmp ax,0
jne s1
cmp bx,0
jne s1

popf
pop bx
pop ax
ret

check:
push ax
push es
push ds
push si
push di
push bx

mov bl,ah
mov ax,0b800h
mov es,ax
mov di,13*160+2*40
mov ax,data
mov ds,ax
add bl,bl
mov bh,0
mov si,e[bx]   ;得到显示数据偏移位置
s2:
mov cl,[si]
mov ch,0
jcxz ok1 
mov al,[si]
mov es:[di],al
or byte ptr es:[di+1],00000111b
inc si
add di,2
jmp short s2

ok1:
pop bx
pop di
pop si
pop ds
pop es
pop ax

ret

code ends
end start