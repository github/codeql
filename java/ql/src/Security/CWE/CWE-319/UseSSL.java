public static void main(String[] args) {
	{
		try {
			URL u = new URL("http://www.secret.example.org/");
			HttpURLConnection httpcon = (HttpURLConnection) u.openConnection();
			httpcon.setRequestMethod("PUT");
			httpcon.connect();
			// BAD: output stream from non-HTTPS connection
			OutputStream os = httpcon.getOutputStream();
			httpcon.disconnect();
		}
		catch (IOException e) {
			// fail
		}
	}
	
	{
		try {
			URL u = new URL("https://www.secret.example.org/");
			HttpsURLConnection httpscon = (HttpsURLConnection) u.openConnection();
			httpscon.setRequestMethod("PUT");
			httpscon.connect();
			// GOOD: output stream from HTTPS connection
			OutputStream os = httpscon.getOutputStream();
			httpscon.disconnect();
		}
		catch (IOException e) {
			// fail
		}
	}
}