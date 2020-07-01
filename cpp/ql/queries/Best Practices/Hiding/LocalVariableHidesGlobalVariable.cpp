int i = 10;

void f() {
	for (int i = 0; i < 10; i++) { //the loop counter hides the global variable i
		 ...
	}

	{
		int i = 12; //this variable hides the global variable i
		...
	}
}
