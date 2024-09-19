#include <stdio.h>
#include <stdlib.h>

char hexDigit(char x) {
	if (0 <= x && x <= 9) return '0' + x;
	if (10 <= x && x <= 15) return 'A' + x - 10;
}

char hexDigit2(char x) {
	char digits[] = "0123456789ABCDEF";
	
	return digits[x];
}

void byte2hex(unsigned char byte) {
	char hex[2];
	
	char maska = 1 + 2 + 4 + 8; // 0000 1111
	
	hex[1] = hexDigit(byte & maska);
	
	byte = byte >> 4;
	
	hex[0] = hexDigit(byte);
	
	printf("%c%c", hex[0], hex[1]);
} 

int main() {
	printf("konwersje2.c\n\n");
	
	int a = 12;
	
	printf("hexDigit(%d) = %c\n", a, hexDigit(a));
	printf("hexDigit2(%d) = %c\n", a, hexDigit2(a));
	printf("\n");
	
	unsigned char byte = 128;
	
	printf("byte2hex(%d) = ", byte); byte2hex(byte); printf("\n");
	
	return 0;
}