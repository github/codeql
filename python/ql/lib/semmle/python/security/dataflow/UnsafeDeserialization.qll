/** DEPRECATED. Import `UnsafeDeserializationQuery` instead. */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/** DEPRECATED. Import `UnsafeDeserializationQuery` instead. */
deprecated module UnsafeDeserialization {
  import UnsafeDeserializationQuery // ignore-query-import
}

/** DEPRECATED. Import `UnsafeDeserializationQuery` instead. */
deprecated class UnsafeDeserializationConfiguration = UnsafeDeserialization::Configuration;
