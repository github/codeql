void f(char* string) {
	// wrong: allocates space for characters, but not zero terminator
	char* buf = malloc(strlen(string));
	strcpy(buf, string);

	char* buf_right = malloc(strlen(string) + 1); //correct: includes the zero terminator
	strcpy(buf_right, string);
	// buf_right is now full
	strcat(buf_right, string); //wrong: appending would overflow the buffer
}
