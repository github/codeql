import go
import utils.test.InlineFlowTest

string getArgString(DataFlow::Node src, DataFlow::Node sink) {
  exists(sink) and
  result = src.(DataFlow::CallNode).getArgument(0).getExactValue()
}

import TaintFlowTestArgString<DefaultFlowConfig, getArgString/2>
