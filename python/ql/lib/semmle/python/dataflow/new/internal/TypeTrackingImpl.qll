import codeql.util.Unit
import codeql.typetracking.TypeTracking as Shared
import codeql.typetracking.internal.TypeTrackingImpl as SharedImpl
private import python
private import semmle.python.internal.CachedStages
private import semmle.python.dataflow.new.internal.DataFlowPublic as DataFlowPublic
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import codeql.typetracking.internal.SummaryTypeTracker as SummaryTypeTracker
private import semmle.python.dataflow.new.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.python.dataflow.new.internal.DataFlowDispatch as DataFlowDispatch

private module SummaryTypeTrackerInput implements SummaryTypeTracker::Input {
  // Dataflow nodes
  class Node = DataFlowPublic::Node;

  // Content
  class Content = DataFlowPublic::ContentSet;

  class ContentFilter = TypeTrackingInput::ContentFilter;

  ContentFilter getFilterFromWithoutContentStep(Content content) { none() }

  ContentFilter getFilterFromWithContentStep(Content content) { none() }

  // Callables
  class SummarizedCallable = FlowSummaryImpl::Private::SummarizedCallableImpl;

  // Summaries and their stacks
  class SummaryComponent = FlowSummaryImpl::Private::SummaryComponent;

  class SummaryComponentStack = FlowSummaryImpl::Private::SummaryComponentStack;

  predicate singleton = FlowSummaryImpl::Private::SummaryComponentStack::singleton/1;

  predicate push = FlowSummaryImpl::Private::SummaryComponentStack::push/2;

  // Relating content to summaries
  predicate content = FlowSummaryImpl::Private::SummaryComponent::content/1;

  SummaryComponent withoutContent(Content contents) { none() }

  SummaryComponent withContent(Content contents) { none() }

  predicate return = FlowSummaryImpl::Private::SummaryComponent::return/0;

  pragma[noinline]
  private predicate argumentPositionMatch(
    DataFlowPublic::CallCfgNode call, DataFlowPublic::Node arg,
    DataFlowDispatch::ParameterPosition ppos
  ) {
    exists(DataFlowDispatch::ArgumentPosition apos |
      DataFlowDispatch::parameterMatch(ppos, apos) and
      DataFlowDispatch::normalCallArg(call.getNode(), arg, apos)
    )
  }

  // Relating nodes to summaries
  Node argumentOf(Node call, SummaryComponent arg, boolean isPostUpdate) {
    exists(DataFlowDispatch::ParameterPosition pos |
      arg = FlowSummaryImpl::Private::SummaryComponent::argument(pos) and
      argumentPositionMatch(call, result, pos) and
      isPostUpdate = [false, true] // todo: implement when/if Python uses post-update nodes in type tracking
    )
  }

  Node parameterOf(Node callable, SummaryComponent param) {
    exists(
      DataFlowDispatch::ArgumentPosition apos, DataFlowDispatch::ParameterPosition ppos, Parameter p
    |
      param = FlowSummaryImpl::Private::SummaryComponent::parameter(apos) and
      DataFlowDispatch::parameterMatch(ppos, apos) and
      result.asCfgNode().getNode() = p and
      (
        exists(int i | ppos.isPositional(i) |
          p = callable.getALocalSource().asExpr().(CallableExpr).getInnerScope().getArg(i)
        )
        or
        exists(string name | ppos.isKeyword(name) |
          p = callable.getALocalSource().asExpr().(CallableExpr).getInnerScope().getArgByName(name)
        )
      )
    )
  }

  Node returnOf(Node callable, SummaryComponent return) {
    return = FlowSummaryImpl::Private::SummaryComponent::return() and
    // `result` should be the return value of a callable expression (lambda or function) referenced by `callable`
    result.asCfgNode() =
      callable.getALocalSource().asExpr().(CallableExpr).getInnerScope().getAReturnValueFlowNode()
  }

  // Relating callables to nodes
  Node callTo(SummarizedCallable callable) {
    result = callable.(DataFlowDispatch::LibraryCallable).getACallSimple()
  }
}

private module TypeTrackerSummaryFlow = SummaryTypeTracker::SummaryFlow<SummaryTypeTrackerInput>;

/**
 * Gets the name of a possible piece of content. For Python, this is currently only attribute names,
 * using the name of the attribute for the corresponding content.
 */
private string getPossibleContentName() {
  Stages::TypeTracking::ref() and // the TypeTracking::append() etc. predicates that we want to cache depend on this predicate, so we can place the `ref()` call here to get around identical files.
  result = any(DataFlowPublic::AttrRef a).getAttributeName()
}

module TypeTrackingInput implements Shared::TypeTrackingInput {
  class Node = DataFlowPublic::Node;

  class LocalSourceNode = DataFlowPublic::LocalSourceNode;

  class Content instanceof string {
    Content() { this = getPossibleContentName() }

    string toString() { result = this }
  }

  /**
   * A label to use for `WithContent` and `WithoutContent` steps, restricting
   * which `ContentSet` may pass through.
   */
  class ContentFilter extends Unit {
    Content getAMatchingContent() { none() }
  }

  /**
   * Holds if a value stored with `storeContents` can be read back with `loadContents`.
   */
  pragma[inline]
  predicate compatibleContents(Content storeContents, Content loadContents) {
    storeContents = loadContents
  }

  /** Holds if there is a simple local flow step from `nodeFrom` to `nodeTo` */
  predicate simpleLocalSmallStep = DataFlowPrivate::simpleLocalFlowStepForTypetracking/2;

