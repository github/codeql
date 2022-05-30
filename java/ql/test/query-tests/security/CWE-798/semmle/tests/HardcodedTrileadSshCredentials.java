import com.trilead.ssh2.Connection;

import java.io.IOException;
import java.io.File;

public class HardcodedTrileadSshCredentials {
	public static void main(Connection conn) {
    // BAD: Hardcoded credentials used for the session username and/or password.
    try {
      conn.authenticateWithPassword("Username", "password");
      conn.authenticateWithDSA("Username", "password", "key");
      conn.authenticateWithNone("Username");
      conn.getRemainingAuthMethods("Username");
      conn.isAuthMethodAvailable("Username", "method");
      conn.authenticateWithPublicKey("Username", "key".toCharArray(), "password");
      conn.authenticateWithPublicKey("Username", (File)null, "password");
    } catch(IOException e) { }
  }
}