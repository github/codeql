/**
 * Provides classes and predicates for working with the Java Server Faces (JSF).
 */
deprecated module;

import java

/**
 * The JSF class `ExternalContext` for processing HTTP requests.
 */
class ExternalContext extends RefType {
  ExternalContext() {
    this.hasQualifiedName(["javax.faces.context", "jakarta.faces.context"], "ExternalContext")
  }
}

/**
 * The method `getResource()` declared in JSF `ExternalContext`.
 */
class GetFacesResourceMethod extends Method {
  GetFacesResourceMethod() {
    this.getDeclaringType().getASupertype*() instanceof ExternalContext and
    this.hasName("getResource")
  }
}

/**
 * The method `getResourceAsStream()` declared in JSF `ExternalContext`.
 */
class GetFacesResourceAsStreamMethod extends Method {
  GetFacesResourceAsStreamMethod() {
    this.getDeclaringType().getASupertype*() instanceof ExternalContext and
    this.hasName("getResourceAsStream")
  }
}
