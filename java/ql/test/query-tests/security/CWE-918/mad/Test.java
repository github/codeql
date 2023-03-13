import java.net.URL;
import javax.servlet.http.HttpServletRequest;
import javafx.scene.web.WebEngine;
import org.codehaus.cargo.container.installer.ZipURLInstaller;

public class Test {

    public static Object source(HttpServletRequest request) {
        return request.getParameter(null);
    }

    public void test(WebEngine webEngine) {
        // "javafx.scene.web;WebEngine;false;load;(String);;Argument[0];open-url;ai-generated"
        webEngine.load((String) source(null)); // $ SSRF
    }

    public void test() {
        // "org.codehaus.cargo.container.installer;ZipURLInstaller;true;ZipURLInstaller;(URL,String,String);;Argument[0];open-url:ai-generated"
        new ZipURLInstaller((URL) source(null), "", ""); // $ SSRF
    }

}
