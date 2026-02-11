/** Provides classes and predicates for working with JavaServer Faces renderer. */
overlay[local?]
module;

import java

/**
 * The JSF class `FacesContext` for processing HTTP requests.
 */
class FacesContext extends RefType {
  FacesContext() {
    this.hasQualifiedName(["javax.faces.context", "jakarta.faces.context"], "FacesContext")
  }
}

/**
 * The method `getResponseWriter()` declared in JSF `ExternalContext`.
 */
class FacesGetResponseWriterMethod extends Method {
  FacesGetResponseWriterMethod() {
    this.getDeclaringType() instanceof FacesContext and
    this.hasName("getResponseWriter") and
    this.getNumberOfParameters() = 0
  }
}

/**
 * The method `getResponseStream()` declared in JSF `ExternalContext`.
 */
class FacesGetResponseStreamMethod extends Method {
  FacesGetResponseStreamMethod() {
    this.getDeclaringType() instanceof FacesContext and
    this.hasName("getResponseStream") and
    this.getNumberOfParameters() = 0
  }
}
