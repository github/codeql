/**
 * Provides Python-specific definitions for use in the type tracker library.
 */

private import python
private import semmle.python.dataflow.new.internal.DataFlowPublic as DataFlowPublic
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.python.dataflow.new.internal.DataFlowDispatch as DataFlowDispatch
private import semmle.python.dataflow.new.FlowSummary
import semmle.python.internal.CachedStages

class Node = DataFlowPublic::Node;

class TypeTrackingNode = DataFlowPublic::TypeTrackingNode;

private module SCS = SummaryComponentStack;

private module SC = SummaryComponent;

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

predicate jumpStep = DataFlowPrivate::jumpStepSharedWithTypeTracker/2;

/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which may depend on the call graph. */
predicate levelStepCall(Node nodeFrom, Node nodeTo) { none() }

// For testing
// private import TestSummaries
/** Holds if there is a level step from `nodeFrom` to `nodeTo`, which does not depend on the call graph. */
predicate levelStepNoCall(Node nodeFrom, Node nodeTo) {
  exists(
    SummarizedCallable callable, DataFlowPublic::CallCfgNode call, SummaryComponentStack input,
    SummaryComponentStack output
  |
    callable.propagatesFlow(input, output, true) and
    call = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
    nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
  )
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
  exists(
    SummarizedCallable callable, DataFlowPublic::CallCfgNode call, SummaryComponentStack input,
    SummaryComponentStack output, DataFlowPublic::ContentSet contents
  |
    contents.(DataFlowPublic::AttributeContent).getAttribute() = content
  |
    hasStoreSummary(callable, contents, pragma[only_bind_into](input),
      pragma[only_bind_into](output)) and
    call = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
    nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
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
  exists(
    SummarizedCallable callable, DataFlowPublic::CallCfgNode call, SummaryComponentStack input,
    SummaryComponentStack output, DataFlowPublic::ContentSet contents
  |
    contents.(DataFlowPublic::AttributeContent).getAttribute() = content
  |
    hasLoadSummary(callable, contents, pragma[only_bind_into](input), pragma[only_bind_into](output)) and
    call = callable.getACallSimple() and
    nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
    nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
  )
}

/**
 * Holds if the `loadContent` of `nodeFrom` is stored in the `storeContent` of `nodeTo`.
 */
predicate basicLoadStoreStep(Node nodeFrom, Node nodeTo, string loadContent, string storeContent) {
  none()
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

// Summary level steps
/**
 * Holds if the given component can't be evaluated by `evaluateSummaryComponentStackLocal`.
 */
pragma[nomagic]
predicate isNonLocal(SummaryComponent component) { component = SC::content(_) }

pragma[nomagic]
private predicate hasStoreSummary(
  SummarizedCallable callable, DataFlowPublic::ContentSet contents, SummaryComponentStack input,
  SummaryComponentStack output
) {
  not isNonLocal(input.head()) and
  not isNonLocal(output.head()) and
  callable
      .propagatesFlow(input,
        SummaryComponentStack::push(SummaryComponent::content(contents), output), true)
}

pragma[nomagic]
private predicate hasLoadSummary(
  SummarizedCallable callable, DataFlowPublic::ContentSet contents, SummaryComponentStack input,
  SummaryComponentStack output
) {
  callable
      .propagatesFlow(SummaryComponentStack::push(SummaryComponent::content(contents), input),
        output, true) and
  not isNonLocal(input.head()) and
  not isNonLocal(output.head())
}

private import semmle.python.dataflow.new.internal.AccessPathSyntax as APS

predicate testS(APS::AccessPath ap) { ap.hasSyntaxError() }

pragma[noinline]
private predicate argumentPositionMatch(
  DataFlowPublic::CallCfgNode call, DataFlowPublic::ArgumentNode arg,
  DataFlowDispatch::ParameterPosition ppos
) {
  exists(DataFlowDispatch::ArgumentPosition apos, DataFlowPrivate::DataFlowCall c |
    c.getNode() = call.asCfgNode() and
    arg.argumentOf(c, apos) and
    DataFlowDispatch::parameterMatch(ppos, apos)
  )
}

/**
 * Gets a data flow node corresponding an argument or return value of `call`,
 * as specified by `component`.
 */
bindingset[call, component]
private DataFlowPublic::Node evaluateSummaryComponentLocal(
  DataFlowPublic::CallCfgNode call, SummaryComponent component
) {
  exists(DataFlowDispatch::ParameterPosition pos |
    component = SummaryComponent::argument(pos) and
    argumentPositionMatch(call, result, pos)
  )
  or
  component = SummaryComponent::return() and
  result = call
}

/**
 * Holds if `callable` is relevant for type-tracking and we therefore want `stack` to
 * be evaluated locally at its call sites.
 */
pragma[nomagic]
private predicate dependsOnSummaryComponentStack(
  SummarizedCallable callable, SummaryComponentStack stack
) {
  exists(callable.getACallSimple()) and
  (
    callable.propagatesFlow(stack, _, true)
    or
    callable.propagatesFlow(_, stack, true)
    or
    // include store summaries as they may skip an initial step at the input
    hasStoreSummary(callable, _, stack, _)
  )
  or
  dependsOnSummaryComponentStackCons(callable, _, stack)
}

pragma[nomagic]
private predicate dependsOnSummaryComponentStackCons(
  SummarizedCallable callable, SummaryComponent head, SummaryComponentStack tail
) {
  dependsOnSummaryComponentStack(callable, SCS::push(head, tail))
}

pragma[nomagic]
private predicate dependsOnSummaryComponentStackConsLocal(
  SummarizedCallable callable, SummaryComponent head, SummaryComponentStack tail
) {
  dependsOnSummaryComponentStackCons(callable, head, tail) and
  not isNonLocal(head)
}

pragma[nomagic]
private predicate dependsOnSummaryComponentStackLeaf(
  SummarizedCallable callable, SummaryComponent leaf
) {
  dependsOnSummaryComponentStack(callable, SCS::singleton(leaf))
}

/**
 * Gets a data flow node corresponding to the local input or output of `call`
 * identified by `stack`, if possible.
 */
pragma[nomagic]
private DataFlowPublic::Node evaluateSummaryComponentStackLocal(
  SummarizedCallable callable, DataFlowPublic::CallCfgNode call, SummaryComponentStack stack
) {
  exists(SummaryComponent component |
    dependsOnSummaryComponentStackLeaf(callable, component) and
    stack = SCS::singleton(component) and
    call = callable.getACallSimple() and
    result = evaluateSummaryComponentLocal(call, component)
  )
  or
  exists(DataFlowPublic::Node prev, SummaryComponent head, SummaryComponentStack tail |
    prev = evaluateSummaryComponentStackLocal(callable, call, tail) and
    dependsOnSummaryComponentStackConsLocal(callable, pragma[only_bind_into](head),
      pragma[only_bind_out](tail)) and
    stack = SCS::push(pragma[only_bind_out](head), pragma[only_bind_out](tail))
  |
    exists(
      DataFlowDispatch::ArgumentPosition apos, DataFlowDispatch::ParameterPosition ppos, Parameter p
    |
      head = SummaryComponent::parameter(apos) and
      DataFlowDispatch::parameterMatch(ppos, apos) and
      // pick the SsaNode rather than the CfgNode
      result.asVar().getDefinition().(ParameterDefinition).getParameter() = p and
      (
        exists(int i | ppos.isPositional(i) |
          p = prev.getALocalSource().asExpr().(CallableExpr).getInnerScope().getArg(i)
        )
        or
        exists(string name | ppos.isKeyword(name) |
          p = prev.getALocalSource().asExpr().(CallableExpr).getInnerScope().getArgByName(name)
        )
      )
    )
    or
    head = SummaryComponent::return() and
    // result should be return value of prev which should be a lambda
    result.asCfgNode() =
      prev.getALocalSource().asExpr().(CallableExpr).getInnerScope().getAReturnValueFlowNode()
  )
}
