void f() {
	char* buf = new char[SIZE];
	...
	if (error) {
		delete buf; //error handling has freed the buffer
	}
	...
	log_contents(buf); //but it is still used here for logging
	...
}
