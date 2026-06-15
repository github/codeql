import go
import utils.test.InlineFlowTest

string getArgString(DataFlow::Node src, DataFlow::Node sink) {
  result =
    "\"" + sink.toString() + " (from source " +
      src.(DataFlow::CallNode).getArgument(0).getExactValue() + ")\""
}

import ValueFlowTestArgString<DefaultFlowConfig, getArgString/2>
