/**
 * Provides a taint-tracking configuration for detecting regular expression injection
 * vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `RegexInjection::Configuration` is needed, otherwise
 * `RegexInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting regular expression injection
 * vulnerabilities.
 */
module RegexInjection {
  import RegexInjectionQuery // ignore-query-import
}
