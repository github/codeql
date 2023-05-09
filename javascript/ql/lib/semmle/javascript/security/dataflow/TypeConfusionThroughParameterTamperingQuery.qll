/**
 * Provides a tracking configuration for reasoning about type
 * confusion for HTTP request inputs.
 *
 * Note, for performance reasons: only import this file if
 * `TypeConfusionThroughParameterTampering::Configuration` is needed,
 * otherwise `TypeConfusionThroughParameterTamperingCustomizations`
 * should be imported instead.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
import TypeConfusionThroughParameterTamperingCustomizations::TypeConfusionThroughParameterTampering

/**
 * A taint tracking configuration for type confusion for HTTP request inputs.
 */
class Configuration extends DataFlow::Configuration {
  Configuration() { this = "TypeConfusionThroughParameterTampering" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof Sink and
    sink.analyze().getAType() = TTString() and
    sink.analyze().getAType() = TTObject()
  }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node)
    or
    node instanceof Barrier
  }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
    guard instanceof TypeOfTestBarrier or
    guard instanceof IsArrayBarrier
  }
}

private class TypeOfTestBarrier extends DataFlow::BarrierGuardNode, DataFlow::ValueNode {
  override EqualityTest astNode;

  TypeOfTestBarrier() { TaintTracking::isTypeofGuard(astNode, _, _) }

  override predicate blocks(boolean outcome, Expr e) {
    exists(string tag |
      TaintTracking::isTypeofGuard(astNode, e, tag) and
      if tag = ["string", "object"]
      then outcome = [true, false] // separation between string/array removes type confusion in both branches
      else outcome = astNode.getPolarity() // block flow to branch where value is neither string nor array
    )
  }
}

private class IsArrayBarrier extends DataFlow::BarrierGuardNode, DataFlow::CallNode {
  IsArrayBarrier() { this = DataFlow::globalVarRef("Array").getAMemberCall("isArray") }

  override predicate blocks(boolean outcome, Expr e) {
    e = this.getArgument(0).asExpr() and
    outcome = [true, false] // separation between string/array removes type confusion in both branches
  }
}
