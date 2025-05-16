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
module RemotePropertyInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or
    node = StringConcatenation::getRoot(any(ConstantString str).flow())
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about remote property injection.
 */
module RemotePropertyInjectionFlow = TaintTracking::Global<RemotePropertyInjectionConfig>;
