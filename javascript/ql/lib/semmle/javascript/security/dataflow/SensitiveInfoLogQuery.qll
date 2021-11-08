/**
 * Provides a taint tracking configuration for reasoning about
 * logging sensitive information.
 *
 * Note, for performance reasons: only import this file if
 * `SensitiveInfoLog::Configuration` is needed, otherwise
 * `SensitiveInfoLogCustomizations` should be imported instead.
 */

import javascript
import SensitiveInfoLogCustomizations::SensitiveInfoLog

/**
 * A taint tracking configuration for logging of sensitive information.
 *
 * This configuration identifies flows from `Source`s, which are sources of
 * sensitive data, to `Sink`s, which is an abstract class representing all
 * the places sensitive data may be logged. Additional sources or sinks can be
 * added either by extending the relevant class, or by subclassing this configuration itself,
 * and amending the sources and sinks.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "SensitiveInfoLog" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
