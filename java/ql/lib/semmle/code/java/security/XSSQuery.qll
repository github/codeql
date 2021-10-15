/** Provides default sinks and sanitizers for XSS queries. */

import java
import XSS
import semmle.code.java.dataflow.ExternalFlow

private class DefaultXssSink extends XssSink {
  DefaultXssSink() {
    sinkNode(this, "xss")
    or
    exists(XssVulnerableWriterSourceToWritingMethodFlowConfig writer, MethodAccess ma |
      ma.getMethod() instanceof WritingMethod and
      writer.hasFlowToExpr(ma.getQualifier()) and
      this.asExpr() = ma.getArgument(_)
    )
  }
}

/** A default sanitizer that considers numeric and boolean typed data safe for writing to output. */
private class DefaultXSSSanitizer extends XssSanitizer {
  DefaultXSSSanitizer() {
    this.getType() instanceof NumericType or
    this.getType() instanceof BooleanType or
    // Match `org.springframework.web.util.HtmlUtils.htmlEscape` and possibly other methods like it.
    this.asExpr().(MethodAccess).getMethod().getName().regexpMatch("(?i)html_?escape.*")
  }
}

/** A configuration that tracks data from a servlet writer to an output method. */
private class XssVulnerableWriterSourceToWritingMethodFlowConfig extends TaintTracking2::Configuration {
  XssVulnerableWriterSourceToWritingMethodFlowConfig() {
    this = "XSS::XssVulnerableWriterSourceToWritingMethodFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof XssVulnerableWriterSource
  }

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
