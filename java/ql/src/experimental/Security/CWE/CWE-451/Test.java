import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletResponse;

public class Test {

   public void safeXframeOption(HttpServletResponse response) {
        response.addHeader("X-Frame-Options", "DENY");  //GOOD
    }
}
