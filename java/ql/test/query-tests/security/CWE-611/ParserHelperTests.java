import javax.servlet.http.HttpServletRequest;
import org.dom4j.Document;
import org.rundeck.api.parser.ParserHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class ParserHelperTests {

    @PostMapping(value = "bad4")
    public void bad4(HttpServletRequest request) throws Exception {
        Document document = ParserHelper.loadDocument(request.getInputStream()); // $ hasTaintFlow
    }
}
