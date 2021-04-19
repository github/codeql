import java.net.Socket;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.transform.sax.SAXSource;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

public class SAXSourceTests {

  public void unsafeSource(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    SAXSource source = new SAXSource(reader, new InputSource(sock.getInputStream()));
    JAXBContext jc = JAXBContext.newInstance(Object.class);
    Unmarshaller um = jc.createUnmarshaller();
    um.unmarshal(source); // BAD
  }

  public void explicitlySafeSource1(Socket sock) throws Exception {
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd",false);
    SAXSource source = new SAXSource(reader, new InputSource(sock.getInputStream())); // GOOD
  }

  public void createdSafeSource(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    SAXParser parser = factory.newSAXParser();
    XMLReader reader = parser.getXMLReader();
    SAXSource source = new SAXSource(parser.getXMLReader(), new InputSource(sock.getInputStream())); // GOOD
    SAXSource source2 = new SAXSource(reader, new InputSource(sock.getInputStream())); // GOOD
  }
}
