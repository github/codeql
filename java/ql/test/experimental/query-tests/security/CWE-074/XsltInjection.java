import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.Socket;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.stream.XMLInputFactory;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.springframework.web.bind.annotation.RequestParam;
import org.xml.sax.InputSource;

public class XsltInjection {
  public void testStreamSourceInputStream(Socket socket) throws Exception {
    StreamSource source = new StreamSource(socket.getInputStream());
    TransformerFactory.newInstance().newTransformer(source).transform(null, null);
  }

  public void testStreamSourceReader(Socket socket) throws Exception {
    StreamSource source = new StreamSource(new InputStreamReader(socket.getInputStream()));
    TransformerFactory.newInstance().newTemplates(source).newTransformer().transform(null, null);
  }

  public void testStreamSourceInjectedParam(@RequestParam String param) throws Exception {
    String xslt = "<xsl:stylesheet [...]" + param + "</xsl:stylesheet>";
    StreamSource source = new StreamSource(new StringReader(xslt));
    TransformerFactory.newInstance().newTransformer(source).transform(null, null);
  }

  public void testSAXSourceInputStream(Socket socket) throws Exception {
    SAXSource source = new SAXSource(new InputSource(socket.getInputStream()));
    TransformerFactory.newInstance().newTemplates(source).newTransformer().transform(null, null);
  }

  public void testSAXSourceReader(Socket socket) throws Exception {
    SAXSource source = new SAXSource(null, new InputSource(new InputStreamReader(socket.getInputStream())));
    TransformerFactory.newInstance().newTransformer(source).transform(null, null);
  }

  public void testStAXSourceEventReader(Socket socket) throws Exception {
    StAXSource source = new StAXSource(XMLInputFactory.newInstance().createXMLEventReader(socket.getInputStream()));
    TransformerFactory.newInstance().newTransformer(source).transform(null, null);
  }

  public void testStAXSourceEventStream(Socket socket) throws Exception {
    StAXSource source = new StAXSource(XMLInputFactory.newInstance().createXMLStreamReader(null, new InputStreamReader(socket.getInputStream())));
    TransformerFactory.newInstance().newTemplates(source).newTransformer().transform(null, null);
  }

  public void testDOMSource(Socket socket) throws Exception {
    DOMSource source = new DOMSource(DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(socket.getInputStream()));
    TransformerFactory.newInstance().newTransformer(source).transform(null, null);
  }

  public void testDisabledXXE(Socket socket) throws Exception {
    StreamSource source = new StreamSource(socket.getInputStream());
    TransformerFactory factory = TransformerFactory.newInstance();
    factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
    factory.newTransformer(source).transform(null, null);
  }

  public void testFeatureSecureProcessingDisabled(Socket socket) throws Exception {
    StreamSource source = new StreamSource(socket.getInputStream());
    TransformerFactory factory = TransformerFactory.newInstance();
    factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, false);
    factory.newTransformer(source).transform(null, null);
  }

  public void testOkFeatureSecureProcessing(Socket socket) throws Exception {
    StreamSource source = new StreamSource(socket.getInputStream());
    TransformerFactory factory = TransformerFactory.newInstance();
    factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
    factory.newTransformer(source).transform(null, null);
  }
}