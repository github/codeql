import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.lang.String;
import javax.servlet.http.HttpServletRequest;

public class Test {
    private boolean UnsafeComparison(String pwd, HttpServletRequest request) {
        String password = request.getParameter("password");
        return password.equals(pwd);        
    }
     
    private boolean safeComparison(String pwd, HttpServletRequest request) {
          String password = request.getParameter("password");
          return MessageDigest.isEqual(password.getBytes(StandardCharsets.UTF_8), pwd.getBytes(StandardCharsets.UTF_8));
    }

}
