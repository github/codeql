import javascript
import testUtilities.InlineFlowTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node =
      API::moduleImport("lib").getMember("something").getParameter(0).getParameter(0).asSource()
    or
    DefaultFlowConfig::isSource(node)
  }

  predicate isSink(DataFlow::Node node) { DefaultFlowConfig::isSink(node) }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }
}

import ValueFlowTest<TestConfig>
