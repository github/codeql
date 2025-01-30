// This test flags any difference in flow between the type-tracking and dataflow
// libraries. New results in this query do not necessarily indicate a problem,
// only that type-tracking cannot follow the flow in your test. If the dataflow
// test (`array-flow.ql`) shows no failures, then that may be sufficient
// (depending on your use case).
import utils.test.InlineTypeTrackingFlowTest
