/**
 * @kind path-problem
 */

import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import TestUtilities.InlineFlowTest

class Config extends TaintTracking::Configuration {
  Config() { this = "external-flow-test" }

  override predicate isSource(DataFlow::Node src) { sourceNode(src, "qltest") }

  override predicate isSink(DataFlow::Node src) { sinkNode(src, "qltest") }
}

class ExternalFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override DataFlow::Configuration getTaintFlowConfig() { result = any(Config config) }
}
