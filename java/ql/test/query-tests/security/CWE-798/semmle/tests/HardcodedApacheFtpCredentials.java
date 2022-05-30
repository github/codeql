import org.apache.commons.net.ftp.FTPClient;

import java.io.IOException;

public class HardcodedApacheFtpCredentials {
	public static void main(FTPClient client) {
    // BAD: Hardcoded credentials used for the session username and/or password.
    try {
      client.login("username", "password");
      client.login("username", "password", "blah");
    } catch(IOException e) { }
	}
}