import java.net.Socket;

import javax.xml.stream.XMLInputFactory;

public class XmlInputFactoryTests {

  public void unconfigureFactory(Socket sock) throws Exception {
    XMLInputFactory factory = XMLInputFactory.newFactory();
    factory.createXMLStreamReader(sock.getInputStream()); //unsafe
    factory.createXMLEventReader(sock.getInputStream()); //unsafe
  }
  
  public void safeFactory(Socket sock) throws Exception {
    XMLInputFactory factory = XMLInputFactory.newFactory();
    factory.setProperty(XMLInputFactory.SUPPORT_DTD, false);
    factory.setProperty("javax.xml.stream.isSupportingExternalEntities", false);
    factory.createXMLStreamReader(sock.getInputStream()); //safe
    factory.createXMLEventReader(sock.getInputStream()); //safe
  }
  
  public void misConfiguredFactory(Socket sock) throws Exception {
    XMLInputFactory factory = XMLInputFactory.newFactory();
    factory.setProperty("javax.xml.stream.isSupportingExternalEntities", false);
    factory.createXMLStreamReader(sock.getInputStream()); //unsafe
    factory.createXMLEventReader(sock.getInputStream()); //unsafe
  }
  
  public void misConfiguredFactory2(Socket sock) throws Exception {
    XMLInputFactory factory = XMLInputFactory.newFactory();
    factory.setProperty(XMLInputFactory.SUPPORT_DTD, false);
    factory.createXMLStreamReader(sock.getInputStream()); //unsafe
    factory.createXMLEventReader(sock.getInputStream()); //unsafe
  }
  
  public void misConfiguredFactory3(Socket sock) throws Exception {
    XMLInputFactory factory = XMLInputFactory.newFactory();
    factory.setProperty("javax.xml.stream.isSupportingExternalEntities", true);
    factory.setProperty(XMLInputFactory.SUPPORT_DTD, true);
    factory.createXMLStreamReader(sock.getInputStream()); //unsafe
    factory.createXMLEventReader(sock.getInputStream()); //unsafe
  }
  
  public void misConfiguredFactory4(Socket sock) throws Exception {
    XMLInputFactory factory = XMLInputFactory.newFactory();
    factory.setProperty("javax.xml.stream.isSupportingExternalEntities", false);
    factory.setProperty(XMLInputFactory.SUPPORT_DTD, true);
    factory.createXMLStreamReader(sock.getInputStream()); //unsafe
    factory.createXMLEventReader(sock.getInputStream()); //unsafe
  }
  
  public void misConfiguredFactory5(Socket sock) throws Exception {
    XMLInputFactory factory = XMLInputFactory.newFactory();
    factory.setProperty("javax.xml.stream.isSupportingExternalEntities", true);
    factory.setProperty(XMLInputFactory.SUPPORT_DTD, false);
    factory.createXMLStreamReader(sock.getInputStream()); //unsafe
    factory.createXMLEventReader(sock.getInputStream()); //unsafe
  }  
}
