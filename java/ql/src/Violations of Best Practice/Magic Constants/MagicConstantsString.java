// Problem version
public class MagicConstants
{
	public static final String IP = "127.0.0.1";
	public static final int PORT = 8080;
	public static final int TIMEOUT = 60000;

	public void serve(String ip, int port, String user, int timeout) {
		// ...
	}

	public static void main(String[] args) {
		String username = "test";  // AVOID: Magic string

		new MagicConstants().serve(IP, PORT, username, TIMEOUT);
	}
}


// Fixed version
public class MagicConstants
{
	public static final String IP = "127.0.0.1";
	public static final int PORT = 8080;
	public static final int USERNAME = "test";  // Magic string is replaced by named constant
	public static final int TIMEOUT = 60000;

	public void serve(String ip, int port, String user, int timeout) {
		// ...
	}

	public static void main(String[] args) {
		new MagicConstants().serve(IP, PORT, USERNAME, TIMEOUT);  // Use 'USERNAME' constant
	}
}