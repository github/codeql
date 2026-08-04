import java.net.Socket;

import javax.xml.stream.XMLInputFactory;

import com.ctc.wstx.stax.WstxInputFactory;

public class WstxInputFactoryTests {

  public void unconfiguredFactory(Socket sock) throws Exception {
    WstxInputFactory factory = new WstxInputFactory();
    factory.createXMLStreamReader(sock.getInputStream()); // $ Alert
    factory.createXMLEventReader(sock.getInputStream()); // $ Alert
  }

  public void safeFactory(Socket sock) throws Exception {
    WstxInputFactory factory = new WstxInputFactory();
    factory.setProperty(XMLInputFactory.SUPPORT_DTD, false);
    factory.setProperty(XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES, false);
    factory.createXMLStreamReader(sock.getInputStream()); // safe
    factory.createXMLEventReader(sock.getInputStream()); // safe
  }

  public void safeFactoryStringProperties(Socket sock) throws Exception {
    WstxInputFactory factory = new WstxInputFactory();
    factory.setProperty("javax.xml.stream.supportDTD", false);
    factory.setProperty("javax.xml.stream.isSupportingExternalEntities", false);
    factory.createXMLStreamReader(sock.getInputStream()); // safe
    factory.createXMLEventReader(sock.getInputStream()); // safe
  }

  public void misConfiguredFactory(Socket sock) throws Exception {
    WstxInputFactory factory = new WstxInputFactory();
    factory.setProperty("javax.xml.stream.isSupportingExternalEntities", false);
    factory.createXMLStreamReader(sock.getInputStream()); // $ Alert
    factory.createXMLEventReader(sock.getInputStream()); // $ Alert
  }

  public void misConfiguredFactory2(Socket sock) throws Exception {
    WstxInputFactory factory = new WstxInputFactory();
    factory.setProperty(XMLInputFactory.SUPPORT_DTD, false);
    factory.createXMLStreamReader(sock.getInputStream()); // $ Alert
    factory.createXMLEventReader(sock.getInputStream()); // $ Alert
  }
}
