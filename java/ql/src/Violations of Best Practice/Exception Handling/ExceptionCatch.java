FileInputStream fis = ...
try {
	fis.read();
} catch (Throwable e) {  // BAD: The exception is too general.
	// Handle this exception
}

FileInputStream fis = ...
try {
	fis.read();
} catch (IOException e) {  // GOOD: The exception is specific. 
	// Handle this exception
}
