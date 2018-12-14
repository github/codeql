import java

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
    a.getPackage().getName() = "javax.ws.rs"
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
      a.getPackage().getName() = "javax.ws.rs"
    |
      a.hasName("GET") or
      a.hasName("POST") or
      a.hasName("DELETE") or
      a.hasName("PUT") or
      a.hasName("OPTIONS") or
      a.hasName("HEAD")
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

/**
 * An annotation that is used by JaxRS containers to determine a value to inject into the annotated
 * element.
 */
class JaxRsInjectionAnnotation extends Annotation {
  JaxRsInjectionAnnotation() {
    exists(AnnotationType a |
      a = getType() and
      a.getPackage().getName() = "javax.ws.rs"
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
    getType().hasQualifiedName("javax.ws.rs.core", "Context")
  }
}

class JaxRsResponse extends Class {
  JaxRsResponse() { this.hasQualifiedName("javax.ws.rs.core", "Response") }
}

class JaxRsResponseBuilder extends Class {
  JaxRsResponseBuilder() { this.hasQualifiedName("javax.ws.rs.core", "ResponseBuilder") }
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
      p.getAnAnnotation().getType().hasQualifiedName("javax.ws.rs", "BeanParam") and
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
  MessageBodyReader() { this.hasQualifiedName("javax.ws.rs.ext", "MessageBodyReader") }
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
