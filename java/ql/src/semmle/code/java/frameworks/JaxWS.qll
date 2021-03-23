import java
private import semmle.code.java.dataflow.ExternalFlow

string getAJaxWsPackage() { result in ["javax.ws.rs", "jakarta.ws.rs"] }

bindingset[subpackage]
string getAJaxWsPackage(string subpackage) { result = getAJaxWsPackage() + "." + subpackage }

/**
 * A JAX WS endpoint is constructed by the container, and its methods
 * are -- where annotated -- called remotely.
 */
class JaxWsEndpoint extends Class {
  JaxWsEndpoint() {
    exists(AnnotationType a | a = this.getAnAnnotation().getType() |
      a.hasName("WebService") or
      a.hasName("WebServiceProvider") or
      a.hasName("WebServiceClient")
    )
  }

  Callable getARemoteMethod() {
    result = this.getACallable() and
    exists(AnnotationType a | a = result.getAnAnnotation().getType() |
      a.hasName("WebMethod") or
      a.hasName("WebEndpoint")
    )
  }
}

/**
 * Holds if the annotatable has the JaxRs `@Path` annotation.
 */
private predicate hasPathAnnotation(Annotatable annotatable) {
  exists(AnnotationType a |
    a = annotatable.getAnAnnotation().getType() and
    a.getPackage().getName() = getAJaxWsPackage()
  |
    a.hasName("Path")
  )
}

/**
 * A method which is annotated with one or more JaxRS resource type annotations e.g. `@GET`, `@POST` etc.
 */
class JaxRsResourceMethod extends Method {
  JaxRsResourceMethod() {
    exists(AnnotationType a |
      a = this.getAnAnnotation().getType() and
      a.getPackage().getName() = getAJaxWsPackage()
    |
      a.hasName("GET") or
      a.hasName("POST") or
      a.hasName("DELETE") or
      a.hasName("PUT") or
      a.hasName("OPTIONS") or
      a.hasName("HEAD")
    )
    or
    // A JaxRS resource method can also inherit these annotations from a supertype, but only if
    // there are no JaxRS annotations on the method itself
    getAnOverride() instanceof JaxRsResourceMethod and
    not exists(getAnAnnotation().(JaxRSAnnotation))
  }

  /** Gets an `@Produces` annotation that applies to this method */
  JaxRSProducesAnnotation getProducesAnnotation() {
    result = getAnAnnotation()
    or
    // No direct annotations
    not exists(getAnAnnotation().(JaxRSProducesAnnotation)) and
    (
      // Annotations on a method we've overridden
      result = getAnOverride().getAnAnnotation()
      or
      // No annotations on this method, or a method we've overridden, so look to the class
      not exists(getAnOverride().getAnAnnotation().(JaxRSProducesAnnotation)) and
      result = getDeclaringType().getAnAnnotation()
    )
  }
}

/**
 * A JaxRs resource class, annotated with `@Path` or referred to from a sub-resource locator on
 * another resource class.
 *
 * This class contains resource methods, which are executed in response to requests.
 */
class JaxRsResourceClass extends Class {
  JaxRsResourceClass() {
    // A root resource class has a @Path annotation on the class.
    hasPathAnnotation(this)
    or
    // A sub-resource
    exists(JaxRsResourceClass resourceClass, Method method |
      // This is a sub-resource class is if it is referred to from the sub-resource locator of
      // another resource class.
      method = resourceClass.getASubResourceLocator()
    |
      this = method.getReturnType()
    )
  }

  /**
   * Gets a resource method on this resource class.
   *
   * Resource methods may be executed in response to web requests which match the `@Path`
   * annotations leading to this resource method.
   */
  JaxRsResourceMethod getAResourceMethod() {
    isPublic() and
    result = this.getACallable()
  }

  /**
   * Gets a "sub-resource locator" on this resource class, which is a method annotated with `@Path`,
   * but is not a resource method e.g. it is not annotated with `@GET` etc.
   */
  Callable getASubResourceLocator() {
    result = getAMethod() and
    not result instanceof JaxRsResourceMethod and
    hasPathAnnotation(result)
  }

  /**
   * Holds if this class is a "root resource" class
   */
  predicate isRootResource() { hasPathAnnotation(this) }

