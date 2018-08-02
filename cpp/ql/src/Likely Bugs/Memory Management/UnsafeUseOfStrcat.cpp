void f(char *s) {
	char buf[80];
	strcpy(buf, "s: ");
	strcat(buf, s);  // wrong: buffer not checked before strcat
}

void g(char *s) {
	char buf[80];
	strcpy(buf, "s: ");
	if(strlen(s) < 77)
		strcat(buf, s);  // correct: buffer size checked before strcat
}
