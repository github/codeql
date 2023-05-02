import java.sql.*;
import java.net.*;

class Test {
  public void M1(Statement handle) throws Exception {
    // Only a source if "remote" is a selected threat model
    Socket sock = new Socket("localhost", 1234);
    int val = sock.getInputStream().read();

    // Sink
    sock.getOutputStream().write(val);

    // Sink
    handle.executeUpdate("INSERT INTO foo VALUES ('" + val + "')");
  }

  public void M2(Statement handle) throws Exception {    
    // Only a source if "sql" is a selected threat model
    ResultSet rs = handle.executeQuery("SELECT * FROM foo");

    // Sink
    handle.executeUpdate("INSERT INTO foo VALUES ('" + rs.getString("name") + "')");

    // Sink
    Socket sock = new Socket("localhost", 1234);
    sock.getOutputStream().write(rs.getString("name").getBytes());
  }
}
