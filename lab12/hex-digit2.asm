         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x        equ 10  ; x..15

         call getaddr ; push on the stack the run-time adress of format and jump to getaddr
table:
         db "0123456789ABCDEF"
getaddr:

;        esp -> [table][ret]

         mov ebp, ebx  ; ebp = ebx
         
         mov ebx, [esp]  ; ebx = *(int*)esp = table
         
         mov al, x  ; al = x

         xlat  ; al = *(char*) (ebx + al)  ; table lookup translation
         
;        esp -> [table][ret]

         push eax  ; stack -> stack
         
;        esp -> [eax][table][ret]

         call getaddr2 ; push on the stack the run-time adress of format and jump to getaddr
format2:
         db "hexDigit2 = %c", 0xA, 0
getaddr2:

;        esp -> [format][eax][table][ret]

         call [ebp+3*4]  ; printf(format, eax);
         add esp, 3*4    ; esp = esp + 12

;        esp -> [ret]

         push 0          ; esp -> [00 00 00 00][ret]
         call [ebp+0*4]  ; exit(0);

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
