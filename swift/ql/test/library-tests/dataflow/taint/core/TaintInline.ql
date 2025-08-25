import utils.test.InlineFlowTest
import Taint

string customTaintFlowTag() { result = "tainted" }

import FlowTest<NoFlowConfig, DefaultFlowConfig, defaultValueFlowTag/0, customTaintFlowTag/0>
