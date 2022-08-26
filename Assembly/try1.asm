assume cs:code

code segment
start:
mov ax,0b800h
mov ds,ax
mov si,1
mov cx,2000
mov al,3
mov ah,2
int 7ch
                            ;s:
                            ;and byte ptr [si],11111000b
                            ;add byte ptr [si],al
                            ;add si,2
                            ;loop s

                            ;mov ax,0b800h
                            ;mov es,ax
                            ;mov ds,ax 
                            ;mov di,0
                            ;mov si,160
                            ;mov cx,24     ;24行
                            ;cld
                            ;s3:
                            ;push cx
                            ;mov cx,160     ;每行有160个字符
                            ;rep movsb
                            ;pop cx
                            ;loop s3

                            ;mov di,160*23+2*80
                            ;mov cx,80
                            ;s4:
                            ;mov byte ptr es:[di],' '
                            ;add di,2
                            ;loop s4

mov ax,4c00h
int 21h
code ends
end start