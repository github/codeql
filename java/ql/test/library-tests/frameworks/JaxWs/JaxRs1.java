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
import javax.ws.rs.CookieParam;
import javax.ws.rs.FormParam;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.MatrixParam;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.client.Client;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.MessageBodyReader;

@Path("")
public class JaxRs1 { // $ RootResourceClass
  public JaxRs1() { // $ InjectableConstructor
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
  NonRootResourceClass subResourceLocator() { // $ SubResourceLocator
    return null;
  }

  public class NonRootResourceClass { // $ NonRootResourceClass
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
    AnotherNonRootResourceClass subResourceLocator1() { // $ SubResourceLocator
      return null;
    }

    @GET
    @Path("")
    NotAResourceClass1 NotASubResourceLocator1() { // $ ResourceMethod ResourceMethodOnResourceClass
      return null; // $ XssSink
    }

    @GET
    NotAResourceClass2 NotASubResourceLocator2() { // $ ResourceMethod ResourceMethodOnResourceClass
      return null; // $ XssSink
    }

    NotAResourceClass2 NotASubResourceLocator3() {
      return null;
    }
  }
}

class AnotherNonRootResourceClass { // $ NonRootResourceClass
  public AnotherNonRootResourceClass() {
  }

  public AnotherNonRootResourceClass(
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
  public void resourceMethodWithBeanParamParameter(@BeanParam Foo foo) { // $ SubResourceLocator InjectionAnnotation
  }
}

class Foo {
  Foo() { // $ BeanParamConstructor
  }

  public Foo( // $ BeanParamConstructor
      @BeanParam int beanParam, // $ InjectionAnnotation
      @CookieParam("") int cookieParam, // $ InjectionAnnotation
      @FormParam("") int formParam, // $ InjectionAnnotation
      @HeaderParam("") int headerParam, // $ InjectionAnnotation
      @MatrixParam("") int matrixParam, // $ InjectionAnnotation
      @PathParam("") int pathParam, // $ InjectionAnnotation
      @QueryParam("") int queryParam, // $ InjectionAnnotation
      @Context int context) { // $ InjectionAnnotation
  }

  public Foo(
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

class NotAResourceClass1 {
}

class NotAResourceClass2 {
}

class ExtendsJaxRs1 extends JaxRs1 { // $ RootResourceClass
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
class ExtendsJaxRs1WithProducesAnnotation extends JaxRs1 { // Not a root resource class because it has a JAX-RS annotation
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
