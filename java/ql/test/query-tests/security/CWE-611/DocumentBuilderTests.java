import java.net.Socket;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.XMLConstants;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamSource;
import org.xml.sax.InputSource;

class DocumentBuilderTests {

  public void unconfiguredParse(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //unsafe
  }

  public void disableDTD(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //safe
  }

  public void enableSecurityFeature(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //safe
  }

  public void enableSecurityFeature2(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://javax.xml.XMLConstants/feature/secure-processing", true);
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //safe
  }

  public void enableDTD(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", false);
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //unsafe
  }

  public void disableSecurityFeature(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://javax.xml.XMLConstants/feature/secure-processing", false);
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //unsafe
  }

  public void disableExternalEntities(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //safe
  }

  public void partialDisableExternalEntities(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //unsafe
  }

  public void partialDisableExternalEntities2(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //unsafe
  }

  public void misConfigureExternalEntities1(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", true);
    factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //unsafe
  }

  public void misConfigureExternalEntities2(Socket sock) throws Exception {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    factory.setFeature("http://xml.org/sax/features/external-general-entities", true);
    DocumentBuilder builder = factory.newDocumentBuilder();
    builder.parse(sock.getInputStream()); //unsafe
  }

  public void taintedSAXInputSource1(Socket sock) throws Exception {
	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	DocumentBuilder builder = factory.newDocumentBuilder();
	SAXSource source = new SAXSource(new InputSource(sock.getInputStream()));
	builder.parse(source.getInputSource()); //unsafe
  }

  public void taintedSAXInputSource2(Socket sock) throws Exception {
	DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	DocumentBuilder builder = factory.newDocumentBuilder();
	StreamSource source = new StreamSource(sock.getInputStream());
	builder.parse(SAXSource.sourceToInputSource(source)); //unsafe
	builder.parse(source.getInputStream()); //unsafe
  }

  private static DocumentBuilderFactory getDocumentBuilderFactory() {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    String feature = "";
    feature = "http://xml.org/sax/features/external-parameter-entities";
    factory.setFeature(feature, false);
    feature = "http://xml.org/sax/features/external-general-entities";
    factory.setFeature(feature, false);
    return factory;
  }

  private static final ThreadLocal<DocumentBuilder> XML_DOCUMENT_BUILDER = new ThreadLocal<DocumentBuilder>() {
    @Override
    protected DocumentBuilder initialValue() {
      DocumentBuilderFactory factory = getDocumentBuilderFactory();
      try {
        return factory.newDocumentBuilder();
      } catch (Exception ex) {
        throw new RuntimeException(ex);
      }
    }
  };

  public void disableExternalEntities2(Socket sock) throws Exception {
    DocumentBuilder builder = XML_DOCUMENT_BUILDER.get();
    builder.parse(sock.getInputStream()); //safe
  }

}
