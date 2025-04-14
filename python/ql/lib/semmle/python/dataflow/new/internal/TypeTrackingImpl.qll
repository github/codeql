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
private import semmle.python.dataflow.new.internal.IterableUnpacking as IterableUnpacking

private module SummaryTypeTrackerInput implements SummaryTypeTracker::Input {
  // Dataflow nodes
  class Node = DataFlowPublic::Node;

  // Content
  class Content = DataFlowPublic::ContentSet;

  class ContentFilter = TypeTrackingInput::ContentFilter;

  ContentFilter getFilterFromWithoutContentStep(Content content) { none() }

  ContentFilter getFilterFromWithContentStep(Content content) { none() }

  // Callables
  class SummarizedCallable instanceof FlowSummaryImpl::Private::SummarizedCallableImpl {
    string toString() { result = super.toString() }

    predicate propagatesFlow(
      SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
    ) {
      super.propagatesFlow(input, output, preservesValue, _)
    }
  }

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

module TypeTrackingInput implements Shared::TypeTrackingInput<Location> {
  class Node = DataFlowPublic::Node;

  class LocalSourceNode = DataFlowPublic::LocalSourceNode;

  class Content extends DataFlowPublic::Content {
    Content() {
      // TODO: for now, it's not 100% clear if should support non-precise content in
      // type-tracking, or if it will lead to bad results. We start with only allowing
      // precise content, which should always be a good improvement! It also simplifies
      // the process of examining new results from non-precise content steps in the
      // future, since you will _only_ have to look over the results from the new
      // non-precise steps.
      this instanceof DataFlowPublic::AttributeContent
      or
      this instanceof DataFlowPublic::DictionaryElementContent
      or
      this instanceof DataFlowPublic::TupleElementContent
    }
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
  predicate simpleLocalSmallStep(Node nodeFrom, Node nodeTo) {
    DataFlowPrivate::simpleLocalFlowStepForTypetracking(nodeFrom, nodeTo) and
    // for `for k,v in foo` no need to do local flow step from the synthetic sequence
    // node for `k,v` to the tuple `k,v` -- since type-tracking only supports one level
    // of content tracking, and there is one read-step from `foo` the synthetic sequence
    // node required, we can skip the flow step from the synthetic sequence node to the
    // tuple itself, since the read-step from the tuple to the tuple elements will not
    // matter.
    not (
      IterableUnpacking::iterableUnpackingForReadStep(_, _, nodeFrom) and
      IterableUnpacking::iterableUnpackingTupleFlowStep(nodeFrom, nodeTo)
    ) and
    // for nested iterable unpacking, such as `[[a]] = foo` or `((a,b),) = bar`, we can
    // ignore the flow steps from the synthetic sequence node to the real sequence node,
    // since we only support one level of content in type-trackers, and the nested
    // structure requires two levels at least to be useful.
    not exists(SequenceNode outer |
      outer.getAnElement() = nodeTo.asCfgNode() and
      IterableUnpacking::iterableUnpackingTupleFlowStep(nodeFrom, nodeTo)
    )
  }

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
    exists(DataFlowPublic::AttrWrite a, string attrName |
      content.(DataFlowPublic::AttributeContent).getAttribute() = attrName and
      a.mayHaveAttributeName(attrName) and
      nodeFrom = a.getValue() and
      nodeTo = a.getObject()
    )
    or
    // type-tracking doesn't really handle PostUpdateNodes, so for some assignment steps
    // like `my_dict["foo"] = foo` the data-flow step targets the PostUpdateNode for
    // `my_dict`, where we want to translate that into a type-tracking step that targets
    // the normal/non-PostUpdateNode for `my_dict`.
    exists(DataFlowPublic::Node storeTarget |
      DataFlowPrivate::storeStepCommon(nodeFrom, content, storeTarget)
    |
      not storeTarget instanceof DataFlowPrivate::SyntheticPostUpdateNode and
      nodeTo = storeTarget
      or
      nodeTo = storeTarget.(DataFlowPrivate::SyntheticPostUpdateNode).getPreUpdateNode()
    ) and
    // when only supporting precise content, no need for IterableElementNode (since it
    // is only fed set/list content)
    not nodeFrom instanceof DataFlowPublic::IterableElementNode
    or
    TypeTrackerSummaryFlow::basicStoreStep(nodeFrom, nodeTo, content)
  }

  /**
   * Holds if `nodeTo` is the result of accessing the `content` content of `nodeFrom`.
   */
  predicate loadStep(Node nodeFrom, LocalSourceNode nodeTo, Content content) {
    exists(DataFlowPublic::AttrRead a, string attrName |
      content.(DataFlowPublic::AttributeContent).getAttribute() = attrName and
      a.mayHaveAttributeName(attrName) and
      nodeFrom = a.getObject() and
      nodeTo = a
    )
    or
    DataFlowPrivate::readStepCommon(nodeFrom, content, nodeTo) and
    // Since we only support one level of content in type-trackers we don't actually
    // support `(aa, ab), (ba, bb) = ...`. Therefore we exclude the read-step from `(aa,
    // ab)` to `aa` (since it is not needed).
    not exists(SequenceNode outer |
      outer.getAnElement() = nodeFrom.asCfgNode() and
      IterableUnpacking::iterableUnpackingTupleFlowStep(_, nodeFrom)
    ) and
    // Again, due to only supporting one level deep, for `for (k,v) in ...` we exclude read-step from
    // the tuple to `k` and `v`.
    not exists(DataFlowPublic::IterableSequenceNode seq, DataFlowPublic::IterableElementNode elem |
      IterableUnpacking::iterableUnpackingForReadStep(_, _, seq) and
      IterableUnpacking::iterableUnpackingConvertingReadStep(seq, _, elem) and
      IterableUnpacking::iterableUnpackingConvertingStoreStep(elem, _, nodeFrom) and
      nodeFrom.asCfgNode() instanceof SequenceNode
    )
    or
    TypeTrackerSummaryFlow::basicLoadStep(nodeFrom, nodeTo, content)
  }

  /**
   * Holds if the `loadContent` of `nodeFrom` is stored in the `storeContent` of `nodeTo`.
   */
  predicate loadStoreStep(Node nodeFrom, Node nodeTo, Content loadContent, Content storeContent) {
    TypeTrackerSummaryFlow::basicLoadStoreStep(nodeFrom, nodeTo, loadContent, storeContent)
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
      nodeFrom.asCfgNode() = def and
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

import SharedImpl::TypeTracking<Location, TypeTrackingInput>
