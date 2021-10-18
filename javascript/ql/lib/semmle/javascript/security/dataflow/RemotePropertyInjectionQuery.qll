/**
 * Provides a taint tracking configuration for reasoning about injections in
 * property names, used either for writing into a property, into a header or
 * for calling an object's method.
 *
 * Note, for performance reasons: only import this file if
 * `RemotePropertyInjection::Configuration` is needed, otherwise
 * `RemotePropertyInjectionCustomizations` should be imported instead.
 */

import javascript
import RemotePropertyInjectionCustomizations::RemotePropertyInjection

/**
 * A taint-tracking configuration for reasoning about remote property injection.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "RemotePropertyInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer or
    node = StringConcatenation::getRoot(any(ConstantString str).flow())
  }
}
