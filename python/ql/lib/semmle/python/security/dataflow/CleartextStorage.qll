/** DEPRECATED. Import `CleartextStorageQuery` instead. */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.dataflow.new.SensitiveDataSources

/** DEPRECATED. Import `CleartextStorageQuery` instead. */
deprecated module CleartextStorage {
  import CleartextStorageQuery // ignore-query-import
}