  /** Holds if there is a level step from `nodeFrom` to `nodeTo`, which may depend on the call graph. */
  predicate levelStepCall(Node nodeFrom, LocalSourceNode nodeTo) { none() }

  /** Holds if there is a level step from `nodeFrom` to `nodeTo`, which does not depend on the call graph. */
  predicate levelStepNoCall(Node nodeFrom, LocalSourceNode nodeTo) {
    TypeTrackerSummaryFlow::levelStepNoCall(nodeFrom, nodeTo)
  }

  /**
   * Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a call.
   *
   * Flow into summarized library methods is not included, as that will lead to negative
   * recursion (or, at best, terrible performance), since identifying calls to library
   * methods is done using API graphs (which uses type tracking).
   */
  predicate callStep(Node nodeFrom, LocalSourceNode nodeTo) {
    exists(
      DataFlowPrivate::DataFlowCall call, DataFlowPrivate::DataFlowCallable callable,
      DataFlowPrivate::ArgumentPosition apos, DataFlowPrivate::ParameterPosition ppos
    |
      nodeFrom = call.getArgument(apos) and
      nodeTo = callable.getParameter(ppos) and
      DataFlowPrivate::parameterMatch(ppos, apos) and
      callable = call.getCallable()
    )
  }

  /**
   * Holds if `nodeFrom` steps to `nodeTo` by being returned from a call.
   *
   * Flow out of summarized library methods is not included, as that will lead to negative
   * recursion (or, at best, terrible performance), since identifying calls to library
   * methods is done using API graphs (which uses type tracking).
   */
  predicate returnStep(Node nodeFrom, LocalSourceNode nodeTo) {
    exists(DataFlowPrivate::ExtractedDataFlowCall call |
      nodeFrom.(DataFlowPrivate::ReturnNode).getEnclosingCallable() = call.getCallable() and
      nodeTo.(DataFlowPublic::CfgNode).getNode() = call.getNode()
    )
  }

  /**
   * Holds if `nodeFrom` is being written to the `content` content of the object in `nodeTo`.
   */
  predicate storeStep(Node nodeFrom, Node nodeTo, Content content) {
    exists(DataFlowPublic::AttrWrite a |
      a.mayHaveAttributeName(content) and
      nodeFrom = a.getValue() and
      nodeTo = a.getObject()
    )
    or
    exists(DataFlowPublic::ContentSet contents |
      contents.(DataFlowPublic::AttributeContent).getAttribute() = content
    |
      TypeTrackerSummaryFlow::basicStoreStep(nodeFrom, nodeTo, contents)
    )
  }

  /**
   * Holds if `nodeTo` is the result of accessing the `content` content of `nodeFrom`.
   */
  predicate loadStep(Node nodeFrom, LocalSourceNode nodeTo, Content content) {
    exists(DataFlowPublic::AttrRead a |
      a.mayHaveAttributeName(content) and
      nodeFrom = a.getObject() and
      nodeTo = a
    )
    or
    exists(DataFlowPublic::ContentSet contents |
      contents.(DataFlowPublic::AttributeContent).getAttribute() = content
    |
      TypeTrackerSummaryFlow::basicLoadStep(nodeFrom, nodeTo, contents)
    )
  }

  /**
   * Holds if the `loadContent` of `nodeFrom` is stored in the `storeContent` of `nodeTo`.
   */
  predicate loadStoreStep(Node nodeFrom, Node nodeTo, Content loadContent, Content storeContent) {
    exists(DataFlowPublic::ContentSet loadContents, DataFlowPublic::ContentSet storeContents |
      loadContents.(DataFlowPublic::AttributeContent).getAttribute() = loadContent and
      storeContents.(DataFlowPublic::AttributeContent).getAttribute() = storeContent
    |
      TypeTrackerSummaryFlow::basicLoadStoreStep(nodeFrom, nodeTo, loadContents, storeContents)
    )
  }

  /**
   * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a content matched by `filter`.
   */
  predicate withContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter filter) {
    TypeTrackerSummaryFlow::basicWithContentStep(nodeFrom, nodeTo, filter)
  }

  /**
   * Holds if type-tracking should step from `nodeFrom` to `nodeTo` but block flow of contents matched by `filter` through here.
   */
  predicate withoutContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter filter) {
    TypeTrackerSummaryFlow::basicWithoutContentStep(nodeFrom, nodeTo, filter)
  }

  private predicate capturedJumpStep(Node nodeFrom, Node nodeTo) {
    // Jump into a capturing scope.
    //
    // var = expr
    // ...
    // def f():
    // ..var is used..
    //
    // nodeFrom is `expr`
    // nodeTo is entry node for `f`
    exists(ScopeEntryDefinition e, SsaSourceVariable var, DefinitionNode def |
      e.getSourceVariable() = var and
      var.hasDefiningNode(def)
    |
      nodeTo.(DataFlowPublic::ScopeEntryDefinitionNode).getDefinition() = e and
      nodeFrom.asCfgNode() = def.getValue() and
      var.getScope().getScope*() = nodeFrom.getScope()
    )
  }

  /**
   * Holds if data can flow from `node1` to `node2` in a way that discards call contexts.
   */
  predicate jumpStep(Node nodeFrom, LocalSourceNode nodeTo) {
    DataFlowPrivate::jumpStepSharedWithTypeTracker(nodeFrom, nodeTo)
    or
    capturedJumpStep(nodeFrom, nodeTo)
  }

  predicate hasFeatureBacktrackStoreTarget() { any() }

  predicate nonStandardFlowsTo(LocalSourceNode localSource, Node dst) { localSource.flowsTo(dst) }
}

import SharedImpl::TypeTracking<TypeTrackingInput>
