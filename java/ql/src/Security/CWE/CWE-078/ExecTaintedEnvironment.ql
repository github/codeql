/**
 * @name ExecTaintedEnvironment.ql
 * @description Using tainted data in a call to exec() may allow an attacker to execute arbitrary commands.
 * @problem.severity error
 * @kind path-problem
 * @precision medium
 * @id java/exec-tainted-environment
 * @tags security
 *     external/cwe/cwe-078
 *    external/cwe/cwe-088
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources

class ExecMethod extends Method {
  ExecMethod() {
    this.hasName("exec") and
    this.getDeclaringType().hasQualifiedName("java.lang", "Runtime")
  }
}

module ExecTaintedEnvironmentConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof ExecMethod and sink.asExpr() = ma.getArgument(1)
    )
  }
}

module ExecTaintedEnvironmentFlow = TaintTracking::Global<ExecTaintedEnvironmentConfig>;

import ExecTaintedEnvironmentFlow::PathGraph

from ExecTaintedEnvironmentFlow::PathNode source, ExecTaintedEnvironmentFlow::PathNode sink
where ExecTaintedEnvironmentFlow::flowPath(source, sink)
select sink.getNode(), sink, source, "This command will be executed in a $@.", sink.getNode(),
  "tainted environment"
