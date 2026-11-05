import java.net.Socket;

import javax.xml.XMLConstants;
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

import org.apache.commons.xml.secure.SecureDocumentBuilderFactory;
import org.apache.commons.xml.secure.SecureSAXParserFactory;
import org.apache.commons.xml.secure.SecureSchemaFactory;
import org.apache.commons.xml.secure.SecureTransformerFactory;
import org.apache.commons.xml.secure.SecureXMLInputFactory;

// Every factory returned by the `org.apache.commons.xml.secure.SecureXxxFactory` classes is
// already hardened against XXE, so the parsers created from them must not be reported.
public class SecureXmlFactoriesTests {

  public void hardenedDocumentBuilder(Socket sock) throws Exception {
    DocumentBuilderFactory factory = SecureDocumentBuilderFactory.newInstance();
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); // safe
  }

  public void hardenedDocumentBuilderChained(Socket sock) throws Exception {
    SecureDocumentBuilderFactory.newDefaultNSInstance().newDocumentBuilder().parse(sock.getInputStream()); // safe
  }

  public void hardenedSaxParser(Socket sock) throws Exception {
    SAXParserFactory factory = SecureSAXParserFactory.newInstance();
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); // safe
  }

  public void hardenedSaxParserXmlReader(Socket sock) throws Exception {
    SAXParser parser = SecureSAXParserFactory.newNSInstance().newSAXParser();
    XMLReader reader = parser.getXMLReader();
    reader.parse(new org.xml.sax.InputSource(sock.getInputStream())); // safe
  }

  public void hardenedXmlInputFactory(Socket sock) throws Exception {
    XMLInputFactory factory = SecureXMLInputFactory.newFactory();
    factory.createXMLStreamReader(sock.getInputStream()); // safe
    factory.createXMLEventReader(sock.getInputStream()); // safe
  }

  public void hardenedXmlInputFactoryDefault(Socket sock) throws Exception {
    XMLInputFactory factory = SecureXMLInputFactory.newDefaultFactory();
    factory.createXMLStreamReader(sock.getInputStream()); // safe
  }

  public void hardenedTransformer(Socket sock) throws Exception {
    TransformerFactory tf = SecureTransformerFactory.newInstance();
    Transformer transformer = tf.newTransformer();
    transformer.transform(new StreamSource(sock.getInputStream()), null); // safe
    tf.newTransformer(new StreamSource(sock.getInputStream())); // safe
  }

  public void hardenedTransformerDefault(Socket sock) throws Exception {
    TransformerFactory tf = SecureTransformerFactory.newDefaultInstance();
    tf.newTransformer(new StreamSource(sock.getInputStream())); // safe
  }

  public void hardenedSchema(Socket sock) throws Exception {
    SchemaFactory factory = SecureSchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
    Schema schema = factory.newSchema(new StreamSource(sock.getInputStream())); // safe
  }
}
