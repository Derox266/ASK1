%ifdef COMMENT

0!! = 1
1!! = 1
n!! = n*(n-2)!!


%endif

         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 2

         mov ecx, n  ; ecx = n

         call silniap   ; eax = silniap(ecx) = n!!  ; fastcall

raddr:

;        esp -> [ret]

         push eax

;        esp -> [eax][ret]

         call getaddr
format:
         db "silnia = %i", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("suma = %i\n", eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

;        eax silnia(ecx)

silniap  cmp ecx, 1  ; ecx - 1           ; ZF affected
         jg rec      ; jump if greater           ; jump if SF == OF and ZF = 0
         mov eax, 1  ; eax = 1
         ret

rec      push ecx      ; ecx -> stack = n
         sub ecx, 2    ; ecx = ecx - 2 = n-2
         call silniap  ; eax = silniap(ecx) = silnia(n-2)
         pop ecx       ; ecx <- stack = n

                       ; mnozenie bez znaku
         mul ecx       ; edx:eax = eax*ecx = silnia(n-2) * n
         ret
         
         
%ifdef COMMENT

analiza wywo³ania silnia(2)
eax = silnia(ecx)

* silniap(2) =
  cmp ecx, 1      ; 2 - 1
  jump rec        ; jump if greater
  push ecx        ; ecx -> stack = 2
  sub ecx, 2      ; ecx = 2 - 2 = 0
  call silniap(0) =

* silniap(0) =  1
  cmp ecx, 1      ; 0 - 1
  mov eax, 1      ; eax = 1
  ret             ; powrót do silniap(2)

  * powrót do silniap(2) = 2
  pop ecx         ; ecx <- stack = 1
  mul ecx         ; eax = eax * ecx = silnia(n-2) * n = 2 * 1 = 2
  ret             ; koniec









* silnia1(2) =
  cmp ecx, 0      2 - 0     jump rec
  ecx -> stack = 2
  ecx = ecx - 1 = 2 - 1 = 1

* silnia2(1) =
  cmp ecx, 0      1 - 0     jump rec
  ecx -> stack = 1
  ecx = ecx - 1 = n - 1 = 0

* silnia3(0) =
  cmp ecx, 0      0 - 0
  eax = 1




%endif

; suma(0) = 0
; suma(n) = n + suma(n-1)

%ifdef COMMENT
eax = suma(ecx)

* suma(1) =           * suma(1) = 1
  ecx -> stack = 1      ecx -> stack = 1
  ecx = ecx - 1 = 0     ecx = ecx - 1 = 0
  eax = suma(0) =       eax = suma(0) = 0
  ecx <- stack = 1      ecx <- stack = 1
  eax = eax + ecx =     eax = eax + ecx = 0 + 1 = 1
  return eax =          return eax = 1

* suma(0) =           * suma(0) = 0
  eax = ecx = 0         eax = ecx = 0
  return eax = 0        return eax = 0
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
