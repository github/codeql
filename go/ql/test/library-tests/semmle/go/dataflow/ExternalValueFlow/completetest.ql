/**
 * @kind path-problem
 */

import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { sourceNode(source, "qltest") }

  predicate isSink(DataFlow::Node sink) { sinkNode(sink, "qltest") }
}

import ValueFlowTest<Config>
