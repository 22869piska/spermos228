ORG  0x7C00
[BITS 16]

section .text
start:         

          xor ax, ax                  ;Настроить сегменты
          mov ds, ax
          mov es, ax
          mov ss, ax
          mov sp, 0x7C00          ;Стек
		   
      mov ax, 0x0003
      int 0x10;cls
	     
          mov si,start_msg
          CALL print_proc
 	
    mov [bootdrv], dl ;disk запомнить номер
	
    mov ah, 0x02      ;Заранее загружаю ядро перед протектед модом 16kb
    mov al, 32
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootdrv]
    mov bx, 0x1000
    mov es, bx
    mov bx, 0x0000
    int 0x13
	
    in al, 0x92
    or al, 2
    out 0x92, al  ;A20 врубить
	
    mov ax, 0x0
    mov ss, ax
 ;   mov sp, 4096

     cli          
    lgdt [GDT_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax	
	
		    jmp CODE_SEG:protected_mode 
				
GDT_start:
   ; Null descriptor
dd 0                    ; Limit
dd 0   
   ; Код сегмент (CODE_SEG)
dw 0xFFFF                  ; Limit (bits 0-15)
dw 0                       ; Base (bits 0-15)
db 0                       ; Base (bits 16-23)
db 10011010b              ; Access byte
db 11001111b              ; Granularity + Limit (bits 16-19)
db 0                      ; Base (bits 24-31)
; Данные сегмент (DATA_SEG)
dw 0xFFFF                  ; Limit (bits 0-15)
dw 0                       ; Base (bits 0-15)
db 0                       ; Base (bits 16-23)
db 10010010b              ; Access byte
db 11001111b              ; Granularity + Limit (bits 16-19)
db 0          
GDT_end:
GDT_descriptor:
  dw GDT_end - GDT_start - 1  ; Размер GDT
    dd GDT_start                ; Адрес GDT

CODE_SEG equ 0x08
DATA_SEG equ 0x10
;==========================

protected_mode:
     [BITS 32]

    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov ebp, 0x90000
    mov esp, ebp

    jmp CODE_SEG:0x10000
   ;========================;
   [BITS 16]
 
   print_proc:
           print_loop:	
             mov al,[si]
             cmp al,0
             je @RRET	 
   
	     mov ah, 0Eh 
            ; mov al, 
             mov bh, 0     		 
             int 10h      
  			     
	     inc si		  
             jmp print_loop
			 
	     @RRET:
	     RET	 
		 
  
;=========================;
start_msg db "starting_spermOS...",0
err_msg db "disk_err",0


msg1 db "anal",0
bootdrv db 0
 ;---------------------;
 times 510-($-$$) db 0
 dw 0xAA55      
	
