import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Cookie;

public boolean validateCsrfTokenInRequest(HttpServletRequest request) {
	  if (cookies != null) {
		for (Cookie cookie : cookies) {
			if (cookie.getName().equals(CSRF-TOKEN){
				csrfCookieValue = cookie.getValue();
			}
		}
	  }
          if (compareCsrfTokens(csrfCookieValue)) {
                return true;      
          }
}

private boolean compareCsrfTokens(String csrfTokenInCookie) {
         if(csrfTokenInCookie == null || !csrfTokenInCookie.equals(request.getHeader("X-CSRF-TOKEN"))) {
                 return false;
         }
}
