/** DEPRECATED. Import `CleartextLoggingQuery` instead. */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.dataflow.new.SensitiveDataSources

/** DEPRECATED. Import `CleartextLoggingQuery` instead. */
deprecated module CleartextLogging {
  import CleartextLoggingQuery // ignore-query-import
}
