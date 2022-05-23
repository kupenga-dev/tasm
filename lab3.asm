.model large

data segment
        string     db 100,100 DUP('$')
 
        enterStr db 13,10,'Please enter you string: $'
        decmax_out  db 13,10,'The Maximum is:$'
        decmin_out db 13,10,'The Minimum is:$'
 
        myStrMax db 200
        myStrLen db ?
        myStr    db 210 dup(?)
data ends
code segment
assume cs:code,ds:data
start:
        mov ax, data
        mov ds, ax
 
        ;------------------------------------
        ;-----------------Приглашение к вводу
        mov ah, 09h
        mov dx, offset enterStr
        int 21h
        ;-----------------Вводим строку
        mov ah, 0ah
        lea dx, myStrMax
        int 21h
        ;-----------------Готовимся к обработке
        xor ch,ch
        cld
        mov cl, [myStrLen]
        lea si, myStr
        mov ah, [si]
        ;-----------------Ишем максимум
        findMax:
                lodsb         ;Загружаем 1 байт в регистр Al
                cmp ah, al
                jge findNext  ;больше или равно
                mov ah, al
        findNext:
                loop findMax
 	;-----------------Готовим число к выводу
        mov al, ah
        xor ah, ah
        push ax
        ;-----------------вывод строки "максимум"
        mov ah, 09h
        lea dx, decmax_out
        int 21h
        pop ax
        ;-----------------вывод сам аски код
        call out_dec
        ;-----------------вывод в дос
        mov ah, 4ch
        int 21h
        ;-----------------вывод
        out_dec:
                xor cx, cx
                mov bx, 10
 
        out_dec_div:
                xor dx, dx
                div bx
                or dx, 30h            ;остаток от деления
                push dx               ;сохраняем в стеке
                inc cx                ;считаем кол-во цифр
                or ax, ax             ;пока не 0 - делим
                jnz out_dec_div
 
        out_dec_out:
                pop ax               ;извлекаем из стека
                int 29h              ;и выводим подсчитаенное кол-во цифр
                loop out_dec_out
 
 
 	;-----------------Готовимся к обработке
 	mov ah, 8h
        int 21h
        mov ah, 4ch
        mov al, 0
        
        xor ch,ch
        cld
        mov cl, [myStrLen]
        lea si, myStr
        mov ah, 255 
        ;-----------------Ишем минимум
        findMin:
                lodsb         ;Загружаем 1 байт в регистр Al
                cmp al, ah
                jae findNextMin  ;меньше или равно
                mov ah, al
        findNextMin:
                loop findMin
 	;-----------------Готовим число к выводу
        mov al, ah
        xor ah, ah
        push ax
        ;-----------------вывод строки "минимум"
        mov ah, 09h
        lea dx, decmin_out
        int 21h
        pop ax
        ;-----------------вывод сам аски код
        call out_dec
        ;-----------------вывод в дос
        mov ah, 4ch
        int 21h
        ;------------Нажатие
        mov ah, 8h
        int 21h
        ;------------Выход
        mov ah, 4ch
        mov al, 0
        int 21h
code ends
end start
