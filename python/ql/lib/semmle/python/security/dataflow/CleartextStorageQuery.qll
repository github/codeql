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
import CleartextStorageCustomizations::CleartextStorage

private module CleartextStorageConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/** Global taint-tracking for detecting "Clear-text storage of sensitive information" vulnerabilities. */
module CleartextStorageFlow = TaintTracking::Global<CleartextStorageConfig>;
