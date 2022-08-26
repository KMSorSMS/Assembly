comment/*用到的知识：
sti：设置IF=1相应外部中断，
CMOS：从数据端口71h读出数据（用in：BCD码，高4位是10位，低四位是个位。编码+30h就是十进制对应ASCII码American Standard Code for Information Interchange
al发出单元向70h（用out：秒0分2时4日7月8年9
int 9h响应与处理中断（不配合int 16h）

*/

assume cs:code

code segment
;安装程序
start:
mov ax,cs
mov ds,ax
mov si,offset int9

mov ax,0
mov es,ax
mov di,0204h

;老的int9入口在0：0200h中
mov ax,es:[4*9h]
mov es:[0200h],ax
mov ax,es:[4*9h+2]
mov es:[0202h],ax

;新的入口放入int9
mov es:[4*9h],di
mov es:[4*9h+2],es

mov cx,offset int9end - offset int9
cld
rep movsb

mov ax,4c00h
int 21h
;完成安装
int9:
;常规调用原来的nt9
push ax
push es
push bx
push dx
push cx
push di

in al,60h
mov bx,0
mov es,bx
pushf
call dword ptr es:[0200h]

;debug 检查中断处理情况
push bx
push es
mov bx,0b800h
mov es,bx
mov es:[160*10+2*20],al
pop bx
pop es

cmp al,05h+80h
je change
sti

s:
cmp si,0ff00h
je change
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

mov cx,2
loop s

change:
pop di
pop cx
pop dx
pop bx
pop es
pop ax
mov si,0ff00h

;debug 检查中断处理情况
push bx
push es
mov bx,0b800h
mov es,bx
mov bl,'d'
mov es:[160*10+2*10],bl
pop bx
pop es

iret

int9end:nop

code ends
end start