import java.io.IOException;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;
import java.security.SecureRandom;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;

public class WeakRandomCookies extends HttpServlet {
    HttpServletResponse response;

    public void doGet() {
        Random r = new Random();

        int c = r.nextInt();
        // BAD: The cookie value may be predictable.
        Cookie cookie = new Cookie("name", Integer.toString(c));
        response.addCookie(cookie); // $hasWeakRandomFlow

        int c2 = r.nextInt();
        // BAD: The cookie value may be predictable.
        Cookie cookie2 = new Cookie("name" + c2, "value");
        response.addCookie(cookie2); // $hasWeakRandomFlow

        byte[] bytes = new byte[16];
        r.nextBytes(bytes);
        // BAD: The cookie value may be predictable.
        Cookie cookie3 = new Cookie("name", new String(bytes));
        response.addCookie(cookie3); // $hasWeakRandomFlow

        SecureRandom sr = new SecureRandom();

        byte[] bytes2 = new byte[16];
        sr.nextBytes(bytes2);
        // GOOD: The cookie value is unpredictable.
        Cookie cookie4 = new Cookie("name", new String(bytes2));
        response.addCookie(cookie4);

        ThreadLocalRandom tlr = ThreadLocalRandom.current();

        Cookie cookie5 = new Cookie("name", Integer.toString(tlr.nextInt()));
        response.addCookie(cookie5); // $hasWeakRandomFlow
    }
}
