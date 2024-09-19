#include <stdio.h>

/*
	r0	 r1	  r2
	n-2  n-1 n
	|---|---|       
    1   2   3   4   5   6    indeksy
    3   4   8   12  22  35   wartości
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
		r2 = r2 = 0.5*r1 + 2*r0;
	}
	
	return r2;
}

/*
- ile razy należy przesunąć ramkę w prawo, aby wyznaczyć wartość n-tego wyrazu ciągu w funkcji seq dla n >= 3 ?
 n-3

- dokonaj analizy wywołania seq1(4)

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
  
- narysuj graf obliczeń dla seq1(4)

s(1)  s(2)    s(3)
         \   /  
          s(4)  
          
*/


/*
obliczanie przy pomocy ramki dwuzębnej

r0  r1
|---|
1   2   3   4   5   6    indeksy
3   4   8   12  22  35   wartości
|   |---|
pom r0  r1


Przesunięcie ramki w prawo:

pom = r0
r0 = r1
r1 = 0.5*r0 + 2*pom


*/

int seq2(int n) {
	
	int r0 = 3;
	int r1 = 4;
	
	if (n == 1) return r0;
	if (n == 2) return r1;
	
	int pom;
	int i;
	
	for(i = 3; i <= n; i++) {
		pom = r0;
		r0 = r1;
		r1 = 0.5*r0 + 2*pom;
	}
	return r1;
}

/*

- ile razy należy przesunąć ramkę w prawo, aby wyznaczyć wartość n-tego wyrazu ciągu w funkcji seq2 dla n >= 2 ?
n-2 razy


- dokonaj analizy wywołania seq2(4)
 seq2(4) = 12
 r0 = 3
 r1 = 4

 n == 1 false
 n == 2 false

 pom
 i

 i=3 <= 4	pom = 3
 			r0 = 4
 			r1 = 0.5*4 + 2*3 = 8	i = 4
 
 4 <= 4		pom = 4
 			r0 = 8
			r1 = 0.5*8 + 2*4 = 12	i = 5
			
 5 <= 4		false
 
 return r1 = 12	 	

- narysuj graf obliczeń dla seq2(4)

s(1)     s(2)
    \   /  |
     s(3)  |
        \  |
         s(4)
         

- która funkcja ma mniejszą złożoność obliczeniową seq1 czy seq2 
seq1

*/

int main() {
	printf("sequence.c\n\n");
	
	int n = 4;
	
	printf("seq1(%u) = %u", n, seq1(n));
	printf("\nseq2(%u) = %u", n, seq2(n));
	
	return 0;
}
