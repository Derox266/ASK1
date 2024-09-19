%ifdef COMMENT
silnia(n) = 0 + 1 + 2 + ... + n

0! = 1
n! = n*(n-1)!

%endif

         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 2

         mov ecx, n  ; ecx = n

         call silnia   ; eax = silnia(ecx) ; fastcall

raddr:

;        esp -> [ret]

         push eax

;        esp -> [eax][ret]

         call getaddr
format:
         db "silnia = %i", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("silnia = %i\n", eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

;        eax silnia(ecx)

silnia   cmp ecx, 0    ; ecx - 0           ; ZF affected
         jne rec       ; jump if not equal ; jump if ZF = 0
         mov eax, 1    ; eax = 1
         ret

rec      dec ecx       ; ecx = ecx - 1 = n-1
         call silnia   ; eax = silnia(ecx) = silnia(n-1)
         inc ecx       ; ecx = ecx + 1 = n
         mul ecx       ; edx:eax = eax * ecx = silnia(n-1) * n
         ret

; suma(0) = 0
; suma(n) = n + suma(n-1)

%ifdef COMMENT

analiza wywo³ania silnia(2)
eax = silnia(ecx)

* silnia(2) =
  cmp ecx, 0      ; 2 - 0
  jump rec
  dec ecx         ; ecx = ecx - 1 = 2 - 1 = 1
  call silnia(1)

* silnia(1) =
  cmp ecx, 0      ; 1 - 0
  jump rec
  dec ecx         ; ecx = ecx - 1 = 1 - 1 = 0
  call silnia(0)

* silnia(0) = 1
  cmp ecx, 0      ; 0 - 0
  mov eax, 1      ; eax = 1
  ret             ; powrót do silnia(1)

* powrót do silnia(1) = 1
  inc ecx         ; ecx = ecx + 1 = 0 + 1 =  1
  mul ecx         ; eax = eax * ecx = 1 * 1 = 1
  ret             ; powrót do silnia(2)

* powrót do silnia(2) = 2
  inc ecx         ; ecx = ecx + 1 = 1 + 1 = 2
  mul ecx         ; eax = eax * ecx = 1 * 2 = 2
  ret             ; zakoñczenie

%endif

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
