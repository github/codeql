public void sendUserFile(Socket sock, String user) {
	BufferedReader filenameReader = new BufferedReader(
			new InputStreamReader(sock.getInputStream(), "UTF-8"));
	String filename = filenameReader.readLine();
	// BAD: read from a file using a path controlled by the user
	BufferedReader fileReader = new BufferedReader(
			new FileReader("/home/" + user + "/" + filename));
	String fileLine = fileReader.readLine();
	while(fileLine != null) {
		sock.getOutputStream().write(fileLine.getBytes());
		fileLine = fileReader.readLine();
	}
}

public void sendUserFileFixed(Socket sock, String user) {
	// ...
	
	// GOOD: remove all dots and directory delimiters from the filename before using
	String filename = filenameReader.readLine().replaceAll("\.", "").replaceAll("/", "");
	BufferedReader fileReader = new BufferedReader(
			new FileReader("/home/" + user + "/" + filename));

	// ...
}