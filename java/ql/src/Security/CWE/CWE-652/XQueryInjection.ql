/**
 * @name XQuery query built from user-controlled sources
 * @description Building an XQuery query from user-controlled sources is vulnerable to insertion of
 *              malicious XQuery code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/XQuery-injection
 * @tags security
 *       external/cwe/cwe-652
 */

import java
import semmle.code.java.dataflow.FlowSources
import XQueryInjectionLib
import DataFlow::PathGraph

class XQueryInjectionConfig extends TaintTracking::Configuration {
  XQueryInjectionConfig() { this = "XQueryInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(XQueryExecuteCall execute).getPreparedExpression()
  }

  /**
   * Conveys taint from the input to a `prepareExpression` call to the returned prepared expression.
   */
  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(XQueryParserCall parser |
      pred.asExpr() = parser.getInput() and succ.asExpr() = parser)
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, XQueryInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "XQuery query might include code from $@.", source.getNode(),
  "this user input"
