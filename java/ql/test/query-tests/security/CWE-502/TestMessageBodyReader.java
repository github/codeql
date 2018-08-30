import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;
import javax.ws.rs.ext.MessageBodyReader;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;


public class TestMessageBodyReader implements MessageBodyReader<Object> {

  @Override
  public boolean isReadable(Class<?> type, Type genericType, Annotation[] annotations, MediaType mediaType) {
      return false;
  }

  @Override
  public Object readFrom(Class<Object> type, Type genericType, Annotation[] annotations, MediaType mediaType,
          MultivaluedMap<String, String> httpHeaders, InputStream entityStream) throws IOException {
      try {
          return new ObjectInputStream(entityStream).readObject();
      } catch (ClassNotFoundException e) {
          e.printStackTrace();
      }
      return null;
  }
}