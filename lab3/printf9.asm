         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 4

         call getaddr
addr_a:
         dd a  ; [ ][ ][ ][ ]  ; define double word
         db "a = %d", 0xA, 0
getaddr:

;        esp -> [addr_a][ret]

         pop eax  ; pop the address of 'a' from the stack into eax

;        esp -> [ret]

         push dword [eax]  ; *(int*)eax = *(int*)addr_a = a -> stack

;        esp -> [a][ret]

         add eax, 4  ; eax wskazuje teraz na tekst "a = %d"
         
         push eax  ; eax -> stack

;        esp -> ["a = %d"][a][ret]

         call [ebx+3*4]  ; printf(format, a);
         add esp, 2*4    ; esp = esp + 8

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
