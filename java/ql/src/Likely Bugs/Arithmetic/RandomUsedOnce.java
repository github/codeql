public static void main(String args[]) {
	// BAD: A new 'Random' object is created every time
	// a pseudo-random integer is required.
	int notReallyRandom = new Random().nextInt();
	int notReallyRandom2 = new Random().nextInt();
	
	// GOOD: The same 'Random' object is used to generate 
	// two pseudo-random integers.
	Random r = new Random();
	int random1 = r.nextInt();
	int random2 = r.nextInt();
}