;需求分析：
    ;需要1、数据集中：年  总收入 员工收入（计算获得，直接套用8p.asm )
    ;需要2、数据显示：因为某些数字已经大于65535需要重写dtoc
    ;对于dtoc：
     ;   function：将dword型数据转变为表示10进制的字符串，以0结尾
      ;  ax = dword的低位
       ; bx = dword的高位
        ;ds:si指向字符串的首地址

assume cs:code, ds:data,ss:stack

data_i segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
data_i ends

data_print segment
dd 10 dup (0)
data_print ends

data segment 
    db 21 dup ('year summ ne ?? ')
data ends

stack segment 
dw 10 dup(0)

code segment 
start:
   mov ax,data     ;最终表所在段
       mov ds,ax       
       mov ax,data_i   ;原始数据所在段区
       mov es,ax     
       mov ax,stack
       mov ss,ax
       mov sp,20

       call mov_data  ;进行数据转移
       mov bx,0
       mov si,0
       mov bp,0
       mov di,0
       mov ax,data_print       ;放置打印内容的段
       mov es,ax
       mov dl,1
       mov dh,2                ;把位置参数置零便于后面打印(注意我初始的位置)
       mov cx,21

       s2:
       push cx
       mov cl,01001001b
       mov ax,[bx][si]
       mov es:[bp][di],ax
       mov ax,[bx][si+2]        ;移动两次，dword
       mov es:[bp][di+2],ax
       mov word ptr es:[bp][di+4],0

       push ds
       mov ax,es
       mov ds,ax

       call show_str
       add dl,20            ;换列显示
       pop ds

       add si,5            ;移到下一列
       push dx             ;保存打印位置
       mov ax,[bx][si]     ;下一列数据移到ax，dx内完成转移
       mov dx,[bx][si+2]
       call dtoc      ;进行十进制转换
       pop dx 

       push ds
       mov ax,es
       mov ds,ax

       call show_str
       pop ds

       add dl,20
       add si,5             ;移到下一列

       push dx
       mov ax,[bx][si]
       mov dx,0
       call dtoc
       pop dx

       push ds         ;打印内容段更改
       mov ax,es
       mov ds,ax
       call show_str
       add dl,12
       pop ds

       add si,3          ;移到下一列数据
       push dx
       mov ax,[bx][si]
       mov dx,0
       call dtoc
       pop dx

       push ds
       mov ax,es
       mov ds,ax
       call show_str
       pop ds

       inc dh          ;换到下一行
       add bx,16       ;数据换到下一行
       mov dl,1        ;列归1！！！
       mov si,0        ;reset si

       pop cx
       loop s2



    mov ax,4c00h
    int 21h

dtoc:
;并不能直接用之前的代码，因为数据更大超过了65535（word）
push di
push sp
push cx
push ax
push es 
push si 


mov di,sp                 ;记录此时栈顶位置
s1:
mov cx,10                 ;进入循环取余数，
;由于是dword类型用divdw除法（ax放低16位，dx放高16位，cx放除数）
call divdw                ;首先还是和10相除取出余数

push cx                   ;完成除法后余数入栈（只用cl），jcxz判断两次ax与dx，ax==0，dx==0，jmp来实现部分
mov cx,ax
jcxz next
jmp go
next:
mov cx,dx


jcxz ok

go:
add cx,1   ;因为到这里的cx为1时代表商是1，不是0，还要继续，如果不加1，会退出循环
loop s1                     ;循环

ok:
mov ax,data_print
;定位到对应段和对应索引
mov es,ax
mov bp,0    ;初始化索引
mov si,0
s3:
pop ax;倒序出栈，和初始栈顶比较，将初始拉入cx
add al,30h       ;加上30h，转为ASCII形式数据（1byte）
mov es:[bp][si],al  
add si,1
mov cx,di        ;把最开始栈顶的位置给cx
sub cx,sp        ;初始栈顶与当前栈顶做差入cx
jcxz ok1         ;比较是否栈空，是则出
loop s3
ok1:
mov word ptr es:[bp][si],0
pop si
pop es
pop ax
pop cx
pop sp
pop di
ret




;防溢出dword除法
;function：
;param:
;       ax = dword(高位数据)（输入&&结果）
;       dx = dword(低位数据)（输入&&结果）
;       cx = 除数（结果返回余数）


divdw: push di 
       push bp 
       push bx

       mov di,dx
       mov bx,ax
       mov ax,dx
       mov dx,0
       div cx
       mov bp,ax
       mov ax,bx
       div cx
       mov cx,dx
       mov dx,bp

       pop bx
       pop bp
       pop di

       ret




mov_data:
       push ax
       push ds
       push es
       push ss
       push sp




    ;for si:是记录原始数据索引（列
    ;di：记录最终数据索引（列
    ;bx:记录原始数据行号
    ;bp:记录最终数据行号

       mov si,0h
       mov di,0h
       mov bx,0h
       mov bp,0h
       mov cx,21   ;循环次数

s0:    push si
       add si,si        ;因为si是代表对于字（公司员工的脚标），所以对于dword类型（年份和总收入要×2）

       mov ax,es:[bx][si]  ;原始数据的第一类第si项入ax寄存器
       mov ds:[bp][di],ax  ;完成数据转移(低位)
       mov ax,es:[bx][si+2]
       mov ds:[bp][di+2],ax ;完成数据转移（高位）
       add bx,84        ;移到下一类数据
       add di,5        ;最终表移到下一个元素

       mov ax,es:[bx][si]  ;低位记录
       mov ds:[bp][di],ax  ;转移低位
       mov dx,es:[bx][si+2]
       mov ds:[bp][di+2],dx  ;转移高位
       add bx,84      ;change the class of initil data
       add di,5        ;change table element's index

       pop si
       push cx
       mov cx,es:[bx][si]
       mov ds:[bp][di],cx
       add di,3         ;change table element's index to the next
       div word ptr es:[bx][si]
       mov ds:[bp][di],ax
       pop cx


       mov bx,0  ;reset initial data class
       mov di,0  ;reset  fianl tale element index
       add si,2  ;change to next element in initial data
       add bp,16 ;change to the next line in final data

loop s0

pop sp
pop ss
pop es
pop ds
pop ax

ret

show_str:
push di
push dx
push cx
push es 
push ax
push si
push bx
dec dh
dec dl

mov si,0           ;把si置0，从段的第一个元素开始
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
jcxz ok2
mov cl,[si]
mov es:[bx+di],cl

inc si
inc di

mov es:[bx+di],dl
inc di

loop s

ok2:
pop bx
pop si
pop ax
pop es
pop cx
pop dx
pop di
ret

code ends
end start