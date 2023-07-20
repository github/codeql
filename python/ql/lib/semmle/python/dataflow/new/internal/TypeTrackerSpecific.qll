/**
 * Provides Python-specific definitions for use in the type tracker library.
 */

private import python
private import semmle.python.dataflow.new.internal.DataFlowPublic as DataFlowPublic
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
import semmle.python.internal.CachedStages

class Node = DataFlowPublic::Node;

class TypeTrackingNode = DataFlowPublic::TypeTrackingNode;

/** A content name for use by type trackers, or the empty string. */
class OptionalTypeTrackerContent extends string {
  OptionalTypeTrackerContent() {
    this = ""
    or
    this = getPossibleContentName()
  }
}

/** A content name for use by type trackers. */
class TypeTrackerContent extends OptionalTypeTrackerContent {
  TypeTrackerContent() { this != "" }
}

/** Gets the content string representing no value. */
OptionalTypeTrackerContent noContent() { result = "" }

/**
 * A label to use for `WithContent` and `WithoutContent` steps, restricting
 * which `ContentSet` may pass through. Not currently used in Python.
 */
class ContentFilter extends Unit {
  TypeTrackerContent getAMatchingContent() { none() }
}

pragma[inline]
predicate compatibleContents(TypeTrackerContent storeContent, TypeTrackerContent loadContent) {
  storeContent = loadContent
}

predicate simpleLocalFlowStep = DataFlowPrivate::simpleLocalFlowStepForTypetracking/2;

predicate jumpStep(Node nodeFrom, Node nodeTo) {
  DataFlowPrivate::jumpStepSharedWithTypeTracker(nodeFrom, nodeTo)
  or
  capturedJumpStep(nodeFrom, nodeTo)
}

predicate capturedJumpStep(Node nodeFrom, Node nodeTo) {
  exists(SsaSourceVariable var, DefinitionNode def | var.hasDefiningNode(def) |
    nodeTo.asVar().(ScopeEntryDefinition).getSourceVariable() = var and
    nodeFrom.asCfgNode() = def.getValue() and
    var.getScope().getScope*() = nodeFrom.getScope()
  )
}

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which may depend on the call graph. */
predicate levelStepCall(Node nodeFrom, Node nodeTo) { none() }

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which does not depend on the call graph. */
predicate levelStepNoCall(Node nodeFrom, Node nodeTo) {
  TypeTrackerSummaryFlow::levelStepNoCall(nodeFrom, nodeTo)
}

/**
 * Gets the name of a possible piece of content. For Python, this is currently only attribute names,
 * using the name of the attribute for the corresponding content.
 */
string getPossibleContentName() {
  Stages::TypeTracking::ref() and // the TypeTracking::append() etc. predicates that we want to cache depend on this predicate, so we can place the `ref()` call here to get around identical files.
  result = any(DataFlowPublic::AttrRef a).getAttributeName()
}

/**
 * Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a call.
 *
 * Flow into summarized library methods is not included, as that will lead to negative
 * recursion (or, at best, terrible performance), since identifying calls to library
 * methods is done using API graphs (which uses type tracking).
 */
