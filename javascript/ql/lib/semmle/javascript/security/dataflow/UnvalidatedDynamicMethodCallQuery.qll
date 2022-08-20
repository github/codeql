/**
 * Provides a taint-tracking configuration for reasoning about
 * unvalidated dynamic method calls.
 *
 * Note, for performance reasons: only import this file if
 * `UnvalidatedDynamicMethodCall::Configuration` is needed, otherwise
 * `UnvalidatedDynamicMethodCallCustomizations` should be imported
 * instead.
 */

import javascript
import semmle.javascript.frameworks.Express
import PropertyInjectionShared
private import semmle.javascript.dataflow.InferredTypes
import UnvalidatedDynamicMethodCallCustomizations::UnvalidatedDynamicMethodCall
private import DataFlow::FlowLabel

// Materialize flow labels
private class ConcreteMaybeNonFunction extends MaybeNonFunction {
  ConcreteMaybeNonFunction() { this = this }
}

private class ConcreteMaybeFromProto extends MaybeFromProto {
  ConcreteMaybeFromProto() { this = this }
}

/**
 * A taint-tracking configuration for reasoning about unvalidated dynamic method calls.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnvalidatedDynamicMethodCall" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getFlowLabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getFlowLabel() = label
  }

  override predicate isSanitizerEdge(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel lbl
  ) {
    any(Sanitizer s).sanitizes(pred, succ, lbl)
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof NumberGuard or
    guard instanceof FunctionCheck
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    exists(DataFlow::PropRead read |
      src = read.getPropertyNameExpr().flow() and
      dst = read and
      srclabel.isTaint() and
      (
        dstlabel instanceof MaybeNonFunction
        or
        // a property of `Object.create(null)` cannot come from a prototype
        not PropertyInjection::isPrototypeLessObject(read.getBase().getALocalSource()) and
        dstlabel instanceof MaybeFromProto
      ) and
      // avoid overlapping results with unsafe dynamic method access query
      not PropertyInjection::hasUnsafeMethods(read.getBase().getALocalSource())
    )
    or
    exists(DataFlow::SourceNode base, DataFlow::CallNode get | get = base.getAMethodCall("get") |
      src = get.getArgument(0) and
      dst = get
    ) and
    srclabel.isTaint() and
    dstlabel instanceof MaybeNonFunction
  }
}
