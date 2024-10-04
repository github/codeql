/**
 * Provides default sources, sinks and sanitizers for detecting
 * "polynomial regular expression denial of service (ReDoS)"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.regexp.RegexTreeView::RegexTreeView as TreeView
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
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

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
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsSanitizerGuard extends Sanitizer, ConstCompareBarrier { }

  /** DEPRECATED: Use ConstCompareAsSanitizerGuard instead. */
  deprecated class StringConstCompareAsSanitizerGuard = ConstCompareAsSanitizerGuard;
}
