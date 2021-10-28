/**
 * Provides a taint-tracking configuration for reasoning about method invocations
 * with a user-controlled method name on objects with unsafe methods.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeDynamicMethodAccess::Configuration` is needed, otherwise
 * `UnsafeDynamicMethodAccessCustomizations` should be imported instead.
 */

import javascript
import PropertyInjectionShared
private import DataFlow::FlowLabel
import UnsafeDynamicMethodAccessCustomizations::UnsafeDynamicMethodAccess

// Materialize flow labels
private class ConcreteUnsafeFunction extends UnsafeFunction {
  ConcreteUnsafeFunction() { this = this }
}

/**
 * A taint-tracking configuration for reasoning about unsafe dynamic method access.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeDynamicMethodAccess" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source.(Source).getFlowLabel() = label
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink.(Sink).getFlowLabel() = label
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    or
    node instanceof Sanitizer
    or
    exists(StringConcatenation::getOperand(node, _)) and
    not StringConcatenation::isCoercion(node)
  }

  /**
   * Holds if a property of the given object is an unsafe function.
   */
  predicate hasUnsafeMethods(DataFlow::SourceNode node) {
    PropertyInjection::hasUnsafeMethods(node) // Redefined here so custom queries can override it
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    // Reading a property of the global object or of a function
    exists(DataFlow::PropRead read |
      hasUnsafeMethods(read.getBase().getALocalSource()) and
      src = read.getPropertyNameExpr().flow() and
      dst = read and
      srclabel.isTaint() and
      dstlabel = unsafeFunction()
    )
    or
    // Reading a chain of properties from any object with a prototype can lead to Function
    exists(PropertyProjection proj |
      not PropertyInjection::isPrototypeLessObject(proj.getObject().getALocalSource()) and
      src = proj.getASelector() and
      dst = proj and
      srclabel.isTaint() and
      dstlabel = unsafeFunction()
    )
  }
}
