import javax.servlet.http.HttpServletRequest;
import org.kohsuke.stapler.HttpResponses;

public class Test {

    private static HttpServletRequest request;

    public static Object source() {
        return request.getParameter(null);
    }

    public void test(HttpResponses r) {
        // "org.kohsuke.stapler;HttpResponses;true;redirectTo;(String);;Argument[0];open-url;ai-generated"
        r.redirectTo((String) source());
    }
}
