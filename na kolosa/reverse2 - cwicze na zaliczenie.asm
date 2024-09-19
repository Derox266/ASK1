         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader
a        equ 7
b        equ 9

         push a  ; a -> stack
         push b  ; b -> stack

;        esp -> [b][a][ret]

         push dword [ebx];
         
;        esp -> [][b][a][ret]


         call getaddr ; push on the stack the run-time adress of format and jump to getaddr

format:  db "adres b: %d" , 0xA, 0


getaddr:
;        esp -> [FORMAT][][ret]

         call [ebx+3*4]  ; printf(format, ecx);
         add esp, 4*4      ; esp = esp + 4

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
