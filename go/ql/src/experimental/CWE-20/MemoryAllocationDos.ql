/**
 * @name User-controlled size of a memory allocation operation
 * @description Allowing a user to influence the size of a memory allocation could lead to denial of service attacks
 * @kind path-problem
 * @problem.severity error
 * @id go/allow-memory-size-injection
 * @tag security
 *      experimental
 *      external/cwe/cwe-023
 */

import go
import semmle.go.security.FlowSources
import semmle.go.security.AllocationSizeOverflow
import DataFlow::PathGraph

abstract class Source extends DataFlow::Node { }

abstract class Sanitizer extends DataFlow::Node { }

private predicate compCheckGuard(DataFlow::Node g, Expr e) {
  e = g.(DataFlow::RelationalComparisonNode).getAnOperand().asExpr()
}

class CompSanitizer2 extends Sanitizer {
  CompSanitizer2() {
    exists(
      ControlFlow::ConditionGuardNode guard, SsaWithFields var, boolean branch, DataFlow::Node g
    |
      this = var.similar().getAUse()
    |
      compCheckGuard(g, var.getAUse().asExpr()) and guard.ensures(g, branch)
    )
  }
}

string macaronContextPath() { result = package("gopkg.in/macaron", "") }

class UntrustedFlowAsSource extends Source instanceof UntrustedFlowSource { }

class MacaronInputSource extends Source, DataFlow::MethodCallNode {
  MacaronInputSource() {
    this.getTarget().hasQualifiedName(macaronContextPath(), "Context", ["QueryInt", "QueryInt64"])
  }
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "MemoryAllocationDos" }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof AllocationSizeOverflow::AllocationSize
  }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(DataFlow::CallNode call |
      node2 = call and
      call.getTarget().hasQualifiedName("strconv", ["Atoi", "ParseInt", "ParseUint"]) and
      call.getArgument(0) = node1
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted memory allocation size depends on a $@.",
  source.getNode(), "user-provided value"
