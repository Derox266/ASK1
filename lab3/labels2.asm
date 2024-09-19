         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader
;adres1
_720100   call _720107  ; push on the stack the return address _addr2 and jump to _720107

_720105   nop  ; no operation

;        esp -> [ret]

_720106   ret  ; return to asmloader

_720107   nop  ; no operation

;        esp -> [_720105][ret]

_720108   ret  ; return to _720105

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