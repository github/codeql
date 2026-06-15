import utils.test.InlineFlowTest

string customTaintFlowTag() { result = "tainted" }

import FlowTest<NoFlowConfig, DefaultFlowConfig, defaultValueFlowTag/0, customTaintFlowTag/0>
