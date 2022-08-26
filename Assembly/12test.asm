assume cs:code

code segment
start:
mov ax,1000h
mov bl,1h 
div bl
mov ax,4c00h
int 21h
code ends
end start