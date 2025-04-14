import java.io.*;
import java.security.NoSuchAlgorithmException;
import java.util.Objects;
import java.util.Optional;
import javax.crypto.KeyGenerator;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.BearerToken;

public class JwtNoVerifier extends HttpServlet {

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // OK: first decode without signature verification
        // and then verify with signature verification
        String JwtToken1 = request.getParameter("JWT1");
        String userName = decodeToken(JwtToken1);
        verifyToken(JwtToken1, "A Securely generated Key");
        if (Objects.equals(userName, "Admin")) {
            out.println("<html><body>");
            out.println("<h1>" + "heyyy Admin" + "</h1>");
            out.println("</body></html>");
        }

        out.println("<html><body>");
        out.println("<h1>" + "heyyy Nobody" + "</h1>");
        out.println("</body></html>");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // NOT OK:  only decode, no verification
        String JwtToken1 = request.getParameter("JWT2");
        String userName = decodeToken(JwtToken1);
        if (Objects.equals(userName, "Admin")) {
            out.println("<html><body>");
            out.println("<h1>" + "heyyy Admin" + "</h1>");
            out.println("</body></html>");
        }

        AuthenticationToken authToken = new BearerToken("admin", "admin");
        // OK:  no clue of the use of unsafe decoded JWT return value
        String JwtToken2 = request.getParameter("JWT2");
        JWT.decode(JwtToken2);

        // NOT OK:  only decode, no verification
        String JwtToken3 = (String) authToken.getCredentials();
        userName = decodeToken(JwtToken3);
        if (Objects.equals(userName, "Admin")) {
            out.println("<html><body>");
            out.println("<h1>" + "heyyy Admin" + "</h1>");
            out.println("</body></html>");
        }

        // OK:  no clue of the use of unsafe decoded JWT return value
        String JwtToken4 = (String) authToken.getCredentials();
        JWT.decode(JwtToken4);

        

        out.println("<html><body>");
        out.println("<h1>" + "heyyy Nobody" + "</h1>");
        out.println("</body></html>");
    }

    public static boolean verifyToken(final String token, final String key) {
        try {
            JWTVerifier verifier = JWT.require(Algorithm.HMAC256(key)).build();
            verifier.verify(token);
            return true;
        } catch (JWTVerificationException e) {
            System.out.printf("jwt decode fail, token: %s", e);
        }
        return false;
    }


    public static String decodeToken(final String token) {
        DecodedJWT jwt = JWT.decode(token);
        return Optional.of(jwt).map(item -> item.getClaim("userName").asString()).orElse("");
    }


    private static String getSecureRandomKey() throws NoSuchAlgorithmException {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256); // for example
        return keyGen.generateKey().toString();
    }

    static final String JWT_KEY = "KEY";

    public static void NoNeedForTest(HttpServletRequest request) {
        // constant key
        String JwtToken3 = request.getParameter("JWT3");
        verifyToken(JwtToken3, JWT_KEY);

        // none algorithm
        String JwtToken4 = request.getParameter("JWT4");
        try {
            verifyTokenNoneAlg(JwtToken4, getSecureRandomKey());
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }

    }

    public static String generateToken(final String userName, final String key) {
        try {
            return JWT.create().withClaim("userName", userName).sign(Algorithm.HMAC256(key));
        } catch (IllegalArgumentException e) {
            System.out.printf("JWTToken generate fail %s", e);
        }
        return "";
    }

    public static boolean verifyTokenNoneAlg(final String token, final String key) {
        try {
            JWTVerifier verifier = JWT.require(Algorithm.none()).build();
            verifier.verify(token);
            return true;
        } catch (JWTVerificationException e) {
            System.out.printf("jwt decode fail, token: %s", e);
        }
        return false;
    }
}
