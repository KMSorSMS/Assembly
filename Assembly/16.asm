;安装int 7ch新中断程序
;功能如下：
;(1)清屏(2)设置前景色(3)设背景色(4)向上滚动一行
;0      1           2         3
;ah 传送功能号
;对于1、2号功能，用al传送色彩，al有0、1、2、3、4、5、6、7    


assume cs:code 

code segment
start:
mov ax,cs
mov ds,ax
mov si,offset int7ch 

mov ax,0
mov es,ax
mov di,200h

mov cx,offset int7chend-int7ch
cld
rep movsb

mov word ptr es:[4*7ch],200h
mov word ptr es:[4*7ch+2],0h

mov ax,4c00h
int 21h

int7ch:
;模式选择
jmp short choose

table dw offset f1-offset start1,offset f2-offset start1,offset f3-offset start1,offset f4-offset start1

choose:
;根据ah选择
push bx

cmp ah,3
ja ok1
mov bl,ah
add bl,bl
mov bh,0

mov bx,cs:[bx][0202h]
push ax
call addipbx
start1:pop ax
push cs
pop ds
call bx

ok1:
pop bx
iret



addipbx:
pop ax
add bx,ax
push ax
ret



;清屏
f1:
push ax
push si
push cx
push ds

mov ax,0b800h
mov ds,ax
mov si,0

mov cx,2000
s1:
mov word ptr[si],' '
add si,2
loop s1

pop ds
pop cx
pop si
pop ax

ret

;设置前景色
f2:
push ax

push si
push cx
push ds

mov si,0b800h
mov ds,si
mov si,1

;颜色
and al,00000111b

mov cx,2000
s2:
and byte ptr [si],11111000b
add byte ptr [si],al
add si,2
loop s2

pop ds
pop cx
pop si

pop ax

ret

;设置背景色
f3:
push ax
push ds
push si
push cx

mov si,0b800h
mov ds,si
mov si,1

;颜色
mov cl,4
shl al,cl        ;注意al的取值需要对应到背景色
and al,01110000b

mov cx,2000
s3:
and byte ptr [si],10001111b
add byte ptr [si],al
add si,2
loop s3

pop cx
pop si
pop ds
pop ax

ret

;向上滚动一行
f4:
push ax
push es
push di
push ds
push si
push cx

mov ax,0b800h
mov es,ax
mov ds,ax 
mov di,0
mov si,160
mov cx,24
cld
s4s:
push cx
mov cx,160
rep movsb
pop cx
loop s4s

mov di,160*23+2*80
mov cx,80
s4:
mov byte ptr es:[di],' '
add di,2
loop s4

pop cx
pop si
pop ds
pop di
pop es
pop ax

ret

int7chend:nop
code ends
end start