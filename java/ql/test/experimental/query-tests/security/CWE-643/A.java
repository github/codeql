import java.io.ByteArrayInputStream;
import java.io.StringReader;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class A {
    public void handle(HttpServletRequest request) throws Exception {
        final String xmlStr = "<users>" + "   <user name=\"aaa\" pass=\"pass1\"></user>"
                + "   <user name=\"bbb\" pass=\"pass2\"></user>" + "</users>";
        DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
        domFactory.setNamespaceAware(true);
        DocumentBuilder builder = domFactory.newDocumentBuilder();
        Document doc = builder.parse(new InputSource(new StringReader(xmlStr)));

        XPathFactory factory = XPathFactory.newInstance();
        XPath xpath = factory.newXPath();

        // Injectable data
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        if (user != null && pass != null) {
            // Bad expression
            String expression1 = "/users/user[@name='" + user + "' and @pass='" + pass + "']";
            xpath.evaluate(expression1, doc, XPathConstants.BOOLEAN); // $hasXPathInjection

            // Bad expression
            XPathExpression expression2 = xpath.compile("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
            expression2.evaluate(doc, XPathConstants.BOOLEAN);

            // Bad expression
            StringBuffer sb = new StringBuffer("/users/user[@name=");
            sb.append(user);
            sb.append("' and @pass='");
            sb.append(pass);
            sb.append("']");
            String query = sb.toString();
            XPathExpression expression3 = xpath.compile(query); // $hasXPathInjection
            expression3.evaluate(doc, XPathConstants.BOOLEAN);

            // Good expression
            String expression4 = "/users/user[@name=$user and @pass=$pass]";
            xpath.setXPathVariableResolver(v -> {
                switch (v.getLocalPart()) {
                case "user":
                    return user;
                case "pass":
                    return pass;
                default:
                    throw new IllegalArgumentException();
                }
            });
            xpath.evaluate(expression4, doc, XPathConstants.BOOLEAN); // Safe

            // Bad Dom4j
            org.dom4j.io.SAXReader reader = new org.dom4j.io.SAXReader();
            org.dom4j.Document document = reader.read(new ByteArrayInputStream(xmlStr.getBytes()));
            document.selectSingleNode("/users/user[@name='" + user + "' and @pass='" + pass + "']") // $hasXPathInjection
                    .hasContent();
            document.selectNodes("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
        }
    }
}