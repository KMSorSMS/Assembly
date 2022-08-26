assume cs:code

datasg segment
    db "Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends

code segment
start:
;源字符位置 ds:si
mov ax,datasg
mov ds,ax
mov si,0
;显示未切换的字符
mov dh,15
mov dl,3
mov cl,2
call show_str


call letterc

;显示改变后
mov dh,10
mov dl,3
mov cl,2
call show_str

mov ax,4c00h
int 21h

letterc:
push cx
push ax
push si

s1:
;检查是否到末尾
mov ch,0
mov cl,[si]
jcxz ok2
;找到小写字母
cmp byte ptr [si],61h
;若更小
jb ok1
cmp byte ptr [si],7ah
;若更大
ja ok1
mov al,[si]
and al,11011111b 
mov [si],al

ok1:
;转到下一个字符
inc si
jmp s1

ok2:
pop si
pop ax
pop cx
ret


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
end  start