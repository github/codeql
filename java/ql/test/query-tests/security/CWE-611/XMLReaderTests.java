
import java.net.Socket;

import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.dom4j.io.SAXReader;


public class XMLReaderTests {

  public void unconfiguredReader(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.parse(new InputSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void safeReaderFromConfig1(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    reader.parse(new InputSource(sock.getInputStream())); // safe
  }

  public void safeReaderFromConfig2(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    reader.parse(new InputSource(sock.getInputStream())); // safe
  }

  public void safeReaderFromSAXParser(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    SAXParser parser = factory.newSAXParser();
    XMLReader reader = parser.getXMLReader();
    reader.parse(new InputSource(sock.getInputStream())); // safe
  }

  public void safeReaderFromSAXReader(Socket sock) throws Exception {
    SAXReader reader = new SAXReader();
    reader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    XMLReader xmlReader = reader.getXMLReader();
    xmlReader.parse(new InputSource(sock.getInputStream())); // safe
  }

  public void partialConfiguredXMLReader1(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    reader.parse(new InputSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void partialConfiguredXMLReader2(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    reader.parse(new InputSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void partilaConfiguredXMLReader3(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    reader.parse(new InputSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void misConfiguredXMLReader1(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://xml.org/sax/features/external-general-entities", true);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    reader.parse(new InputSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void misConfiguredXMLReader2(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", true);
    reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    reader.parse(new InputSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void misConfiguredXMLReader3(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", true);
    reader.parse(new InputSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void misConfiguredXMLReader4(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", false);
    reader.parse(new InputSource(sock.getInputStream())); // $ hasTaintFlow
  }
}
