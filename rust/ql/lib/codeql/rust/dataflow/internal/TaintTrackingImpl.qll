private import rust
private import codeql.dataflow.DataFlow as DF
private import codeql.dataflow.TaintTracking
private import codeql.rust.dataflow.DataFlow as RustDataFlow
private import codeql.rust.dataflow.FlowSummary
private import DataFlowImpl as DataFlowImpl
private import Node as Node
private import Content
private import FlowSummaryImpl as FlowSummaryImpl
private import codeql.rust.internal.CachedStages
private import codeql.rust.internal.typeinference.TypeInference as TypeInference
private import codeql.rust.internal.typeinference.Type as Type
private import codeql.rust.frameworks.stdlib.Builtins as Builtins

/**
 * Holds if the field `field` should, by default, be excluded from taint steps
 * from the containing type to reads of the field. The models-as-data syntax
 * used to denote the field is the same as for `Field[]` access path elements.
 */
extensible predicate excludeFieldTaintStep(string field);

/**
 * Holds if the content `c` corresponds to a field that has explicitly been
 * excluded as a taint step.
 */
private predicate excludedTaintStepContent(Content c) {
  exists(string arg | excludeFieldTaintStep(arg) |
    FlowSummaryImpl::encodeContentStructField(c, arg) or
    FlowSummaryImpl::encodeContentTupleField(c, arg)
  )
}

module RustTaintTrackingGen<DataFlowImpl::RustDataFlowInputSig I> implements
  InputSig<Location, DataFlowImpl::RustDataFlowGen<I>>
{
  private module DataFlow = DataFlowImpl::RustDataFlowGen<I>;

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
      pred.asExpr() = succ.asExpr().(CastExpr).getExpr()
      or
      exists(IndexExpr index |
        index.getIndex() instanceof RangeExpr and
        pred.asExpr() = index.getBase() and
        succ.asExpr() = index
      )
      or
      // Read steps give rise to taint steps. This has the effect that if `foo`
      // is tainted and an operation reads from `foo` (e.g., `foo.bar`) then
      // taint is propagated.
      exists(ContentSet cs |
        DataFlow::readStep(pred, cs, succ) and
        not excludedTaintStepContent(cs.getAReadContent())
      )
      or
      exists(FormatArgsExpr format | succ.asExpr() = format |
        pred.asExpr() = format.getAnArg().getExpr()
        or
        pred.asExpr() =
          any(FormatTemplateVariableAccess v |
            exists(Format f |
              f = format.getAFormat() and
              v.getArgument() = [f.getArgumentRef(), f.getWidthArgument(), f.getPrecisionArgument()]
            )
          )
      )
      or
      succ.(Node::PostUpdateNode).getPreUpdateNode().asExpr() =
        DataFlowImpl::getPostUpdateReverseStep(pred.(Node::PostUpdateNode)
              .getPreUpdateNode()
              .asExpr(), false)
      or
      DataFlowImpl::indexAssignment(any(CompoundAssignmentExpr cae),
        pred.(Node::PostUpdateNode).getPreUpdateNode().asExpr(), _, succ, _)
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
    not DataFlowImpl::optionalStep(node, _, _)
  }

  /**
   * Holds if the additional step from `src` to `sink` should be considered in
   * speculative taint flow exploration.
   */
  predicate speculativeTaintStep(DataFlow::Node src, DataFlow::Node sink) { none() }
}

module RustTaintTracking = RustTaintTrackingGen<DataFlowImpl::RustDataFlowInput>;
