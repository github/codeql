/** Provides classes to reason about Cross-site scripting (XSS) vulnerabilities. */

import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.android.WebView
import semmle.code.java.frameworks.spring.SpringController
import semmle.code.java.frameworks.spring.SpringHttp
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.dataflow.ExternalFlow

/** A sink that represent a method that outputs data without applying contextual output encoding. */
abstract class XssSink extends DataFlow::Node { }

/** A sanitizer that neutralizes dangerous characters that can be used to perform a XSS attack. */
abstract class XssSanitizer extends DataFlow::Node { }

/**
 * A sink that represent a method that outputs data without applying contextual output encoding,
 * and which should truncate flow paths such that downstream sinks are not flagged as well.
 */
abstract class XssSinkBarrier extends XssSink { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the XSS
 * taint configuration.
 */
class XssAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for XSS taint configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** CSV sink models representing methods susceptible to XSS attacks. */
private class DefaultXssSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.webkit;WebView;false;loadData;;;Argument[0];xss",
        "android.webkit;WebView;false;loadUrl;;;Argument[0];xss",
        "android.webkit;WebView;false;loadDataWithBaseURL;;;Argument[1];xss"
      ]
  }
}

/** A default sink representing methods susceptible to XSS attacks. */
private class DefaultXssSink extends XssSink {
  DefaultXssSink() {
    sinkNode(this, "xss")
    or
    exists(ServletWriterSourceToWritingMethodFlowConfig writer, MethodAccess ma |
      ma.getMethod() instanceof WritingMethod and
      writer.hasFlowToExpr(ma.getQualifier()) and
      this.asExpr() = ma.getArgument(_)
    )
    or
    exists(SpringRequestMappingMethod requestMappingMethod, ReturnStmt rs |
      requestMappingMethod = rs.getEnclosingCallable() and
      this.asExpr() = rs.getResult() and
      (
        not exists(requestMappingMethod.getProduces()) or
        requestMappingMethod.getProduces().matches("text/%")
      )
    |
      // If a Spring request mapping method is either annotated with @ResponseBody (or equivalent),
      // or returns a HttpEntity or sub-type, then the return value of the method is converted into
      // a HTTP reponse using a HttpMessageConverter implementation. The implementation is chosen
      // based on the return type of the method, and the Accept header of the request.
      //
      // By default, the only message converter which produces a response which is vulnerable to
      // XSS is the StringHttpMessageConverter, which "Accept"s all text/* content types, including
      // text/html. Therefore, if a browser request includes "text/html" in the "Accept" header,
      // any String returned will be converted into a text/html response.
      requestMappingMethod.isResponseBody() and
      requestMappingMethod.getReturnType() instanceof TypeString
      or
      exists(Type returnType |
        // A return type of HttpEntity<T> or ResponseEntity<T> represents an HTTP response with both
        // a body and a set of headers. The body is subject to the same HttpMessageConverter
        // process as above.
        returnType = requestMappingMethod.getReturnType() and
        (
          returnType instanceof SpringHttpEntity
          or
          returnType instanceof SpringResponseEntity
        )
      |
        // The type argument, representing the type of the body, is type String
        returnType.(ParameterizedClass).getTypeArgument(0) instanceof TypeString
        or
        // Return type is a Raw class, which means no static type information on the body. In this
        // case we will still treat this as an XSS sink, but rely on our taint flow steps for
        // HttpEntity/ResponseEntity to only pass taint into those instances if the body type was
        // String.
        returnType instanceof RawClass
      )
    )
  }
}

/** A default sanitizer that considers numeric and boolean typed data safe for writing to output. */
private class DefaultXSSSanitizer extends XssSanitizer {
  DefaultXSSSanitizer() {
    this.getType() instanceof NumericType or this.getType() instanceof BooleanType
  }
}

/** A configuration that tracks data from a servlet writer to an output method. */
private class ServletWriterSourceToWritingMethodFlowConfig extends TaintTracking2::Configuration {
  ServletWriterSourceToWritingMethodFlowConfig() {
    this = "XSS::ServletWriterSourceToWritingMethodFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ServletWriterSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod() instanceof WritingMethod
    )
  }
}

/** A method that can be used to output data to an output stream or writer. */
private class WritingMethod extends Method {
  WritingMethod() {
    getDeclaringType().getASupertype*().hasQualifiedName("java.io", _) and
    (
      this.getName().matches("print%") or
      this.getName() = "append" or
      this.getName() = "format" or
      this.getName() = "write"
    )
  }
}

/** An output stream or writer that writes to a servlet response. */
class ServletWriterSource extends MethodAccess {
  ServletWriterSource() {
    this.getMethod() instanceof ServletResponseGetWriterMethod
    or
    this.getMethod() instanceof ServletResponseGetOutputStreamMethod
    or
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType().getQualifiedName() = "javax.servlet.jsp.JspContext" and
      m.getName() = "getOut"
    )
  }
}

/**
 * Holds if `s` is an HTTP Content-Type vulnerable to XSS.
 */
bindingset[s]
predicate isXssVulnerableContentType(string s) {
  s.regexpMatch("(?i)text/(html|xml|xsl|rdf|vtt|cache-manifest).*") or
  s.regexpMatch("(?i)application/(.*\\+)?xml.*") or
  s.regexpMatch("(?i)cache-manifest.*") or
  s.regexpMatch("(?i)image/svg\\+xml.*")
}

/**
 * Holds if `s` is an HTTP Content-Type that is not vulnerable to XSS.
 */
bindingset[s]
predicate isXssSafeContentType(string s) { not isXssVulnerableContentType(s) }
