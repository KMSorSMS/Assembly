assume cs:code

code segment
start:
;源中断例程位置ds:si
mov ax,cs
mov ds,ax
mov si,offset d7
;目的位置es:di
mov ax,0
mov es,ax
mov di,200h
;中断向量表
mov es:[4*7ch+2],es
mov es:[4*7ch],di
;例程长度
mov cx,offset d7end-offset d7 
;移动
cld
rep movsb
mov ax,4c00h
int 21h

d7:
push dx
push cx
push ax
push es
push si
push di
;dh行号dl列号
dec dh
dec dl
;显示缓存区
mov ax,0b800h
mov es,ax
;行号部分
mov ax,160
mul dh
;列号部分
push ax
mov ax,2
mul dl
;两部分相加
pop dx
add ax,dx
;放入di中，es:di是显示缓存区位置
mov di,ax
;cx的内容存到dx，因为cx后面会有用途
mov dx,cx
s1:
;移动部分ds:si内容移到es:di
mov ch,0
mov cl,[si]
jcxz ok1               ;判断字符是否为0
mov ax,[si]
mov es:[di],ax
mov es:[di+1],dl
inc si
add di,2
jmp short s1

ok1:
pop di
pop si
pop es
pop ax
pop cx
pop dx
iret
d7end:nop
code ends
end start