  /**
   * Gets a `Constructor` that may be called by a JaxRS container to construct this class reflectively.
   *
   * This only considers which constructors adhere to the rules for injectable constructors. In the
   * case of multiple matching constructors, the container will choose the constructor with the most
   * matching parameters, but this is not modeled, because it may take into account runtime aspects
   * (existence of particular parameters).
   */
  Constructor getAnInjectableConstructor() {
    result = getAConstructor() and
    // JaxRs Spec v2.0 - 3.12
    // Only root resources are constructed by the JaxRS container.
    isRootResource() and
    // JaxRS can only construct the class using constructors that are public, and where the
    // container can provide all of the parameters. This includes the no-arg constructor.
    result.isPublic() and
    forall(Parameter p | p = result.getAParameter() |
      p.getAnAnnotation() instanceof JaxRsInjectionAnnotation
    )
  }

  /**
   * Gets a Callable that may be executed by the JaxRs container, injecting parameters as required.
   */
  Callable getAnInjectableCallable() {
    result = getAResourceMethod() or
    result = getAnInjectableConstructor() or
    result = getASubResourceLocator()
  }

  /**
   * Gets a Field that may be injected with a value by the JaxRs container.
   */
  Field getAnInjectableField() {
    result = getAField() and
    result.getAnAnnotation() instanceof JaxRsInjectionAnnotation
  }
}

/** An annotation from the `javax.ws.rs` package hierarchy. */
class JaxRSAnnotation extends Annotation {
  JaxRSAnnotation() {
    exists(AnnotationType a |
      a = getType() and
      a.getPackage().getName().regexpMatch("javax\\.ws\\.rs(\\..*)?")
    )
  }
}

/**
 * An annotation that is used by JaxRS containers to determine a value to inject into the annotated
 * element.
 */
class JaxRsInjectionAnnotation extends JaxRSAnnotation {
  JaxRsInjectionAnnotation() {
    exists(AnnotationType a |
      a = getType() and
      a.getPackage().getName() = getAJaxWsPackage()
    |
      a.hasName("BeanParam") or
      a.hasName("CookieParam") or
      a.hasName("FormParam") or
      a.hasName("HeaderParam") or
      a.hasName("MatrixParam") or
      a.hasName("PathParam") or
      a.hasName("QueryParam")
    )
    or
    getType().hasQualifiedName(getAJaxWsPackage("core"), "Context")
  }
}

class JaxRsResponse extends Class {
  JaxRsResponse() { this.hasQualifiedName(getAJaxWsPackage("core"), "Response") }
}

class JaxRsResponseBuilder extends Class {
  JaxRsResponseBuilder() {
    this.hasQualifiedName(getAJaxWsPackage("core"), "Response$ResponseBuilder")
  }
}

/**
 * The class `javax.ws.rs.client.Client`.
 */
class JaxRsClient extends RefType {
  JaxRsClient() { this.hasQualifiedName(getAJaxWsPackage("client"), "Client") }
}

/**
 * A constructor that may be called by a JaxRS container to construct an instance to inject into a
 * resource method or resource class constructor.
 */
class JaxRsBeanParamConstructor extends Constructor {
  JaxRsBeanParamConstructor() {
    exists(JaxRsResourceClass resourceClass, Callable c, Parameter p |
      c = resourceClass.getAnInjectableCallable()
    |
      p = c.getAParameter() and
      p.getAnAnnotation().getType().hasQualifiedName(getAJaxWsPackage(), "BeanParam") and
      this.getDeclaringType().getSourceDeclaration() = p.getType().(RefType).getSourceDeclaration()
    ) and
    forall(Parameter p | p = getAParameter() |
      p.getAnAnnotation() instanceof JaxRsInjectionAnnotation
    )
  }
}

/**
 * The class `javax.ws.rs.ext.MessageBodyReader`.
 */
class MessageBodyReader extends GenericInterface {
  MessageBodyReader() { this.hasQualifiedName(getAJaxWsPackage("ext"), "MessageBodyReader") }
}

/**
 * The method `readFrom` in `MessageBodyReader`.
 */
