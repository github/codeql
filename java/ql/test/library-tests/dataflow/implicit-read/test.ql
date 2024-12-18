import java
import utils.test.InlineFlowTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { DefaultFlowConfig::isSource(source) }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall call |
      call.getMethod().getName() = "step" and
      node1.asExpr() = call.getArgument(0) and
      node2.asExpr() = call
    )
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet content) {
    isAdditionalFlowStep(node, _) and content instanceof DataFlow::FieldContent
  }
}

import TaintFlowTest<TestConfig>
