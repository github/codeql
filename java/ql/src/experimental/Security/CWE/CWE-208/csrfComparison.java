import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Cookie;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public boolean validateCsrfTokenInRequest(HttpServletRequest request) {
	  if (cookies != null) {
		for (Cookie cookie : cookies) {
			if (cookie.getName().equals(CSRF-TOKEN){
				csrfCookieValue = cookie.getValue();
			}
		}
	  }
          if (UnsafecsrfComparison(csrfCookieValue)) { // BAD
                return true;      
          }
}
private boolean UnsafecsrfComparison(String csrfTokenInCookie) {
         if(csrfTokenInCookie == null || !csrfTokenInCookie.equals(request.getHeader("X-CSRF-TOKEN"))) { // BAD
                 return false;
         }
}

			    
			    
public boolean validateCsrfTokenInRequest(HttpServletRequest request) {
	  if (cookies != null) {
		for (Cookie cookie : cookies) {
			if (cookie.getName().equals(CSRF-TOKEN){
				csrfCookieValue = cookie.getValue();
			}
		}
	  }
          if (safecsrfComparison(csrfCookieValue)) { // GOOD
                return true;      
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
