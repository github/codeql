void f() {
	int i = 0;
	for (i = 0; i < 10; i++) {
		//...
		if (special_case) {
			i += 5; //Wrong: loop variable changed in body, which is contrary 
			        //to the usual expectation of for loop behavior. 
			        //Use a while loop instead.
			continue;
		}
	}
}
