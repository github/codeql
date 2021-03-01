import java.io.IOException;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import javax.ws.rs.core.NewCookie;

class SensitiveCookieNotHttpOnly {
    // GOOD - Tests adding a sensitive cookie with the `HttpOnly` flag set.
    public void addCookie(String jwt_token, HttpServletRequest request, HttpServletResponse response) {
        Cookie jwtCookie =new Cookie("jwt_token", jwt_token);
        jwtCookie.setPath("/");
        jwtCookie.setMaxAge(3600*24*7);
        jwtCookie.setHttpOnly(true);
        response.addCookie(jwtCookie);
    }

    // BAD - Tests adding a sensitive cookie without the `HttpOnly` flag set.
    public void addCookie2(String jwt_token, String userId, HttpServletRequest request, HttpServletResponse response) {
        Cookie jwtCookie =new Cookie("jwt_token", jwt_token);
        Cookie userIdCookie =new Cookie("user_id", userId.toString());
        jwtCookie.setPath("/");
        userIdCookie.setPath("/");
        jwtCookie.setMaxAge(3600*24*7);
        userIdCookie.setMaxAge(3600*24*7);
        response.addCookie(jwtCookie);
        response.addCookie(userIdCookie);
    }

    // GOOD - Tests set a sensitive cookie header with the `HttpOnly` flag set.
    public void addCookie3(String authId, HttpServletRequest request, HttpServletResponse response) {
        response.addHeader("Set-Cookie", "token=" +authId + ";HttpOnly;Secure");
    }

    // BAD - Tests set a sensitive cookie header without the `HttpOnly` flag set.
    public void addCookie4(String authId, HttpServletRequest request, HttpServletResponse response) {
        response.addHeader("Set-Cookie", "token=" +authId + ";Secure");
    }
    
    // GOOD - Tests set a sensitive cookie header using the class `javax.ws.rs.core.Cookie` with the `HttpOnly` flag set through string concatenation.
    public void addCookie5(String accessKey, HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Set-Cookie", new NewCookie("session-access-key", accessKey, "/", null, null, 0, true) + ";HttpOnly");
    }

    // BAD - Tests set a sensitive cookie header using the class `javax.ws.rs.core.Cookie` without the `HttpOnly` flag set.
    public void addCookie6(String accessKey, HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Set-Cookie", new NewCookie("session-access-key", accessKey, "/", null, null, 0, true).toString());
    }

    // GOOD - Tests set a sensitive cookie header using the class `javax.ws.rs.core.Cookie` with the `HttpOnly` flag set through the constructor.
    public void addCookie7(String accessKey, HttpServletRequest request, HttpServletResponse response) {
        NewCookie accessKeyCookie = new NewCookie("session-access-key", accessKey, "/", null, null, 0, true, true);
        response.setHeader("Set-Cookie", accessKeyCookie.toString());
    }
}