class MessageBodyReaderReadFrom extends Method {
  MessageBodyReaderReadFrom() {
    this.getDeclaringType() instanceof MessageBodyReader and
    this.hasName("readFrom")
  }
}

/**
 * A method that overrides `readFrom` in `MessageBodyReader`.
 */
class MessageBodyReaderRead extends Method {
  MessageBodyReaderRead() {
    exists(Method m | m.getSourceDeclaration() instanceof MessageBodyReaderReadFrom |
      this.overrides*(m)
    )
  }
}

/** An `@Produces` annotation that describes which content types can be produced by this resource. */
class JaxRSProducesAnnotation extends JaxRSAnnotation {
  JaxRSProducesAnnotation() { getType().hasQualifiedName(getAJaxWsPackage(), "Produces") }

  /**
   * Gets a declared content type that can be produced by this resource.
   */
  string getADeclaredContentType() {
    result = getAValue().(CompileTimeConstantExpr).getStringValue()
    or
    exists(Field jaxMediaType |
      // Accesses to static fields on `MediaType` class do not have constant strings in the database
      // so convert the field name to a content type string
      jaxMediaType.getDeclaringType().hasQualifiedName(getAJaxWsPackage("core"), "MediaType") and
      jaxMediaType.getAnAccess() = getAValue() and
      // e.g. MediaType.TEXT_PLAIN => text/plain
      result = jaxMediaType.getName().toLowerCase().replaceAll("_", "/")
    )
  }
}

/** An `@Consumes` annotation that describes content types can be consumed by this resource. */
class JaxRSConsumesAnnotation extends JaxRSAnnotation {
  JaxRSConsumesAnnotation() { getType().hasQualifiedName(getAJaxWsPackage(), "Consumes") }
}

/**
 * Model Response:
 *
 * - the returned ResponseBuilder gains taint from a tainted entity or existing Response
 */
private class ResponseModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;Response;false;accepted;;;Argument[0];ReturnValue;taint",
        "javax.ws.rs.core;Response;false;fromResponse;;;Argument[0];ReturnValue;taint",
        "javax.ws.rs.core;Response;false;ok;;;Argument[0];ReturnValue;taint",
        "jakarta.ws.rs.core;Response;false;accepted;;;Argument[0];ReturnValue;taint",
        "jakarta.ws.rs.core;Response;false;fromResponse;;;Argument[0];ReturnValue;taint",
        "jakarta.ws.rs.core;Response;false;ok;;;Argument[0];ReturnValue;taint"
      ]
  }
}

/**
 * Model ResponseBuilder:
 *
 * - becomes tainted by a tainted entity, but not by metadata, headers etc
 * - build() method returns taint
 * - almost all methods are fluent, and so preserve value
 */
private class ResponseBuilderModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;Response$ResponseBuilder;true;build;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;Response$ResponseBuilder;true;entity;;;Argument[0];Argument[-1];taint",
        "javax.ws.rs.core;Response$ResponseBuilder;true;allow;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;cacheControl;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;clone;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;Response$ResponseBuilder;true;contentLocation;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;cookie;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;encoding;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;entity;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;expires;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;header;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;language;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;lastModified;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;link;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;links;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;location;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;replaceAll;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;status;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;tag;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;type;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;variant;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;Response$ResponseBuilder;true;variants;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;build;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;entity;;;Argument[0];Argument[-1];taint",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;allow;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;cacheControl;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;clone;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;contentLocation;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;cookie;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;encoding;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;entity;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;expires;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;header;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;language;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;lastModified;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;link;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;links;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;location;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;replaceAll;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;status;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;tag;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;type;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;variant;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Response$ResponseBuilder;true;variants;;;Argument[-1];ReturnValue;value"
      ]
  }
}

/**
 * Model HttpHeaders: methods that Date have to be syntax-checked, but those returning MediaType
 * or Locale are assumed potentially dangerous, as these types do not generally check that the
 * input data is recognised, only that it conforms to the expected syntax.
 */
