/** Definitions and configurations for the Polynomial ReDoS query */

private import semmle.code.java.regex.RegexTreeView::RegexTreeView as TreeView
import codeql.regex.nfa.SuperlinearBackTracking::Make<TreeView> as SuperlinearBackTracking
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.regex.RegexFlowConfigs
import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.Sanitizers

/** A sink for polynomial redos queries, where a regex is matched. */
class PolynomialRedosSink extends DataFlow::Node {
  TreeView::RegExpLiteral reg;

  PolynomialRedosSink() { regexMatchedAgainst(reg.getRegex(), this.asExpr()) }

  /** Gets the regex that is matched against this node. */
  TreeView::RegExpTerm getRegExp() { result.getParent() = reg }
}

/**
 * A method whose result typically has a limited length,
 * such as HTTP headers, and values derrived from them.
 */
private class LengthRestrictedMethod extends Method {
  LengthRestrictedMethod() {
    this.getName().toLowerCase().matches(["%header%", "%requesturi%", "%requesturl%", "%cookie%"])
    or
    this.getDeclaringType().getName().toLowerCase().matches("%cookie%") and
    this.getName().matches("get%")
    or
    this.getDeclaringType().getName().toLowerCase().matches("%request%") and
    this.getName().toLowerCase().matches(["%get%path%", "get%user%", "%querystring%"])
  }
}

/** A configuration for Polynomial ReDoS queries. */
module PolynomialRedosConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    exists(SuperlinearBackTracking::PolynomialBackTrackingTerm regexp |
      regexp.getRootTerm() = sink.(PolynomialRedosSink).getRegExp()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof SimpleTypeSanitizer or
    node.asExpr().(MethodCall).getMethod() instanceof LengthRestrictedMethod
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    exists(SuperlinearBackTracking::PolynomialBackTrackingTerm regexp |
      regexp.getRootTerm() = sink.(PolynomialRedosSink).getRegExp()
    |
      result = sink.getLocation()
      or
      result = regexp.getLocation()
    )
  }
}

module PolynomialRedosFlow = TaintTracking::Global<PolynomialRedosConfig>;
