         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 18
b        equ 99
x        equ 25

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b
         mov edx, x  ; edx = x

         push ecx  ; ecx -> stack
         push eax  ; eax -> stack
         push edx  ; edx -> stack

;        esp -> [edx][eax][ecx][ret]

         cmp edx, eax  ; porownanie wartosci x, a
greater_a:

         je less_b      ; x = a
         jg less_b      ; x > a
         jmp not_equal  ; x < a
less_b:

         cmp edx, ecx  ; porownanie wartosci x, b

         jg not_equal  ; x > b

         call getaddr1
format1:

         db "%d nalezy do [%d, %d]", 0xA, 0
getaddr1:

;        esp -> [format1][edx][eax][ecx][ret]

         call [ebx+3*4]  ; printf(format1, edx, eax, ecx);

         jmp getaddr3

not_equal:

         call getaddr2
format2:

         db "%d nie nalezy do [%d, %d]", 0xA, 0
getaddr2:

;        esp -> [format2][edx][eax][ecx][ret]

         call [ebx+3*4]  ; printf(format2, edx, eax, ecx);
getaddr3:

         add esp, 4*4    ; esp = esp + 16

;        esp -> [ret]

         push 0          ; esp ->[0][ret]
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
; To co funkcja zwróci jest w EAX.
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
