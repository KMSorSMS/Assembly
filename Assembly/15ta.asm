assume cs:code

stack segment
db 128 dup(0)
stack ends

data segment
dw 0,0
data ends

code segment
start:
;初始化
mov ax,stack
mov ss,ax
mov sp,128

push cs
pop ds
mov si,offset int9

mov ax,0
mov es,ax
mov di,204h

mov cx,offset int9end-offset int9   ;循环次数
cld
rep movsb   ;移动安装



;存中断向量表
push es:[4*9h]
pop es:[200h]
push es:[4*9h+2]
pop es:[200h+2]
;放中断向量表
cli
;Attention:前面的di会因为movsb改变
mov word ptr es:[4*9h],204h
mov word ptr es:[4*9h+2],0
sti


mov ax,0b800h
mov es,ax
mov di,[12*160+40*2]
mov al,'A'
s4:
mov es:[di],al
call delay
inc al
cmp al,'Z'
jna s4

mov ax,4c00h
int 21h


delay:
push ax
push dx
pushf

mov dx,1h 
mov ax,0h 
s3:
sub ax,1
sbb dx,0
cmp ax,0
jne s3
cmp dx,0
jne s3

popf
pop dx
pop ax
ret

int9:
push ax
push cx
push dx
push es
push di

in al,60h
;调用原int 9
pushf
call dword ptr cs:[200h]
;一种思路
cmp al,1eh+80h
jne s2

mov ax,0b800h
mov es,ax
mov di,0
mov cx,1000
s1:
mov byte ptr es:[di],'A'
add di,2
loop s1
s2:
pop di
pop es
pop dx
pop cx
pop ax
iret

int9end:nop

code ends
end start