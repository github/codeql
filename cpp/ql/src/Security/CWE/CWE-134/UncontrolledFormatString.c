#include <stdio.h>

void printWrapper(char *str) {
	printf(str);
}

int main(int argc, char **argv) {
	// This should be avoided
	printf(argv[1]);

	// This should be avoided too, because it has the same effect
	printWrapper(argv[1]);

	// This is fine
	printf("%s", argv[1]);
}