private class HttpHeadersModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;HttpHeaders;true;getAcceptableLanguages;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;HttpHeaders;true;getAcceptableMediaTypes;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;HttpHeaders;true;getCookies;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;HttpHeaders;true;getHeaderString;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;HttpHeaders;true;getLanguage;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;HttpHeaders;true;getMediaType;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;HttpHeaders;true;getRequestHeader;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;HttpHeaders;true;getRequestHeaders;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;HttpHeaders;true;getAcceptableLanguages;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;HttpHeaders;true;getAcceptableMediaTypes;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;HttpHeaders;true;getCookies;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;HttpHeaders;true;getHeaderString;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;HttpHeaders;true;getLanguage;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;HttpHeaders;true;getMediaType;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;HttpHeaders;true;getRequestHeader;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;HttpHeaders;true;getRequestHeaders;;;Argument[-1];ReturnValue;taint"
      ]
  }
}

/**
 * Model MultivaluedMap, which extends Map<List<K>, V> and provides a few extra helper methods.
 */
private class MultivaluedMapModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;MultivaluedMap;true;add;;;Argument;Argument[-1];taint",
        "javax.ws.rs.core;MultivaluedMap;true;addAll;;;Argument;Argument[-1];taint",
        "javax.ws.rs.core;MultivaluedMap;true;addFirst;;;Argument;Argument[-1];taint",
        "javax.ws.rs.core;MultivaluedMap;true;getFirst;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;MultivaluedMap;true;putSingle;;;Argument;Argument[-1];taint",
        "jakarta.ws.rs.core;MultivaluedMap;true;add;;;Argument;Argument[-1];taint",
        "jakarta.ws.rs.core;MultivaluedMap;true;addAll;;;Argument;Argument[-1];taint",
        "jakarta.ws.rs.core;MultivaluedMap;true;addFirst;;;Argument;Argument[-1];taint",
        "jakarta.ws.rs.core;MultivaluedMap;true;getFirst;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;MultivaluedMap;true;putSingle;;;Argument;Argument[-1];taint"
      ]
  }
}

/**
 * Model PathSegment, which wraps a path and its associated matrix parameters.
 */
private class PathSegmentModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;PathSegment;true;getMatrixParameters;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;PathSegment;true;getPath;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;PathSegment;true;getMatrixParameters;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;PathSegment;true;getPath;;;Argument[-1];ReturnValue;taint"
      ]
  }
}

/**
 * Model UriInfo, which provides URI element accessors.
 */
private class UriInfoModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;UriInfo;true;getPathParameters;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;UriInfo;true;getPathSegments;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;UriInfo;true;getQueryParameters;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;UriInfo;true;getRequestUri;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;UriInfo;true;getRequestUriBuilder;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriInfo;true;getPathParameters;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriInfo;true;getPathSegments;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriInfo;true;getQueryParameters;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriInfo;true;getRequestUri;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriInfo;true;getRequestUriBuilder;;;Argument[-1];ReturnValue;taint"
      ]
  }
}

/**
 * Model Cookie, a simple tuple type.
 */
private class CookieModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;Cookie;true;getDomain;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;Cookie;true;getName;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;Cookie;true;getPath;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;Cookie;true;getValue;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;Cookie;true;getVersion;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;Cookie;true;toString;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;Cookie;false;Cookie;;;Argument;Argument[-1];taint",
        "javax.ws.rs.core;Cookie;false;valueOf;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;Cookie;true;getDomain;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;Cookie;true;getName;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;Cookie;true;getPath;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;Cookie;true;getValue;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;Cookie;true;getVersion;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;Cookie;true;toString;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;Cookie;false;Cookie;;;Argument;Argument[-1];taint",
        "jakarta.ws.rs.core;Cookie;false;valueOf;;;Argument;ReturnValue;taint"
      ]
  }
}

/**
 * Model Form, a simple container type.
 */
private class FormModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;Form;true;asMap;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;Form;true;param;;;Argument;Argument[-1];taint",
        "javax.ws.rs.core;Form;true;param;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;Form;true;asMap;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;Form;true;param;;;Argument;Argument[-1];taint",
        "jakarta.ws.rs.core;Form;true;param;;;Argument[-1];ReturnValue;value"
      ]
  }
}

/**
 * Model GenericEntity, a wrapper for HTTP entities (e.g., documents).
 */
