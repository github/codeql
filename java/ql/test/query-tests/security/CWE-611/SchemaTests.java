import java.net.Socket;

import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;

public class SchemaTests {

  public void unconfiguredSchemaFactory(Socket sock) throws Exception {
    SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
    Schema schema = factory.newSchema(new StreamSource(sock.getInputStream())); //unsafe
  }

  public void safeSchemaFactory(Socket sock) throws Exception {
    SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
    factory.setProperty(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    factory.setProperty(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");
    Schema schema = factory.newSchema(new StreamSource(sock.getInputStream())); //safe
  }

  public void partialConfiguredSchemaFactory1(Socket sock) throws Exception {
    SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
    factory.setProperty(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    Schema schema = factory.newSchema(new StreamSource(sock.getInputStream())); //unsafe
  }

  public void partialConfiguredSchemaFactory2(Socket sock) throws Exception {
    SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
    factory.setProperty(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");
    Schema schema = factory.newSchema(new StreamSource(sock.getInputStream())); //unsafe
  }

  public void misConfiguredSchemaFactory1(Socket sock) throws Exception {
    SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
    factory.setProperty(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    factory.setProperty(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "ab");
    Schema schema = factory.newSchema(new StreamSource(sock.getInputStream())); //unsafe
  }

  public void misConfiguredSchemaFactory2(Socket sock) throws Exception {
    SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
    factory.setProperty(XMLConstants.ACCESS_EXTERNAL_DTD, "cd");
    factory.setProperty(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");
    Schema schema = factory.newSchema(new StreamSource(sock.getInputStream())); //unsafe
  }
}
