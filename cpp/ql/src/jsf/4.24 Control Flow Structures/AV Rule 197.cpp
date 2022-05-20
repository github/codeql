void f() {
	float i = 0.0f;
	//wrong: float used as loop counter
	for (i = 0; i < 1000000.0f; i++) { //may execute 1000000 +x/-x times
		//...
	}
	for (i = 0; i < 100000000.0f; i++) { //may never terminate, as rounding errors 
	                                     //cancel out the addition of 1.0 once 
	                                     //i becomes large enough
		//...
	}
}
