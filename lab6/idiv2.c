#include <stdio.h>
#include <stdlib.h>

int main() {
	printf("idiv2.c\n\n");
	
	long long a = -2147483648;
	int b = -3;
	
	int iloraz = a / b;
	int reszta = a % b;
	
	printf("a = %lld\n", a);
	printf("b = %d\n\n", b);
	
	printf("iloraz = %d\n", iloraz);
	printf("reszta = %d\n", reszta);
	
	return 0;
}