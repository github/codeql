/**
 * @name Polynomial regular expression used on uncontrolled data
 * @description A regular expression that can require polynomial time
 *              to match may be vulnerable to denial-of-service attacks.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id java/polynomial-redos
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import java
import semmle.code.java.security.performance.SuperlinearBackTracking
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.regex.RegexTreeView
import semmle.code.java.regex.RegexFlowConfigs
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class PolynomialRedosSink extends DataFlow::Node {
  RegExpLiteral reg;

  PolynomialRedosSink() { regexMatchedAgainst(reg.getRegex(), this.asExpr()) }

  RegExpTerm getRegExp() { result = reg }
}

class PolynomialRedosConfig extends TaintTracking::Configuration {
  PolynomialRedosConfig() { this = "PolynomialRodisConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PolynomialRedosSink }
}

from
  PolynomialRedosConfig config, DataFlow::PathNode source, DataFlow::PathNode sink,
  PolynomialRedosSink sinkNode, PolynomialBackTrackingTerm regexp
where
  config.hasFlowPath(source, sink) and
  sinkNode = sink.getNode() and
  regexp.getRootTerm() = sinkNode.getRegExp()
select sinkNode, source, sink,
  "This $@ that depends on $@ may run slow on strings " + regexp.getPrefixMessage() +
    "with many repetitions of '" + regexp.getPumpString() + "'.", regexp, "regular expression",
  source.getNode(), "a user-provided value"
