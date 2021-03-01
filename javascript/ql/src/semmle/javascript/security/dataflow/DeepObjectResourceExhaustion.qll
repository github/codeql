/**
 * Provides a taint tracking configuration for reasoning about DoS attacks
 * due to inefficient handling of user-controlled objects.
 */

import javascript
import semmle.javascript.security.TaintedObject

/**
 * Provides a taint tracking configuration for reasoning about DoS attacks
 * due to inefficient handling of user-controlled objects.
 */
module DeepObjectResourceExhaustion {
  import DeepObjectResourceExhaustionCustomizations::DeepObjectResourceExhaustion

  /**
   * A taint tracking configuration for reasoning about DoS attacks due to inefficient handling
   * of user-controlled objects.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "DeepObjectResourceExhaustion" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      source instanceof Source and label = TaintedObject::label()
      or
      // We currently can't expose the TaintedObject label in the Customizations library
      // so just add its default sources here.
      source instanceof TaintedObject::Source and label = TaintedObject::label()
      or
      source instanceof RemoteFlowSource and label.isTaint()
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      sink instanceof Sink and label = TaintedObject::label()
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof TaintedObject::SanitizerGuard
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
    ) {
      TaintedObject::step(src, trg, inlbl, outlbl)
    }
  }
}
