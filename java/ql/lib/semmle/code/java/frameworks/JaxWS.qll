/**
 * Definitions relating to JAX-WS (Java/Jakarta API for XML Web Services) and JAX-RS
 * (Java/Jakarta API for RESTful Web Services).
 */

import java
private import semmle.code.java.frameworks.Networking
private import semmle.code.java.frameworks.Rmi
private import semmle.code.java.security.XSS

/**
 * Gets a name for the root package of JAX-RS.
 */
string getAJaxRsPackage() { result in ["javax.ws.rs", "jakarta.ws.rs"] }

/**
 * Gets a name for package `subpackage` within the JAX-RS hierarchy.
 */
bindingset[subpackage]
string getAJaxRsPackage(string subpackage) { result = getAJaxRsPackage() + "." + subpackage }

/**
 * A JAX WS endpoint is constructed by the container, and its methods
 * are -- where annotated -- called remotely.
 */
class JaxWsEndpoint extends Class {
  JaxWsEndpoint() {
    exists(AnnotationType a | a = this.getAnAncestor().getAnAnnotation().getType() |
      a.hasName(["WebService", "WebServiceProvider", "WebServiceClient"])
    )
  }

  /**
   * Gets a method of this class that is not an excluded `@WebMethod`,
   * and the parameters and return value of which are either of an acceptable type,
   * or are annotated with `@XmlJavaTypeAdapter`.
   */
  Method getARemoteMethod() {
    result = this.getACallable() and
    result.isPublic() and
    not result instanceof InitializerMethod and
    not exists(Annotation a | a = result.getAnAnnotation() |
      a.getType().hasQualifiedName(["javax", "jakarta"] + ".jws", "WebMethod") and
      a.getValue("exclude").(BooleanLiteral).getBooleanValue() = true
    ) and
    forex(ParamOrReturn paramOrRet | paramOrRet = result.getAParameter() or paramOrRet = result |
      exists(Type t | t = paramOrRet.getType() |
        t instanceof JaxAcceptableType
        or
        t.(Annotatable).getAnAnnotation().getType() instanceof XmlJavaTypeAdapter
        or
        t instanceof VoidType
      )
      or
      paramOrRet.getInheritedAnnotation().getType() instanceof XmlJavaTypeAdapter
    )
  }
}

/** The annotation type `@XmlJavaTypeAdapter`. */
class XmlJavaTypeAdapter extends AnnotationType {
  XmlJavaTypeAdapter() {
    this.hasQualifiedName(["javax", "jakarta"] + ".xml.bind.annotation.adapters",
      "XmlJavaTypeAdapter")
  }
}

private class ParamOrReturn extends Annotatable {
  ParamOrReturn() { this instanceof Parameter or this instanceof Method }

  Type getType() {
    result = this.(Parameter).getType()
    or
    result = this.(Method).getReturnType()
  }

  Annotation getInheritedAnnotation() {
    result = this.getAnAnnotation()
    or
    result = this.(Method).getAnOverride*().getAnAnnotation()
    or
    result =
      this.(Parameter)
          .getCallable()
          .(Method)
          .getAnOverride*()
          .getParameter(this.(Parameter).getPosition())
          .getAnAnnotation()
  }
}

// JAX-RPC 1.1, section 5
private class JaxAcceptableType extends Type {
  JaxAcceptableType() {
    // JAX-RPC 1.1, section 5.1.1
    this instanceof PrimitiveType
    or
    // JAX-RPC 1.1, section 5.1.2
    this.(Array).getElementType() instanceof JaxAcceptableType
    or
    // JAX-RPC 1.1, section 5.1.3
    this instanceof JaxAcceptableStandardClass
    or
    // JAX-RPC 1.1, section 5.1.4
    this instanceof JaxValueType
  }
}

private class JaxAcceptableStandardClass extends RefType {
  JaxAcceptableStandardClass() {
    this instanceof TypeString or
    this.hasQualifiedName("java.util", "Date") or
    this.hasQualifiedName("java.util", "Calendar") or
    this.hasQualifiedName("java.math", "BigInteger") or
    this.hasQualifiedName("java.math", "BigDecimal") or
    this.hasQualifiedName("javax.xml.namespace", "QName") or
    this instanceof TypeUri
  }
}

