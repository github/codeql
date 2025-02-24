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

/** A sanitizer that neutralizes dangerous characters that can be used to perform a XSS attack. */
abstract class XssSanitizer extends DataFlow::Node { }

/**
 * A sink that represent a method that outputs data without applying contextual
 * output encoding. Extend this class to add more sinks that should be
 * considered XSS sinks by every query. To find the full set of XSS sinks, use
 * `XssSink` instead.
 */
abstract class AbstractXssSink extends DataFlow::Node { }

/** A default sink representing methods susceptible to XSS attacks. */
private class DefaultXssSink extends AbstractXssSink {
  DefaultXssSink() { sinkNode(this, ["html-injection", "js-injection"]) }
}

/**
 * A sink that represent a method that outputs data without applying contextual
 * output encoding. To add more sinks, extend `AbstractXssSink` rather than
 * this class. To find XSS sinks efficiently for a diff-informed query, use the
 * `XssDiffInformed` module instead.
 */
final class XssSink extends ApiSinkNode instanceof XssDiffInformed<xssNotDiffInformed/0>::XssSink {
}

/**
 * A sink that represent a method that outputs data without applying contextual output encoding,
 * and which should truncate flow paths such that downstream sinks are not flagged as well.
 */
abstract class XssSinkBarrier extends AbstractXssSink { }

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

/** A default sanitizer that considers numeric and boolean typed data safe for writing to output. */
private class DefaultXssSanitizer extends XssSanitizer {
  DefaultXssSanitizer() {
    this.getType() instanceof NumericType or
    this.getType() instanceof BooleanType or
    // Match `org.springframework.web.util.HtmlUtils.htmlEscape` and possibly other methods like it.
    this.asExpr().(MethodCall).getMethod().getName().regexpMatch("(?i)html_?escape.*")
  }
}

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

/** A nullary predicate. */
signature predicate xssNullaryPredicate();

/** Holds always. Use this predicate as parameter to `XssDiffInformed` to disable diff-informed mode. */
predicate xssNotDiffInformed() { any() }

/**
 * A module for finding XSS sinks faster in a diff-informed query. The
 * `hasSourceInDiffRange` parameter should hold if the overall data-flow
 * configuration of the query has any sources in the diff range.
 */
module XssDiffInformed<xssNullaryPredicate/0 hasSourceInDiffRange> {
  final private class Node = DataFlow::Node;

  /**
   * A diff-informed replacement for the top-level `XssSink`, omitting for
   * efficiency some sinks that would never be reported by a diff-informed
   * query.
   */
  final class XssSink extends Node {
    XssSink() {
      this instanceof AbstractXssSink
      or
      isResponseWriterSink(this)
    }
  }

  predicate isResponseWriterSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      // This code mirrors `getASelectedSinkLocation`.
      ma.getMethod() instanceof WritingMethod and
      XssVulnerableWriterSourceToWritingMethodFlow::flowToExpr(ma.getQualifier()) and
      sink.asExpr() = ma.getArgument(_)
    )
  }

  /** A configuration that tracks data from a servlet writer to an output method. */
  private module XssVulnerableWriterSourceToWritingMethodFlowConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node src) { src instanceof XssVulnerableWriterSourceNode }

    predicate isSink(DataFlow::Node sink) {
      exists(MethodCall ma |
        sink.asExpr() = ma.getQualifier() and ma.getMethod() instanceof WritingMethod
      )
    }

    predicate observeDiffInformedIncrementalMode() {
      // Since this configuration is for finding sinks to be used in a main
      // data-flow configuration, this configuration should only restrict the
      // sinks to be found if there are no main-configuration sources in the
      // diff range. That's because if there is such a source, we need to
      // report query results for it even with sinks outside the diff range.
      not hasSourceInDiffRange()
    }

    // The sources are not exposed outside this file module, so we know the
    // query will not select them.
    Location getASelectedSourceLocation(DataFlow::Node source) { none() }

    Location getASelectedSinkLocation(DataFlow::Node sink) {
      // This code mirrors `isResponseWriterSink`.
      exists(MethodCall ma | result = ma.getAnArgument().getLocation() |
        sink.asExpr() = ma.getQualifier() and ma.getMethod() instanceof WritingMethod
      )
    }
  }

  private module XssVulnerableWriterSourceToWritingMethodFlow =
    TaintTracking::Global<XssVulnerableWriterSourceToWritingMethodFlowConfig>;
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
