assume cs:code

code segment
start:
;dl用于切换端口
mov dl,9
;显示位置
mov ax,0b800h
mov es,ax
mov di,160*12+34*2
;循环次数
mov cx,3
s1:
push cx
mov al,dl
out 70h,al
in al,71h

mov ah,al
mov cl,4
shr ah,cl   ;高位，十位
add ah,30h
and al,00001111b   ;低位，个位
add al,30h

mov es:[di],ah
mov es:[di+2],al
pop cx
cmp cx,1
je ok0
mov byte ptr es:[di+4],'\'
;下一个信息
dec dl

ok0:
add di,6

loop s1

mov dl,4
mov cx,3
s2:
push cx
mov al,dl
out 70h,al
in al,71h

mov ah,al
mov cl,4
shr ah,cl   ;高位，十位
add ah,30h
and al,00001111b   ;低位，个位
add al,30h

mov es:[di],ah
mov es:[di+2],al
pop cx
cmp cx,1
je ok1
mov byte ptr es:[di+4],':'
;下一个信息
sub dl,2

add di,6
ok1:

loop s2

mov ax,4c00h
int 21h
code ends
end start