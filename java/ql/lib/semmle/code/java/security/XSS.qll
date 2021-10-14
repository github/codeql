/** Provides classes to reason about Cross-site scripting (XSS) vulnerabilities. */

import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.frameworks.android.WebView
import semmle.code.java.frameworks.spring.SpringController
import semmle.code.java.frameworks.spring.SpringHttp
import semmle.code.java.frameworks.javaee.jsf.JSFRenderer
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking2

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

/** An output stream or writer that writes to a servlet, JSP or JSF response. */
class XssVulnerableWriterSource extends MethodAccess {
  XssVulnerableWriterSource() {
    this.getMethod() instanceof ServletResponseGetWriterMethod
    or
    this.getMethod() instanceof ServletResponseGetOutputStreamMethod
    or
    exists(Method m | m = this.getMethod() |
      m.getDeclaringType().getQualifiedName() = "javax.servlet.jsp.JspContext" and
      m.getName() = "getOut"
    )
    or
    this.getMethod() instanceof FacesGetResponseWriterMethod
    or
    this.getMethod() instanceof FacesGetResponseStreamMethod
  }
}

/**
 * DEPRECATED: Use `XssVulnerableWriterSource` instead.
 */
deprecated class ServletWriterSource = XssVulnerableWriterSource;

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
