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
    source instanceof TrueNullValue and state = FlowState::trueOrNull()
    or
    source instanceof WildcardValue and state = FlowState::wildcard()
    or
    source instanceof RemoteFlowSource and state = FlowState::taint()
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof CorsApolloServer and state = [FlowState::taint(), FlowState::trueOrNull()]
    or
    sink instanceof ExpressCors and state = [FlowState::taint(), FlowState::wildcard()]
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module CorsPermissiveConfigurationFlow =
  TaintTracking::GlobalWithState<CorsPermissiveConfigurationConfig>;

/**
 * DEPRECATED. Use the `CorsPermissiveConfigurationFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CorsPermissiveConfiguration" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    CorsPermissiveConfigurationConfig::isSource(source, FlowState::fromFlowLabel(label))
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    CorsPermissiveConfigurationConfig::isSink(sink, FlowState::fromFlowLabel(label))
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    CorsPermissiveConfigurationConfig::isBarrier(node)
  }
}

deprecated private class WildcardActivated extends DataFlow::FlowLabel, Wildcard {
  WildcardActivated() { this = this }
}

deprecated private class TrueAndNullActivated extends DataFlow::FlowLabel, TrueAndNull {
  TrueAndNullActivated() { this = this }
}
