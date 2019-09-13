/**
 * Provides a taint tracking configuration for reasoning about DoS attacks
 * using a user-controlled object with an unbounded .length property.
 *
 * Note, for performance reasons: only import this file if
 * `LoopBoundInjection::Configuration` is needed, otherwise
 * `LoopBoundInjectionCustomizations` should be imported instead.
 */

import javascript
import semmle.javascript.security.TaintedObject

module LoopBoundInjection {
  import LoopBoundInjectionCustomizations::LoopBoundInjection

  /**
   * A taint tracking configuration for reasoning about looping on tainted objects with unbounded length.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "LoopBoundInjection" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      source instanceof Source and label = TaintedObject::label()
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      sink instanceof Sink and label = TaintedObject::label()
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof TaintedObject::SanitizerGuard or
      guard instanceof IsArraySanitizerGuard or
      guard instanceof InstanceofArraySanitizerGuard or
      guard instanceof LengthCheckSanitizerGuard
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
    ) {
      TaintedObject::step(src, trg, inlbl, outlbl)
    }
  }
}
