private import rust
private import codeql.dataflow.TaintTracking
private import codeql.rust.controlflow.CfgNodes
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSummary
private import DataFlowImpl
private import Node as Node
private import Content
private import FlowSummaryImpl as FlowSummaryImpl
private import codeql.rust.internal.CachedStages

module RustTaintTracking implements InputSig<Location, RustDataFlow> {
  predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

  /**
   * Holds if the additional step from `pred` to `succ` should be included in all
   * global taint flow configurations.
   */
  cached
  predicate defaultAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ, string model) {
    Stages::DataFlowStage::ref() and
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
      or
      // Although data flow through collections is modeled using stores/reads,
      // we also allow taint to flow out of a tainted collection. This is
      // needed in order to support taint-tracking configurations where the
      // source is a collection.
      exists(SingletonContentSet cs |
        RustDataFlow::readStep(pred, cs, succ) and
        cs.getContent() instanceof ElementContent
      )
      or
      exists(FormatArgsExprCfgNode format | succ.asExpr() = format |
        pred.asExpr() = [format.getArgumentExpr(_), format.getFormatTemplateVariableAccess(_)]
      )
      or
      succ.(Node::PostUpdateNode).getPreUpdateNode().asExpr() =
        getPostUpdateReverseStep(pred.(Node::PostUpdateNode).getPreUpdateNode().asExpr(), false)
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
  predicate defaultImplicitTaintRead(DataFlow::Node node, ContentSet cs) {
    exists(node) and
    exists(Content c | c = cs.(SingletonContentSet).getContent() |
      c instanceof ElementContent or
      c instanceof ReferenceContent
    ) and
    // Optional steps are added through isAdditionalFlowStep but we don't want the implicit reads
    not optionalStep(node, _, _)
  }

  /**
   * Holds if the additional step from `src` to `sink` should be considered in
   * speculative taint flow exploration.
   */
  predicate speculativeTaintStep(DataFlow::Node src, DataFlow::Node sink) { none() }
}
