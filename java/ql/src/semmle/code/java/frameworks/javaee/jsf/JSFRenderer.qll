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

/**
 * The JSF class `ExternalContext` allowing JavaServer Faces based applications to run in
 * either a Servlet or a Portlet environment.
 */
class ExternalContext extends RefType {
  ExternalContext() {
    this.hasQualifiedName(["javax.faces.context", "jakarta.faces.context"], "ExternalContext")
  }
}

/**
 * The base class type `UIComponent` for all user interface components in JavaServer Faces.
 */
class FacesUIComponent extends RefType {
  FacesUIComponent() {
    this.hasQualifiedName(["javax.faces.component", "jakarta.faces.component"], "UIComponent")
  }
}

/**
 * The JSF class `Renderer` that converts internal representation of `UIComponent` into the output
 * stream (or writer) associated with the response we are creating for a particular request.
 */
class FacesRenderer extends RefType {
  FacesRenderer() {
    this.hasQualifiedName(["javax.faces.render", "jakarta.faces.render"], "Renderer")
  }
}

/**
 * The JSF class `ResponseWriter` that outputs and producing elements and attributes for markup
 * languages like HTML and XML.
 */
class FacesResponseWriter extends RefType {
  FacesResponseWriter() {
    this.hasQualifiedName(["javax.faces.context", "jakarta.faces.context"], "ResponseWriter")
  }
}

/**
 * The class `ResponseStream` that produces binary output.
 */
class FacesResponseStream extends RefType {
  FacesResponseStream() {
    this.hasQualifiedName(["javax.faces.context", "jakarta.faces.context"], "ResponseStream")
  }
}

private class ExternalContextSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.faces.context;ExternalContext;true;getRequestParameterMap;();;ReturnValue;remote",
        "javax.faces.context;ExternalContext;true;getRequestParameterNames;();;ReturnValue;remote",
        "javax.faces.context;ExternalContext;true;getRequestParameterValuesMap;();;ReturnValue;remote",
        "javax.faces.context;ExternalContext;true;getRequestPathInfo;();;ReturnValue;remote",
        "javax.faces.context;ExternalContext;true;getResource;(String);;ReturnValue;remote",
        "javax.faces.context;ExternalContext;true;getResourceAsStream;(String);;ReturnValue;remote",
        "javax.faces.context;ExternalContext;true;getResourcePaths;(String);;ReturnValue;remote",
        "javax.faces.context;ExternalContext;true;getRequestCookieMap;();;ReturnValue;remote",
        "javax.faces.context;ExternalContext;true;getRequestHeaderMap;();;ReturnValue;remote",
        "javax.faces.context;ExternalContext;true;getRequestHeaderValuesMap;();;ReturnValue;remote",
        "jakarta.faces.context;ExternalContext;true;getRequestParameterMap;();;ReturnValue;remote",
        "jakarta.faces.context;ExternalContext;true;getRequestParameterNames;();;ReturnValue;remote",
        "jakarta.faces.context;ExternalContext;true;getRequestParameterValuesMap;();;ReturnValue;remote",
        "jakarta.faces.context;ExternalContext;true;getRequestPathInfo;();;ReturnValue;remote",
        "jakarta.faces.context;ExternalContext;true;getResource;(String);;ReturnValue;remote",
        "jakarta.faces.context;ExternalContext;true;getResourceAsStream;(String);;ReturnValue;remote",
        "jakarta.faces.context;ExternalContext;true;getResourcePaths;(String);;ReturnValue;remote",
        "jakarta.faces.context;ExternalContext;true;getRequestCookieMap;();;ReturnValue;remote",
        "jakarta.faces.context;ExternalContext;true;getRequestHeaderMap;();;ReturnValue;remote",
        "jakarta.faces.context;ExternalContext;true;getRequestHeaderValuesMap;();;ReturnValue;remote"
      ]
  }
}

/**
 * The method `getResponseWriter()` declared in JSF `ExternalContext`.
 */
class FacesGetResponseWriterMethod extends Method {
  FacesGetResponseWriterMethod() {
    getDeclaringType() instanceof FacesContext and
    hasName("getResponseWriter") and
    getNumberOfParameters() = 0
  }
}

/**
 * The method `getResponseStream()` declared in JSF `ExternalContext`.
 */
class FacesGetResponseStreamMethod extends Method {
  FacesGetResponseStreamMethod() {
    getDeclaringType() instanceof FacesContext and
    hasName("getResponseStream") and
    getNumberOfParameters() = 0
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
