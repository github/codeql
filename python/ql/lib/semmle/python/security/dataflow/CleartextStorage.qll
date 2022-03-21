/**
 * Provides a taint-tracking configuration for "Clear-text storage of sensitive information".
 *
 * Note, for performance reasons: only import this file if
 * `CleartextStorage::Configuration` is needed, otherwise
 * `CleartextStorageCustomizations` should be imported instead.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.dataflow.new.SensitiveDataSources

/**
 * Provides a taint-tracking configuration for detecting "Clear-text storage of sensitive information".
 */
module CleartextStorage {
  import CleartextStorageQuery // ignore-query-import
}
