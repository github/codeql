import java.net.Socket;

import javax.xml.XMLConstants;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.sax.SAXSource;

import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;


public class TransformerTests {

  public void unconfiguredTransformerFactory(Socket sock) throws Exception {
    TransformerFactory tf = TransformerFactory.newInstance();
    Transformer transformer = tf.newTransformer();
    transformer.transform(new StreamSource(sock.getInputStream()), null); // $ hasTaintFlow
    tf.newTransformer(new StreamSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void safeTransformerFactory1(Socket sock) throws Exception {
    TransformerFactory tf = TransformerFactory.newInstance();
    tf.setAttribute("http://javax.xml.XMLConstants/property/accessExternalDTD", "");
    tf.setAttribute("http://javax.xml.XMLConstants/property/accessExternalStylesheet", "");
    Transformer transformer = tf.newTransformer();
    transformer.transform(new StreamSource(sock.getInputStream()), null); // safe
    tf.newTransformer(new StreamSource(sock.getInputStream())); // safe
  }

  public void safeTransformerFactory2(Socket sock) throws Exception {
    TransformerFactory tf = TransformerFactory.newInstance();
    tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
    Transformer transformer = tf.newTransformer();
    transformer.transform(new StreamSource(sock.getInputStream()), null); // safe
    tf.newTransformer(new StreamSource(sock.getInputStream())); // safe
  }

  public void safeTransformerFactory3(Socket sock) throws Exception {
    TransformerFactory tf = TransformerFactory.newInstance();
    Transformer transformer = tf.newTransformer();
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    SAXSource source = new SAXSource(reader, new InputSource(sock.getInputStream())); // safe
    transformer.transform(source, null); // safe
    tf.newTransformer(source); // safe
  }

  public void safeTransformerFactory4(Socket sock) throws Exception {
    TransformerFactory tf = TransformerFactory.newInstance();
    Transformer transformer = tf.newTransformer();
    XMLReader reader = XMLReaderFactory.createXMLReader();
    reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
    reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
    SAXSource source = new SAXSource(new InputSource(sock.getInputStream()));
    source.setXMLReader(reader);
    transformer.transform(source, null); // safe
    tf.newTransformer(source); // safe
  }

  public void partialConfiguredTransformerFactory1(Socket sock) throws Exception {
    TransformerFactory tf = TransformerFactory.newInstance();
    tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    Transformer transformer = tf.newTransformer();
    transformer.transform(new StreamSource(sock.getInputStream()), null); // $ hasTaintFlow
    tf.newTransformer(new StreamSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void partialConfiguredTransformerFactory2(Socket sock) throws Exception {
    TransformerFactory tf = TransformerFactory.newInstance();
    tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
    Transformer transformer = tf.newTransformer();
    transformer.transform(new StreamSource(sock.getInputStream()), null); // $ hasTaintFlow
    tf.newTransformer(new StreamSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void misConfiguredTransformerFactory1(Socket sock) throws Exception {
    TransformerFactory tf = TransformerFactory.newInstance();
    Transformer transformer = tf.newTransformer();
    tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "ab");
    tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
    transformer.transform(new StreamSource(sock.getInputStream()), null); // $ hasTaintFlow
    tf.newTransformer(new StreamSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void misConfiguredTransformerFactory2(Socket sock) throws Exception {
    TransformerFactory tf = TransformerFactory.newInstance();
    Transformer transformer = tf.newTransformer();
    tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    tf.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "cd");
    transformer.transform(new StreamSource(sock.getInputStream()), null); // $ hasTaintFlow
    tf.newTransformer(new StreamSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void unconfiguredSAXTransformerFactory(Socket sock) throws Exception {
    SAXTransformerFactory sf = (SAXTransformerFactory) SAXTransformerFactory.newInstance();
    sf.newXMLFilter(new StreamSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void safeSAXTransformerFactory(Socket sock) throws Exception {
    SAXTransformerFactory sf = (SAXTransformerFactory) SAXTransformerFactory.newInstance();
    sf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    sf.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
    sf.newXMLFilter(new StreamSource(sock.getInputStream())); // safe
  }

  public void partialConfiguredSAXTransformerFactory1(Socket sock) throws Exception {
    SAXTransformerFactory sf = (SAXTransformerFactory) SAXTransformerFactory.newInstance();
    sf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    sf.newXMLFilter(new StreamSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void partialConfiguredSAXTransformerFactory2(Socket sock) throws Exception {
    SAXTransformerFactory sf = (SAXTransformerFactory) SAXTransformerFactory.newInstance();
    sf.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
    sf.newXMLFilter(new StreamSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void misConfiguredSAXTransformerFactory1(Socket sock) throws Exception {
    SAXTransformerFactory sf = (SAXTransformerFactory) SAXTransformerFactory.newInstance();
    sf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "ab");
    sf.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
    sf.newXMLFilter(new StreamSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void misConfiguredSAXTransformerFactory2(Socket sock) throws Exception {
    SAXTransformerFactory sf = (SAXTransformerFactory) SAXTransformerFactory.newInstance();
    sf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    sf.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "cd");
    sf.newXMLFilter(new StreamSource(sock.getInputStream())); // $ hasTaintFlow
  }

  public void taintedSAXSource(Socket sock) throws Exception {
    SAXTransformerFactory sf = (SAXTransformerFactory) SAXTransformerFactory.newInstance();
    sf.newXMLFilter(new SAXSource(new InputSource(sock.getInputStream()))); // $ hasTaintFlow
  }
}
