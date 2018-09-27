void f() {
	int i = 10;

	for (int i = 0; i < 10; i++) { //the loop counter hides the variable
		 ...
	}

	{
		int i = 12; //this variable hides the variable in the outer block
		...
	}
}
