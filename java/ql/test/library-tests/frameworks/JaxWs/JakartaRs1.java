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
import jakarta.ws.rs.CookieParam;
import jakarta.ws.rs.FormParam;
import jakarta.ws.rs.HeaderParam;
import jakarta.ws.rs.MatrixParam;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.MultivaluedMap;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.MessageBodyReader;

@Path("")
public class JakartaRs1 { // $ RootResourceClass
  public JakartaRs1() { // $ InjectableConstructor
  }

  @GET
  int Get() { // $ ResourceMethod ResourceMethodOnResourceClass
    return 0; // $ XssSink
  }

  @POST
  void Post() { // $ ResourceMethod ResourceMethodOnResourceClass
  }

  @Produces("text/plain") // $ ProducesAnnotation=text/plain
  @DELETE
  double Delete() { // $ ResourceMethod=text/plain ResourceMethodOnResourceClass
    return 0.0;
  }

  @Produces(MediaType.TEXT_HTML) // $ ProducesAnnotation=text/html
  @PUT
  void Put() { // $ ResourceMethod=text/html ResourceMethodOnResourceClass
  }

  @OPTIONS
  void Options() { // $ ResourceMethod ResourceMethodOnResourceClass
  }

  @HEAD
  void Head() { // $ ResourceMethod ResourceMethodOnResourceClass
  }

  @Path("")
  NonRootResourceClassJakarta subResourceLocator() { // $ SubResourceLocator
    return null;
  }

  public class NonRootResourceClassJakarta { // $ NonRootResourceClass
    @GET
    int Get() { // $ ResourceMethod ResourceMethodOnResourceClass
      return 0; // $ XssSink
    }

    @Produces("text/html") // $ ProducesAnnotation=text/html
    @POST
    boolean Post() { // $ ResourceMethod=text/html ResourceMethodOnResourceClass
      return false; // $ XssSink
    }

    @Produces(MediaType.TEXT_PLAIN) // $ ProducesAnnotation=text/plain
    @DELETE
    double Delete() { // $ ResourceMethod=text/plain ResourceMethodOnResourceClass
      return 0.0;
    }

    @Path("")
    AnotherNonRootResourceClassJakarta subResourceLocator1() { // $ SubResourceLocator
      return null;
    }

    @GET
    @Path("")
    NotAResourceClass1Jakarta NotASubResourceLocator1() { // $ ResourceMethod ResourceMethodOnResourceClass
      return null; // $ XssSink
    }

    @GET
    NotAResourceClass2Jakarta NotASubResourceLocator2() { // $ ResourceMethod ResourceMethodOnResourceClass
      return null; // $ XssSink
    }

    NotAResourceClass2Jakarta NotASubResourceLocator3() {
      return null;
    }
  }
}

class AnotherNonRootResourceClassJakarta { // $ NonRootResourceClass
  public AnotherNonRootResourceClassJakarta() {
  }

  public AnotherNonRootResourceClassJakarta(
      @BeanParam int beanParam, // $ InjectionAnnotation
      @CookieParam("") int cookieParam, // $ InjectionAnnotation
      @FormParam("") int formParam, // $ InjectionAnnotation
      @HeaderParam("") int headerParam, // $ InjectionAnnotation
      @MatrixParam("") int matrixParam, // $ InjectionAnnotation
      @PathParam("") int pathParam, // $ InjectionAnnotation
      @QueryParam("") int queryParam, // $ InjectionAnnotation
      @Context int context) { // $ InjectionAnnotation
  }

  @Path("")
  public void resourceMethodWithBeanParamParameter(@BeanParam FooJakarta FooJakarta) { // $ SubResourceLocator InjectionAnnotation
  }
}

class FooJakarta {
  FooJakarta() { // $ BeanParamConstructor
  }

  public FooJakarta( // $ BeanParamConstructor
      @BeanParam int beanParam, // $ InjectionAnnotation
      @CookieParam("") int cookieParam, // $ InjectionAnnotation
      @FormParam("") int formParam, // $ InjectionAnnotation
      @HeaderParam("") int headerParam, // $ InjectionAnnotation
      @MatrixParam("") int matrixParam, // $ InjectionAnnotation
      @PathParam("") int pathParam, // $ InjectionAnnotation
      @QueryParam("") int queryParam, // $ InjectionAnnotation
      @Context int context) { // $ InjectionAnnotation
  }

  public FooJakarta(
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
}

class NotAResourceClass1Jakarta {
}

class NotAResourceClass2Jakarta {
}

class ExtendsJakartaRs1 extends JakartaRs1 { // $ RootResourceClass
  @Override
  int Get() { // $ ResourceMethod
    return 1;
  }

  @Override
  @QueryParam("") // $ InjectionAnnotation
  void Post() {
  }

  @Override
  double Delete() { // $ ResourceMethod=text/plain
    return 1.0;
  }

  @Override
  void Put() { // $ ResourceMethod=text/html
  }

  @Produces("application/json") // $ ProducesAnnotation=application/json
  @Override
  void Options() {
  }

  @Produces(MediaType.TEXT_XML) // $ ProducesAnnotation=text/xml
  @Override
  void Head() {
  }

}

@Produces(MediaType.TEXT_XML) // $ ProducesAnnotation=text/xml
class ExtendsJakartaRs1WithProducesAnnotation extends JakartaRs1 { // Not a root resource class because it has a JAX-RS annotation
  @Override
  int Get() { // $ ResourceMethod=text/xml
    return 2;
  }

  @Override
  @QueryParam("") // $ InjectionAnnotation
  void Post() {
  }

  @Override
  double Delete() { // $ ResourceMethod=text/plain
    return 2.0;
  }

  @Override
  void Put() { // $ ResourceMethod=text/html
  }

  @Override
  void Options() { // $ ResourceMethod=text/xml
  }
}
