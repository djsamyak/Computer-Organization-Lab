;(2+4-1)*2/1

ORG 100h  

mov bx,4
mov cx,1
mov dx,2

mov ax,dx
add ax,bx
sub ax,cx
mul dx
div cx
