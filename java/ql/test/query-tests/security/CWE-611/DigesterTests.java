import java.io.BufferedReader;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.digester3.Digester;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class DigesterTests {

    @PostMapping(value = "bad")
    public void bad1(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ServletInputStream servletInputStream = request.getInputStream();
        Digester digester = new Digester();
        digester.parse(servletInputStream); // $ hasTaintFlow
    }

    @PostMapping(value = "good")
    public void good1(HttpServletRequest request, HttpServletResponse response) throws Exception {
        BufferedReader br = request.getReader();
        String str = "";
        StringBuilder listString = new StringBuilder();
        while ((str = br.readLine()) != null) {
            listString.append(str);
        }
        Digester digester = new Digester();
        digester.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        digester.setFeature("http://xml.org/sax/features/external-general-entities", false);
        digester.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
        digester.parse(listString.toString());
    }
}
