import java.net.Socket;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.transform.Source;
import javax.xml.transform.sax.SAXSource;

import org.xml.sax.InputSource;

public class UnmarshallerTests {

  public void safeUnmarshal(Socket sock) throws Exception {
    SAXParserFactory spf = SAXParserFactory.newInstance();
    spf.setFeature("http://xml.org/sax/features/external-general-entities", false);
    spf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    spf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    JAXBContext jc = JAXBContext.newInstance(Object.class);
    Source xmlSource = new SAXSource(spf.newSAXParser().getXMLReader(), new InputSource(sock.getInputStream()));
    Unmarshaller um = jc.createUnmarshaller();
    um.unmarshal(xmlSource); //safe
  }

  public void unsafeUnmarshal(Socket sock) throws Exception {
    SAXParserFactory spf = SAXParserFactory.newInstance();
    JAXBContext jc = JAXBContext.newInstance(Object.class);
    Unmarshaller um = jc.createUnmarshaller();
    um.unmarshal(sock.getInputStream()); //unsafe
  }
}
