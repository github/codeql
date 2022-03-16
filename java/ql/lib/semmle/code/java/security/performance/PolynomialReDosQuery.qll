/** Definitions and configurations for the Polynomial ReDos query */

import semmle.code.java.security.performance.SuperlinearBackTracking
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.regex.RegexTreeView
import semmle.code.java.regex.RegexFlowConfigs
import semmle.code.java.dataflow.FlowSources

/** A sink for polynomial redos queries, where a regex is matched. */
class PolynomialRedosSink extends DataFlow::Node {
  RegExpLiteral reg;

  PolynomialRedosSink() { regexMatchedAgainst(reg.getRegex(), this.asExpr()) }

  /** Gets the regex that is matched against this node. */
  RegExpTerm getRegExp() { result.getParent() = reg }
}

/** A configuration for Polynomial ReDoS queries. */
class PolynomialRedosConfig extends TaintTracking::Configuration {
  PolynomialRedosConfig() { this = "PolynomialRedosConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PolynomialRedosSink }
}

/** Holds if there is flow from `source` to `sink` that is matched against the regexp term `regexp` that is vulnerable to Polynomial ReDoS. */
predicate hasPolynomialReDosResult(
  DataFlow::PathNode source, DataFlow::PathNode sink, PolynomialBackTrackingTerm regexp
) {
  any(PolynomialRedosConfig config).hasFlowPath(source, sink) and
  regexp.getRootTerm() = sink.getNode().(PolynomialRedosSink).getRegExp()
}
