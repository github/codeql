import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import java.io.IOException;

public class HardcodedJschCredentials {
	public static void main(JSch jsch) {
    // BAD: Hardcoded credentials used for the session username and/or password.
    try {
      Session session = jsch.getSession("Username", "hostname"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
      Session session2 = jsch.getSession("Username", "hostname", 22); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
      session.setPassword("password"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
      session2.setPassword("password".getBytes()); // $ HardcodedCredentialsApiCall
    } catch(JSchException e) { }
	}
}