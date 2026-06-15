import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.Socket;
import java.net.URI;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.stream.XMLInputFactory;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stax.StAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.xml.sax.InputSource;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.XdmValue;
import net.sf.saxon.s9api.XsltCompiler;

@Controller
public class XsltInjectionTest {
  public void testStreamSourceInputStream(Socket socket) throws Exception {
    StreamSource source = new StreamSource(socket.getInputStream()); // $ Source
    TransformerFactory.newInstance().newTransformer(source).transform(null, null); // $ Alert
  }

  public void testStreamSourceReader(Socket socket) throws Exception {
    StreamSource source = new StreamSource(new InputStreamReader(socket.getInputStream())); // $ Source
    TransformerFactory.newInstance().newTemplates(source).newTransformer().transform(null, null); // $ Alert
  }

  @RequestMapping
  public void testStreamSourceInjectedParam(@RequestParam String param) throws Exception { // $ Source
    String xslt = "<xsl:stylesheet [...]" + param + "</xsl:stylesheet>";
    StreamSource source = new StreamSource(new StringReader(xslt));
    TransformerFactory.newInstance().newTransformer(source).transform(null, null); // $ Alert
  }

  public void testSAXSourceInputStream(Socket socket) throws Exception {
    SAXSource source = new SAXSource(new InputSource(socket.getInputStream())); // $ Source
    TransformerFactory.newInstance().newTemplates(source).newTransformer().transform(null, null); // $ Alert
  }

  public void testSAXSourceReader(Socket socket) throws Exception {
    SAXSource source =
        new SAXSource(null, new InputSource(new InputStreamReader(socket.getInputStream()))); // $ Source
    TransformerFactory.newInstance().newTransformer(source).transform(null, null); // $ Alert
  }

  public void testStAXSourceEventReader(Socket socket) throws Exception {
    StAXSource source =
        new StAXSource(XMLInputFactory.newInstance().createXMLEventReader(socket.getInputStream())); // $ Source
    TransformerFactory.newInstance().newTransformer(source).transform(null, null); // $ Alert
  }

  public void testStAXSourceEventStream(Socket socket) throws Exception {
    StAXSource source = new StAXSource(XMLInputFactory.newInstance().createXMLStreamReader(null,
        new InputStreamReader(socket.getInputStream()))); // $ Source
    TransformerFactory.newInstance().newTemplates(source).newTransformer().transform(null, null); // $ Alert
  }

  public void testDOMSource(Socket socket) throws Exception {
    DOMSource source = new DOMSource(
        DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(socket.getInputStream())); // $ Source
    TransformerFactory.newInstance().newTransformer(source).transform(null, null); // $ Alert
  }

  public void testDisabledXXE(Socket socket) throws Exception {
    StreamSource source = new StreamSource(socket.getInputStream()); // $ Source
    TransformerFactory factory = TransformerFactory.newInstance();
    factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
    factory.newTransformer(source).transform(null, null); // $ Alert
  }

  public void testFeatureSecureProcessingDisabled(Socket socket) throws Exception {
    StreamSource source = new StreamSource(socket.getInputStream()); // $ Source
    TransformerFactory factory = TransformerFactory.newInstance();
    factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, false);
    factory.newTransformer(source).transform(null, null); // $ Alert
  }

  public void testSaxon(Socket socket) throws Exception {
    StreamSource source = new StreamSource(socket.getInputStream()); // $ Source
    XsltCompiler compiler = new Processor(true).newXsltCompiler();

    compiler.compile(source).load().transform(); // $ Alert
    compiler.compile(source).load30().transform(null, null); // $ Alert
    compiler.compile(source).load30().applyTemplates((Source) null); // $ Alert
    compiler.compile(source).load30().applyTemplates((Source) null, null); // $ Alert
    compiler.compile(source).load30().applyTemplates((XdmValue) null); // $ Alert
    compiler.compile(source).load30().applyTemplates((XdmValue) null, null); // $ Alert
    compiler.compile(source).load30().callFunction(null, null); // $ Alert
    compiler.compile(source).load30().callFunction(null, null, null); // $ Alert
    compiler.compile(source).load30().callTemplate(null); // $ Alert
    compiler.compile(source).load30().callTemplate(null, null); // $ Alert
  }

  @RequestMapping
  public void testSaxonXsltPackage(@RequestParam String param, Socket socket) throws Exception { // $ Source
    URI uri = new URI(param);
    StreamSource source = new StreamSource(socket.getInputStream()); // $ Source
    XsltCompiler compiler = new Processor(true).newXsltCompiler();

    compiler.loadExecutablePackage(uri).load().transform(); // $ Alert
    compiler.compilePackage(source).link().load().transform(); // $ Alert
    compiler.loadLibraryPackage(uri).link().load().transform(); // $ Alert
  }

  public void testOkFeatureSecureProcessing(Socket socket) throws Exception {
    StreamSource source = new StreamSource(socket.getInputStream());
    TransformerFactory factory = TransformerFactory.newInstance();
    factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
    factory.newTransformer(source).transform(null, null); // Safe
  }

  public void testOkSaxon(Socket socket) throws Exception {
    StreamSource source = new StreamSource(socket.getInputStream());
    XsltCompiler compiler = new Processor(true).newXsltCompiler();

    compiler.compile(source).load().close(); // Safe
    compiler.compile((Source) new Object()).load().transform(); // Safe
  }
}
