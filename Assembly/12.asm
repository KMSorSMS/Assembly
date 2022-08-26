;安装0号中断例程

assume cs:code

code segment
start:
;定位源代码位置ds:si
mov ax,cs
mov ds,ax
mov si,offset d0

;定位目标位置es:di
mov ax,0
mov es,ax
mov di,0200h

;设置中断向量表的位置
mov es:[4*0],di ;偏移地址
mov es:[4*0+2],es ;段地址

;设置转移长度
mov cx,offset d0end-offset d0

;转移
cld
rep movsb



mov ax,4c00h
int 21h
 


;待转移的代码中断处理代码（中断例程）
d0:
jmp short s0
db "divide error!",0

s0:
push ax
push ds
push si
push cx

;字符位置ds:si
mov ax,cs
mov ds,ax
mov si,202h

;设置显示位置es:di
mov ax, 0b800h
mov es,ax
mov di,12*160+36*2  ;13行37列

;字符放入缓冲区
s1:
mov cl,[si]
mov ch,0
jcxz ok1

mov cl,[si]
mov es:[di],cl
inc si  ;要往后移动
add di,2 ;要往后移动
jmp s1

ok1:
pop cx
pop si
pop ds
pop ax
iret     ;千万千万注意是iret

d0end:nop

code ends
end start


