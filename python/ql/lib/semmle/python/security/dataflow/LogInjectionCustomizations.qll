/**
 * Provides default sources, sinks and sanitizers for detecting
 * "command injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "command injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module LogInjection {
  /**
   * A data flow source for "command injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "command injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "command injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "command injection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A logging operation, considered as a flow sink.
   */
  class LoggingAsSink extends Sink {
    LoggingAsSink() { this = any(Logging write).getAnInput() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }

  /**
   * A call to replace line breaks functions as a sanitizer.
   */
  class ReplaceLineBreaksSanitizer extends Sanitizer, DataFlow::CallCfgNode {
    ReplaceLineBreaksSanitizer() {
      this.getFunction().(DataFlow::AttrRead).getAttributeName() = "replace" and
      this.getArg(0).asExpr().(StrConst).getText() in ["\r\n", "\n"]
    }
  }
}
