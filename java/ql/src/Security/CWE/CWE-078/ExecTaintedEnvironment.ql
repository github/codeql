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
import semmle.code.java.dataflow.ExternalFlow

class ExecMethod extends Method {
  ExecMethod() {
    this.hasName("exec") and
    this.getDeclaringType().hasQualifiedName("java.lang", "Runtime")
  }
}

module ProcessBuilderEnvironmentFlow implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getType().(RefType).hasQualifiedName("java.lang", "ProcessBuilder")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma | ma.getQualifier() = sink.asExpr() |
      ma.getMethod().hasName("environment")
    )
  }
}

module ExecTaintedEnvironmentConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { sinkNode(sink, "environment-injection") }
}

module ExecTaintedEnvironmentFlow = TaintTracking::Global<ExecTaintedEnvironmentConfig>;

from Flow::PathNode source, Flow::PathNode sink, string label
where
  ExecTaintedCommandFlow::flowPath(source.asPathNode1(), sink.asPathNode1()) and label = "argument"
  or
  ExecTaintedEnvironmentFlow::flowPath(source.asPathNode2(), sink.asPathNode2()) and
  label = "environment"
select sink.getNode(), sink, source, "This command will be execute with a tainted $@.",
  sink.getNode(), label
