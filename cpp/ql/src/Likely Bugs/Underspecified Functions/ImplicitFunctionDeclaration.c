/* '#include <stdlib.h>' was forgotten */

int main(void) {
	/* 'int malloc()' assumed */
	unsigned char *p = malloc(100);
	*p = 'a';
	return 0;
}