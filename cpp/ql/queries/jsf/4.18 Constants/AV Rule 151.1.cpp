void f() {
	char *s = "String"; //wrong: literal assigned to non-const
	//this will cause a write error or corrupt other data in the data section
	strcpy(s, "Another string"); 

	const char* cs ="String"; //correct: literal assigned to a const
	//this will cause a compile error (trying to write to a const)
	strcpy(cs, "Another string");
}
