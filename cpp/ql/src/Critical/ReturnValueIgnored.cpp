int doFoo() {
	...
	return status;
}

void f() {
	if (doFoo() == OK) {
		...
	}
}

void g() {
	int status = doFoo();
	if (status == OK) {
		...
	}
}

void err() {
	doFoo(); //doFoo is called but its return value is not checked, and 
	         //the value is checked in other locations
	...
}
