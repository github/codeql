import java.io.FileInputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.Socket;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A {

  private static void sink(Object o) {}

  public static void main(String[] args) {
    sink(args); // $hasLocalValueFlow
    sink(args[0]); // $hasLocalTaintFlow
  }

  public static void userInput() throws SQLException, IOException, MalformedURLException {
    sink(System.getenv("test")); // $hasLocalValueFlow
    class TestServlet extends HttpServlet {
      @Override
      protected void doGet(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {
        sink(req.getParameter("test")); // $hasRemoteValueFlow
        sink(req.getHeader("test")); // $hasRemoteValueFlow
        sink(req.getQueryString()); // $hasRemoteValueFlow
        sink(req.getCookies()[0].getValue()); // $hasRemoteValueFlow
      }
    }
    sink(new Properties().getProperty("test")); // $hasLocalValueFlow
    sink(System.getProperty("test")); // $hasLocalValueFlow
    new Object() {
      public void test(ResultSet rs) throws SQLException {
        sink(rs.getString(0)); // $hasLocalValueFlow
      }
    };
    sink(new URL("test").openConnection().getInputStream()); // $hasRemoteValueFlow
    sink(new Socket("test", 1234).getInputStream()); // $hasRemoteValueFlow
    sink(InetAddress.getByName("test").getHostName()); // $hasReverseDnsValueFlow
    sink(InetAddress.getLocalHost().getHostName());
    sink(InetAddress.getLoopbackAddress().getHostName());
    sink(InetAddress.getByName("test").getCanonicalHostName()); // $hasReverseDnsValueFlow
    sink(InetAddress.getLocalHost().getCanonicalHostName());
    sink(InetAddress.getLoopbackAddress().getCanonicalHostName());

    sink(System.in); // $hasLocalValueFlow
    sink(new FileInputStream("test")); // $hasLocalValueFlow
  }

}
