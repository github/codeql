/**
 * Provides default sources, sinks and sanitizers for detecting
 * "regular expression injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "regular expression injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module RegexInjection {
  /**
   * A data flow source for "regular expression injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A sink for "regular expression injection" vulnerabilities is the execution of a regular expression.
   * If you have a custom way to execute regular expressions, you can extend `RegexExecution::Range`.
   */
  class Sink extends DataFlow::Node {
    RegexExecution regexExecution;

    Sink() { this = regexExecution.getRegex() }

    /** Gets the call that executes the regular expression marked by this sink. */
    RegexExecution getRegexExecution() { result = regexExecution }
  }

  /**
   * A sanitizer for "regular expression injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "regular expression injection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A regex escaping, considered as a sanitizer.
   */
  class RegexEscapingAsSanitizer extends Sanitizer {
    RegexEscapingAsSanitizer() {
      // Due to use-use flow, we want the output rather than an input
      // (so the input can still flow to other sinks).
      this = any(RegexEscaping esc).getOutput()
    }
  }
}
