package javax.xml.bind;

import java.util.Map;

abstract public class JAXBContext {
  protected JAXBContext() { }

//  public static final String JAXB_CONTEXT_FACTORY;
//
//  public Binder<Node> createBinder() { return null; }
//
//  public Binder<T> createBinder(Class<T> p0) { return null; }
//
//  public JAXBIntrospector createJAXBIntrospector() { return null; }
//
//  abstract public Marshaller createMarshaller();

  abstract public Unmarshaller createUnmarshaller();

//  abstract public Validator createValidator();
//
//  public void generateSchema(SchemaOutputResolver p0) { }

  public static JAXBContext newInstance(Class... p0) { return null; }

  public static JAXBContext newInstance(Class<?>[] p0, Map<String,?> p1) { return null; }

  public static JAXBContext newInstance(String p0) { return null; }

  public static JAXBContext newInstance(String p0, ClassLoader p1) { return null; }

  public static JAXBContext newInstance(String p0, ClassLoader p1, Map<String,?> p2) { return null; }
}
