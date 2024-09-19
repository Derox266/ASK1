        [bits 32]

;       esp -> [ret]  ; ret - adres powrotu do asmloader

n       equ 7

        mov ecx, n  ; ecx = n
        mov eax, 1  ; eax = 1

        jecxz done  ; jump if ECX register is 0

petla:
        mul ecx  ; edx:eax = eax * ecx

        sub ecx, 2  ; ecx = ecx - 2
        
        cmp ecx, 0
        jg petla  ; jump if greater           ; jump if SF == OF and ZF = 0

done:
        push eax  ; eax -> stack
        push n    ; n -> stack

;       esp -> [n][eax][ret]

        call getaddr  ; push on the stack the run-time address of format and jump to getaddr
format:
       db "%u!! = %u", 0xA, 0
getaddr:

;       esp -> [format][n][eax][ret]

        call [ebx + 3 * 4]  ; printf(format, n, eax);
        add esp, 4 * 3      ; esp = esp + 12

;       esp -> [ret]

        push 0              ; esp -> [00 00 00 00][ret]
        call [ebx + 0 * 4]  ; exit(0);

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