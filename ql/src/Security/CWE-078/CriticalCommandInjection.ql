/**
 * @name Command built from user-controlled sources
 * @description Building a system command from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9
 * @precision high
 * @id actions/command-injection
 * @tags actions
 *       security
 *       external/cwe/cwe-078
 */

import actions
import codeql.actions.TaintTracking
import codeql.actions.dataflow.FlowSources
import codeql.actions.dataflow.ExternalFlow

private class CommandInjectionSink extends DataFlow::Node {
  CommandInjectionSink() { externallyDefinedSink(this, "command-injection") }
}

private module MyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CommandInjectionSink }
}

module MyFlow = TaintTracking::Global<MyConfig>;

import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink, Workflow w
where
  MyFlow::flowPath(source, sink) and
  w = source.getNode().asExpr().getEnclosingWorkflow() and
  (
    w instanceof ReusableWorkflow or
    w.hasTriggerEvent(source.getNode().(RemoteFlowSource).getATriggerEvent())
  )
select sink.getNode(), source, sink,
  "Potential expression injection in $@, which may be controlled by an external user.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
