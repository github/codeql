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

class ExtendsJakartaRs3 extends JakartaRs3 { // $ RootResourceClass
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
class ExtendsJakartaRs3WithProducesAnnotation extends JakartaRs3 { // Not a root resource class because it has a JAX-RS annotation
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
public class JakartaRs3 implements JakartaRsInterface { // $ RootResourceClass
  public JakartaRs3() { // $ InjectableConstructor
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
