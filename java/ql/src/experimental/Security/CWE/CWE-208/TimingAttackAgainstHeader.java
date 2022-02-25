import javax.servlet.http.HttpServletRequest;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.lang.String;


public class Test {
    private boolean UnsafeComparison(HttpServletRequest request) {
        String Key = "secret";
        return Key.equals(request.getHeader("X-Auth-Token"));        
    }

    private boolean safeComparison(HttpServletRequest request) {
          String token = request.getHeader("X-Auth-Token");
          String Key = "secret"; 
          return MessageDigest.isEqual(Key.getBytes(StandardCharsets.UTF_8), token.getBytes(StandardCharsets.UTF_8));
    }
    
}

