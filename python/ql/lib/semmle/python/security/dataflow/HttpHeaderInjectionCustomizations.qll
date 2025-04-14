/**
 * Provides default sources, sinks, and sanitizers for detecting
 * "HTTP Header injection" vulnerabilities, as well as extension
 * points for adding your own.
 */

import python
private import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources

/**
 * Provides default sources, sinks, and sanitizers for detecting
 * "HTTP Header injection" vulnerabilities, as well as extension
 * points for adding your own.
 */
module HttpHeaderInjection {
  /**
   * A data flow source for "HTTP Header injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "HTTP Header injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A data flow sanitizer for "HTTP Header injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A HTTP header write, considered as a flow sink.
   */
  class HeaderWriteAsSink extends Sink {
    HeaderWriteAsSink() {
      exists(Http::Server::ResponseHeaderWrite headerWrite |
        headerWrite.nameAllowsNewline() and
        this = headerWrite.getNameArg()
        or
        headerWrite.valueAllowsNewline() and
        this = headerWrite.getValueArg()
      )
    }
  }

  /**
   * A call to replace line breaks, considered as a sanitizer.
   */
  class ReplaceLineBreaksSanitizer extends Sanitizer, DataFlow::CallCfgNode {
    ReplaceLineBreaksSanitizer() {
      this.getFunction().(DataFlow::AttrRead).getAttributeName() = "replace" and
      this.getArg(0).asExpr().(StringLiteral).getText() = "\n"
    }
  }
}
