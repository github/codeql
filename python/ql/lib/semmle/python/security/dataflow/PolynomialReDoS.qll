/**
 * Provides a taint-tracking configuration for detecting "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `PolynomialReDoS::Configuration` is needed, otherwise
 * `PolynomialReDoSCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
 */
module PolynomialReDoS {
  import PolynomialReDoSQuery // ignore-query-import
}
