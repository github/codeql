import go
import TestUtilities.InlineFlowTest

string getArgString(DataFlow::Node src, DataFlow::Node sink) {
  exists(src) and
  result =
    "\"" + sink.toString() + " (from source " +
      src.(DataFlow::CallNode).getArgument(0).getExactValue() + ")\""
}

import ValueFlowTestArgString<DefaultFlowConfig, getArgString/2>