// JAX-RPC 1.1, section 5.4
private class JaxValueType extends RefType {
  JaxValueType() {
    not this instanceof Wildcard and
    // Mutually exclusive with other `JaxAcceptableType`s
    not this instanceof Array and
    not this instanceof JaxAcceptableStandardClass and
    not this.getPackage().getName().matches("java.%") and
    // Must not implement (directly or indirectly) the java.rmi.Remote interface.
    not this.getAnAncestor() instanceof TypeRemote and
    // The Java type of a public field must be a supported JAX-RPC type as specified in the section 5.1.
    forall(Field f | this.getAMember() = f and f.isPublic() |
      f.getType() instanceof JaxAcceptableType
    )
  }
}

/**
 * Holds if the annotatable has the JaxRs `@Path` annotation.
 */
private predicate hasPathAnnotation(Annotatable annotatable) {
  exists(AnnotationType a |
    a = annotatable.getAnAnnotation().getType() and
    a.getPackage().getName() = getAJaxRsPackage()
  |
    a.hasName("Path")
  )
}

/**
 * Holds if the class has or inherits the JaxRs `@Path` annotation.
 */
private predicate hasOrInheritsPathAnnotation(Class c) {
  hasPathAnnotation(c)
  or
  // Note that by the JAX-RS spec, JAX-RS annotations on classes and interfaces
  // are not inherited, but some implementations, like Apache CXF, do inherit
  // them. I think this only applies if there are no JaxRS annotations on the
  // class itself, as that is the rule in the JAX-RS spec for method
  // annotations.
  hasPathAnnotation(c.getAnAncestor()) and
  not exists(c.getAnAnnotation().(JaxRSAnnotation))
}

/**
 * A method which is annotated with one or more JaxRS resource type annotations e.g. `@GET`, `@POST` etc.
 */
class JaxRsResourceMethod extends Method {
  JaxRsResourceMethod() {
    exists(AnnotationType a |
      a = this.getAnAnnotation().getType() and
      a.getPackage().getName() = getAJaxRsPackage()
    |
      a.hasName(["GET", "POST", "DELETE", "PUT", "OPTIONS", "HEAD"])
    )
    or
    // A JaxRS resource method can also inherit these annotations from a supertype, but only if
    // there are no JaxRS annotations on the method itself
    this.getAnOverride() instanceof JaxRsResourceMethod and
    not exists(this.getAnAnnotation().(JaxRSAnnotation))
  }

