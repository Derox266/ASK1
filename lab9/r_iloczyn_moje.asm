%ifdef COMMENT

1   2    indeksy
2   8  wartosci

ip(1) = 2
ip(n) = ip(n-1) * 2n  ; dla n = 2, 3, 4, ...


%endif

         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 3

         mov ecx, n  ; ecx = n

         call ip   ; eax = ip(ecx) ; fastcall

raddr:

;        esp -> [ret]

         push eax

;        esp -> [eax][ret]

         call getaddr
format:
         db "ip = %i", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("fibo = %i\n", eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

;        eax = ip(ecx)

ip       cmp ecx, 1    ; ecx - 0           ; ZF affected
         jne next      ; jump if not equal ; jump if ZF = 0
         mov eax, 2    ; eax = 1
         ret
         
next     push ecx      ; ecx -> stack = n
         dec ecx       ; ecx = ecx - 1 = n - 1
         call ip       ; eax = ip(ecx) = ip(n - 1)
         pop ecx       ; ecx <- stack = n - 1
         mov esi, 2    ; esi = 2
         mul esi       ; edx:eax = eax*esi = ip(n-1) * 2
         mul ecx       ; edx:eax = eax*ecx = ip(n-1) * 2 * n
         ret

        ; push eax      ; eax -> stack = fibo(n - 1)
         ;call fibo     ; eax = fibo(ecx) = fibo(n - 2)
        ; pop ecx       ; ecx <- stack = fibo(n - 1)
        ; add eax, ecx  ; eax = eax + ecx = fibo(n - 2) + fibo(n - 1)
        ; ret



%ifdef COMMENT
eax = ip(ecx)

* ip(2) = 8
ecx -> stack = 2
ecx = ecx - 1 = 1
eax = ip(1) = 2
ecx <- stack = 2
ecx = 2*ecx = 4
eax = eax*ecx = 2*4 = 8
return eax = 8

* ip(1) = 2
eax = 2
return eax = 2
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
