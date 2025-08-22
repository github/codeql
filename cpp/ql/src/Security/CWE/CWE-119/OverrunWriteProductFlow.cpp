int f(char * s, unsigned size) {
	char* buf = (char*)malloc(size);

	strncpy(buf, s, size + 1); // wrong: copy may exceed size of buf

	for (int i = 0; i <= size; i++) { // wrong: upper limit that is higher than size of buf
		cout << buf[i];
	}
}
