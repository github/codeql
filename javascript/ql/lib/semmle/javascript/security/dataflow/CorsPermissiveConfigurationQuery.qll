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

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }
}
