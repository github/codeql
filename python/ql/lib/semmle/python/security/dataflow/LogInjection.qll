/**
 * Provides a taint-tracking configuration for tracking untrusted user input used in log entries.
 *
 * Note, for performance reasons: only import this file if
 * `LogInjection::Configuration` is needed, otherwise
 * `LogInjectionCustomizations` should be imported instead.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for tracking untrusted user input used in log entries.
 */
module LogInjection {
  import LogInjectionQuery // ignore-query-import
}
