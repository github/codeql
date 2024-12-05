private import rust
private import codeql.dataflow.TaintTracking
private import codeql.rust.controlflow.CfgNodes
private import DataFlowImpl
private import codeql.rust.dataflow.FlowSummary
private import FlowSummaryImpl as FlowSummaryImpl
private import DataFlowImpl

module RustTaintTracking implements InputSig<Location, RustDataFlow> {
  predicate defaultTaintSanitizer(Node::Node node) { none() }

  /**
   * Holds if the additional step from `pred` to `succ` should be included in all
   * global taint flow configurations.
   */
  predicate defaultAdditionalTaintStep(Node::Node pred, Node::Node succ, string model) {
    model = "" and
    (
      exists(BinaryExprCfgNode binary |
        binary.getOperatorName() = ["+", "-", "*", "/", "%", "&", "|", "^", "<<", ">>"] and
        pred.asExpr() = [binary.getLhs(), binary.getRhs()] and
        succ.asExpr() = binary
      )
      or
      exists(PrefixExprCfgNode prefix |
        prefix.getOperatorName() = ["-", "!"] and
        pred.asExpr() = prefix.getExpr() and
        succ.asExpr() = prefix
      )
      or
      pred.asExpr() = succ.asExpr().(CastExprCfgNode).getExpr()
      or
      exists(IndexExprCfgNode index |
        index.getIndex() instanceof RangeExprCfgNode and
        pred.asExpr() = index.getBase() and
        succ.asExpr() = index
      )
    )
    or
    FlowSummaryImpl::Private::Steps::summaryLocalStep(pred.(Node::FlowSummaryNode).getSummaryNode(),
      succ.(Node::FlowSummaryNode).getSummaryNode(), false, model)
  }

  /**
   * Holds if taint flow configurations should allow implicit reads of `c` at sinks
   * and inputs to additional taint steps.
   */
  bindingset[node]
  predicate defaultImplicitTaintRead(Node::Node node, ContentSet c) { none() }

  /**
   * Holds if the additional step from `src` to `sink` should be considered in
   * speculative taint flow exploration.
   */
  predicate speculativeTaintStep(Node::Node src, Node::Node sink) { none() }
}
