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

// This is not a resource class because it doesn't have a @Path annotation.
// Note that inheritance of class or interface annotations is not supported in
// JAX-RS.
public class JaxRs4 implements JaxRsInterface {
  public JaxRs4() {
  }

  @Override
  public int Get() { // $ ResourceMethod
    return 1;
  }

  @Override
  public void Post() { // $ ResourceMethod
  }

  @Produces("application/json") // $ ProducesAnnotation=application/json
  @Override
  public double Delete() { // not a resource method because it has a jax-rs annotation, so it doesn't inherit any jax-rs annotations
    return 1.0;
  }

  @Produces(MediaType.TEXT_HTML) // $ ProducesAnnotation=text/html
  @Override
  public void Put() { // not a resource method because it has a jax-rs annotation, so it doesn't inherit any jax-rs annotations
  }

  @Override
  public void Options() { // $ ResourceMethod
  }

  @Override
  public void Head() { // $ ResourceMethod
  }


  @Path("")
  NonRootResourceClass subResourceLocator() {
    return null;
  }

  public class NonRootResourceClass {
    @GET
    int Get() { // $ ResourceMethod
      return 0;
    }

    @Produces("text/html") // $ ProducesAnnotation=text/html
    @POST
    boolean Post() { // $ ResourceMethod=text/html
      return false;
    }

    @Produces(MediaType.TEXT_PLAIN) // $ ProducesAnnotation=text/plain
    @DELETE
    double Delete() { // $ ResourceMethod=text/plain
      return 0.0;
    }

    @Path("")
    AnotherNonRootResourceClass subResourceLocator1() { // $ SubResourceLocator
      return null;
    }

    @GET
    @Path("")
    NotAResourceClass1 NotASubResourceLocator1() { // $ ResourceMethod
      return null; //
    }

    @GET
    NotAResourceClass2 NotASubResourceLocator2() { // $ ResourceMethod
      return null; //
    }

    NotAResourceClass2 NotASubResourceLocator3() {
      return null;
    }
  }
}
