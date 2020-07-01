#include <stdio.h>

char *copy;

void copyArgv(char **argv) {
	copy = argv[1];
}

void printWrapper(char *str) {
	printf(str);
}

int main(int argc, char **argv) {
	copyArgv(argv);

	// This should be avoided
	printf(copy);

	// This should be avoided too, because it has the same effect
	printWrapper(copy);

	// This is fine
	printf("%s", copy);
}
