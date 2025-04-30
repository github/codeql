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
 * Data flow configuration for type confusion for HTTP request inputs.
 */
module TypeConfusionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof Sink and
    sink.analyze().getAType() = TTString() and
    sink.analyze().getAType() = TTObject()
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Barrier or node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Data flow for type confusion for HTTP request inputs.
 */
module TypeConfusionFlow = DataFlow::Global<TypeConfusionConfig>;

private class TypeOfTestBarrier extends BarrierGuard, DataFlow::ValueNode {
  override EqualityTest astNode;

  TypeOfTestBarrier() { TaintTracking::isTypeofGuard(astNode, _, _) }

  override predicate blocksExpr(boolean outcome, Expr e) {
    exists(string tag |
      TaintTracking::isTypeofGuard(astNode, e, tag) and
      if tag = ["string", "object"]
      then outcome = [true, false] // separation between string/array removes type confusion in both branches
      else outcome = astNode.getPolarity() // block flow to branch where value is neither string nor array
    )
  }
}

private class IsArrayBarrier extends BarrierGuard, DataFlow::CallNode {
  IsArrayBarrier() { this = DataFlow::globalVarRef("Array").getAMemberCall("isArray") }

  override predicate blocksExpr(boolean outcome, Expr e) {
    e = this.getArgument(0).asExpr() and
    outcome = [true, false] // separation between string/array removes type confusion in both branches
  }
}

/**
 * DEPRECATED. Use the `TypeConfusionFlow` module instead.
 */
deprecated class Configuration extends DataFlow::Configuration {
  Configuration() { this = "TypeConfusionThroughParameterTampering" }

  override predicate isSource(DataFlow::Node source) { TypeConfusionConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TypeConfusionConfig::isSink(sink) }

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
