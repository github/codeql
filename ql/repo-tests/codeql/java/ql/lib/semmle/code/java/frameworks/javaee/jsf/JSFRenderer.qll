/** Provides classes and predicates for working with JavaServer Faces renderer. */

import java
private import semmle.code.java.dataflow.ExternalFlow

/**
 * The JSF class `FacesContext` for processing HTTP requests.
 */
class FacesContext extends RefType {
  FacesContext() {
    this.hasQualifiedName(["javax.faces.context", "jakarta.faces.context"], "FacesContext")
  }
}

private class ExternalContextSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      ["javax.", "jakarta."] +
        [
          "faces.context;ExternalContext;true;getRequestParameterMap;();;ReturnValue;remote",
          "faces.context;ExternalContext;true;getRequestParameterNames;();;ReturnValue;remote",
          "faces.context;ExternalContext;true;getRequestParameterValuesMap;();;ReturnValue;remote",
          "faces.context;ExternalContext;true;getRequestPathInfo;();;ReturnValue;remote",
          "faces.context;ExternalContext;true;getRequestCookieMap;();;ReturnValue;remote",
          "faces.context;ExternalContext;true;getRequestHeaderMap;();;ReturnValue;remote",
          "faces.context;ExternalContext;true;getRequestHeaderValuesMap;();;ReturnValue;remote"
        ]
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

private class ExternalContextXssSink extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.faces.context;ResponseWriter;true;write;;;Argument[0];xss",
        "javax.faces.context;ResponseStream;true;write;;;Argument[0];xss",
        "jakarta.faces.context;ResponseWriter;true;write;;;Argument[0];xss",
        "jakarta.faces.context;ResponseStream;true;write;;;Argument[0];xss"
      ]
  }
}
