assume cs:table,ds:data,ss:stack

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
data ends

stack segment
    db 10 dup (0)
stack ends

table segment
    db 21 dup ('year summ ne ?? ')
start: mov ax,data
       mov ds,ax
       mov ax,stack
       mov ss,ax
       mov sp,6h
       mov ax,table
       mov es,ax
       mov si,0h
       mov di,0h
       mov bx,0h
       mov bp,0h
       mov cx,21

s0:    push si
       add si,si
       mov ax,[bx][si]
       mov es:[bp][di],ax
       mov ax,[bx][si+2]
       mov es:[bp][di+2],ax
       add bx,84
       add di,5

       mov ax,[bx][si]
       mov es:[bp][di],ax
       mov dx,[bx][si+2]
       mov es:[bp][di+2],dx
       add bx,84
       add di,5
       
       pop si
       push cx
       mov cx,[bx][si]
       mov es:[bp][di],cx
       add di,3
       div word ptr [bx][si]
       mov es:[bp][di],ax
       pop cx
       mov bx,0
       mov di,0
       add si,2
       add bp,16

       loop s0
       mov ax,4c00h
       int 21h
table ends
end start