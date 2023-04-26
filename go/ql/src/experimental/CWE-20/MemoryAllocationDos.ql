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
import semmle.go.security.AllocationSizeOverflow
import semmle.go.frameworks.Stdlib
import DataFlow::PathGraph

abstract class Source extends DataFlow::Node { }

abstract class Sanitizer extends DataFlow::Node { }

private SsaWithFields getAComparedVar() {
  exists(RelationalComparisonExpr e |
    not e.getLesserOperand().isConst() or e.getLesserOperand().getIntValue() != 0
  |
    result.getAUse().asExpr() = e.getGreaterOperand()
  )
}

class CompSanitizer extends Sanitizer {
  CompSanitizer() { this = getAComparedVar().similar().getAUse() }
}

class FieldReadSanitizer extends Sanitizer {
  FieldReadSanitizer() {
    exists(DataFlow::FieldReadNode f |
      f.asExpr() = any(RelationalComparisonExpr e).getGreaterOperand()
    |
      this.asInstruction() = f.asInstruction().getASuccessor+()
    )
  }
}

private predicate compCheckGuard(DataFlow::Node g, Expr e, boolean outcome) {
  e = g.(DataFlow::RelationalComparisonNode).getAnOperand().asExpr() and
  outcome = [true, false]
}

class CompSanitizerGuard extends Sanitizer {
  CompSanitizerGuard() { this = DataFlow::BarrierGuard<compCheckGuard/3>::getABarrierNode() }
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
      node2 = call.getResult(0) and
      call.getTarget() instanceof IntegerParser::Range and
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
