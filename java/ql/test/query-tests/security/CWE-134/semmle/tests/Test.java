// Test case for
// CWE-134: Use of Externally-Controlled Format String
// http://cwe.mitre.org/data/definitions/134.html

package test.cwe134.cwe.examples;


import java.io.IOException;
import java.util.Formatter;
import java.util.Locale;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
class Test {
  public static void basic() {
    String userProperty = System.getProperty("userProperty"); // $ Source
    // BAD User provided value as format string for String.format
    String.format(userProperty); // $ Alert
    // BAD User provided value as format string for PrintStream.format
    System.out.format(userProperty); // $ Alert
    // BAD User provided value as format string for PrintStream.printf
    System.out.printf(userProperty); // $ Alert
    // BAD User provided value as format string for Formatter.format
    new Formatter().format(userProperty); // $ Alert
    // BAD User provided value as format string for Formatter.format
    new Formatter().format(Locale.ENGLISH, userProperty); // $ Alert
  }
  
  public class FileUploadServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      String userParameter = request.getParameter("userProvidedParameter"); // $ Source
      formatString(userParameter);
    }
    
    private void formatString(String format) {
      // BAD This is used with user provided parameter
      System.out.format(format); // $ Alert
    }
  }
}
