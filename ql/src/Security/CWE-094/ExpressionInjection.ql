/**
 * @name Expression injection in Actions
 * @description Using user-controlled GitHub Actions contexts like `run:` or `script:` may allow a malicious
 *              user to inject code into the GitHub action.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id actions/command-injection
 * @tags actions
 *       security
 *       external/cwe/cwe-094
 */

import actions
import codeql.actions.TaintTracking
import codeql.actions.dataflow.FlowSources

private class ExpressionInjectionSink extends DataFlow::Node {
  ExpressionInjectionSink() { exists(RunExpr e | e.getScriptExpr() = this.asExpr()) }
}

private module MyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ExpressionInjectionSink }
  //predicate isSink(DataFlow::Node sink) { any() }
  //predicate neverSkip(DataFlow::Node node) { any() }
}

module MyFlow = TaintTracking::Global<MyConfig>;

import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Potential injection from the ${{ " + sink.getNode().asExpr().(ExprAccessExpr).getExpression() +
    " }}, which may be controlled by an external user."
