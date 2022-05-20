/** DEPRECATED. Import `WeakSensitiveDataHashingQuery` instead. */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.dataflow.new.SensitiveDataSources

/** DEPRECATED. Import `WeakSensitiveDataHashingQuery` instead. */
deprecated module NormalHashFunction {
  import WeakSensitiveDataHashingQuery::NormalHashFunction // ignore-query-import
}

/** DEPRECATED. Import `WeakSensitiveDataHashingQuery` instead. */
deprecated module ComputationallyExpensiveHashFunction {
  import WeakSensitiveDataHashingQuery::ComputationallyExpensiveHashFunction // ignore-query-import
}
