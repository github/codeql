import java.net.Socket;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.XMLConstants;
import org.xml.sax.helpers.DefaultHandler;

public class SAXParserTests {
  
  public void unconfiguredParser(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); //unsafe
  }
  
  public void safeParser(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); //safe
  }
  
  public void partialConfiguredParser1(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); //unsafe
  }
  
  public void partialConfiguredParser2(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); //unsafe
  }
  
  public void partialConfiguredParser3(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
    factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); //unsafe
  }
  
  public void misConfiguredParser1(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-general-entities", true);
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); //unsafe
  }
  
  public void misConfiguredParser2(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", true);
    factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); //unsafe
  }
  
  public void misConfiguredParser3(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", true);
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); //unsafe
  }

  public void safeParser2(Socket sock) throws Exception {
    SAXParserFactory factory = SAXParserFactory.newInstance();
    factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
    factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true); 
    SAXParser parser = factory.newSAXParser();
    parser.parse(sock.getInputStream(), new DefaultHandler()); //safe
  }
}
