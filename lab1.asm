.model small
 
.stack 100h
 
.data
        InFileName      db      'lab1.txt', 0
        InFileHandler   dw      ?
 
        errFileOpen     db      'File open error', '$'
        errFileLSeek    db      'File lseek error', '$'
        errFileWrite    db      'File write error', '$'
        errFileClose    db      'File close error', '$'
 
        CrLf    db      0Dh, 0Ah, '$'
 
        Array           db      100 dup(?)
        N               dw      ?
 	sum		 dw 	 0
        Char            db      ?
 
.code
 
main    proc
        mov     ax,     @data
        mov     ds,     ax
 
        ;открытие файлов
 
        mov     ah,     3Dh
        mov     al,     00h     ;открыть для чтения
        lea     dx,     InFileName
        int     21h
        jnc     @@InFileOpenOk
        mov     ah,     09h
        lea     dx,     errFileOpen
        int     21h
        jmp     @@Exit
@@InFileOpenOk:
        mov     [InFileHandler],        ax
 
 
        lea     di,     [Array]
        mov     ax,     ds
        mov     es,     ax
InputArray:
 
        mov     bl,     0       ;временное хранение считанного числа
        mov     dx,     0       ;считано 0 байт
        @@InputUInt8:
                call    GetChar
                jc      @@CloseIfFile
                xchg    ax,     cx
                cmp     ax,     cx
                jne     @@Break
 
                sub     [Char], '0'
                jb      @@Break
                cmp     [Char], 9
                ja      @@Break
                mov     al,     10
                mul     bl
                mov     bl,     [Char]
                add     bl,     al
 
                inc     dx      ;признак считывания хоть одной цифры
        jmp     @@InputUInt8
@@Break:
        or      dx,     dx
        jz      @@SkipStore
        mov     [di],   bl
        inc     di
        inc     [N]
@@SkipStore:
        or      cx,     cx
        jne     InputArray
 
 
@@CloseIfFile:
        mov     ah,     3Eh
        mov     bx,     InFileHandler
        int     21h
        
        lea si, Array
        mov cx, [N]
        jnc     SumOfArray
        mov     ah,     09h
        lea     dx,     errFileClose
        int     21h
        
SumOfArray:
	mov al, byte[si]
	jz [sum]
	xor ax, ax
	inc si
	loop SumOfArray
@@Exit:
        mov     ax,     4C00h
        int     21h
main    endp
 
GetChar proc
        push    bx
        push    dx
        mov     ah,     3Fh
        mov     bx,     [InFileHandler]
        mov     cx,     1
        lea     dx,     [Char]
        int     21h
        pop     dx
        pop     bx
        ret
GetChar endp
 
end     main
