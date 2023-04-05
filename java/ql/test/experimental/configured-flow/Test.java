import java.sql.*;
import java.net.*;

class Test {
  public static void main(String[] args) throws Exception {
    Connection conn = DriverManager.getConnection("");
    Statement readStmt = conn.createStatement();
    Statement writeStmt = conn.createStatement();
    Socket sock = new Socket("localhost", 1234);

    // Source only if "sql" is a selected threat model
    ResultSet rs = readStmt.executeQuery("SELECT * FROM foo");

    // Only a source if "remote" is a selected threat model
    int val = sock.getInputStream().read();

    // Sink
    sock.getOutputStream().write(val);

    // Sink
    writeStmt.executeUpdate("INSERT INTO foo VALUES ('" + val + "')");

    // Sink
    writeStmt.executeUpdate("INSERT INTO foo VALUES ('" + rs.getString("name") + "')");
    // Sink
    sock.getOutputStream().write(rs.getString("name").getBytes());
  }
}
