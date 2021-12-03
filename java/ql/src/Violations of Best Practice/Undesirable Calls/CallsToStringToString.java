public static void main(String args[]) {
	String name = "John Doe";
	
	// BAD: Unnecessary call to 'toString' on 'name'
	System.out.println("Hi, my name is " + name.toString());
	
	// GOOD: No call to 'toString' on 'name'
	System.out.println("Hi, my name is " + name);
}