predicate callStep(DataFlowPublic::ArgumentNode nodeFrom, DataFlowPublic::ParameterNode nodeTo) {
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

/** Holds if `nodeFrom` steps to `nodeTo` by being returned from a call. */
predicate returnStep(DataFlowPrivate::ReturnNode nodeFrom, Node nodeTo) {
  exists(DataFlowPrivate::ExtractedDataFlowCall call |
    nodeFrom.getEnclosingCallable() = call.getCallable() and
    nodeTo.(DataFlowPublic::CfgNode).getNode() = call.getNode()
  )
}

/**
 * Holds if `nodeFrom` is being written to the `content` content of the object in `nodeTo`.
 */
predicate basicStoreStep(Node nodeFrom, Node nodeTo, string content) {
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
predicate basicLoadStep(Node nodeFrom, Node nodeTo, string content) {
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
predicate basicLoadStoreStep(Node nodeFrom, Node nodeTo, string loadContent, string storeContent) {
  exists(DataFlowPublic::ContentSet loadContents, DataFlowPublic::ContentSet storeContents |
    loadContents.(DataFlowPublic::AttributeContent).getAttribute() = loadContent and
    storeContents.(DataFlowPublic::AttributeContent).getAttribute() = storeContent
  |
    TypeTrackerSummaryFlow::basicLoadStoreStep(nodeFrom, nodeTo, loadContents, storeContents)
  )
}

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` but block flow of contents matched by `filter` through here.
 */
predicate basicWithoutContentStep(Node nodeFrom, Node nodeTo, ContentFilter filter) { none() }

/**
 * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a content matched by `filter`.
 */
predicate basicWithContentStep(Node nodeFrom, Node nodeTo, ContentFilter filter) { none() }

/**
 * A utility class that is equivalent to `boolean` but does not require type joining.
 */
class Boolean extends boolean {
  Boolean() { this = true or this = false }
}

private import SummaryTypeTracker as SummaryTypeTracker
private import semmle.python.dataflow.new.FlowSummary as FlowSummary
private import semmle.python.dataflow.new.internal.DataFlowDispatch as DataFlowDispatch

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

private module SummaryTypeTrackerInput implements SummaryTypeTracker::Input {
  // Dataflow nodes
  class Node = DataFlowPublic::Node;

  // Content
  class TypeTrackerContent = DataFlowPublic::ContentSet;

  class TypeTrackerContentFilter = ContentFilter;

  TypeTrackerContentFilter getFilterFromWithoutContentStep(TypeTrackerContent content) { none() }

  TypeTrackerContentFilter getFilterFromWithContentStep(TypeTrackerContent content) { none() }

  // Callables
  class SummarizedCallable = FlowSummary::SummarizedCallable;

  // Summaries and their stacks
  class SummaryComponent = FlowSummary::SummaryComponent;

  class SummaryComponentStack = FlowSummary::SummaryComponentStack;

  predicate singleton = FlowSummary::SummaryComponentStack::singleton/1;

  predicate push = FlowSummary::SummaryComponentStack::push/2;

  // Relating content to summaries
  predicate content = FlowSummary::SummaryComponent::content/1;

  SummaryComponent withoutContent(TypeTrackerContent contents) { none() }

  SummaryComponent withContent(TypeTrackerContent contents) { none() }

  predicate return = FlowSummary::SummaryComponent::return/0;

  // Relating nodes to summaries
  Node argumentOf(Node call, SummaryComponent arg) {
    exists(DataFlowDispatch::ParameterPosition pos |
      arg = FlowSummary::SummaryComponent::argument(pos) and
      argumentPositionMatch(call, result, pos)
    )
  }

  Node parameterOf(Node callable, SummaryComponent param) {
    exists(
      DataFlowDispatch::ArgumentPosition apos, DataFlowDispatch::ParameterPosition ppos, Parameter p
    |
      param = FlowSummary::SummaryComponent::parameter(apos) and
      DataFlowDispatch::parameterMatch(ppos, apos) and
      // pick the SsaNode rather than the CfgNode
      result.asVar().getDefinition().(ParameterDefinition).getParameter() = p and
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
    return = FlowSummary::SummaryComponent::return() and
    // `result` should be the return value of a callable expression (lambda or function) referenced by `callable`
    result.asCfgNode() =
      callable.getALocalSource().asExpr().(CallableExpr).getInnerScope().getAReturnValueFlowNode()
  }

  // Relating callables to nodes
  Node callTo(SummarizedCallable callable) { result = callable.getACallSimple() }
}

private module TypeTrackerSummaryFlow = SummaryTypeTracker::SummaryFlow<SummaryTypeTrackerInput>;
