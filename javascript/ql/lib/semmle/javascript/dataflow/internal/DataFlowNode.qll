/**
 * INTERNAL: Do not use outside the data flow library.
 *
 * Contains the raw data type underlying `DataFlow::Node`.
 */

private import javascript
private import codeql.util.Boolean
private import semmle.javascript.dataflow.internal.AdditionalFlowInternal
private import semmle.javascript.dataflow.internal.Contents::Private
private import semmle.javascript.dataflow.internal.sharedlib.DataFlowImplCommon as DataFlowImplCommon
private import semmle.javascript.dataflow.internal.sharedlib.Ssa as Ssa2
private import semmle.javascript.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.javascript.dataflow.internal.sharedlib.FlowSummaryImpl as FlowSummaryImpl
private import semmle.javascript.dataflow.internal.FlowSummaryPrivate as FlowSummaryPrivate
private import semmle.javascript.dataflow.internal.VariableCapture as VariableCapture
private import semmle.javascript.dataflow.internal.VariableOrThis

cached
private module Cached {
  private Content dynamicArgumentsContent() {
    result.asArrayIndex() = [0 .. 10]
    or
    result.isUnknownArrayElement()
  }

  /**
   * The raw data type underlying `DataFlow::Node`.
   */
  cached
  newtype TNode =
    TValueNode(AST::ValueNode nd) or
    /** An SSA node from the legacy SSA library */
    TSsaDefNode(SsaDefinition d) or
    /** Use of a variable or 'this', with flow from a post-update node (from an earlier use) */
    TSsaUseNode(ControlFlowNode use) { use = any(Ssa2::SsaConfig::SourceVariable v).getAUse() } or
    /** Phi-read node (new SSA library). Ordinary phi nodes are represented by TSsaDefNode. */
    TSsaPhiReadNode(Ssa2::PhiReadNode phi) or
    /** Input to a phi node (new SSA library) */
    TSsaInputNode(Ssa2::SsaInputNode input) or
    TCapturedVariableNode(LocalVariable v) { v.isCaptured() } or
    TPropNode(@property p) or
    TRestPatternNode(DestructuringPattern dp, Expr rest) { rest = dp.getRest() } or
    TElementPatternNode(ArrayPattern ap, Expr p) { p = ap.getElement(_) } or
    TElementNode(ArrayExpr arr, Expr e) { e = arr.getAnElement() } or
    TReflectiveCallNode(MethodCallExpr ce, string kind) {
      ce.getMethodName() = kind and
      (kind = "call" or kind = "apply")
    } or
    TThisNode(StmtContainer f) { f.(Function).getThisBinder() = f or f instanceof TopLevel } or
    TFunctionSelfReferenceNode(Function f) or
    TStaticArgumentArrayNode(InvokeExpr node) or
    TDynamicArgumentArrayNode(InvokeExpr node) { node.isSpreadArgument(_) } or
    TStaticParameterArrayNode(Function f) {
      f.getAParameter().isRestParameter() or f.usesArgumentsObject()
    } or
    TDynamicParameterArrayNode(Function f) or
    /** Data about to be stored in the rest parameter object. Needed for shifting array indices. */
    TRestParameterStoreNode(Function f, Content storeContent) {
      f.getRestParameter().getIndex() > 0 and
      storeContent = dynamicArgumentsContent()
    } or
    /** Data about to be stored in the dynamic argument array of an invocation. Needed for shifting array indices. */
    TDynamicArgumentStoreNode(InvokeExpr invoke, Content storeContent) {
      invoke.isSpreadArgument(_) and
      storeContent = dynamicArgumentsContent()
    } or
    TApplyCallTaintNode(MethodCallExpr node) {
      node.getMethodName() = "apply" and exists(node.getArgument(1))
    } or
    TDestructuredModuleImportNode(ImportDeclaration decl) {
      exists(decl.getASpecifier().getImportedName())
    } or
    THtmlAttributeNode(HTML::Attribute attr) or
    TXmlAttributeNode(XmlAttribute attr) or
    TFunctionReturnNode(Function f) or
    TExceptionalFunctionReturnNode(Function f) or
    TExceptionalInvocationReturnNode(InvokeExpr e) or
    TGlobalAccessPathRoot() or
    TTemplatePlaceholderTag(Templating::TemplatePlaceholderTag tag) or
    TReflectiveParametersNode(Function f) { f.usesArgumentsObject() } or
    TExprPostUpdateNode(AST::ValueNode e) {
      e = any(InvokeExpr invoke).getAnArgument() or
      e = any(PropAccess access).getBase() or
      e = any(DestructuringPattern pattern) or
      e = any(InvokeExpr invoke).getCallee() or
      // We have read steps out of the await operand, so it technically needs a post-update
      e = any(AwaitExpr a).getOperand() or
      e = any(Function f) or // functions are passed as their own self-reference argument
      // The RHS of an assignment can be an argument to a setter-call, so it needs a post-update node
      e = any(Assignment asn | asn.getTarget() instanceof PropAccess).getRhs()
    } or
    TNewCallThisArgument(NewExpr e) or
    TImplicitThisUse(ImplicitThisUse use, Boolean isPost) or
    TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn) or
    TFlowSummaryDynamicParameterArrayNode(FlowSummaryImpl::Public::SummarizedCallable callable) or
    TFlowSummaryIntermediateAwaitStoreNode(FlowSummaryImpl::Private::SummaryNode sn) {
      // NOTE: This dependency goes through the 'Steps' module whose instantiation depends on the call graph,
      //       but the specific predicate we're referering to does not use that information.
      //       So it doesn't cause negative recursion but it might look a bit surprising.
      FlowSummaryPrivate::Steps::summaryStoreStep(sn, MkAwaited(), _)
    } or
    TFlowSummaryDefaultExceptionalReturn(FlowSummaryImpl::Public::SummarizedCallable callable) {
      not DataFlowPrivate::mentionsExceptionalReturn(callable)
    } or
    TSynthCaptureNode(VariableCapture::VariableCaptureOutput::SynthesizedCaptureNode node) or
    TGenericSynthesizedNode(AstNode node, string tag, DataFlowPrivate::DataFlowCallable container) {
      any(AdditionalFlowInternal flow).needsSynthesizedNode(node, tag, container)
    } or
    TForbiddenRecursionGuard() {
      none() and
      // We want to prune irrelevant models before materialising data flow nodes, so types contributed
      // directly from CodeQL must expose their pruning info without depending on data flow nodes.
      (any(ModelInput::TypeModel tm).isTypeUsed("") implies any())
    }

  cached
  private module Backref {
    cached
    predicate backref() {
      DataFlowImplCommon::forceCachingInSameStage() or
      exists(any(DataFlow::Node node).toString()) or
      exists(any(DataFlow::Node node).getContainer()) or
      any(DataFlow::Node node).hasLocationInfo(_, _, _, _, _) or
      exists(any(Content c).toString())
    }
  }
}

