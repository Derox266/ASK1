         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

%define  UINT_MAX 4294967295

x        equ 10  ; x..4294967295

         push ebx  ; ebx -> stack
         
;        esp -> [ebx][ret]

         call getaddr ; push on the stack the run-time adress of table and jump to getaddr

table    db "0123456789ABCDEF"

format   db "dec2hex = "
hex      times 8 db 0
         db 0xA, 0

getaddr:

;        esp -> [table][ebx][ret]

         mov ebx, [esp]  ; ebx = *(int*)esp = table

         lea edi, [ebx - table + hex]  ; edi = table - table + hex = hex
         
         mov eax, x  ; eax = x
         
         mov ecx, 8  ; ecx = 8
         
         mov ebp, 16  ; ebp = 16

.loop    mov edx, 0

         div ebp     ; eax = edx:eax / ebp  ; iloraz
                     ; edx = edx:eax % ebp  ; reszta
                     
         mov esi, eax  ; esi = eax
         mov eax, edx  ; eax = edx

         xlat  ; al = *(char*) (ebx + al)  ; table lookup translation
         
         mov [edi + ecx - 1], al  ; *(char*)(edi + ecx - 1) = al
         
         mov eax, esi  ; eax = esi
         
         loop .loop
         //tutaj instrukacja add ktora zrobi zeby na szczycie stosu byl format



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
