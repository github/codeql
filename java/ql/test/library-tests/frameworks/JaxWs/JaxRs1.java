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
public class JaxRs1 { // $RootResourceClass
  public JaxRs1() { // $InjectableConstructor
  }

  @GET
  void Get() { // $ResourceMethod $ResourceMethodOnResourceClass
  }

  @POST
  void Post() { // $ResourceMethod $ResourceMethodOnResourceClass
  }

  @Produces("text/plain") // $ProducesAnnotation=text/plain
  @DELETE
  void Delete() { // $ResourceMethod=text/plain $ResourceMethodOnResourceClass
  }

  @Produces(MediaType.TEXT_HTML) // $ProducesAnnotation=text/html
  @PUT
  void Put() { // $ResourceMethod=text/html $ResourceMethodOnResourceClass
  }

  @OPTIONS
  void Options() { // $ResourceMethod $ResourceMethodOnResourceClass
  }

  @HEAD
  void Head() { // $ResourceMethod $ResourceMethodOnResourceClass
  }

  @Path("")
  NonRootResourceClass subResourceLocator() { // $SubResourceLocator
    return null;
  }
}

class NonRootResourceClass { // $NonRootResourceClass
  @Path("")
  AnotherNonRootResourceClass subResourceLocator1() { // $SubResourceLocator
    return null;
  }

  @GET
  @Path("")
  NotAResourceClass1 NotASubResourceLocator1() { // $ResourceMethod
    return null;
  }

  @GET
  NotAResourceClass2 NotASubResourceLocator2() { // $ResourceMethod
    return null;
  }

  NotAResourceClass2 NotASubResourceLocator3() {
    return null;
  }
}

class AnotherNonRootResourceClass { // $NonRootResourceClass
  public AnotherNonRootResourceClass() {
  }

  public AnotherNonRootResourceClass(@BeanParam int beanParam, @CookieParam("") int cookieParam, @FormParam("") int formParam, // $InjectionAnnotation
      @HeaderParam("") int headerParam, @MatrixParam("") int matrixParam, @PathParam("") int pathParam, @QueryParam("") int queryParam, // $InjectionAnnotation
      @Context int context) { // $InjectionAnnotation
  }

  @Path("")
  public void resourceMethodWithBeanParamParameter(@BeanParam Foo foo) { // $SubResourceLocator $InjectionAnnotation
  }
}

class Foo {
  Foo() { // $BeanParamConstructor
  }

  public Foo(@BeanParam int beanParam, @CookieParam("") int cookieParam, @FormParam("") int formParam, // $InjectionAnnotation $BeanParamConstructor
      @HeaderParam("") int headerParam, @MatrixParam("") int matrixParam, @PathParam("") int pathParam, @QueryParam("") int queryParam, // $InjectionAnnotation
      @Context int context) { // $InjectionAnnotation
  }

  public Foo(@BeanParam int beanParam, @CookieParam("") int cookieParam, @FormParam("") int formParam, // $InjectionAnnotation
      @HeaderParam("") int headerParam, @MatrixParam("") int matrixParam, @PathParam("") int pathParam, @QueryParam("") int queryParam, // $InjectionAnnotation
      @Context int context, int paramWithoutAnnotation) { // $InjectionAnnotation
  }
}

class NotAResourceClass1 {
}

class NotAResourceClass2 {
}

class ExtendsJaxRs1 extends JaxRs1 {
  @Override
  void Get() { // $ResourceMethod
  }
  
  @Override
  @QueryParam("") // $InjectionAnnotation
  void Post() {
  }

  @Override
  void Delete() { // $ResourceMethod=text/plain
  }

  @Override
  void Put() { // $ResourceMethod=text/html
  }

  @Produces("application/json") // $ProducesAnnotation=application/json
  @Override
  void Options() {
  }

  @Produces(MediaType.TEXT_XML) // $ProducesAnnotation=text/xml
  @Override
  void Head() {
  }

}

@Produces(MediaType.TEXT_XML) // $ProducesAnnotation=text/xml
class ExtendsJaxRs1WithProducesAnnotation extends JaxRs1 {
  @Override
  void Get() { // $ResourceMethod=text/xml
  }
  
  @Override
  @QueryParam("") // $InjectionAnnotation
  void Post() {
  }

  @Override
  void Delete() { // $ResourceMethod=text/plain
  }

  @Override
  void Put() { // $ResourceMethod=text/html
  }

  @Override
  void Options() { // $ResourceMethod=text/xml
  }
}