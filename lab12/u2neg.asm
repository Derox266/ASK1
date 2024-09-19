         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

equ      6

         mov eax, 6  ; eax = a
         
         xor eax, ~0  ; eax = eax ^ ~0
         inc eax      ; eax = eax + 1
         
         mov ecx, a  ; ecx = a
         
         not ecx  ; ecx = ~ecx
         inc ecx  ; ecx = ecx + 1
         
         mov edx, a  ; edx = a
         
         neg edx  ; edx = -edx
         
         push eax  ; eax -> stack
         push ecx  ; ecx -> stack
         push edx  ; edx -> stack
         
;        esp -> [edx][ecx][eax][ret]

         call getaddr ; push on the stack the run-time adress of format and jump to getaddr
format:
         db "-a = %d", 0xA
         db "-a = %d", 0xA
         db "-a = %d", 0xA, 0
getaddr:

;        esp -> [format][edx][ecx][eax][ret]

         call [ebx+3*4]  ; printf(format, edx, ecx, eax);
         add esp, 4*4    ; esp = esp + 4*4

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
