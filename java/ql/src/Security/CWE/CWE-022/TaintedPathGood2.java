public void sendUserFileGood(Socket sock, String user) {
	BufferedReader filenameReader = new BufferedReader(
			new InputStreamReader(sock.getInputStream(), "UTF-8"));
	String filename = filenameReader.readLine();
	// GOOD: remove all ".." sequences and path separators from the filename
	filename = filename.replaceAll("\\.\\.|[/\\\\]", "");
	BufferedReader fileReader = new BufferedReader(new FileReader(filename));
	String fileLine = fileReader.readLine();
	while(fileLine != null) {
		sock.getOutputStream().write(fileLine.getBytes());
		fileLine = fileReader.readLine();
	}
}
