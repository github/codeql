public class WebComponentMain implements Servlet {
	// BAD - Implement a main method in servlet.
	public static void main(String[] args) throws Exception {
		// Connect to my server
		URL url = new URL("https://www.example.com");
		url.openConnection();
	}

	// GOOD - Not to have a main method in servlet.
}
