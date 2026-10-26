import com.trilead.ssh2.Connection;

import java.io.IOException;
import java.io.File;

public class HardcodedTrileadSshCredentials {
	public static void main(Connection conn) {
    // BAD: Hardcoded credentials used for the session username and/or password.
    try {
      conn.authenticateWithPassword("Username", "password"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
      conn.authenticateWithDSA("Username", "password", "key"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
      conn.authenticateWithNone("Username"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
      conn.getRemainingAuthMethods("Username"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
      conn.isAuthMethodAvailable("Username", "method"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
      conn.authenticateWithPublicKey("Username", "key".toCharArray(), "password"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
      conn.authenticateWithPublicKey("Username", (File)null, "password"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
    } catch(IOException e) { }
  }
}