import java.net.Socket;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.stream.XMLInputFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;

import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;

import org.apache.commons.xml.XmlFactories;

// Every factory returned by `org.apache.commons.xml.XmlFactories` is already hardened against
// XXE, so the parsers created from them must not be reported.
public class XmlFactoriesTests {

  public void hardenedDocumentBuilder(Socket sock) throws Exception {
    DocumentBuilderFactory factory = XmlFactories.newDocumentBuilderFactory();
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); // safe
  }

  public void hardenedDocumentBuilderChained(Socket sock) throws Exception {
    XmlFactories.newDocumentBuilderFactory().newDocumentBuilder().parse(sock.getInputStream()); // safe
  }

  public void hardenedSaxParser(Socket sock) throws Exception {
    SAXParserFactory factory = XmlFactories.newSAXParserFactory();
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); // safe
  }

  public void hardenedSaxParserXmlReader(Socket sock) throws Exception {
    SAXParser parser = XmlFactories.newSAXParserFactory().newSAXParser();
    XMLReader reader = parser.getXMLReader();
    reader.parse(new org.xml.sax.InputSource(sock.getInputStream())); // safe
  }

  public void hardenedXmlInputFactory(Socket sock) throws Exception {
    XMLInputFactory factory = XmlFactories.newXMLInputFactory();
    factory.createXMLStreamReader(sock.getInputStream()); // safe
    factory.createXMLEventReader(sock.getInputStream()); // safe
  }

  public void hardenedTransformer(Socket sock) throws Exception {
    TransformerFactory tf = XmlFactories.newTransformerFactory();
    Transformer transformer = tf.newTransformer();
    transformer.transform(new StreamSource(sock.getInputStream()), null); // safe
    tf.newTransformer(new StreamSource(sock.getInputStream())); // safe
  }

  public void hardenedSchema(Socket sock) throws Exception {
    SchemaFactory factory = XmlFactories.newSchemaFactory();
    Schema schema = factory.newSchema(new StreamSource(sock.getInputStream())); // safe
  }
}
