         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 4
b        equ 5
c        equ 6

; exp = a + b * c = 4 + 5 * 6 = 34



         sub esp, 1*4  ; esp = esp - 4
         
;        esp -> [ ][ret]

         call getaddr  ; push on the stack the run-time address of format and jump to getaddr
format:
         db "exp = %i", 0xA, 0
length   equ $-format

addr_a   dd a  ; a  ; define double word
addr_b   dd b  ; b
addr_c   dd c  ; c

getaddr:

;                       +4
;        esp -> [format][ ][ret]

         finit  ; fpu init

;        st = [ ]

         mov eax, [esp]           ; eax = *(int*)esp = format
         lea eax, [eax + length]  ; eax = eax + length = format + length = addr_a

         fild dword [eax] ; *(int*)eax = *(int*)addr_a = a -> st  ; fpu low integer

;        st = [st0] = [a]
         
         fild dword [eax+4]  ; *(int*)(eax + 4) = *(int*)addr_b = b -> st  ; fpu low integer

;        st = [st0, st1] = [b, a]

         fild dword [eax+8]  ; *(int*)(eax + 8) = *(int*)addr_c = c -> st  ; fpu low integer

;        st = [st0, st1, st2] = [c, b, a]

         fmulp st1  ; [st0, st1, st2] => [st0, st0*st1, st2] -> [st0*st1, st2] -> [c*b, a]

;        st = [st0, st1] = [c*b, a]

         faddp st1  ; [st0, st1] => [st0, st1+st0] -> [st1+st0] = [a + c*b]

;        st = [st0] = [a + c*b]

         fistp dword [esp+4]  ; *(int*)(esp+4) <- st = a + c*b  ; fpu store integer and pop

;        st = []

         call [ebx+3*4]  ; printf(format, *(int*)(exp+4));
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
