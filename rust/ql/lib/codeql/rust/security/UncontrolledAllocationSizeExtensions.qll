/**
 * Provides classes and predicates for reasoning about uncontrolled allocation
 * size vulnerabilities.
 */

import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink

/**
 * Provides default sources, sinks and barriers for detecting uncontrolled
 * allocation size vulnerabilities, as well as extension points for adding your own.
 */
module UncontrolledAllocationSize {
  /**
   * A data flow sink for uncontrolled allocation size vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "UncontrolledAllocationSize" }
  }

  /**
   * A barrier for uncontrolled allocation size vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A sink for uncontrolled allocation size from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, ["alloc-size", "alloc-layout"]) }
  }

  /**
   * A barrier for uncontrolled allocation size that is an upper bound check / guard.
   */
  private class UpperBoundCheckBarrier extends Barrier {
    UpperBoundCheckBarrier() {
      this = DataFlow::BarrierGuard<isUpperBoundCheck/3>::getABarrierNode()
    }
  }

  /**
   * Holds if comparison `g` having result `branch` indicates an upper bound for the sub-expression
   * `e`. For example when the comparison `x < 10` is true, we have an upper bound for `x`.
   */
  private predicate isUpperBoundCheck(AstNode g, Expr e, boolean branch) {
    g =
      any(BinaryExpr cmp |
        e = cmp.(RelationalOperation).getLesserOperand() and
        branch = true
        or
        e = cmp.(RelationalOperation).getGreaterOperand() and
        branch = false
        or
        cmp instanceof EqualsOperation and
        [cmp.getLhs(), cmp.getRhs()] = e and
        branch = true
        or
        cmp instanceof NotEqualsOperation and
        [cmp.getLhs(), cmp.getRhs()] = e and
        branch = false
      )
  }

  /**
   * A barrier for uncontrolled allocation size flow into particular functions.
   */
  private class ModeledBarrier extends Barrier {
    ModeledBarrier() {
      exists(MethodCall c |
        c.getStaticTarget().getCanonicalPath() =
          ["<alloc::string::String>::split_off", "<alloc::vec::Vec>::split_off"] and
        this.asExpr() = c.getAnArgument()
      )
    }
  }
}
