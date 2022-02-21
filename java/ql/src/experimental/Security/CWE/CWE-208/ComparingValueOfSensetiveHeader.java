import javax.servlet.http.HttpServletRequest;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

private boolean UnsafecsrfComparison(String csrfTokenInCookie) {
         if(csrfTokenInCookie == null || !csrfTokenInCookie.equals(request.getHeader("X-CSRF-TOKEN"))) { // BAD
                 return false;
         }
}
private boolean safecsrfComparison(String csrfTokenInCookie) {
	  String csrfTokenInRequest = request.getHeader("X-CSRF-TOKEN");
          if (csrfTokenInRequest == null || !MessageDigest.isEqual(
                csrfTokenInCookie.getBytes(StandardCharsets.UTF_8), 
                csrfTokenInRequest.getBytes(StandardCharsets.UTF_8))) { // GOOD
                     return false;
         }
}
