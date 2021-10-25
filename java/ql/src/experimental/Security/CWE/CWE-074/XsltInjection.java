import javax.xml.XMLConstants;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

public void transform(Socket socket, String inputXml) throws Exception {
  StreamSource xslt = new StreamSource(socket.getInputStream());
  StreamSource xml = new StreamSource(new StringReader(inputXml));
  StringWriter result = new StringWriter();
  TransformerFactory factory = TransformerFactory.newInstance();

  // BAD: User provided XSLT stylesheet is processed
  factory.newTransformer(xslt).transform(xml, new StreamResult(result));

  // GOOD: The secure processing mode is enabled
  factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
  factory.newTransformer(xslt).transform(xml, new StreamResult(result));
}  