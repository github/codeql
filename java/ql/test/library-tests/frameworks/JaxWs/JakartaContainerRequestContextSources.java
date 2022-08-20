import jakarta.ws.rs.container.ContainerRequestContext;

public class JakartaContainerRequestContextSources {
  void sink(Object o) {}

  void test(ContainerRequestContext context) throws Exception {
    sink(context.getAcceptableLanguages()); // $ hasValueFlow
    sink(context.getAcceptableMediaTypes().get(0).getType()); // $ hasTaintFlow
    sink(context.getCookies().get("someKey").getValue()); // $ hasTaintFlow
    byte[] buf = new byte[1024];
    context.getEntityStream().read(buf);
    sink(buf); // $ hasTaintFlow
    sink(context.getHeaders().getFirst("someKey")); // $ hasTaintFlow
    sink(context.getHeaderString("someKey")); // $ hasValueFlow
    sink(context.getLanguage()); // $ hasValueFlow
    sink(context.getMediaType().getType()); // $ hasTaintFlow
    sink(context.getUriInfo().getPath()); // $ hasTaintFlow
  }
}