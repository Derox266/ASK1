#include <stdio.h>

/*

r0  r1  r2
|---|---|       
0   1   2   3   4   5   6    indeksy
1   1   2   3   5   8   13   wartoœci
    |---|---|
    r0  r1  r2

*/

/*
	r0	 r1	  r2
	n-2  n-1 n
	|---|---|       
    1   2   3   4   5   6    indeksy
    3   4   8   12  22  35   wartoœci
    	|---|---|
      n-2  n-1  n
	  r0   r1   r2
*/

int seq1(int n) {
	int r0 = 3;
	int r1 = 4;
	int r2 = 8;
	
	if (n == 1) return r0;
	if (n == 2) return r1;
	if (n == 3) return r2;
	
	int i;
	
	for(i = 4; i <= n; i++) {
		r0 = r1;
		r1 = r2;
		r2 = 0.5*seq1(n-1) + 2*seq1(n-2);
	}
	
	return r2;
}

/*
- ile razy nale¿y przesun¹æ ramkê w prawo, aby wyznaczyæ wartoœæ n-tego wyrazu ci¹gu w funkcji seq dla n >= 3 ?
 n-3

- dokonaj analizy wywo³ania seq1(4)

* seq1(4) = 12
  r0 = 3
  r1 = 4
  r2 = 8

  4 == 1  false
  4 == 2  false
  4 == 3  false
  
  i
  i = 4
  4 <= 4   r0 = 4
           r1 = 8
           r2 = 0,5*8 + 2*4 = 12    i = 5
  
  5 <= 4   false
  
  return r2 = 12
  
- narysuj graf obliczeñ dla seq1(4)

s(1)  s(2)    s(3)
         \   /  
          s(4)  
             
  
*/

int main() {
//	printf("sequence.c\n\n");
//	
//	int n = 4;
//	
//	printf("seq1(%u) = %u", n, seq1(n));
	
	char *ptr = "ola";  // WskaŸnik do sta³ego ci¹gu znaków
    char str[] = "ola"; // Tablica znaków zawieraj¹ca ci¹g znaków
    
    printf("ptr: %s\n", ptr);
    printf("str: %s\n", str);
   
	
	return 0;
}
