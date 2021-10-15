import java.net.Socket;
import org.jdom.input.SAXBuilder;

public class SAXBuilderTests {

  public void unconfiguredSAXBuilder(Socket sock) throws Exception {
    SAXBuilder builder = new SAXBuilder();
    builder.build(sock.getInputStream()); //unsafe
  }
  
  public void safeBuilder(Socket sock) throws Exception {
    SAXBuilder builder = new SAXBuilder();
    builder.setFeature("http://apache.org/xml/features/disallow-doctype-decl",true);
    builder.build(sock.getInputStream()); //safe
  }

  public void misConfiguredBuilder(Socket sock) throws Exception {
    SAXBuilder builder = new SAXBuilder();
    builder.setFeature("http://apache.org/xml/features/disallow-doctype-decl",false);
    builder.build(sock.getInputStream()); //unsafe
  }
}
