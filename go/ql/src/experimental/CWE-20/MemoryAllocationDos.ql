/**
 * @name User-controlled data control memory allocation size
 * @description Using a user input value to memory allocation size
 * @kind path-problem
 * @problem.severity error
 * @id go/allow-memory-size-injection
 * @problem.severity 7.1
 * @tag security
 *      experimental
 *      external/cwe/cwe-023
 */

import go
import semmle.go.security.FlowSources
import DataFlow
import semmle.go.security.AllocationSizeOverflow
import DataFlow::PathGraph

module MemoryAllocationDos {
  abstract class Source extends DataFlow::Node { }

  abstract class Sanitizer extends DataFlow::Node { }

  // If developer comparison size, it should be safe
  class CompSanitizer extends Sanitizer {
    CompSanitizer() {
      exists(RelationalComparisonExpr r |
        TaintTracking::localTaintStep(this, DataFlow::exprNode(r.getGreaterOperand()))
      )
    }
  }

  string macaronContextPath() { result = "gopkg.in/macaron.v1" }

  class UntrustedFlowAsSource extends Source instanceof UntrustedFlowSource { }

  class MacaronInputSource extends Source, DataFlow::MethodCallNode {
    string methodName;

    MacaronInputSource() {
      exists( | this.getTarget().hasQualifiedName(macaronContextPath(), "Context", methodName)) and
      methodName in ["QueryInt", "QueryInt64"]
    }
  }

  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "MemoryAllocationDos" }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof AllocationSizeOverflow::AllocationSize
    }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
      exists(CallNode call |
        node2 = call and
        call.getTarget().hasQualifiedName("strconv", "Atoi") and
        call.getArgument(0) = node1
      )
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof Sanitizer
    }
  }
}

from MemoryAllocationDos::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Untrusted memory allocation size depends on a $@.",
  source.getNode(), "user-provided value"
