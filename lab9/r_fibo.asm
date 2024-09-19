%ifdef COMMENT

0   1   2   3   4   5   6    indeksy
1   1   2   3   5   8   13   wartosci

f(0) = 1
f(1) = 1
f(n) = f(n-1) + f (n-2)

Pierwszy i drugi wyraz ci�gu Fibonacciego przyjmuje warto�� 1, 
a ka�dy kolejny wyraz jest sum� dw�ch poprzednich.

%endif

         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 2

         mov ecx, n  ; ecx = n

         call fibo   ; eax = fibo(ecx) ; fastcall

raddr:

;        esp -> [ret]

         push eax

;        esp -> [eax][ret]

         call getaddr
format:
         db "fibo = %i", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("fibo = %i\n", eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

;        eax fibo(ecx)

fibo     cmp ecx, 0    ; ecx - 0           ; ZF affected
         jne next      ; jump if not equal ; jump if ZF = 0
         mov eax, 1    ; eax = 1
         ret
         
next     cmp ecx, 1    ; ecx - 1           ; ZF affected
         jne rec       ; jump if not equal ; jump if ZF = 0
         mov eax, ecx  ; eax = ecx = 1
         ret

rec      dec ecx       ; ecx = ecx - 1 = n - 1
         push ecx      ; ecx -> stack = n - 1
         call fibo     ; eax = fibo(ecx) = fibo(n - 1)
         pop ecx       ; ecx <- stack = n - 1
         dec ecx       ; ecx = ecx - 1 = n - 2
         push eax      ; eax -> stack = fibo(n - 1)
         call fibo     ; eax = fibo(ecx) = fibo(n - 2)
         pop ecx       ; ecx <- stack = fibo(n - 1)
         add eax, ecx  ; eax = eax + ecx = fibo(n - 2) + fibo(n - 1)
         ret



%ifdef COMMENT
analiza wywolania fibo(2)

eax = fibo(ecx)

ecx = 2

* fibo(2) =
cmp ecx, 0    ; 2 - 0    ; jump if not equal
jump next
cmp ecx, 1    ; 2 - 1    ; jump if not equal
jump rec
dec ecx       ; ecx = ecx - 1 = 2 - 1 = 1
push ecx      ; ecx -> stack = 1
call fibo(1) =     ; eax = fibo(ecx) = fibo(1)

* fibo(1) = 1
cmp ecx, 0    ; 1 - 0    ; jump if not equal
jump next
cmp ecx, 1    ; 1 - 1    ; jump if not equal
mov eax, ecx  ; eax = ecx = 1
ret           ; powrot do fibo(2)

* powrot do fibo(2)
pop ecx       ; ecx <- stack = 1
dec ecx       ; ecx = ecx - 1 = 1 - 1 = 0
push eax      ; eax -> stack = fibo(n - 1) = 1
call fibo(0)     ; eax = fibo(ecx) = fibo(n - 2) = fibo(0)

* fibo(0) = 1
cmp ecx, 0    ; 0 - 0           ; ZF affected
              ; jump if not equal ; jump if ZF = 0
mov eax, 1    ; eax = 1
ret           ; powrot do fibo(2)

* powrot do fibo(2)
pop ecx       ; ecx <- stack = fibo(n - 1) = fibo(1) = 1
add eax, ecx  ; eax = eax + ecx = fibo(n - 2) + fibo(n - 1) = fibo(0) + fibo(1) = 1 + 1 = 2



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
; To co funkcja zwr�ci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387
