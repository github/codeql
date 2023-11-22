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
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CorsPermissiveConfiguration" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source instanceof TrueNullValue and label = truenullLabel()
    or
    source instanceof WildcardValue and label = wildcardLabel()
    or
    source instanceof RemoteFlowSource and label = DataFlow::FlowLabel::taint()
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof CorsApolloServer and label = [DataFlow::FlowLabel::taint(), truenullLabel()]
    or
    sink instanceof ExpressCors and label = [DataFlow::FlowLabel::taint(), wildcardLabel()]
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}

private class WildcardActivated extends DataFlow::FlowLabel, Wildcard {
  WildcardActivated() { this = this }
}

private class TrueAndNullActivated extends DataFlow::FlowLabel, TrueAndNull {
  TrueAndNullActivated() { this = this }
}
