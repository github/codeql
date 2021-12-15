import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Variant;

import java.util.Locale;

@Path("")
public class JaxXSS {

  @GET
  public static Response specificContentType(boolean safeContentType, boolean chainDirectly, boolean contentTypeFirst, String userControlled) {

    Response.ResponseBuilder builder = Response.ok();

    if(!safeContentType) {
      if(chainDirectly) {
        if(contentTypeFirst)
          return builder.type(MediaType.TEXT_HTML).entity(userControlled).build(); // $xss
        else
          return builder.entity(userControlled).type(MediaType.TEXT_HTML).build(); // $xss
      }
      else {
        if(contentTypeFirst) {
          Response.ResponseBuilder builder2 = builder.type(MediaType.TEXT_HTML);
          return builder2.entity(userControlled).build(); // $xss
        }
        else {
          Response.ResponseBuilder builder2 = builder.entity(userControlled);
          return builder2.type(MediaType.TEXT_HTML).build(); // $xss
        }
      }
    }
    else {
      if(chainDirectly) {
        if(contentTypeFirst)
          return builder.type(MediaType.APPLICATION_JSON).entity(userControlled).build();
        else
          return builder.entity(userControlled).type(MediaType.APPLICATION_JSON).build();
      }
      else {
        if(contentTypeFirst) {
          Response.ResponseBuilder builder2 = builder.type(MediaType.APPLICATION_JSON);
          return builder2.entity(userControlled).build();
        }
        else {
          Response.ResponseBuilder builder2 = builder.entity(userControlled);
          return builder2.type(MediaType.APPLICATION_JSON).build();
        }
      }
    }

  }

  @GET
  public static Response specificContentTypeSetterMethods(int route, boolean safeContentType, String userControlled) {

    // Test the remarkably many routes to setting a content-type in Jax-RS, besides the ResponseBuilder.entity method used above:

    if(safeContentType) {
      if(route == 0) {
        // via ok, as a string literal:
        return Response.ok(userControlled, "application/json").build();
      }
      else if(route == 1) {
        // via ok, as a string constant:
        return Response.ok(userControlled, MediaType.APPLICATION_JSON).build();
      }
      else if(route == 2) {
        // via ok, as a MediaType constant:
        return Response.ok(userControlled, MediaType.APPLICATION_JSON_TYPE).build();
      }
      else if(route == 3) {
        // via ok, as a Variant, via constructor:
        return Response.ok(userControlled, new Variant(MediaType.APPLICATION_JSON_TYPE, "language", "encoding")).build();
      }
      else if(route == 4) {
        // via ok, as a Variant, via static method:
        return Response.ok(userControlled, Variant.mediaTypes(MediaType.APPLICATION_JSON_TYPE).build().get(0)).build();
      }
      else if(route == -4) {
        // via ok, as a Variant, via static method (testing multiple media types):
        return Response.ok(userControlled, Variant.mediaTypes(MediaType.APPLICATION_JSON_TYPE, MediaType.APPLICATION_OCTET_STREAM_TYPE).build().get(0)).build();
      }
      else if(route == 5) {
        // via ok, as a Variant, via instance method:
        return Response.ok(userControlled, Variant.languages(Locale.UK).mediaTypes(MediaType.APPLICATION_JSON_TYPE).build().get(0)).build();
      }
      else if(route == 6) {
        // via builder variant, before entity:
        return Response.ok().variant(new Variant(MediaType.APPLICATION_JSON_TYPE, "language", "encoding")).entity(userControlled).build();
      }
      else if(route == 7) {
        // via builder variant, after entity:
        return Response.ok().entity(userControlled).variant(new Variant(MediaType.APPLICATION_JSON_TYPE, "language", "encoding")).build();
      }
      else if(route == 8) {
        // provide entity via ok, then content-type via builder:
        return Response.ok(userControlled).type(MediaType.APPLICATION_JSON_TYPE).build();
      }
    }
    else {
      if(route == 0) {
        // via ok, as a string literal:
        return Response.ok("text/html").entity(userControlled).build(); // $xss
      }
      else if(route == 1) {
        // via ok, as a string constant:
        return Response.ok(MediaType.TEXT_HTML).entity(userControlled).build(); // $xss
      }
      else if(route == 2) {
        // via ok, as a MediaType constant:
        return Response.ok(MediaType.TEXT_HTML_TYPE).entity(userControlled).build(); // $xss
      }
      else if(route == 3) {
        // via ok, as a Variant, via constructor:
        return Response.ok(new Variant(MediaType.TEXT_HTML_TYPE, "language", "encoding")).entity(userControlled).build(); // $xss
      }
      else if(route == 4) {
        // via ok, as a Variant, via static method:
        return Response.ok(Variant.mediaTypes(MediaType.TEXT_HTML_TYPE).build()).entity(userControlled).build(); // $xss
      }
      else if(route == 5) {
        // via ok, as a Variant, via instance method:
        return Response.ok(Variant.languages(Locale.UK).mediaTypes(MediaType.TEXT_HTML_TYPE).build()).entity(userControlled).build(); // $xss
      }
      else if(route == 6) {
        // via builder variant, before entity:
        return Response.ok().variant(new Variant(MediaType.TEXT_HTML_TYPE, "language", "encoding")).entity(userControlled).build(); // $xss
      }
      else if(route == 7) {
        // via builder variant, after entity:
        return Response.ok().entity(userControlled).variant(new Variant(MediaType.TEXT_HTML_TYPE, "language", "encoding")).build(); // $xss
      }
      else if(route == 8) {
        // provide entity via ok, then content-type via builder:
        return Response.ok(userControlled).type(MediaType.TEXT_HTML_TYPE).build(); // $xss
      }
    }

    return null;

  }

