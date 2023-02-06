/**
 * Provides default sources, sinks and sanitizers for detecting
 * "polynomial regular expression denial of service (ReDoS)"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.DataFlow2
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.RegexTreeView::RegexTreeView as TreeView
private import semmle.python.ApiGraphs
private import semmle.python.regex

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "polynomial regular expression denial of service (ReDoS)"
 * vulnerabilities, as well as extension points for adding your own.
 */
module PolynomialReDoS {
  private import TreeView
  import codeql.regex.nfa.SuperlinearBackTracking::Make<TreeView>

  /**
   * A data flow source for "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets the regex that is being executed by this node. */
    abstract RegExpTerm getRegExp();

    /**
     * Gets the node to highlight in the alert message.
     */
    DataFlow::Node getHighlight() { result = this }
  }

  /**
   * A sanitizer for "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `Sanitizer` instead.
   *
   * A sanitizer guard for "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
   */
  abstract deprecated class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A regex execution, considered as a flow sink.
   */
  class RegexExecutionAsSink extends Sink {
    RegExpTerm t;

    RegexExecutionAsSink() {
      exists(RegexExecution re |
        t = getTermForExecution(re) and
        this = re.getString()
      ) and
      t.isRootTerm()
    }

    /** Gets the regex that is being executed by this node. */
    override RegExpTerm getRegExp() { result = t }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends Sanitizer, StringConstCompareBarrier { }
}
