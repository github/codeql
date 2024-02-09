import java.io.IOException;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;
import java.security.SecureRandom;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;
import org.apache.commons.lang3.RandomStringUtils;
import org.owasp.esapi.Encoder;

public class InsecureRandomCookies extends HttpServlet {
    HttpServletResponse response;

    public void doGet() {
        Random r = new Random();

        int c = r.nextInt();
        // BAD: The cookie value may be predictable.
        Cookie cookie = new Cookie("name", Integer.toString(c)); // $hasWeakRandomFlow
        cookie.setValue(Integer.toString(c)); // $hasWeakRandomFlow

        io.netty.handler.codec.http.Cookie nettyCookie =
                new io.netty.handler.codec.http.DefaultCookie("name", Integer.toString(c)); // $hasWeakRandomFlow
        nettyCookie.setValue(Integer.toString(c)); // $hasWeakRandomFlow
        io.netty.handler.codec.http.cookie.Cookie nettyCookie2 =
                new io.netty.handler.codec.http.cookie.DefaultCookie("name", Integer.toString(c)); // $hasWeakRandomFlow
        nettyCookie2.setValue(Integer.toString(c)); // $hasWeakRandomFlow

        Encoder enc = null;
        int c2 = r.nextInt();
        String value = enc.encodeForHTML(Integer.toString(c2));
        // BAD: The cookie value may be predictable.
        Cookie cookie2 = new Cookie("name", value); // $hasWeakRandomFlow

        byte[] bytes = new byte[16];
        r.nextBytes(bytes);
        // BAD: The cookie value may be predictable.
        Cookie cookie3 = new Cookie("name", new String(bytes)); // $hasWeakRandomFlow

        SecureRandom sr = new SecureRandom();

        byte[] bytes2 = new byte[16];
        sr.nextBytes(bytes2);
        // GOOD: The cookie value is unpredictable.
        Cookie cookie4 = new Cookie("name", new String(bytes2));

        ThreadLocalRandom tlr = ThreadLocalRandom.current();

        Cookie cookie5 = new Cookie("name", Integer.toString(tlr.nextInt())); // $hasWeakRandomFlow

        Cookie cookie6 = new Cookie("name", RandomStringUtils.random(10)); // $hasWeakRandomFlow

        Cookie cookie7 = new Cookie("name", RandomStringUtils.randomAscii(10)); // $hasWeakRandomFlow

        long c3 = r.nextLong();
        // BAD: The cookie value may be predictable.
        Cookie cookie8 = new Cookie("name", Long.toString(c3 * 5)); // $hasWeakRandomFlow

        double c4 = Math.random();
        // BAD: The cookie value may be predictable.
        Cookie cookie9 = new Cookie("name", Double.toString(c4)); // $hasWeakRandomFlow

        double c5 = Math.random();
        // BAD: The cookie value may be predictable.
        Cookie cookie10 = new Cookie("name", Double.toString(++c5)); // $hasWeakRandomFlow
    }
}
