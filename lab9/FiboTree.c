#include <stdio.h>
#include <stdlib.h>

int f(int n) {
	if (n == 0) return 1;	
	if (n == 1) return 1;
	
	return f(n-1) + f(n-2);	
}

int fibo(int n) {
	static int wywolanie;
	
	wywolanie++;
	
	printf("fibo%u(%u) = %u\n", wywolanie, n, f(n));
	
	if (n == 0) return 1;	
	if (n == 1) return 1;
	
	return fibo(n-1) + fibo(n-2);	
}

int main() {
    printf("FiboTree.c\n\n");
    
    int n = 4;
    
    fibo(n);
    
    return 0;
}
