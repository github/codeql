/**
 * Provides a taint-tracking configuration for reasoning about system
 * commands built from user-controlled sources (that is, command injection
 * vulnerabilities).
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.CommandInjectionExtensions

/**
 * A taint configuration for tainted data that reaches a command injection sink.
 */
module CommandInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { node instanceof CommandInjectionSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof CommandInjectionBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(CommandInjectionAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }
}

/**
 * Detect taint flow of tainted data that reaches a command injection sink.
 */
module CommandInjectionFlow = TaintTracking::Global<CommandInjectionConfig>;
