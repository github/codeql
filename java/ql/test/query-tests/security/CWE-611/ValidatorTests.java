import java.io.BufferedReader;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class ValidatorTests {

    @PostMapping(value = "bad")
    public void bad2(HttpServletRequest request) throws Exception {
        ServletInputStream servletInputStream = request.getInputStream();
        SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
        Schema schema = factory.newSchema();
        Validator validator = schema.newValidator();
        StreamSource source = new StreamSource(servletInputStream);
        validator.validate(source); // $ hasTaintFlow
    }

    @PostMapping(value = "good")
    public void good2(HttpServletRequest request, HttpServletResponse response) throws Exception {
        BufferedReader br = request.getReader();
        String str = "";
        StringBuilder listString = new StringBuilder();
        while ((str = br.readLine()) != null) {
            listString.append(str).append("\n");
        }
        SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
        Schema schema = factory.newSchema();
        Validator validator = schema.newValidator();
        validator.setProperty("http://javax.xml.XMLConstants/property/accessExternalDTD", "");
        validator.setProperty("http://javax.xml.XMLConstants/property/accessExternalSchema", "");
        StreamSource source = new StreamSource(listString.toString());
        validator.validate(source);
    }
}
