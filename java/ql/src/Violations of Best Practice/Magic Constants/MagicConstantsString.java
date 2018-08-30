// Problem version
public class MagicConstants
{
	final static public String IP = "127.0.0.1";
	final static public int PORT = 8080;
	final static public int TIMEOUT = 60000;

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
	final static public String IP = "127.0.0.1";
	final static public int PORT = 8080;
	final static public int USERNAME = "test";  // Magic string is replaced by named constant
	final static public int TIMEOUT = 60000;

	public void serve(String ip, int port, String user, int timeout) {
		// ...
	}

	public static void main(String[] args) {

		new MagicConstants().serve(IP, PORT, USERNAME, TIMEOUT);  // Use 'USERNAME' constant
	}
}