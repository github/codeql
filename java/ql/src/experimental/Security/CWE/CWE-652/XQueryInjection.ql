/**
 * @name XQuery query built from user-controlled sources
 * @description Building an XQuery query from user-controlled sources is vulnerable to insertion of
 *              malicious XQuery code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/xquery-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-652
 */

import java
import semmle.code.java.dataflow.FlowSources
deprecated import XQueryInjectionLib
deprecated import XQueryInjectionFlow::PathGraph

/**
 * A taint-tracking configuration tracing flow from remote sources, through an XQuery parser, to its eventual execution.
 */
deprecated module XQueryInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(XQueryPreparedExecuteCall xpec).getPreparedExpression() or
    sink.asExpr() = any(XQueryExecuteCall xec).getExecuteQueryArgument() or
    sink.asExpr() = any(XQueryExecuteCommandCall xecc).getExecuteCommandArgument()
  }

  /**
   * Holds if taint from the input `pred` to a `prepareExpression` call flows to the returned prepared expression `succ`.
   */
  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(XQueryParserCall parser | pred.asExpr() = parser.getInput() and succ.asExpr() = parser)
  }
}

/**
 * Taint-tracking flow from remote sources, through an XQuery parser, to its eventual execution.
 */
deprecated module XQueryInjectionFlow = TaintTracking::Global<XQueryInjectionConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, XQueryInjectionFlow::PathNode source, XQueryInjectionFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  XQueryInjectionFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "XQuery query might include code from $@." and
  sourceNode = source.getNode() and
  message2 = "this user input"
}
