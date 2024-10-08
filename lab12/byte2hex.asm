         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x        equ 8  ; x..15

bajt     equ 255

         call getaddr ; push on the stack the run-time adress of format and jump to getaddr

format:  db "byte2hex = "
hex      db 0, 0, 0xA, 0

getaddr:

         mov edi, [esp]  ; edi = *(int*)esp = format
         
         lea edi, [edi + hex - format]  ; edi = format + hex - format =

         mov eax, bajt  ; eax = bajt
         
         mov dl, al  ; dl = al
         
         shr al, 4  ; al = al >> 4 = al / 16

         cmp al, 9  ; al - 9 ; OF SF ZF AF PF CF affected

         jbe _09  ; al - 9
         
_AF      add al, 'A' - 10 - '0'  ; al = al + 'A' - 10 - '0'

_09      add al, '0'  ; al = al + '0'

         mov [edi], al  ; *(char*)edi = al
         
         inc edi  ; edi++
         
         and dl, 00001111b  ; dl = dl & 00001111b

         cmp dl, 9  ; dl - 9 ; OF SF ZF AF PF CF affected

         jbe _09_  ; al - 9
         
_AF_     add dl, 'A' - 10 - '0'  ; al = al + 'A' - 10 - '0'

_09_     add dl, '0'  ; al = al + '0'

         mov [edi], dl  ; *(char*)edi = dl


         call [ebx+3*4]  ; printf(format);
         add esp, 1*4    ; esp = esp + 4

;        esp -> [ret]

         push 0          ; esp -> [00 00 00 00][ret]
         call [ebx+0*4]  ; exit(0);

; asmloader API
;
; ESP wskazuje na prawidlowy stos
; argumenty funkcji wrzucamy na stos
; EBX zawiera pointer na tablice API
;
; call [ebx + NR_FUNKCJI*4] ; wywolanie funkcji API
;
; NR_FUNKCJI:
;
; 0 - exit
; 1 - putchar
; 2 - getchar
; 3 - printf
; 4 - scanf
;
; To co funkcja zwr�ci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387

%ifdef COMMENT

Tablica API

ebx    -> [ ][ ][ ][ ] -> exit
ebx+4  -> [ ][ ][ ][ ] -> putchar
ebx+8  -> [ ][ ][ ][ ] -> getchar
ebx+12 -> [ ][ ][ ][ ] -> printf
ebx+16 -> [ ][ ][ ][ ] -> scanf

%endif
