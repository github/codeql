/**
 * Provides a taint tracking configuration for reasoning about
 * cleartext storage of sensitive information.
 *
 * Note, for performance reasons: only import this file if
 * `CleartextStorage::Configuration` is needed, otherwise
 * `CleartextStorageCustomizations` should be imported instead.
 */

import javascript
import CleartextStorageCustomizations::CleartextStorage

/**
 * A taint tracking configuration for cleartext storage of sensitive information.
 *
 * This configuration identifies flows from `Source`s, which are sources of
 * sensitive data, to `Sink`s, which is an abstract class representing all
 * the places sensitive data may be stored in cleartext. Additional sources or sinks can be
 * added either by extending the relevant class, or by subclassing this configuration itself,
 * and amending the sources and sinks.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ClearTextStorage" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}
