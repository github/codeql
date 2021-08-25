/**
 * Provides a taint-tracking configuration for tracking
 * user-controlled objects flowing into a vulnerable `extends` call.
 *
 * Note, for performance reasons: only import this file if
 * `PrototypePollution::Configuration` is needed, otherwise
 * `PrototypePollutionCustomizations` should be imported instead.
 */

import javascript
import semmle.javascript.security.TaintedObject
import semmle.javascript.dependencies.Dependencies
import semmle.javascript.dependencies.SemVer
import PrototypePollutionCustomizations::PrototypePollution

// Materialize flow labels
private class ConcreteTaintedObjectWrapper extends TaintedObjectWrapper {
  ConcreteTaintedObjectWrapper() { this = this }
}

/**
 * A taint tracking configuration for user-controlled objects flowing into deep `extend` calls,
 * leading to prototype pollution.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PrototypePollution" }

  override predicate isSource(DataFlow::Node node, DataFlow::FlowLabel label) {
    node.(Source).getAFlowLabel() = label
  }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel label) {
    node.(Sink).getAFlowLabel() = label
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedObject::step(src, dst, inlbl, outlbl)
    or
    // Track objects are wrapped in other objects
    exists(DataFlow::PropWrite write |
      src = write.getRhs() and
      inlbl = TaintedObject::label() and
      dst = write.getBase().getALocalSource() and
      outlbl = TaintedObjectWrapper::label()
    )
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
    node instanceof TaintedObject::SanitizerGuard
  }
}
