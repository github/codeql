/**
 * Provides a taint-tracking configuration for detecting flow of query string
 * data to sensitive actions in GET query request handlers.
 *
 * Note, for performance reasons: only import this file if
 * `SensitiveGetQueryFlow` is needed, otherwise
 * `SensitiveGetQueryCustomizations` should be imported instead.
 */

private import ruby
private import codeql.ruby.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting flow of query string
 * data to sensitive actions in GET query request handlers.
 * DEPRECATED: Use `SensitiveGetQueryFlow`
 */
deprecated module SensitiveGetQuery {
  import SensitiveGetQueryCustomizations::SensitiveGetQuery

  /**
   * A taint-tracking configuration for reasoning about use of sensitive data
   * from a GET request query string.
   */
  deprecated class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "SensitiveGetQuery" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
  }
}

private module SensitiveGetQueryConfig implements DataFlow::ConfigSig {
  import SensitiveGetQueryCustomizations::SensitiveGetQuery

  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
}

/**
 * Taint-tracking for reasoning about use of sensitive data from a
 *  GET request query string.
 */
module SensitiveGetQueryFlow = TaintTracking::Global<SensitiveGetQueryConfig>;
