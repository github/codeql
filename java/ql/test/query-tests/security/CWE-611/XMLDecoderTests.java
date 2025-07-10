import java.beans.XMLDecoder;
import java.io.BufferedReader;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class XMLDecoderTests {

    @PostMapping(value = "bad")
    public void bad3(HttpServletRequest request) throws Exception {
        ServletInputStream servletInputStream = request.getInputStream();
        XMLDecoder xmlDecoder = new XMLDecoder(servletInputStream);
        xmlDecoder.readObject(); // $ hasTaintFlow
    }

    @PostMapping(value = "good")
    public void good3(HttpServletRequest request) throws Exception {
        BufferedReader br = request.getReader();
        String str = "";
        StringBuilder listString = new StringBuilder();
        while ((str = br.readLine()) != null) {
            listString.append(str).append("\n");
        }
        // parseText falls back to a default SAXReader, which is safe
        Document document = DocumentHelper.parseText(listString.toString()); // Safe
    }
}