private class GenericEntityModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;GenericEntity;false;GenericEntity;;;Argument[0];Argument[-1];taint",
        "javax.ws.rs.core;GenericEntity;true;getEntity;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;GenericEntity;false;GenericEntity;;;Argument[0];Argument[-1];taint",
        "jakarta.ws.rs.core;GenericEntity;true;getEntity;;;Argument[-1];ReturnValue;taint"
      ]
  }
}

/**
 * Model MediaType, which provides accessors for elements of Content-Type and similar
 * media type specifications.
 */
private class MediaTypeModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;MediaType;false;MediaType;;;Argument;Argument[-1];taint",
        "javax.ws.rs.core;MediaType;true;getParameters;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;MediaType;true;getSubtype;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;MediaType;true;getType;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;MediaType;false;valueOf;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;MediaType;true;withCharset;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;MediaType;false;MediaType;;;Argument;Argument[-1];taint",
        "jakarta.ws.rs.core;MediaType;true;getParameters;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;MediaType;true;getSubtype;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;MediaType;true;getType;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;MediaType;false;valueOf;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;MediaType;true;withCharset;;;Argument[-1];ReturnValue;taint"
      ]
  }
}

/**
 * Model UriBuilder, which provides a fluent interface to build a URI from components.
 */
private class UriBuilderModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.ws.rs.core;UriBuilder;true;build;;;Argument[0];ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;build;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;buildFromEncoded;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;buildFromEncoded;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;buildFromEncodedMap;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;buildFromEncodedMap;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;buildFromMap;;;Argument[0];ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;buildFromMap;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;clone;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;fragment;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;fragment;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;false;fromLink;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;false;fromPath;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;false;fromUri;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;host;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;host;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;matrixParam;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;matrixParam;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;path;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;path;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;queryParam;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;queryParam;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;replaceMatrix;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;replaceMatrix;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;replaceMatrixParam;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;replaceMatrixParam;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;replacePath;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;replacePath;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;replaceQuery;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;replaceQuery;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;replaceQueryParam;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;replaceQueryParam;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;resolveTemplate;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;resolveTemplate;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;resolveTemplateFromEncoded;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;resolveTemplateFromEncoded;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;resolveTemplates;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;resolveTemplates;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;resolveTemplatesFromEncoded;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;resolveTemplatesFromEncoded;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;scheme;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;scheme;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;schemeSpecificPart;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;schemeSpecificPart;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;segment;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;segment;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;schemeSpecificPart;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;schemeSpecificPart;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;toTemplate;;;Argument[-1];ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;uri;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;uri;;;Argument[-1];ReturnValue;value",
        "javax.ws.rs.core;UriBuilder;true;userInfo;;;Argument;ReturnValue;taint",
        "javax.ws.rs.core;UriBuilder;true;userInfo;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;build;;;Argument[0];ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;build;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;buildFromEncoded;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;buildFromEncoded;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;buildFromEncodedMap;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;buildFromEncodedMap;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;buildFromMap;;;Argument[0];ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;buildFromMap;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;clone;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;fragment;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;fragment;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;false;fromLink;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;false;fromPath;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;false;fromUri;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;host;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;host;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;matrixParam;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;matrixParam;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;path;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;path;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;queryParam;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;queryParam;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;replaceMatrix;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;replaceMatrix;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;replaceMatrixParam;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;replaceMatrixParam;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;replacePath;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;replacePath;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;replaceQuery;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;replaceQuery;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;replaceQueryParam;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;replaceQueryParam;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;resolveTemplate;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;resolveTemplate;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;resolveTemplateFromEncoded;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;resolveTemplateFromEncoded;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;resolveTemplates;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;resolveTemplates;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;resolveTemplatesFromEncoded;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;resolveTemplatesFromEncoded;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;scheme;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;scheme;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;schemeSpecificPart;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;schemeSpecificPart;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;segment;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;segment;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;schemeSpecificPart;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;schemeSpecificPart;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;toTemplate;;;Argument[-1];ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;uri;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;uri;;;Argument[-1];ReturnValue;value",
        "jakarta.ws.rs.core;UriBuilder;true;userInfo;;;Argument;ReturnValue;taint",
        "jakarta.ws.rs.core;UriBuilder;true;userInfo;;;Argument[-1];ReturnValue;value"
      ]
  }
}
