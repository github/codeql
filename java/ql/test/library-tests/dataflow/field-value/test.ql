import java
import utils.test.InlineFlowTest

module FieldValueConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof DataFlow::FieldValueNode }

  predicate isSink(DataFlow::Node sink) { DefaultFlowConfig::isSink(sink) }
}

import TaintFlowTest<FieldValueConfig>
