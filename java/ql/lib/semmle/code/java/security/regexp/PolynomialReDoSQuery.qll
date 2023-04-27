/** Definitions and configurations for the Polynomial ReDoS query */

private import semmle.code.java.regex.RegexTreeView::RegexTreeView as TreeView
import codeql.regex.nfa.SuperlinearBackTracking::Make<TreeView> as SuperlinearBackTracking
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.regex.RegexFlowConfigs
import semmle.code.java.dataflow.FlowSources

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

/**
 * DEPRECATED: Use `PolynomialRedosFlow` instead.
 *
 * A configuration for Polynomial ReDoS queries.
 */
deprecated class PolynomialRedosConfig extends TaintTracking::Configuration {
  PolynomialRedosConfig() { this = "PolynomialRedosConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PolynomialRedosSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.asExpr().(MethodAccess).getMethod() instanceof LengthRestrictedMethod
  }
}

/**
 * DEPRECATED: Use `PolynomialRedosFlow` instead.
 *
 * Holds if there is flow from `source` to `sink` that is matched against the regexp term `regexp` that is vulnerable to Polynomial ReDoS.
 */
deprecated predicate hasPolynomialReDoSResult(
  DataFlow::PathNode source, DataFlow::PathNode sink,
  SuperlinearBackTracking::PolynomialBackTrackingTerm regexp
) {
  any(PolynomialRedosConfig config).hasFlowPath(source, sink) and
  regexp.getRootTerm() = sink.getNode().(PolynomialRedosSink).getRegExp()
}

/** A configuration for Polynomial ReDoS queries. */
module PolynomialRedosConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(SuperlinearBackTracking::PolynomialBackTrackingTerm regexp |
      regexp.getRootTerm() = sink.(PolynomialRedosSink).getRegExp()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node.asExpr().(MethodAccess).getMethod() instanceof LengthRestrictedMethod
  }
}

module PolynomialRedosFlow = TaintTracking::Global<PolynomialRedosConfig>;
