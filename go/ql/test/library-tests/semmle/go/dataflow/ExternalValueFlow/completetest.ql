/**
 * @kind path-problem
 */

import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import utils.test.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { sourceNode(src, "qltest") }

  predicate isSink(DataFlow::Node src) { sinkNode(src, "qltest") }
}

import ValueFlowTest<Config>
