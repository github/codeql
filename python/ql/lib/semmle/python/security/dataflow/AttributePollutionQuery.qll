/**
 * Provides a taint-tracking configuration for detecting pollution
 * vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `AttributePollution::Configuration` is needed, otherwise
 * `AttributePollution` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import AttributePollutionCustomizations::AttributePollution

/**
 * A taint-tracking configuration for detecting "attribute pollution" vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "AttributePollution" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
}
