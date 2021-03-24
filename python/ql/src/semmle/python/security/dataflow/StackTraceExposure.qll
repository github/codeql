/**
 * Provides a taint-tracking configuration for detecting stack trace exposure
 * vulnerabilities.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts
import semmle.python.dataflow.new.internal.Attributes
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

  // A stack trace is accessible as the `__traceback__` attribute of a caught exception.
  //  seehttps://docs.python.org/3/reference/datamodel.html#traceback-objects
  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(AttrRead attr | attr.getAttributeName() = "__traceback__" |
      nodeFrom = attr.getObject() and
      nodeTo = attr
    )
  }
}
