import java.sql.*;
import java.net.*;
import java.util.logging.*;
import java.nio.charset.StandardCharsets;

class Test {
  private String byteToString(byte[] data) {
    return new String(data, StandardCharsets.UTF_8);
  }

  public void M1(Statement handle) throws Exception {
    // Only a source if "remote" is a selected threat model
    Socket sock = new Socket("localhost", 1234);
    byte[] data = new byte[1024];
    sock.getInputStream().read(data);

    // Logging sink
    Logger logger = Logger.getLogger("foo");
    logger.severe(byteToString(data));

    // SQL sink
    handle.executeUpdate("INSERT INTO foo VALUES ('" + byteToString(data) + "')");
  }

  public void M2(Statement handle) throws Exception {
    // Only a source if "database" is a selected threat model
    ResultSet rs = handle.executeQuery("SELECT * FROM foo");

    // SQL sink
    handle.executeUpdate("INSERT INTO foo VALUES ('" + rs.getString("name") + "')");

    // Logging sink
    Logger logger = Logger.getLogger("foo");
    logger.severe(rs.getString("name"));
  }
}
