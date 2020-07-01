/* '#include <stdlib.h>' was forgotton */

int main(void) {
	/* 'int malloc()' assumed */
	unsigned char *p = malloc(100);
	*p = 'a';
	return 0;
}