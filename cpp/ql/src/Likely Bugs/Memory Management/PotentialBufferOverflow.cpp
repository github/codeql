void f(char* s, float f) {
	char buf[30];

	//wrong: gets has no limit to the length of data it puts in the buffer
	gets(buf); 

	//wrong: sprintf does not limit the length of the string put into buf
	sprintf(buf, "This is a string: %s", s);

	//wrong: %f can expand to a very long string in extreme cases, easily overrunning this buffer
	sprintf(buf, "This is a float: %f", f);
}
