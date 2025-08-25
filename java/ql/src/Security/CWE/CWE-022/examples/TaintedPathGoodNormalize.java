public void sendUserFileGood(Socket sock, String user) {
	BufferedReader filenameReader = new BufferedReader(
			new InputStreamReader(sock.getInputStream(), "UTF-8"));
	String filename = filenameReader.readLine();
	// GOOD: ensure that the filename has no path separators or parent directory references
	if (filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
		throw new IllegalArgumentException("Invalid filename");
	}
	BufferedReader fileReader = new BufferedReader(new FileReader(filename));
	String fileLine = fileReader.readLine();
	while(fileLine != null) {
		sock.getOutputStream().write(fileLine.getBytes());
		fileLine = fileReader.readLine();
	}	
}
