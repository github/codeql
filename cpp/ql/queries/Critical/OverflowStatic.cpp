#define SIZE 30

int f(char * s) {
	char buf[20]; //buf not set to use SIZE macro

	strncpy(buf, s, SIZE); //wrong: copy may exceed size of buf

	for (int i = 0; i < SIZE; i++) { //wrong: upper limit that is higher than array size
		cout << array[i];
	}
}
