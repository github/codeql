typedef struct {
	unsigned int x : 24;
} my_struct;

unsigned short getX(my_struct s ) {
	return s.x; //BAD: implicit truncation
}

unsigned int getXGood(my_struct s) {
	return s.x //GOOD: no truncation
}

int main (int argc, char **argv) {
	my_struct s;
	s.x = USHORT_MAX + 1;
	int* array = calloc(sizeof(int), getX(s)); //BAD: buffer allocated is smaller than intended
	for (int i = 0; i < s.x; i++) {
		array[i] = i;
	}

	int* array2 = calloc(sizeof(int), getXGood(s)); //GOOD
	for (int i = 0; i < s.x; i++) {
		array[i] = i;
	}
}
