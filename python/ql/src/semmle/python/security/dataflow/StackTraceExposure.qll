/**
 * Provides a taint-tracking configuration for detecting stack trace exposure
 * vulnerabilities.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts
private import ExceptionInfo

/**
 * A taint-tracking configuration for detecting stack trace exposure.
 */
class StackTraceExposureConfiguration extends TaintTracking::Configuration {
  StackTraceExposureConfiguration() { this = "StackTraceExposureConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof ExceptionInfo }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(HTTP::Server::HttpResponse response).getBody()
  }
}
