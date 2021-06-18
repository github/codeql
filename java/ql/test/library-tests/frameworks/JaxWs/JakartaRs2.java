import java.io.InputStream;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.PUT;
import jakarta.ws.rs.OPTIONS;
import jakarta.ws.rs.HEAD;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.BeanParam;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.CookieParam;
import jakarta.ws.rs.FormParam;
import jakarta.ws.rs.HeaderParam;
import jakarta.ws.rs.MatrixParam;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.MultivaluedMap;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.MessageBodyReader;

@Path("")
class JakartaRs2 { // $ RootResourceClass
  JakartaRs2() {
  }

  public JakartaRs2(// $ InjectableConstructor
      @BeanParam int beanParam, // $ InjectionAnnotation
      @CookieParam("") int cookieParam, // $ InjectionAnnotation
      @FormParam("") int formParam, // $ InjectionAnnotation
      @HeaderParam("") int headerParam, // $ InjectionAnnotation
      @MatrixParam("") int matrixParam, // $ InjectionAnnotation
      @PathParam("") int pathParam, // $ InjectionAnnotation
      @QueryParam("") int queryParam, // $ InjectionAnnotation
      @Context int context) { // $ InjectionAnnotation
  }

  public JakartaRs2(@BeanParam int beanParam, // $ InjectionAnnotation
      @CookieParam("") int cookieParam, // $ InjectionAnnotation
      @FormParam("") int formParam, // $ InjectionAnnotation
      @HeaderParam("") int headerParam, // $ InjectionAnnotation
      @MatrixParam("") int matrixParam, // $ InjectionAnnotation
      @PathParam("") int pathParam, // $ InjectionAnnotation
      @QueryParam("") int queryParam, // $ InjectionAnnotation
      @Context int context, // $ InjectionAnnotation
      int paramWithoutAnnotation) {
  }

  @BeanParam // $ InjectionAnnotation
  int beanField; // $ InjectableField
  @CookieParam("") // $ InjectionAnnotation
  int cookieField; // $ InjectableField
  @FormParam("") // $ InjectionAnnotation
  int formField; // $ InjectableField
  @HeaderParam("") // $ InjectionAnnotation
  int headerField; // $ InjectableField
  @MatrixParam("") // $ InjectionAnnotation
  int matrixField; // $ InjectableField
  @PathParam("") // $ InjectionAnnotation
  int pathField; // $ InjectableField
  @QueryParam("") // $ InjectionAnnotation
  int queryField; // $ InjectableField
  @Context // $ InjectionAnnotation
  int context; // $ InjectableField
  int fieldWithoutAnnotation;
}

class CustomUnmarshallerJakarta implements MessageBodyReader {

  @Override
  public boolean isReadable(Class aClass, Type type, Annotation[] annotations, MediaType mediaType) {
    return true;
  }


  @Override
  public Object readFrom(Class aClass, Type type, Annotation[] annotations, MediaType mediaType, MultivaluedMap multivaluedMap, InputStream inputStream) {
    return null;
  }
}

class MiscellaneousJakarta {
  @Consumes("") // $ ConsumesAnnotation
  public static void miscellaneousJakarta() throws IOException {
    Response.ResponseBuilder responseBuilder = Response.accepted(); // $ ResponseBuilderDeclaration
    Response response = responseBuilder.build(); // $ ResponseDeclaration
    Client client; // $ ClientDeclaration
    MessageBodyReader<String> messageBodyReader = null; // $ MessageBodyReaderDeclaration
    messageBodyReader.readFrom(null, null, null, null, null, null); // $ MessageBodyReaderReadFromCall MessageBodyReaderReadCall
    CustomUnmarshallerJakarta CustomUnmarshallerJakarta = null;
    CustomUnmarshallerJakarta.readFrom(null, null, null, null, null, null); // $ MessageBodyReaderReadCall
  }
}