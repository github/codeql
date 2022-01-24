package javax.xml.bind;

import java.net.URL;
import java.io.Reader;
import java.io.InputStream;
import java.io.File;
import javax.xml.transform.Source;

abstract public interface Unmarshaller {
  abstract public static class Listener {
    public Listener() { }
  
    public void afterUnmarshal(Object p0, Object p1) { }
  
    public void beforeUnmarshal(Object p0, Object p1) { }
  }

//  abstract public A getAdapter(Class<A> p0);
//
//  abstract public AttachmentUnmarshaller getAttachmentUnmarshaller();
//
//  abstract public ValidationEventHandler getEventHandler();
//
//  abstract public Listener getListener();

  abstract public Object getProperty(String p0);

//  abstract public Schema getSchema();
//
//  abstract public UnmarshallerHandler getUnmarshallerHandler();

  abstract public boolean isValidating();

//  abstract public void setAdapter(Class<A> p0, A p1);
//
//  abstract public void setAdapter(XmlAdapter p0);
//
//  abstract public void setAttachmentUnmarshaller(AttachmentUnmarshaller p0);
//
//  abstract public void setEventHandler(ValidationEventHandler p0);
//
//  abstract public void setListener(Listener p0);
//
//  abstract public void setProperty(String p0, Object p1);
//
//  abstract public void setSchema(Schema p0);

  abstract public void setValidating(boolean p0);

  abstract public Object unmarshal(File p0);

  abstract public Object unmarshal(InputStream p0);

  abstract public Object unmarshal(Reader p0);

  abstract public Object unmarshal(URL p0);

//  abstract public Object unmarshal(XMLEventReader p0);
//
//  abstract public JAXBElement<T> unmarshal(XMLEventReader p0, Class<T> p1);
//
//  abstract public Object unmarshal(XMLStreamReader p0);
//
//  abstract public JAXBElement<T> unmarshal(XMLStreamReader p0, Class<T> p1);

  abstract public Object unmarshal(Source p0);

//  abstract public JAXBElement<T> unmarshal(Source p0, Class<T> p1);
//
//  abstract public Object unmarshal(Node p0);
//
//  abstract public JAXBElement<T> unmarshal(Node p0, Class<T> p1);
//
//  abstract public Object unmarshal(InputSource p0);
}

