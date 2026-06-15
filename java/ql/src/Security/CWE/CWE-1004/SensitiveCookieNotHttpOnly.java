class SensitiveCookieNotHttpOnly {
    // GOOD - Create a sensitive cookie with the `HttpOnly` flag set.
    public void addCookie(String jwt_token, HttpServletRequest request, HttpServletResponse response) {
        Cookie jwtCookie =new Cookie("jwt_token", jwt_token);
        jwtCookie.setPath("/");
        jwtCookie.setMaxAge(3600*24*7);
        jwtCookie.setHttpOnly(true);
        response.addCookie(jwtCookie);
    }

    // BAD - Create a sensitive cookie without the `HttpOnly` flag set.
    public void addCookie2(String jwt_token, String userId, HttpServletRequest request, HttpServletResponse response) {
        Cookie jwtCookie =new Cookie("jwt_token", jwt_token);
        jwtCookie.setPath("/");
        jwtCookie.setMaxAge(3600*24*7);
        response.addCookie(jwtCookie);
    }

    // GOOD - Set a sensitive cookie header with the `HttpOnly` flag set.
    public void addCookie3(String authId, HttpServletRequest request, HttpServletResponse response) {
        response.addHeader("Set-Cookie", "token=" +authId + ";HttpOnly;Secure");
    }

    // BAD - Set a sensitive cookie header without the `HttpOnly` flag set.
    public void addCookie4(String authId, HttpServletRequest request, HttpServletResponse response) {
        response.addHeader("Set-Cookie", "token=" +authId + ";Secure");
    }
    
    // GOOD - Set a sensitive cookie header using the class `javax.ws.rs.core.Cookie` with the `HttpOnly` flag set through string concatenation.
    public void addCookie5(String accessKey, HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Set-Cookie", new NewCookie("session-access-key", accessKey, "/", null, null, 0, true) + ";HttpOnly");
    }

    // BAD - Set a sensitive cookie header using the class `javax.ws.rs.core.Cookie` without the `HttpOnly` flag set.
    public void addCookie6(String accessKey, HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Set-Cookie", new NewCookie("session-access-key", accessKey, "/", null, null, 0, true).toString());
    }

    // GOOD - Set a sensitive cookie header using the class `javax.ws.rs.core.Cookie` with the `HttpOnly` flag set through the constructor.
    public void addCookie7(String accessKey, HttpServletRequest request, HttpServletResponse response) {
        NewCookie accessKeyCookie = new NewCookie("session-access-key", accessKey, "/", null, null, 0, true, true);
        response.setHeader("Set-Cookie", accessKeyCookie.toString());
    }
}
