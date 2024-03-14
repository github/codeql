/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user to perform arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id actions/code-injection
 * @tags actions
 *       security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-116
 */

import actions
import codeql.actions.TaintTracking
import codeql.actions.dataflow.FlowSources
import codeql.actions.dataflow.ExternalFlow

private class CodeInjectionSink extends DataFlow::Node {
  CodeInjectionSink() { externallyDefinedSink(this, "code-injection") }
}

private module MyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CodeInjectionSink }
}

module MyFlow = TaintTracking::Global<MyConfig>;

import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Potential code injection in $@, which may be controlled by an external user.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
