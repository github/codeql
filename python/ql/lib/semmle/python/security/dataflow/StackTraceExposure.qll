/**
 * Provides a taint-tracking configuration for detecting "stack trace exposure" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `StackTraceExposure::Configuration` is needed, otherwise
 * `StackTraceExposureCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "stack trace exposure" vulnerabilities.
 */
module StackTraceExposure {
  import StackTraceExposureQuery // ignore-query-import
}

/**
 * DEPRECATED: Don't extend this class for customization, since this will lead to bad
 * performance, instead use the new `StackTraceExposureCustomizations.qll` file, and extend
 * its' classes.
 */
deprecated class StackTraceExposureConfiguration = StackTraceExposure::Configuration;
