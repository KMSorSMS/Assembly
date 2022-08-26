assume cs:codesg,ds:datasg

datasg segment
        db 'Devoted to What Truly love'
        db 01010010b,01000010b,11110001b

datasg ends


codesg segment
start:        mov ax,0b800h
        mov es,ax
        mov ax,datasg
        mov ds,ax
        mov bp,070eh
        mov bx,0h
        mov cx,26

s:      mov dl,[bx]
        mov es:[bp],dl
        mov es:[bp+160],dl
        mov es:[bp+320],dl
        inc bp

        mov dl,01010010b
        mov es:[bp],dl
        mov dl,01000010b
        mov es:[bp+160],dl
        mov dl,11110001b
        mov es:[bp+320],dl

        inc bp
        inc bx

        loop s

        mov ax,4c00h
        int 21h

codesg ends
end start
