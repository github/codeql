import net.schmizz.sshj.SSHClient;
import java.io.IOException;

public class HardcodedSshjCredentials {
	public static void main(SSHClient client) {
    // BAD: Hardcoded credentials used for the session username and/or password.
    try {
		  client.authPassword("Username", "password");
      client.authPassword("Username", "password".toCharArray());
    }
    catch(IOException e) { }
	}
}