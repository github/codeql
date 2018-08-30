import java.net.Socket;
import org.dom4j.io.SAXReader;

public class SAXReaderTests {

  public void unconfiguredReader(Socket sock) throws Exception {
    SAXReader reader = new SAXReader();
    reader.read(sock.getInputStream()); //unsafe
  }
  
  public void safeReader(Socket sock) throws Exception {
    SAXReader reader = new SAXReader();
    reader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);    
    reader.read(sock.getInputStream()); //safe
  }
  
  public void partialConfiguredReader1(Socket sock) throws Exception {
    SAXReader reader = new SAXReader();
    reader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.read(sock.getInputStream()); //unsafe
  }
  
  public void partialConfiguredReader2(Socket sock) throws Exception {
    SAXReader reader = new SAXReader();
    reader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);    
    reader.read(sock.getInputStream()); //unsafe
  }
  
  public void partialConfiguredReader3(Socket sock) throws Exception {
    SAXReader reader = new SAXReader();
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);    
    reader.read(sock.getInputStream()); //unsafe
  }
  
  public void misConfiguredReader1(Socket sock) throws Exception {
    SAXReader reader = new SAXReader();
    reader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    reader.setFeature("http://xml.org/sax/features/external-general-entities", true);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);    
    reader.read(sock.getInputStream()); //unsafe
  }
  
  public void misConfiguredReader2(Socket sock) throws Exception {
    SAXReader reader = new SAXReader();
    reader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", false);
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);    
    reader.read(sock.getInputStream()); //unsafe
  }
  
  public void misConfiguredReader3(Socket sock) throws Exception {
    SAXReader reader = new SAXReader();
    reader.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", true);    
    reader.read(sock.getInputStream()); //unsafe
  }
}
