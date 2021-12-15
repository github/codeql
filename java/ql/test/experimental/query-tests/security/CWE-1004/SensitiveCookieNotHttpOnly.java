import java.io.IOException;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import javax.ws.rs.core.NewCookie;

import org.springframework.security.web.csrf.CsrfToken;

class SensitiveCookieNotHttpOnly {
    // GOOD - Tests adding a sensitive cookie with the `HttpOnly` flag set.
    public void addCookie(String jwt_token, HttpServletRequest request, HttpServletResponse response) {
        Cookie jwtCookie = new Cookie("jwt_token", jwt_token);
        jwtCookie.setPath("/");
        jwtCookie.setMaxAge(3600*24*7);
        jwtCookie.setHttpOnly(true);
        response.addCookie(jwtCookie);
    }

    // BAD - Tests adding a sensitive cookie without the `HttpOnly` flag set.
    public void addCookie2(String jwt_token, String userId, HttpServletRequest request, HttpServletResponse response) {
        String tokenCookieStr = "jwt_token";
        Cookie jwtCookie = new Cookie(tokenCookieStr, jwt_token);
        Cookie userIdCookie = new Cookie("user_id", userId);
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

    // BAD - Tests set a sensitive cookie header using the class `javax.ws.rs.core.Cookie` without the `HttpOnly` flag set.
    public void addCookie8(String accessKey, HttpServletRequest request, HttpServletResponse response) {
        NewCookie accessKeyCookie = new NewCookie("session-access-key", accessKey, "/", null, 0, null, 86400, true);
        String keyStr = accessKeyCookie.toString();
        response.setHeader("Set-Cookie", keyStr);
    }

    // BAD - Tests set a sensitive cookie header using a variable without the `HttpOnly` flag set.
    public void addCookie9(String authId, HttpServletRequest request, HttpServletResponse response) {
        String secString = "token=" +authId + ";Secure";
        response.addHeader("Set-Cookie", secString);
    }

    // GOOD - Tests set a sensitive cookie header with the `HttpOnly` flag set using `String.format(...)`.
    public void addCookie10(HttpServletRequest request, HttpServletResponse response) {
        response.addHeader("SET-COOKIE", String.format("%s=%s;HttpOnly", "sessionkey", request.getSession().getAttribute("sessionkey")));
    }

    public Cookie createHttpOnlyAuthenticationCookie(HttpServletRequest request, String jwt) {
        String PRESTO_UI_COOKIE = "Presto-UI-Token";
        Cookie cookie = new Cookie(PRESTO_UI_COOKIE, jwt);
        cookie.setHttpOnly(true);
        cookie.setPath("/ui");
        return cookie;
    }

    public Cookie createAuthenticationCookie(HttpServletRequest request, String jwt) {
        String PRESTO_UI_COOKIE = "Presto-UI-Token";
        Cookie cookie = new Cookie(PRESTO_UI_COOKIE, jwt);
        cookie.setPath("/ui");
        return cookie;
    }

    public Cookie removeAuthenticationCookie(HttpServletRequest request, String jwt) {
        String PRESTO_UI_COOKIE = "Presto-UI-Token";
        Cookie cookie = new Cookie(PRESTO_UI_COOKIE, jwt);
        cookie.setPath("/ui");
        cookie.setMaxAge(0);
        return cookie;
    }

    // GOOD - Tests set a sensitive cookie header with the `HttpOnly` flag set using a wrapper method.
    public void addCookie11(HttpServletRequest request, HttpServletResponse response, String jwt) {
        Cookie cookie = createHttpOnlyAuthenticationCookie(request, jwt);
        response.addCookie(cookie);
    }

    // BAD - Tests set a sensitive cookie header without the `HttpOnly` flag set using a wrapper method.
    public void addCookie12(HttpServletRequest request, HttpServletResponse response, String jwt) {
        Cookie cookie = createAuthenticationCookie(request, jwt);
        response.addCookie(cookie);
    }

    // GOOD - Tests remove a sensitive cookie header without the `HttpOnly` flag set using a wrapper method.
    public void addCookie13(HttpServletRequest request, HttpServletResponse response, String jwt) {
        Cookie cookie = removeAuthenticationCookie(request, jwt);
        response.addCookie(cookie);
    }

    private Cookie createCookie(String name, String value, Boolean httpOnly){
        Cookie cookie = null;
        cookie = new Cookie(name, value);
        cookie.setDomain("/");
        cookie.setHttpOnly(httpOnly);

        //for production https
        cookie.setSecure(true);

        cookie.setMaxAge(60*60*24*30);
        cookie.setPath("/");

        return cookie;
    }

    // GOOD - Tests set a sensitive cookie header with the `HttpOnly` flag set through a boolean variable using a wrapper method.
    public void addCookie14(HttpServletRequest request, HttpServletResponse response, String refreshToken) {
        response.addCookie(createCookie("refresh_token", refreshToken, true));
    }

    // BAD (but not detected) - Tests set a sensitive cookie header with the `HttpOnly` flag not set through a boolean variable using a wrapper method.
    // This example is missed because the `cookie.setHttpOnly` call in `createCookie` is thought to maybe set the HTTP-only flag, and the `cookie`
    // object flows to this `addCookie` call.
    public void addCookie15(HttpServletRequest request, HttpServletResponse response, String refreshToken) {
        response.addCookie(createCookie("refresh_token", refreshToken, false));
    }

    // GOOD - CSRF token doesn't need to have the `HttpOnly` flag set.
    public void addCsrfCookie(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Spring put the CSRF token in session attribute "_csrf"
        CsrfToken csrfToken = (CsrfToken) request.getAttribute("_csrf");
    
        // Send the cookie only if the token has changed
        String actualToken = request.getHeader("X-CSRF-TOKEN");
        if (actualToken == null || !actualToken.equals(csrfToken.getToken())) {
            // Session cookie that can be used by AngularJS
            String pCookieName = "CSRF-TOKEN";
            Cookie cookie = new Cookie(pCookieName, csrfToken.getToken());
            cookie.setMaxAge(-1);
            cookie.setHttpOnly(false);
            cookie.setPath("/");
            response.addCookie(cookie);
        }
    }
}
