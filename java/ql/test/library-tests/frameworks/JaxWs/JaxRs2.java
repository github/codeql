import java.io.InputStream;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.DELETE;
import javax.ws.rs.PUT;
import javax.ws.rs.OPTIONS;
import javax.ws.rs.HEAD;
import javax.ws.rs.Path;
import javax.ws.rs.BeanParam;
import javax.ws.rs.Consumes;
import javax.ws.rs.CookieParam;
import javax.ws.rs.FormParam;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.MatrixParam;
import javax.ws.rs.PathParam;
import javax.ws.rs.QueryParam;
import javax.ws.rs.client.Client;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.MessageBodyReader;

@Path("")
class JaxRs2 { // $ RootResourceClass
  JaxRs2() {
  }

  public JaxRs2(// $ InjectableConstructor
      @BeanParam int beanParam, // $ InjectionAnnotation
      @CookieParam("") int cookieParam, // $ InjectionAnnotation
      @FormParam("") int formParam, // $ InjectionAnnotation
      @HeaderParam("") int headerParam, // $ InjectionAnnotation
      @MatrixParam("") int matrixParam, // $ InjectionAnnotation
      @PathParam("") int pathParam, // $ InjectionAnnotation
      @QueryParam("") int queryParam, // $ InjectionAnnotation
      @Context int context) { // $ InjectionAnnotation
  }

  public JaxRs2(
      @BeanParam int beanParam, // $ InjectionAnnotation
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

class CustomUnmarshaller implements MessageBodyReader {

  @Override
  public boolean isReadable(Class aClass, Type type, Annotation[] annotations, MediaType mediaType) {
    return true;
  }


  @Override
  public Object readFrom(Class aClass, Type type, Annotation[] annotations, MediaType mediaType, MultivaluedMap multivaluedMap, InputStream inputStream) {
    return null;
  }
}

class Miscellaneous {
  @Consumes("") // $ ConsumesAnnotation
  public static void miscellaneous() throws IOException {
    Response.ResponseBuilder responseBuilder = Response.accepted(); // $ ResponseBuilderDeclaration
    Response response = responseBuilder.build(); // $ ResponseDeclaration
    Client client; // $ ClientDeclaration
    MessageBodyReader<String> messageBodyReader = null; // $ MessageBodyReaderDeclaration
    messageBodyReader.readFrom(null, null, null, null, null, null); // $ MessageBodyReaderReadFromCall MessageBodyReaderReadCall
    CustomUnmarshaller customUnmarshaller = null;
    customUnmarshaller.readFrom(null, null, null, null, null, null); // $ MessageBodyReaderReadCall
  }
}