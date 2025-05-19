/**
 * Provides a taint tracking configuration for reasoning about
 * SQL-injection vulnerabilities (CWE-078).
 *
 * Note, for performance reasons: only import this file if
 * `SqlInjectionFlow` is needed, otherwise
 * `SqlInjectionCustomizations` should be imported instead.
 */

import powershell
import semmle.code.powershell.dataflow.TaintTracking
import SqlInjectionCustomizations::SqlInjection
import semmle.code.powershell.dataflow.DataFlow

private module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * Taint-tracking for reasoning about SQL-injection vulnerabilities.
 */
module SqlInjectionFlow = TaintTracking::Global<Config>;
