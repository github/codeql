import java.io.ByteArrayInputStream;
import java.io.StringReader;

import javax.servlet.http.HttpServletRequest;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class A {
    private static abstract class XPathImplStub implements XPath {
        public static XPathImplStub getInstance() {
            return null;
        }

        @Override
        public XPathExpression compile(String expression) throws XPathExpressionException {
            return null;
        }

        @Override
        public Object evaluate(String expression, Object item, QName returnType) throws XPathExpressionException {
            return null;
        }

        @Override
        public String evaluate(String expression, Object item) throws XPathExpressionException {
            return null;
        }

        @Override
        public Object evaluate(String expression, InputSource source, QName returnType)
                throws XPathExpressionException {
            return null;
        }

        @Override
        public String evaluate(String expression, InputSource source) throws XPathExpressionException {
            return null;
        }

    }

    public void handle(HttpServletRequest request) throws Exception {
        final String xmlStr = "<users>" + "   <user name=\"aaa\" pass=\"pass1\"></user>"
                + "   <user name=\"bbb\" pass=\"pass2\"></user>" + "</users>";
        DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
        domFactory.setNamespaceAware(true);
        DocumentBuilder builder = domFactory.newDocumentBuilder();
        InputSource xmlSource = new InputSource(new StringReader(xmlStr));
        Document doc = builder.parse(xmlSource);

        XPathFactory factory = XPathFactory.newInstance();
        XPath xpath = factory.newXPath();
        XPathImplStub xpathStub = XPathImplStub.getInstance();

        // Injectable data
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");
        if (user != null && pass != null) {
            // Bad expression
            String expression1 = "/users/user[@name='" + user + "' and @pass='" + pass + "']";
            xpath.evaluate(expression1, doc, XPathConstants.BOOLEAN); // $hasXPathInjection
            xpathStub.evaluate(expression1, doc, XPathConstants.BOOLEAN); // $hasXPathInjection
            xpath.evaluateExpression(expression1, xmlSource); // $hasXPathInjection
            xpathStub.evaluateExpression(expression1, xmlSource); // $hasXPathInjection

            // Bad expression
            XPathExpression expression2 = xpath.compile("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
            xpathStub.compile("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
            expression2.evaluate(doc, XPathConstants.BOOLEAN);

            // Bad expression
            StringBuffer sb = new StringBuffer("/users/user[@name=");
            sb.append(user);
            sb.append("' and @pass='");
            sb.append(pass);
            sb.append("']");
            String query = sb.toString();
            XPathExpression expression3 = xpath.compile(query); // $hasXPathInjection
            xpathStub.compile(query); // $hasXPathInjection
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
            document.selectObject("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
            document.selectNodes("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
            document.selectNodes("/users/user[@name='test']", "/users/user[@pass='" + pass + "']"); // $hasXPathInjection
            document.selectSingleNode("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
            document.valueOf("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
            document.numberValueOf("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
            document.matches("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
            document.createXPath("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $hasXPathInjection
        }
    }
}