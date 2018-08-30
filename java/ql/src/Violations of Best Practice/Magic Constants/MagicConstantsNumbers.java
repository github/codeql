// Problem version
public class MagicConstants
{
	final static public String IP = "127.0.0.1";
	final static public int PORT = 8080;
	final static public String USERNAME = "test";

	public void serve(String ip, int port, String user, int timeout) {
		// ...
	}

	public static void main(String[] args) {
		int timeout = 60000;  // AVOID: Magic number

		new MagicConstants().serve(IP, PORT, USERNAME, timeout);
	}
}


// Fixed version
public class MagicConstants
{
	final static public String IP = "127.0.0.1";
	final static public int PORT = 8080;
	final static public String USERNAME = "test";
	final static public int TIMEOUT = 60000;  // Magic number is replaced by named constant

	public void serve(String ip, int port, String user, int timeout) {
		// ...
	}

	public static void main(String[] args) {

		new MagicConstants().serve(IP, PORT, USERNAME, TIMEOUT);  // Use 'TIMEOUT' constant
	}
}