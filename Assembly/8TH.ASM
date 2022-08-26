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
       mov sp,6
       mov bx,0h
       mov si,0h
       mov bp,0h
       mov di,0h
       mov ax,table
       mov es,ax
       mov cx,21

s0:    push di
       add di,di
       mov ax,ds:[bp][di]
       mov word ptr es:[bx][si],ax
       mov ax,ds:[bp][di+2]
       mov word ptr es:[bx][si+2],ax
       add si,5
       add bp,84
       
       mov ax,ds:[bp][di]
       mov word ptr es:[bx][si],ax
       mov ax,ds:[bp][di+2]
       mov word ptr es:[bx][si+2],ax
       mov ax,ds:[bp][di]
       mov dx,ds:[bp][di+2h]
       

       add si,5
       add bp,84

       pop di
       push cx
       mov cx,ds:[bp][di]
       mov word ptr es:[bx][si],cx
       pop cx
       add si,3
       div word ptr ds:[bp][di]
       mov es:[bx][si],ax
       mov bp,0h
       mov si,0h

       add bx,16
       add di,2
       

       loop s0
       mov ax,4c00h
       int 21h
table ends
end start
