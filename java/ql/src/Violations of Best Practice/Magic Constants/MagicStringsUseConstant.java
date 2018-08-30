// Problem version
public class MagicConstants
{
	final static public String IP = "127.0.0.1";
	final static public int PORT = 8080;
	final static public String USERNAME = "test";
	final static public int TIMEOUT = 60000;

	public void serve(String ip, int port, String user, int timeout) {
		// ...
	}

	public static void main(String[] args) {
		String internal_ip = "127.0.0.1";  // AVOID: Magic string

		new MagicConstants().serve(internal_ip, PORT, USERNAME, TIMEOUT);
	}
}


// Fixed version
public class MagicConstants
{
	final static public String IP = "127.0.0.1";
	final static public int PORT = 8080;
	final static public String USERNAME = "test";
	final static public int TIMEOUT = 60000;

	public void serve(String ip, int port, String user, int timeout) {
		// ...
	}

	public static void main(String[] args) {

		new MagicConstants().serve(IP, PORT, USERNAME, TIMEOUT);  //Use 'IP' constant
	}
}