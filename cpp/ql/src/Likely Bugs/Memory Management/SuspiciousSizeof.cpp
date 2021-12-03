void f(char s[]) {
	int size = sizeof(s); //wrong: s is now a char*, not an array. 
	                      //sizeof(s) will evaluate to sizeof(char *)
}
