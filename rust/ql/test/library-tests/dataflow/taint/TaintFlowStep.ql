import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.internal.Node as Node
import codeql.rust.dataflow.internal.TaintTrackingImpl
import utils.test.TranslateModels

query predicate additionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  // Taint steps that don't originate from a flow summary.
  RustTaintTracking::defaultAdditionalTaintStep(pred, succ, "") and
  not pred instanceof Node::FlowSummaryNode
}
