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

class ExtendsJaxRs3 extends JaxRs3 { // $ RootResourceClass
  @Override
  public int Get() { // $ ResourceMethod
    return 1;
  }

  @Override
  public @QueryParam("") // $ InjectionAnnotation
  void Post() {
  }

  @Override
  public double Delete() { // $ ResourceMethod=application/json
    return 1.0;
  }

  @Override
  public void Put() { // $ ResourceMethod=text/html
  }

  @Produces("application/json") // $ ProducesAnnotation=application/json
  @Override
  public void Options() { // not a resource method because it has a jax-rs annotation, so it doesn't inherit any jax-rs annotations
  }

  @Produces(MediaType.TEXT_XML) // $ ProducesAnnotation=text/xml
  @Override
  public void Head() { // not a resource method because it has a jax-rs annotation, so it doesn't inherit any jax-rs annotations
  }

}

@Produces(MediaType.TEXT_XML) // $ ProducesAnnotation=text/xml
class ExtendsJaxRs3WithProducesAnnotation extends JaxRs3 { // Not a root resource class because it has a JAX-RS annotation
  @Override
  public int Get() { // $ ResourceMethod=text/xml
    return 2;
  }

  @Override
  public @QueryParam("") // $ InjectionAnnotation
  void Post() {
  }

  @Override
  public double Delete() { // $ ResourceMethod=application/json
    return 2.0;
  }

  @Override
  public void Put() { // $ ResourceMethod=text/html
  }

  @Override
  public void Options() { // $ ResourceMethod=text/xml
  }
}

@Path("")
public class JaxRs3 implements JaxRsInterface { // $ RootResourceClass
  public JaxRs3() { // $ InjectableConstructor
  }

  @Override
  public int Get() { // $ ResourceMethod ResourceMethodOnResourceClass
    return 1; // $ XssSink
  }

  @Override
  public void Post() { // $ ResourceMethod ResourceMethodOnResourceClass
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
  public void Options() { // $ ResourceMethod ResourceMethodOnResourceClass
  }

  @Override
  public void Head() { // $ ResourceMethod ResourceMethodOnResourceClass
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
