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

/**
 * A data flow configuration for overly permissive CORS configuration.
 */
module CorsPermissiveConfigurationConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source instanceof TrueNullValue and label = truenullLabel()
    or
    source instanceof WildcardValue and label = wildcardLabel()
    or
    source instanceof RemoteFlowSource and label = DataFlow::FlowLabel::taint()
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof CorsApolloServer and label = [DataFlow::FlowLabel::taint(), truenullLabel()]
    or
    sink instanceof ExpressCors and label = [DataFlow::FlowLabel::taint(), wildcardLabel()]
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

module CorsPermissiveConfigurationFlow =
  TaintTracking::GlobalWithState<CorsPermissiveConfigurationConfig>;

/**
 * DEPRECATED. Use the `CorsPermissiveConfigurationFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CorsPermissiveConfiguration" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    CorsPermissiveConfigurationConfig::isSource(source, label)
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    CorsPermissiveConfigurationConfig::isSink(sink, label)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    CorsPermissiveConfigurationConfig::isBarrier(node)
  }
}

private class WildcardActivated extends DataFlow::FlowLabel, Wildcard {
  WildcardActivated() { this = this }
}

private class TrueAndNullActivated extends DataFlow::FlowLabel, TrueAndNull {
  TrueAndNullActivated() { this = this }
}
