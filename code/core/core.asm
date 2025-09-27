ORG 0X1000
 ;===============================================;  
 [BITS 32]


    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    mov ebp, 0x90000
    mov esp, ebp
    
    mov edi, 0xB8000
    mov byte [edi], 'A'
    mov byte [edi+1], 0x07
	

    mov ax, 0x0F58   
    mov [edi], ax    

;================================================;  
jmp $
;================================================;

times 15360 - ($-$$) db 0
