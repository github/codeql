/**
 * Provides a taint tracking configuration for reasoning about
 * deserialization vulnerabilities (CWE-502).
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeDeserializationFlow` is needed, otherwise
 * `UnsafeDeserializationCustomizations` should be imported instead.
 */

import powershell
import semmle.code.powershell.dataflow.flowsources.FlowSources
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.dataflow.TaintTracking
import UnsafeDeserializationCustomizations::UnsafeDeserialization

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo){
    exists(InvokeMemberExpr ime | 
        nodeTo.asExpr().getExpr() = ime and 
        nodeFrom.asExpr().getExpr() = ime.getAnArgument()
    )
  }
}

module UnsafeDeserializationFlow = TaintTracking::Global<Config>; 