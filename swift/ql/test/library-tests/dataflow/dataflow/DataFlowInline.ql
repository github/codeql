import utils.test.InlineFlowTest
import FlowConfig

string customTaintFlowTag() { result = "flow" }

import FlowTest<DefaultFlowConfig, NoFlowConfig, customTaintFlowTag/0, defaultTaintFlowTag/0>