  /** Gets an `@Produces` annotation that applies to this method */
  JaxRSProducesAnnotation getProducesAnnotation() {
    result = this.getAnAnnotation()
    or
    // No direct annotations
    not this.getAnAnnotation() instanceof JaxRSProducesAnnotation and
    (
      // Annotations on a method we've overridden
      result = this.getAnOverride().getAnAnnotation()
      or
      // No annotations on this method, or a method we've overridden, so look to the class
      not this.getAnOverride().getAnAnnotation() instanceof JaxRSProducesAnnotation and
      result = this.getDeclaringType().getAnAnnotation()
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
    hasOrInheritsPathAnnotation(this)
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
    this.isPublic() and
    result = this.getACallable()
  }

  /**
   * Gets a "sub-resource locator" on this resource class, which is a method annotated with `@Path`,
   * but is not a resource method e.g. it is not annotated with `@GET` etc.
   */
  Callable getASubResourceLocator() {
    result = this.getAMethod() and
    not result instanceof JaxRsResourceMethod and
    hasPathAnnotation(result)
  }

  /**
   * Holds if this class is a "root resource" class
   */
  predicate isRootResource() { hasOrInheritsPathAnnotation(this) }

  /**
   * Gets a `Constructor` that may be called by a JaxRS container to construct this class reflectively.
   *
   * This only considers which constructors adhere to the rules for injectable constructors. In the
   * case of multiple matching constructors, the container will choose the constructor with the most
   * matching parameters, but this is not modeled, because it may take into account runtime aspects
   * (existence of particular parameters).
   */
  Constructor getAnInjectableConstructor() {
    result = this.getAConstructor() and
    // JaxRs Spec v2.0 - 3.12
    // Only root resources are constructed by the JaxRS container.
    this.isRootResource() and
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
    result = this.getAResourceMethod() or
    result = this.getAnInjectableConstructor() or
    result = this.getASubResourceLocator()
  }

  /**
   * Gets a Field that may be injected with a value by the JaxRs container.
   */
  Field getAnInjectableField() {
    result = this.getAField() and
    result.getAnAnnotation() instanceof JaxRsInjectionAnnotation
  }
}

/**
 * An annotation from the `javax.ws.rs` or `jakarta.ws.rs` package hierarchy.
 */
class JaxRSAnnotation extends Annotation {
  JaxRSAnnotation() {
    exists(AnnotationType a |
      a = this.getType() and
      a.getPackage().getName().regexpMatch(["javax\\.ws\\.rs(\\..*)?", "jakarta\\.ws\\.rs(\\..*)?"])
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
      a = this.getType() and
      a.getPackage().getName() = getAJaxRsPackage()
    |
      a.hasName([
          "BeanParam", "CookieParam", "FormParam", "HeaderParam", "MatrixParam", "PathParam",
          "QueryParam"
        ])
    )
    or
    this.getType().hasQualifiedName(getAJaxRsPackage("core"), "Context")
  }
}

/**
 * The class `javax.ws.rs.core.Response`.
 */
class JaxRsResponse extends Class {
  JaxRsResponse() { this.hasQualifiedName(getAJaxRsPackage("core"), "Response") }
}

/**
 * The class `javax.ws.rs.core.Response$ResponseBuilder`.
 */
class JaxRsResponseBuilder extends Class {
  JaxRsResponseBuilder() {
    this.hasQualifiedName(getAJaxRsPackage("core"), "Response$ResponseBuilder")
  }
}

/**
 * The class `javax.ws.rs.client.Client`.
 */
class JaxRsClient extends RefType {
  JaxRsClient() { this.hasQualifiedName(getAJaxRsPackage("client"), "Client") }
}

/**
 * A constructor that may be called by a JaxRS container to construct an instance to inject into a
 * resource method or resource class constructor.
 */
class JaxRsBeanParamConstructor extends Constructor {
  JaxRsBeanParamConstructor() {
    exists(JaxRsResourceClass resourceClass, Callable c, Parameter p |
      c = resourceClass.getAnInjectableCallable() and
      p = c.getAParameter() and
      p.getAnAnnotation().getType().hasQualifiedName(getAJaxRsPackage(), "BeanParam") and
      this.getDeclaringType().getSourceDeclaration() = p.getType().(RefType).getSourceDeclaration()
    ) and
    forall(Parameter p | p = this.getAParameter() |
      p.getAnAnnotation() instanceof JaxRsInjectionAnnotation
    )
  }
}

/**
 * The class `javax.ws.rs.ext.MessageBodyReader`.
 */
class MessageBodyReader extends GenericInterface {
  MessageBodyReader() { this.hasQualifiedName(getAJaxRsPackage("ext"), "MessageBodyReader") }
}

/**
 * The method `readFrom` in `MessageBodyReader`.
 */
class MessageBodyReaderReadFrom extends Method {
  MessageBodyReaderReadFrom() {
    this.getDeclaringType().getSourceDeclaration() instanceof MessageBodyReader and
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

/**
 * Gets a constant content-type described by expression `e` (either a string constant or a Jax-RS MediaType field access).
 */
string getContentTypeString(Expr e) {
  result = e.(CompileTimeConstantExpr).getStringValue() and
  result != ""
  or
  exists(Field jaxMediaType |
    // Accesses to static fields on `MediaType` class do not have constant strings in the database
    // so convert the field name to a content type string
    jaxMediaType.getDeclaringType().hasQualifiedName(getAJaxRsPackage("core"), "MediaType") and
    jaxMediaType.getAnAccess() = e and
    // e.g. MediaType.TEXT_PLAIN => text/plain
    result = jaxMediaType.getName().toLowerCase().replaceAll("_value", "").replaceAll("_", "/")
  )
}

/** An `@Produces` annotation that describes which content types can be produced by this resource. */
class JaxRSProducesAnnotation extends JaxRSAnnotation {
  JaxRSProducesAnnotation() { this.getType().hasQualifiedName(getAJaxRsPackage(), "Produces") }

  /**
   * Gets a declared content type that can be produced by this resource.
   */
  Expr getADeclaredContentTypeExpr() { result = this.getAnArrayValue("value") }
}

/** An `@Consumes` annotation that describes content types can be consumed by this resource. */
class JaxRSConsumesAnnotation extends JaxRSAnnotation {
  JaxRSConsumesAnnotation() { this.getType().hasQualifiedName(getAJaxRsPackage(), "Consumes") }
}

/** A default sink representing methods susceptible to XSS attacks. */
private class JaxRSXssSink extends XssSink {
  JaxRSXssSink() {
    exists(JaxRsResourceMethod resourceMethod, ReturnStmt rs |
      resourceMethod = any(JaxRsResourceClass resourceClass).getAResourceMethod() and
      rs.getEnclosingCallable() = resourceMethod and
      this.asExpr() = rs.getResult()
    |
      not exists(resourceMethod.getProducesAnnotation())
      or
      isXssVulnerableContentTypeExpr(resourceMethod
            .getProducesAnnotation()
            .getADeclaredContentTypeExpr())
    )
  }
}

pragma[nomagic]
private predicate contentTypeString(string s) { s = getContentTypeString(_) }

pragma[nomagic]
private predicate isXssVulnerableContentTypeString(string s) {
  contentTypeString(s) and isXssVulnerableContentType(s)
}

pragma[nomagic]
private predicate isXssSafeContentTypeString(string s) {
  contentTypeString(s) and isXssSafeContentType(s)
}

private predicate isXssVulnerableContentTypeExpr(Expr e) {
  isXssVulnerableContentTypeString(getContentTypeString(e))
}

private predicate isXssSafeContentTypeExpr(Expr e) {
  isXssSafeContentTypeString(getContentTypeString(e))
}

/**
 * Gets a builder expression or related type that is configured to use the given `contentType`.
 *
 * This could be an instance of `Response.ResponseBuilder`, `Variant`, `Variant.VariantListBuilder` or
 * a `List<Variant>`.
 *
 * This predicate is used to search forwards for response entities set after the content-type is configured.
 * It does not need to consider cases where the entity is set in the same call, or the entity has already
 * been set: these are handled by simple sanitization below.
 */
private DataFlow::Node getABuilderWithExplicitContentType(Expr contentType) {
  // Base case: ResponseBuilder.type(contentType)
  result.asExpr() =
    any(MethodCall ma |
      ma.getCallee().hasQualifiedName(getAJaxRsPackage("core"), "Response$ResponseBuilder", "type") and
      contentType = ma.getArgument(0)
    )
  or
  // Base case: new Variant(contentType, ...)
  result.asExpr() =
    any(ClassInstanceExpr cie |
      cie.getConstructedType().hasQualifiedName(getAJaxRsPackage("core"), "Variant") and
      contentType = cie.getArgument(0)
    )
  or
  // Base case: Variant[.VariantListBuilder].mediaTypes(...)
  result.asExpr() =
    any(MethodCall ma |
      ma.getCallee()
          .hasQualifiedName(getAJaxRsPackage("core"), ["Variant", "Variant$VariantListBuilder"],
            "mediaTypes") and
      contentType = ma.getAnArgument()
    )
  or
  // Recursive case: propagate through variant list building:
  result.asExpr() =
    any(MethodCall ma |
      (
        ma.getType()
            .(RefType)
            .hasQualifiedName(getAJaxRsPackage("core"), "Variant$VariantListBuilder")
        or
        ma.getMethod()
            .hasQualifiedName(getAJaxRsPackage("core"), "Variant$VariantListBuilder", "build")
      ) and
      [ma.getAnArgument(), ma.getQualifier()] =
        getABuilderWithExplicitContentType(contentType).asExpr()
    )
  or
  // Recursive case: propagate through a List.get operation
  result.asExpr() =
    any(MethodCall ma |
      ma.getMethod().hasQualifiedName("java.util", "List<Variant>", "get") and
      ma.getQualifier() = getABuilderWithExplicitContentType(contentType).asExpr()
    )
  or
  // Recursive case: propagate through Response.ResponseBuilder operations, including the `variant(...)` operation.
  result.asExpr() =
    any(MethodCall ma |
      ma.getType().(RefType).hasQualifiedName(getAJaxRsPackage("core"), "Response$ResponseBuilder") and
      [ma.getQualifier(), ma.getArgument(0)] =
        getABuilderWithExplicitContentType(contentType).asExpr()
    )
  or
  // Recursive case: ordinary local dataflow
  DataFlow::localFlowStep(getABuilderWithExplicitContentType(contentType), result)
}

private DataFlow::Node getASanitizedBuilder() {
  result = getABuilderWithExplicitContentType(any(Expr e | isXssSafeContentTypeExpr(e)))
}

private DataFlow::Node getAVulnerableBuilder() {
  result = getABuilderWithExplicitContentType(any(Expr e | isXssVulnerableContentTypeExpr(e)))
}

/**
 * A response builder sanitized by setting a safe content type.
 *
 * The content type could be set before the `entity(...)` call that needs sanitizing
 * (e.g. `Response.ok().type("application/json").entity(sanitizeMe)`)
 * or at the same time (e.g. `Response.ok(sanitizeMe, "application/json")`
 * or the content-type could be set afterwards (e.g. `Response.ok().entity(userControlled).type("application/json")`)
 *
 * This differs from `getASanitizedBuilder` in that we also include functions that must set the entity
 * at the same time, or the entity must already have been set, so propagating forwards to sanitize future
 * build steps is not necessary.
 */
private class SanitizedResponseBuilder extends XssSanitizer {
  SanitizedResponseBuilder() {
    // e.g. sanitizeMe.type("application/json")
    this = getASanitizedBuilder()
    or
    this.asExpr() =
      any(MethodCall ma |
        ma.getMethod().hasQualifiedName(getAJaxRsPackage("core"), "Response", "ok") and
        (
          // e.g. Response.ok(sanitizeMe, new Variant("application/json", ...))
          ma.getArgument(1) = getASanitizedBuilder().asExpr()
          or
          // e.g. Response.ok(sanitizeMe, "application/json")
          isXssSafeContentTypeExpr(ma.getArgument(1))
        )
      )
  }
}

/**
 * An entity call that serves as a sink and barrier because it has a vulnerable content-type set.
 *
 * We flag these as direct sinks because otherwise it may be sanitized when it reaches a resource
 * method with a safe-looking `@Produces` annotation. They are barriers because otherwise if the
 * resource method does *not* have a safe-looking `@Produces` annotation then it would be doubly
 * reported, once at the `entity(...)` call and once on return from the resource method.
 */
private class VulnerableEntity extends XssSinkBarrier {
  VulnerableEntity() {
    this.asExpr() =
      any(MethodCall ma |
        (
          // Vulnerable content-type already set:
          ma.getQualifier() = getAVulnerableBuilder().asExpr()
          or
          // Vulnerable content-type set in the future:
          getAVulnerableBuilder().asExpr().(MethodCall).getQualifier*() = ma
        ) and
        ma.getMethod().hasName("entity")
      ).getArgument(0)
    or
    this.asExpr() =
      any(MethodCall ma |
        (
          isXssVulnerableContentTypeExpr(ma.getArgument(1))
          or
          ma.getArgument(1) = getAVulnerableBuilder().asExpr()
        ) and
        ma.getMethod().hasName("ok")
      ).getArgument(0)
  }
}
