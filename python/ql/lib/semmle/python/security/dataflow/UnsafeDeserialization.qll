/**
 * Provides a taint-tracking configuration for detecting "code execution from deserialization" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeDeserialization::Configuration` is needed, otherwise
 * `UnsafeDeserializationCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "code execution from deserialization" vulnerabilities.
 */
module UnsafeDeserialization {
  import UnsafeDeserializationQuery // ignore-query-import
}

/**
 * DEPRECATED: Don't extend this class for customization, since this will lead to bad
 * performance, instead use the new `UnsafeDeserializationCustomizations.qll` file, and extend
 * its' classes.
 */
deprecated class UnsafeDeserializationConfiguration = UnsafeDeserialization::Configuration;
