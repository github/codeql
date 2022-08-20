/** DEPRECATED. Import `StackTraceExposureQuery` instead. */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/** DEPRECATED. Import `StackTraceExposureQuery` instead. */
deprecated module StackTraceExposure {
  import StackTraceExposureQuery // ignore-query-import
}

/** DEPRECATED. Import `StackTraceExposureQuery` instead. */
deprecated class StackTraceExposureConfiguration = StackTraceExposure::Configuration;
