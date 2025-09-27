nasm -f bin main.asm -o main.bin
nasm  -f bin C:\Users\PROPER069\Desktop\pidr\sasunok\code\inc.asm -o C:\Users\PROPER069\Desktop\pidr\sasunok\code\inc.bin



@echo =====================================

copy /b main.bin + code\inc.bin os.img

@echo off

del main.bin
del C:\Users\PROPER069\Desktop\pidr\sasunok\code\inc.bin


rem qemu-system-x86_64 -drive format=raw,file=os.img -vga std

qemu-system-x86_64 -vga std -no-reboot -d guest_errors os.img



@echo on



pause