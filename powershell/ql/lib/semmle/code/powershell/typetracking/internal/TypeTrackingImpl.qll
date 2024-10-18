import codeql.typetracking.TypeTracking as Shared
import codeql.typetracking.internal.TypeTrackingImpl as SharedImpl
private import powershell
private import semmle.code.powershell.controlflow.Cfg as Cfg
private import Cfg::CfgNodes
private import codeql.typetracking.internal.SummaryTypeTracker as SummaryTypeTracker
private import semmle.code.powershell.dataflow.DataFlow
private import semmle.code.powershell.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.powershell.dataflow.internal.DataFlowPublic as DataFlowPublic
private import semmle.code.powershell.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.code.powershell.dataflow.internal.DataFlowDispatch as DataFlowDispatch
private import codeql.util.Unit

pragma[noinline]
private predicate argumentPositionMatch(
  DataFlowDispatch::DataFlowCall call, DataFlowPrivate::ArgumentNode arg,
  DataFlowDispatch::ParameterPosition ppos
) {
  exists(DataFlowDispatch::ArgumentPosition apos |
    arg.argumentOf(call, apos) and
    DataFlowDispatch::parameterMatch(ppos, apos)
  )
}

pragma[noinline]
private predicate viableParam(
  DataFlowDispatch::DataFlowCall call, DataFlowPrivate::ParameterNodeImpl p,
  DataFlowDispatch::ParameterPosition ppos
) {
  exists(DataFlowDispatch::DataFlowCallable callable |
    DataFlowDispatch::getTarget(call) = callable.asCfgScope()
  |
    p.isParameterOf(callable, ppos)
  )
}

/** Holds if there is flow from `arg` to `p` via the call `call`. */
pragma[nomagic]
predicate callStep(
  DataFlowDispatch::DataFlowCall call, DataFlow::Node arg, DataFlowPrivate::ParameterNodeImpl p
) {
  exists(DataFlowDispatch::ParameterPosition pos |
    argumentPositionMatch(call, arg, pos) and
    viableParam(call, p, pos)
  )
}

private module SummaryTypeTrackerInput implements SummaryTypeTracker::Input {
  class Node = DataFlow::Node;

  class Content = DataFlowPublic::ContentSet;

  class ContentFilter = TypeTrackingInput::ContentFilter;

  ContentFilter getFilterFromWithoutContentStep(Content content) {
    (
      content.isAnyElement()
      or
      content.isSingleton(any(DataFlow::Content::UnknownElementContent c))
    ) and
    result = MkElementFilter()
  }

  ContentFilter getFilterFromWithContentStep(Content content) {
    (
      content.isAnyElement()
      or
      content.isSingleton(any(DataFlow::Content::ElementContent c))
    ) and
    result = MkElementFilter()
  }

  // Summaries and their stacks
  class SummaryComponent extends Unit {
    SummaryComponent() { none() }
  }

  class SummaryComponentStack extends Unit {
    SummaryComponent head() { none() }
  }

  SummaryComponentStack singleton(SummaryComponent component) { none() }

  SummaryComponentStack push(SummaryComponent head, SummaryComponentStack tail) { none() }

  SummaryComponent return() { none() }

  SummaryComponent content(Content contents) { none() }

  SummaryComponent withoutContent(Content contents) { none() }

  SummaryComponent withContent(Content contents) { none() }

  class SummarizedCallable extends Unit {
    SummarizedCallable() { none() }

    predicate propagatesFlow(
      SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
    ) {
      none()
    }
  }

  Node argumentOf(Node call, SummaryComponent arg, boolean isPostUpdate) { none() }

  Node parameterOf(Node callable, SummaryComponent param) { none() }

  Node returnOf(Node callable, SummaryComponent return) { none() }

  Node callTo(SummarizedCallable callable) { none() }
}

private module TypeTrackerSummaryFlow = SummaryTypeTracker::SummaryFlow<SummaryTypeTrackerInput>;

private newtype TContentFilter = MkElementFilter()

module TypeTrackingInput implements Shared::TypeTrackingInput {
  class Node = DataFlowPublic::Node;

  class LocalSourceNode = DataFlowPublic::LocalSourceNode;

  class Content = DataFlowPublic::ContentSet;

  /**
   * A label to use for `WithContent` and `WithoutContent` steps, restricting
   * which `ContentSet` may pass through.
   */
  class ContentFilter extends TContentFilter {
    /** Gets a string representation of this content filter. */
    string toString() { this = MkElementFilter() and result = "elements" }

    /** Gets the content of a type-tracker that matches this filter. */
    Content getAMatchingContent() {
      this = MkElementFilter() and
      result.getAReadContent() instanceof DataFlow::Content::ElementContent
    }
  }

  /**
   * Holds if a value stored with `storeContents` can be read back with `loadContents`.
   */
  pragma[inline]
  predicate compatibleContents(Content storeContents, Content loadContents) {
    storeContents.getAStoreContent() = loadContents.getAReadContent()
  }

