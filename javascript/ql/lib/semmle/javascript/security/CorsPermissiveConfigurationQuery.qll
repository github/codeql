/**
 * Provides a dataflow taint tracking configuration for reasoning
 * about overly permissive CORS configurations.
 *
 * Note, for performance reasons: only import this file if
 * `CorsPermissiveConfiguration::Configuration` is needed,
 * otherwise `CorsPermissiveConfigurationCustomizations` should
 * be imported instead.
 */

import javascript
import CorsPermissiveConfigurationCustomizations::CorsPermissiveConfiguration
private import CorsPermissiveConfigurationCustomizations::CorsPermissiveConfiguration as CorsPermissiveConfiguration

/**
 * A data flow configuration for overly permissive CORS configuration.
 */
module CorsPermissiveConfigurationConfig implements DataFlow::StateConfigSig {
  class FlowState = CorsPermissiveConfiguration::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof PermissiveValue and state = FlowState::permissive()
    or
    source instanceof RemoteFlowSource and state = FlowState::taint()
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof CorsOriginSink and
    state = [FlowState::taint(), FlowState::permissive()]
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module CorsPermissiveConfigurationFlow =
  TaintTracking::GlobalWithState<CorsPermissiveConfigurationConfig>;
