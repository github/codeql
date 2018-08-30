public static void main(String[] args) {
	{
		try {
			String protocol = "http://";
			URL u = new URL(protocol + "www.secret.example.org/");
			// BAD: This causes a 'ClassCastException' at runtime, because the
			// HTTP URL cannot be used to make an 'HttpsURLConnection', 
			// which enforces SSL.
			HttpsURLConnection hu = (HttpsURLConnection) u.openConnection();
			hu.setRequestMethod("PUT");
			hu.connect();
			OutputStream os = hu.getOutputStream();
			hu.disconnect();
		}
		catch (IOException e) {
			// fail
		}
	}
	
	{
		try {
			String protocol = "https://";
			URL u = new URL(protocol + "www.secret.example.org/");
			// GOOD: Opening a connection to a URL using HTTPS enforces SSL.
			HttpsURLConnection hu = (HttpsURLConnection) u.openConnection();
			hu.setRequestMethod("PUT");
			hu.connect();
			OutputStream os = hu.getOutputStream();
			hu.disconnect();
		}
		catch (IOException e) {
			// fail
		}
	}
}