  /** Holds if there is a simple local flow step from `nodeFrom` to `nodeTo` */
  predicate simpleLocalSmallStep = DataFlowPrivate::localFlowStepTypeTracker/2;

  /** Holds if there is a level step from `nodeFrom` to `nodeTo`, which does not depend on the call graph. */
  pragma[nomagic]
  predicate levelStepNoCall(Node nodeFrom, LocalSourceNode nodeTo) {
    TypeTrackerSummaryFlow::levelStepNoCall(nodeFrom, nodeTo)
  }

  /** Holds if there is a level step from `nodeFrom` to `nodeTo`, which may depend on the call graph. */
  pragma[nomagic]
  predicate levelStepCall(Node nodeFrom, LocalSourceNode nodeTo) { none() }

  /**
   * Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a call.
   *
   * Flow into summarized library methods is not included, as that will lead to negative
   * recursion (or, at best, terrible performance), since identifying calls to library
   * methods is done using API graphs (which uses type tracking).
   */
  predicate callStep(Node nodeFrom, LocalSourceNode nodeTo) { callStep(_, nodeFrom, nodeTo) }

  /**
   * Holds if `nodeFrom` steps to `nodeTo` by being returned from a call.
   */
  predicate returnStep(Node nodeFrom, LocalSourceNode nodeTo) {
    exists(CallCfgNode call |
      nodeFrom instanceof DataFlowPrivate::ReturnNode and
      nodeFrom.(DataFlowPrivate::NodeImpl).getCfgScope() =
        DataFlowDispatch::getTarget(DataFlowDispatch::TNormalCall(call)) and
      nodeTo.asExpr().getAstNode() = call.getAstNode()
    )
  }

  /**
   * Holds if `nodeFrom` is being written to the `contents` of the object
   * in `nodeTo`.
   *
   * Note that the choice of `nodeTo` does not have to make sense
   * "chronologically". All we care about is whether the `contents` of
   * `nodeTo` can have a specific type, and the assumption is that if a specific
   * type appears here, then any access of that particular content can yield
   * something of that particular type.
   */
  predicate storeStep(Node nodeFrom, Node nodeTo, Content contents) {
    DataFlowPrivate::storeStep(nodeFrom, contents, nodeTo)
    or
    TypeTrackerSummaryFlow::basicStoreStep(nodeFrom, nodeTo, contents)
  }

  /**
   * Holds if `nodeTo` is the result of accessing the `content` content of `nodeFrom`.
   */
  predicate loadStep(Node nodeFrom, LocalSourceNode nodeTo, Content contents) {
    DataFlowPrivate::readStep(nodeFrom, contents, nodeTo)
    or
    TypeTrackerSummaryFlow::basicLoadStep(nodeFrom, nodeTo, contents)
  }

  /**
   * Holds if the `loadContent` of `nodeFrom` is stored in the `storeContent` of `nodeTo`.
   */
  predicate loadStoreStep(Node nodeFrom, Node nodeTo, Content loadContent, Content storeContent) {
    TypeTrackerSummaryFlow::basicLoadStoreStep(nodeFrom, nodeTo, loadContent, storeContent)
  }

  /**
   * Same as `withContentStep`, but `nodeTo` has type `Node` instead of `LocalSourceNode`,
   * which allows for it by used in the definition of `LocalSourceNode`.
   */
  additional predicate withContentStepImpl(Node nodeFrom, Node nodeTo, ContentFilter filter) {
    TypeTrackerSummaryFlow::basicWithContentStep(nodeFrom, nodeTo, filter)
  }

  /**
   * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a
   * content matched by `filter`.
   */
  predicate withContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter filter) {
    withContentStepImpl(nodeFrom, nodeTo, filter)
  }

  /**
   * Same as `withoutContentStep`, but `nodeTo` has type `Node` instead of `LocalSourceNode`,
   * which allows for it by used in the definition of `LocalSourceNode`.
   */
  additional predicate withoutContentStepImpl(Node nodeFrom, Node nodeTo, ContentFilter filter) {
    TypeTrackerSummaryFlow::basicWithoutContentStep(nodeFrom, nodeTo, filter)
  }

  /**
   * Holds if type-tracking should step from `nodeFrom` to `nodeTo` but block
   * flow of contents matched by `filter` through here.
   */
  predicate withoutContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter filter) {
    withoutContentStepImpl(nodeFrom, nodeTo, filter)
  }

  /**
   * Holds if data can flow from `node1` to `node2` in a way that discards call contexts.
   */
  predicate jumpStep(Node nodeFrom, LocalSourceNode nodeTo) {
    DataFlowPrivate::jumpStep(nodeFrom, nodeTo)
  }

  predicate hasFeatureBacktrackStoreTarget() { none() }
}

import SharedImpl::TypeTracking<TypeTrackingInput>
