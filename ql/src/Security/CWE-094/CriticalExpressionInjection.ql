/**
 * @name Expression injection in Actions
 * @description Using user-controlled GitHub Actions contexts like `run:` or `script:` may allow a malicious
 *              user to inject code into the GitHub action.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9
 * @precision high
 * @id actions/critical-expression-injection
 * @tags actions
 *       security
 *       external/cwe/cwe-094
 */

import actions
import codeql.actions.TaintTracking
import codeql.actions.dataflow.FlowSources
import codeql.actions.dataflow.ExternalFlow

private class ExpressionInjectionSink extends DataFlow::Node {
  ExpressionInjectionSink() {
    exists(Run e | e.getScript().getAnExpression() = this.asExpr()) or
    externallyDefinedSink(this, "expression-injection")
  }
}

private module MyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ExpressionInjectionSink }
}

module MyFlow = TaintTracking::Global<MyConfig>;

import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where
  MyFlow::flowPath(source, sink) and
  source
      .getNode()
      .asExpr()
      .getEnclosingWorkflow()
      .hasTriggerEvent(source.getNode().(RemoteFlowSource).getATriggerEvent())
select sink.getNode(), source, sink,
  "Potential expression injection in $@, which may be controlled by an external user.", sink,
  sink.getNode().asExpr().(ExpressionNode).getExpression()
