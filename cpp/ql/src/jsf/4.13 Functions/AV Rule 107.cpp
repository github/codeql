int f() {
	extern int other(); //scope of externs is the entire file, not just the 
	                    //block where it is declared
	...
	other()
}

int g() {
	other(); //this will use the other() function declared inside f()
}
