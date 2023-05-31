import java.net.Socket;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.xml.sax.InputSource;

public class XPathExpressionTests {

  public void safeXPathExpression(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    DocumentBuilder builder = factory.newDocumentBuilder();
    XPathFactory xFactory = XPathFactory.newInstance();
    XPath path = xFactory.newXPath();
    XPathExpression expr = path.compile("");
    expr.evaluate(builder.parse(sock.getInputStream())); // safe
  }

  public void unsafeExpressionTests(Socket sock) throws Exception {
    XPathFactory xFactory = XPathFactory.newInstance();
    XPath path = xFactory.newXPath();
    XPathExpression expr = path.compile("");
    expr.evaluate(new InputSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void safeXPathEvaluateTest(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    DocumentBuilder builder = factory.newDocumentBuilder();
    XPathFactory xFactory = XPathFactory.newInstance();
    XPath path = xFactory.newXPath();
    path.evaluate("", builder.parse(sock.getInputStream())); // safe
  }

  public void unsafeXPathEvaluateTest(Socket sock) throws Exception {
    XPathFactory xFactory = XPathFactory.newInstance();
    XPath path = xFactory.newXPath();
    path.evaluate("", new InputSource(sock.getInputStream())); // $ hasTaintFlow
  }
}
