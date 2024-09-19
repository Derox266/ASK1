         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x        equ __?float64?__(1000.0)

         sub esp, 2*4  ; esp = esp - 8

;        esp -> [][][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to that address
format:
         db "log10 = %f", 0xA, 0

length   equ $-format
addr_x   dq x

getaddr:

;                       +4
;        esp -> [format][ ][ ][ret]

         finit  ; fpu init

         mov eax, [esp]   ; eax = *(int*)esp = format
         add eax, length  ; eax = eax + length = format + length = addr_x

         fld1  ; fpu load 1.0

;        st = [st0] = [1.0]

         fld qword[eax]  ; *(double*)(eax) = *(double*)addr_x = x ; fpu load floating-point

;        st = [st0,st1] = [x, 1.0]

         fyl2x  ; [st0, st1] => [st0, st1*log2(st0)] => [st1*log2(st0)]

;        st = [st1*log2(st0)] = [y*log2(x)]

         fldlg2  ; [st0, st1] => [log2(10), y*log2(x)]

         fmul st0, st1  ; [log2(10) * y*log2(x), y*log2(x)]

         fstp qword [esp+4] ; *(double*)esp+4 <- st = [y*log2(x)] ; fpu store top elementand pop fpu stack

;        st = []

         call [ebx+3*4]  ; pritnf("log2 = %f")
         add esp, 4

;        esp -> [format]

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

ebx    -> [ ][ ][ ][ ] -> exit
ebx+4  -> [ ][ ][ ][ ] -> putchar
ebx+8  -> [ ][ ][ ][ ] -> getchar
ebx+12 -> [ ][ ][ ][ ] -> printf
ebx+16 -> [ ][ ][ ][ ] -> scanf

%endif
