/** Provides classes to reason about Cross-site scripting (XSS) vulnerabilities. */

import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.android.WebView
import semmle.code.java.frameworks.spring.SpringController
import semmle.code.java.frameworks.spring.SpringHttp
import semmle.code.java.frameworks.javaee.jsf.JSFRenderer
private import semmle.code.java.frameworks.hudson.Hudson
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.FlowSinks

/** A sink that represent a method that outputs data without applying contextual output encoding. */
abstract class XssSink extends ApiSinkNode { }

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

/** A default sink representing methods susceptible to XSS attacks. */
private class DefaultXssSink extends XssSink {
  DefaultXssSink() {
    sinkNode(this, ["html-injection", "js-injection"])
    or
    exists(MethodCall ma |
      ma.getMethod() instanceof WritingMethod and
      XssVulnerableWriterSourceToWritingMethodFlow::flowToExpr(ma.getQualifier()) and
      this.asExpr() = ma.getArgument(_)
    )
  }
}

/** A default sanitizer that considers numeric and boolean typed data safe for writing to output. */
private class DefaultXssSanitizer extends XssSanitizer {
  DefaultXssSanitizer() {
    this.getType() instanceof NumericType or
    this.getType() instanceof BooleanType or
    // Match `org.springframework.web.util.HtmlUtils.htmlEscape` and possibly other methods like it.
    this.asExpr().(MethodCall).getMethod().getName().regexpMatch("(?i)html_?escape.*")
  }
}

/** A configuration that tracks data from a servlet writer to an output method. */
private module XssVulnerableWriterSourceToWritingMethodFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof XssVulnerableWriterSourceNode }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      sink.asExpr() = ma.getQualifier() and ma.getMethod() instanceof WritingMethod
    )
  }
}

private module XssVulnerableWriterSourceToWritingMethodFlow =
  TaintTracking::Global<XssVulnerableWriterSourceToWritingMethodFlowConfig>;

/** A method that can be used to output data to an output stream or writer. */
private class WritingMethod extends Method {
  WritingMethod() {
    this.getDeclaringType().getAnAncestor().hasQualifiedName("java.io", _) and
    (
      this.getName().matches("print%") or
      this.getName() = "append" or
      this.getName() = "format" or
      this.getName() = "write"
    )
  }
}

/** An output stream or writer that writes to a servlet, JSP or JSF response. */
class XssVulnerableWriterSource extends MethodCall {
  XssVulnerableWriterSource() {
    this.getMethod() instanceof ServletResponseGetWriterMethod
    or
    this.getMethod() instanceof ServletResponseGetOutputStreamMethod
    or
    exists(Method m | m = this.getMethod() |
      m.hasQualifiedName("javax.servlet.jsp", "JspContext", "getOut")
    )
    or
    this.getMethod() instanceof FacesGetResponseWriterMethod
    or
    this.getMethod() instanceof FacesGetResponseStreamMethod
  }
}

/**
 * A xss vulnerable writer source node.
 */
class XssVulnerableWriterSourceNode extends ApiSourceNode {
  XssVulnerableWriterSourceNode() { this.asExpr() instanceof XssVulnerableWriterSource }
}

/**
 * Holds if `s` is an HTTP Content-Type vulnerable to XSS.
 */
bindingset[s]
predicate isXssVulnerableContentType(string s) {
  s.regexpMatch("(?i)(" +
      //
      "text/(html|xml|xsl|rdf|vtt|cache-manifest).*" + "|" +
      //
      "application/(.*\\+)?xml.*" + "|" +
      //
      "cache-manifest.*" + "|" +
      //
      "image/svg\\+xml.*" + ")")
}

/**
 * Holds if `s` is an HTTP Content-Type that is not vulnerable to XSS.
 */
bindingset[s]
predicate isXssSafeContentType(string s) { not isXssVulnerableContentType(s) }
