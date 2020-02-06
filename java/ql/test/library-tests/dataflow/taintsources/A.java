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
  public static void main(String[] args) {
    String[] a = args; // user input
    String s = args[0]; // user input
  }

  public static void userInput() throws SQLException, IOException, MalformedURLException {
    System.getenv("test"); // user input
    class TestServlet extends HttpServlet {
      @Override
      protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
        req.getParameter("test"); // remote user input
        req.getHeader("test"); // remote user input
        req.getQueryString(); // remote user input
        req.getCookies()[0].getValue(); // remote user input
      }
    }
    new Properties().getProperty("test"); // user input
    System.getProperty("test"); // user input
    new Object() {
      public void test(ResultSet rs) throws SQLException {
        rs.getString(0); // user input
      }
    };
    new URL("test").openConnection().getInputStream(); // remote user input
    new Socket("test", 1234).getInputStream(); // remote user input
    InetAddress.getByName("test").getHostName(); // remote user input

    System.in.read(); // user input
    new FileInputStream("test").read(); // user input
  }

}
