import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;
import org.owasp.esapi.Encoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.security.MessageDigest;
import java.net.PasswordAuthentication;

public class CleartextStorageCookieTest extends HttpServlet {
  HttpServletResponse response;
  String name = "user";
  String password = "BP@ssw0rd"; // $ Source

  public void doGet() throws Exception {
    {
      Cookie nameCookie = new Cookie("name", name);
      nameCookie.setValue(name);
      response.addCookie(nameCookie); // Safe
      Cookie passwordCookie = new Cookie("password", password);
      passwordCookie.setValue(password);
      response.addCookie(passwordCookie); // $ Alert
      Cookie encodedPasswordCookie = new Cookie("password", encrypt(password));
      encodedPasswordCookie.setValue(encrypt(password));
      response.addCookie(encodedPasswordCookie); // Safe
    }
    {
      io.netty.handler.codec.http.Cookie nettyNameCookie =
        new io.netty.handler.codec.http.DefaultCookie("name", name);
      nettyNameCookie.setValue(name); // Safe

      io.netty.handler.codec.http.Cookie nettyPasswordCookie =
        new io.netty.handler.codec.http.DefaultCookie("password", password);
      nettyPasswordCookie.setValue(password); // $ MISSING: Alert (netty not supported by query)

      io.netty.handler.codec.http.cookie.Cookie nettyEncodedPasswordCookie =
          new io.netty.handler.codec.http.cookie.DefaultCookie("password", encrypt(password));
      nettyEncodedPasswordCookie.setValue(encrypt(password)); // Safe
    }
    {
      Encoder enc = null;
      String value = enc.encodeForHTML(password);
      Cookie cookie = new Cookie("password", value);
      response.addCookie(cookie); // $ Alert
    }
    {
      String data;
      PasswordAuthentication credentials = new PasswordAuthentication(name, password.toCharArray());
      data = credentials.getUserName() + ":" + new String(credentials.getPassword());

      // BAD: store data in a cookie in cleartext form
      response.addCookie(new Cookie("auth", data)); // $ Alert
    }
    {
      String data;
      PasswordAuthentication credentials =
          new PasswordAuthentication(name, password.toCharArray());
      String salt = "ThisIsMySalt";
      MessageDigest messageDigest = MessageDigest.getInstance("SHA-512");
      messageDigest.reset();
      String credentialsToHash =
          credentials.getUserName() + ":" + new String(credentials.getPassword());
      byte[] hashedCredsAsBytes =
          messageDigest.digest((salt+credentialsToHash).getBytes("UTF-8"));
      data = new String(hashedCredsAsBytes);

      // GOOD: store data in a cookie in encrypted form
      response.addCookie(new Cookie("auth", data)); // Safe
    }
  }


  private static String encrypt(String cleartext) throws Exception {
    MessageDigest digest = MessageDigest.getInstance("SHA-256");
    byte[] hash = digest.digest(cleartext.getBytes(StandardCharsets.UTF_8));
    String encoded = Base64.getEncoder().encodeToString(hash);
    return encoded;
  }
}
