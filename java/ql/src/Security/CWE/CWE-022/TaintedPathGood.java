public void sendUserFileGood(Socket sock, String user) {
	BufferedReader filenameReader = new BufferedReader(
			new InputStreamReader(sock.getInputStream(), "UTF-8"));
	String filename = filenameReader.readLine();
	// GOOD: ensure that the file is in a designated folder in the user's home directory
	if (!filePath.contains("..") && filePath.startsWith("/home/" + user + "/public/")) {
		BufferedReader fileReader = new BufferedReader(new FileReader(filePath));
		String fileLine = fileReader.readLine();
		while(fileLine != null) {
			sock.getOutputStream().write(fileLine.getBytes());
			fileLine = fileReader.readLine();
		}
	}	
}