import Cached

private class TEarlyStageNode =
  TValueNode or TSsaDefNode or TCapturedVariableNode or TPropNode or TRestPatternNode or
      TElementPatternNode or TElementNode or TReflectiveCallNode or TThisNode or
      TFunctionSelfReferenceNode or TDestructuredModuleImportNode or THtmlAttributeNode or
      TFunctionReturnNode or TExceptionalFunctionReturnNode or TExceptionalInvocationReturnNode or
      TGlobalAccessPathRoot or TTemplatePlaceholderTag or TReflectiveParametersNode or
      TExprPostUpdateNode or TNewCallThisArgument or TStaticArgumentArrayNode or
      TDynamicArgumentArrayNode or TStaticParameterArrayNode or TDynamicParameterArrayNode or
      TImplicitThisUse;

/**
 * A data-flow node that is not a flow summary node.
 *
 * This node exists to avoid an unwanted dependency on flow summaries in some parts of the codebase
 * that should not depend on them.
 *
 * In particular, this dependency chain must not result in negative recursion:
 * - Flow summaries can only be created after pruning irrelevant flow summaries
 * - To prune irrelevant flow summaries, we must know which packages are imported
 * - To know which packages are imported, module systems must be evaluated
 * - The AMD and NodeJS module systems rely on data flow to find calls to `require` and similar.
 *   These module systems must therefore use `EarlyStageNode` instead of `DataFlow::Node`.
 */
class EarlyStageNode extends TEarlyStageNode {
  /** Gets a string representation of this data flow node. */
  string toString() { result = this.(DataFlow::Node).toString() }

  /** Gets the location of this data flow node. */
  Location getLocation() { result = this.(DataFlow::Node).getLocation() }
}
