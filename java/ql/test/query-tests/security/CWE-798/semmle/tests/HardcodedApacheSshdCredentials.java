import org.apache.sshd.client.SshClient;
import org.apache.sshd.client.session.AbstractClientSession;
import java.io.IOException;

public class HardcodedApacheSshdCredentials {
	public static void main(SshClient client, AbstractClientSession session) {
    // BAD: Hardcoded credentials used for the session username and/or password.
    client.connect("Username", "hostname", 22); // $ HardcodedCredentialsApiCall
    client.connect("Username", null); // $ HardcodedCredentialsApiCall
    session.addPasswordIdentity("password"); // $ HardcodedCredentialsApiCall
	}
}