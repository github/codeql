
void calls() {
	
	undeclared();  // GOOD
	
	undeclared(1); // BAD
	
	undeclared(1, 2); // BAD
}
