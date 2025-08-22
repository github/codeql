import java.sql.*;
import java.net.*;
import java.util.logging.*;
import java.nio.charset.StandardCharsets;
import testlib.TestSources;

class Test {
  private TestSources sources = new TestSources();

  private String byteToString(byte[] data) {
    return new String(data, StandardCharsets.UTF_8);
  }

  public void M1(Statement handle) throws Exception {
    // Only a source if "remote" is a selected threat model.
    // This is included in the "default" threat model.
    Socket sock = new Socket("localhost", 1234);
    byte[] data = new byte[1024];
    sock.getInputStream().read(data);

    // Logging sink
    Logger.getLogger("foo").severe(byteToString(data));

    // SQL sink
    handle.executeUpdate("INSERT INTO foo VALUES ('" + byteToString(data) + "')");
  }

  public void M2(Statement handle) throws Exception {
    // Only a source if "database" is a selected threat model.
    String result = sources.executeQuery("SELECT * FROM foo");

    // SQL sink
    handle.executeUpdate("INSERT INTO foo VALUES ('" + result + "')");

    // Logging sink
    Logger.getLogger("foo").severe(result);
  }

  public void M3(Statement handle) throws Exception {
    // Only a source if "environment" is a selected threat model.
    String result = sources.readEnv("MY_ENV_VAR");

    // SQL sink
    handle.executeUpdate("INSERT INTO foo VALUES ('" + result + "')");

    // Logging sink
    Logger.getLogger("foo").severe(result);
  }

  public void M4(Statement handle) throws Exception {
    // Only a source if "custom" is a selected threat model.
    String result = sources.getCustom("custom");

    // SQL sink
    handle.executeUpdate("INSERT INTO foo VALUES ('" + result + "')");

    // Logging sink
    Logger.getLogger("foo").severe(result);
  }

  public void M5(Statement handle) throws Exception {
    // Only a source if "stdin" is a selected threat model.
    byte[] data = new byte[1024];
    System.in.read(data);

    // SQL sink
    handle.executeUpdate("INSERT INTO foo VALUES ('" + byteToString(data) + "')");

    // Logging sink
    Logger.getLogger("foo").severe(byteToString(data));
  }
}