  @GET @Produces(MediaType.APPLICATION_JSON)
  public static Response methodContentTypeSafe(String userControlled) {
    return Response.ok(userControlled).build();
  }

  @POST @Produces(MediaType.APPLICATION_JSON)
  public static Response methodContentTypeSafePost(String userControlled) {
    return Response.ok(userControlled).build();
  }

  @GET @Produces("application/json")
  public static Response methodContentTypeSafeStringLiteral(String userControlled) {
    return Response.ok(userControlled).build();
  }

  @GET @Produces(MediaType.TEXT_HTML)
  public static Response methodContentTypeUnsafe(String userControlled) {
    return Response.ok(userControlled).build(); // $xss
  }

  @POST @Produces(MediaType.TEXT_HTML)
  public static Response methodContentTypeUnsafePost(String userControlled) {
    return Response.ok(userControlled).build(); // $xss
  }

  @GET @Produces("text/html")
  public static Response methodContentTypeUnsafeStringLiteral(String userControlled) {
    return Response.ok(userControlled).build(); // $xss
  }

  @GET @Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_JSON})
  public static Response methodContentTypeMaybeSafe(String userControlled) {
    return Response.ok(userControlled).build(); // $xss
  }

  @GET @Produces(MediaType.APPLICATION_JSON)
  public static Response methodContentTypeSafeOverriddenWithUnsafe(String userControlled) {
    return Response.ok().type(MediaType.TEXT_HTML).entity(userControlled).build(); // $xss
  }

  @GET @Produces(MediaType.TEXT_HTML)
  public static Response methodContentTypeUnsafeOverriddenWithSafe(String userControlled) {
    return Response.ok().type(MediaType.APPLICATION_JSON).entity(userControlled).build();
  }

  @Path("/abc")
  @Produces({"application/json"})
  public static class ClassContentTypeSafe {
    @GET
    public Response test(String userControlled) {
      return Response.ok(userControlled).build();
    }

    @GET
    public String testDirectReturn(String userControlled) {
      return userControlled;
    }

    @GET @Produces({"text/html"})
    public Response overridesWithUnsafe(String userControlled) {
      return Response.ok(userControlled).build(); // $xss
    }

    @GET
    public Response overridesWithUnsafe2(String userControlled) {
      return Response.ok().type(MediaType.TEXT_HTML).entity(userControlled).build(); // $xss
    }
  }

  @Path("/abc")
  @Produces({"text/html"})
  public static class ClassContentTypeUnsafe {
    @GET
    public Response test(String userControlled) {
      return Response.ok(userControlled).build(); // $xss
    }

    @GET
    public String testDirectReturn(String userControlled) {
      return userControlled; // $xss
    }

    @GET @Produces({"application/json"})
    public Response overridesWithSafe(String userControlled) {
      return Response.ok(userControlled).build();
    }

    @GET
    public Response overridesWithSafe2(String userControlled) {
      return Response.ok().type(MediaType.APPLICATION_JSON).entity(userControlled).build();
    }
  }

  @GET
  public static Response entityWithNoMediaType(String userControlled) {
    return Response.ok(userControlled).build(); // $xss
  }

  @GET
  public static String stringWithNoMediaType(String userControlled) {
    return userControlled; // $xss
  }

}