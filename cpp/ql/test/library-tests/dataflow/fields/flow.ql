import utils.test.dataflow.FlowTestCommon

module AstTest {
  import ASTConfiguration
}

module IRTest {
  import IRConfiguration
}

import MakeTest<MergeTests<AstFlowTest<AstTest::AstFlow>, IRFlowTest<IRTest::IRFlow>>>
