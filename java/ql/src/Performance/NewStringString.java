public void sayHello(String world) {
	// AVOID: Inefficient 'String' constructor
	String message = new String("hello ");

	// AVOID: Inefficient 'String' constructor
	message = new String(message + world);

	// AVOID: Inefficient 'String' constructor
	System.out.println(new String(message));
}