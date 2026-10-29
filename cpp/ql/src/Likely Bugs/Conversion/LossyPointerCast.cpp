void f(char *p) {
	int my_ptr = p; //Wrong: pointer assigned to int, would be incorrect if sizeof(char*) 
	                //is larger than sizeof(int)
	//...
}
