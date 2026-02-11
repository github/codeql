import java.io.ByteArrayInputStream;
import java.io.StringReader;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.jaxen.pattern.Pattern;
import org.dom4j.DocumentFactory;
import org.dom4j.DocumentHelper;
import org.dom4j.Namespace;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;
import org.dom4j.util.ProxyDocumentFactory;
import org.dom4j.xpath.DefaultXPath;
import org.dom4j.xpath.XPathPattern;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class XPathInjectionTest {
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

    private static class ProxyDocumentFactoryStub extends ProxyDocumentFactory {
    }

    private static class PatternStub extends Pattern {
        private String text;

        PatternStub(String text) {
            this.text = text;
        }

        public String getText() {
            return text;
        }
    }

    public void handle(HttpServletRequest request) throws Exception {
        String user = request.getParameter("user"); // $ Source
        String pass = request.getParameter("pass"); // $ Source
        String expression = "/users/user[@name='" + user + "' and @pass='" + pass + "']";

        final String xmlStr = "<users>" + "   <user name=\"aaa\" pass=\"pass1\"></user>"
                + "   <user name=\"bbb\" pass=\"pass2\"></user>" + "</users>";
        DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = domFactory.newDocumentBuilder();
        InputSource xmlSource = new InputSource(new StringReader(xmlStr));
        Document doc = builder.parse(xmlSource);

        XPathFactory factory = XPathFactory.newInstance();
        XPath xpath = factory.newXPath();

        xpath.evaluate(expression, doc, XPathConstants.BOOLEAN); // $ Alert
        xpath.evaluateExpression(expression, xmlSource); // $ Alert
        xpath.compile("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert

        XPathImplStub xpathStub = XPathImplStub.getInstance();
        xpathStub.evaluate(expression, doc, XPathConstants.BOOLEAN); // $ Alert
        xpathStub.evaluateExpression(expression, xmlSource); // $ Alert
        xpathStub.compile("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert

        StringBuffer sb = new StringBuffer("/users/user[@name=");
        sb.append(user);
        sb.append("' and @pass='");
        sb.append(pass);
        sb.append("']");
        String query = sb.toString();

        xpath.compile(query); // $ Alert
        xpathStub.compile(query); // $ Alert

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

        SAXReader reader = new SAXReader();
        org.dom4j.Document document = reader.read(new ByteArrayInputStream(xmlStr.getBytes()));
        document.selectObject("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        document.selectNodes("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        document.selectNodes("/users/user[@name='test']", "/users/user[@pass='" + pass + "']"); // $ Alert
        document.selectSingleNode("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        document.valueOf("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        document.numberValueOf("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        document.matches("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        document.createXPath("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert

        new DefaultXPath("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        new XPathPattern("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        new XPathPattern(new PatternStub(user)); // $ MISSING: hasXPathInjection // Jaxen is not modeled yet

        DocumentFactory docFactory = DocumentFactory.getInstance();
        docFactory.createPattern("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        docFactory.createXPath("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        docFactory.createXPathFilter("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert

        DocumentHelper.createPattern("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        DocumentHelper.createXPath("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        DocumentHelper.createXPathFilter("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        DocumentHelper.selectNodes("/users/user[@name='" + user + "' and @pass='" + pass + "']", new ArrayList<Node>()); // $ Alert
        DocumentHelper.sort(new ArrayList<Node>(), "/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert

        ProxyDocumentFactoryStub proxyDocFactory = new ProxyDocumentFactoryStub();
        proxyDocFactory.createPattern("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        proxyDocFactory.createXPath("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        proxyDocFactory.createXPathFilter("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert

        Namespace namespace = new Namespace("prefix", "http://some.uri.io");
        namespace.createPattern("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert
        namespace.createXPathFilter("/users/user[@name='" + user + "' and @pass='" + pass + "']"); // $ Alert

        org.jaxen.SimpleVariableContext svc = new org.jaxen.SimpleVariableContext();
        svc.setVariableValue("user", user);
        svc.setVariableValue("pass", pass);
        String xpathString = "/users/user[@name=$user and @pass=$pass]";
        org.dom4j.XPath safeXPath = document.createXPath(xpathString); // Safe
        safeXPath.setVariableContext(svc);
        safeXPath.selectSingleNode(document); // Safe
    }
}
