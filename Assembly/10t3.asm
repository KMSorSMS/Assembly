assume cs:code,ss:stack,ds:data

data segment
dd 10 dup (0)
data ends

stack segment
dd 10 dup(0)
stack ends

code segment
start:                         ;开始段
mov ax,data
mov ds,ax
mov si,0
mov ax,stack
mov ss,ax
mov sp,40
mov dh,1          ;指定显示行号
mov dl,1          ;指定显示列号
mov cl,01001101b   ;指定样式 

mov ax,1306h
call dtoc          ;转到函数

mov ax,4c00h
int 21h

dtoc:
push si                  ;二进制转十进制实现
push dx
push cx
mov bx,10
mov bp,sp     ;存sp的值
mov dx,0
s1:
mov dx,0            ;每次都把dx清0，抹去高位
div bx
push dx             ;push只能是字操作
mov cx,ax
jcxz s2
loop s1

s2:
pop bx               ;把上次push进去的dx给pop出来完成倒序输出
add bl,30h
mov [si],bl
inc si
mov cx,bp
sub cx,sp            ;为0说明栈空了（和初始时一样了）
jcxz ok1
loop s2

ok1:
mov byte ptr [si],0          ;把0加上去作为结尾
pop cx
pop dx
pop si
call show_str               ;调用show_str
ret

show_str:
push di         ;show_str实现
push dx
push cx
push es 
push ax
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
mov dx,cx        ;把cx的样式改存到dx里面
mov di,0

s: 
mov cl,[si]
mov ch,0
jcxz ok
mov cl,[si]       ;感觉重复了
mov es:[bx+di],cl

inc si
inc di

mov es:[bx+di],dl
inc di

loop s

ok:pop ax
pop es
pop cx
pop dx
pop di
ret
code ends        ;没写的话会报：fatal error L1103
end start