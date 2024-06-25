private import python
private import DataFlowPublic
private import semmle.python.essa.SsaCompute
private import semmle.python.dataflow.new.internal.ImportResolution
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.python.frameworks.data.ModelsAsData
// Since we allow extra data-flow steps from modeled frameworks, we import these
// up-front, to ensure these are included. This provides a more seamless experience from
// a user point of view, since they don't need to know they need to import a specific
// set of .qll files to get the same data-flow steps as they are used to seeing. This
// also ensures that we don't end up re-evaluating data-flow because it has different
// global steps in some configurations.
//
// This matches behavior in C#.
private import semmle.python.Frameworks
// part of the implementation for this module has been spread over multiple files to
// make it more digestible.
import MatchUnpacking
import IterableUnpacking
import DataFlowDispatch
import VariableCapture as VariableCapture

/** Gets the callable in which this node occurs. */
DataFlowCallable nodeGetEnclosingCallable(Node n) { result = n.getEnclosingCallable() }

/** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
  p.(ParameterNodeImpl).isParameterOf(c, pos)
}

/** Holds if `arg` is an `ArgumentNode` of `c` with position `pos`. */
predicate isArgumentNode(ArgumentNode arg, DataFlowCall c, ArgumentPosition pos) {
  arg.argumentOf(c, pos)
}

//--------
// Data flow graph
//--------
//--------
// Nodes
//--------
predicate isExpressionNode(ControlFlowNode node) { node.getNode() instanceof Expr }

// =============================================================================
// SyntheticPreUpdateNode
// =============================================================================
class SyntheticPreUpdateNode extends Node, TSyntheticPreUpdateNode {
  CallNode node;

  SyntheticPreUpdateNode() { this = TSyntheticPreUpdateNode(node) }

  /** Gets the node for which this is a synthetic pre-update node. */
  CfgNode getPostUpdateNode() { result.getNode() = node }

  override string toString() { result = "[pre] " + node.toString() }

  override Scope getScope() { result = node.getScope() }

  override Location getLocation() { result = node.getLocation() }
}

// =============================================================================
// *args (StarArgs) related
// =============================================================================
/**
 * A (synthetic) data-flow parameter node to capture all positional arguments that
 * should be passed to the `*args` parameter.
 *
 * To handle
 * ```py
 * def func(*args):
 *     for arg in args:
 *         sink(arg)
 *
 * func(source1, source2, ...)
 * ```
 *
 * we add a synthetic parameter to `func` that accepts any positional argument at (or
 * after) the index for the `*args` parameter. We add a store step (at any list index) to the real
 * `*args` parameter. This means we can handle the code above, but if the code had done `sink(args[0])`
 * we would (wrongly) add flow for `source2` as well.
 *
 * To solve this more precisely, we could add a synthetic argument with position `*args`
 * that had store steps with the correct index (like we do for mapping keyword arguments to a
 * `**kwargs` parameter). However, if a single call could go to 2 different
 * targets with `*args` parameters at different positions, as in the example below, it's unclear what
 * index to store `2` at. For the `foo` callable it should be 1, for the `bar` callable it should be 0.
 * So this information would need to be encoded in the arguments of a `ArgumentPosition` branch, and
 * one of the arguments would be which callable is the target. However, we cannot build `ArgumentPosition`
 * branches based on the call-graph, so this strategy doesn't work.
 *
 * Another approach to solving it precisely is to add multiple synthetic parameters that have store steps
 * to the real `*args` parameter. So for the example below, `foo` would need to have synthetic parameter
 * nodes for indexes 1 and 2 (which would have store step for index 0 and 1 of the `*args` parameter),
 * and `bar` would need it for indexes 1, 2, and 3. The question becomes how many synthetic parameters to
 * create, which _must_ be `max(Call call, int i | exists(call.getArg(i)))`, since (again) we can't base
 * this on the call-graph. And each function with a `*args` parameter would need this many extra synthetic
 * nodes. My gut feeling at that this simple approach will be good enough, but if we need to get it more
 * precise, it should be possible to do it like this.
 *
 * In PR review, @yoff suggested an alternative approach for more precise handling:
 *
 * - At the call site, all positional arguments are stored into a synthetic starArgs argument, always tarting at index 0
 * - This is sent to a synthetic star parameter
 * - At the receiving end, we know the offset of a potential real star parameter, so we can define read steps accordingly: In foo, we read from the synthetic star parameter at index 1 and store to the real star parameter at index 0.
 *
 * ```py
 * def foo(one, *args): ...
 * def bar(*args): ...
 *
 * func = foo if <cond> else bar
 * func(1, 2, 3)
 */
class SynthStarArgsElementParameterNode extends ParameterNodeImpl,
  TSynthStarArgsElementParameterNode
{
  DataFlowCallable callable;

  SynthStarArgsElementParameterNode() { this = TSynthStarArgsElementParameterNode(callable) }

  override string toString() { result = "SynthStarArgsElementParameterNode" }

  override Scope getScope() { result = callable.getScope() }

  override Location getLocation() { result = callable.getLocation() }

  override Parameter getParameter() { none() }
}

predicate synthStarArgsElementParameterNodeStoreStep(
  SynthStarArgsElementParameterNode nodeFrom, ListElementContent c, ParameterNode nodeTo
) {
  c = c and // suppress warning about unused parameter
  exists(DataFlowCallable callable, ParameterPosition ppos |
    nodeFrom = TSynthStarArgsElementParameterNode(callable) and
    nodeTo = callable.getParameter(ppos) and
    ppos.isStarArgs(_)
  )
}

// =============================================================================
// **kwargs (DictSplat) related
// =============================================================================
/**
 * A (synthetic) data-flow node that represents all keyword arguments, as if they had
 * been passed in a `**kwargs` argument.
 */
class SynthDictSplatArgumentNode extends Node, TSynthDictSplatArgumentNode {
  CallNode node;

  SynthDictSplatArgumentNode() { this = TSynthDictSplatArgumentNode(node) }

  override string toString() { result = "SynthDictSplatArgumentNode" }

  override Scope getScope() { result = node.getScope() }

  override Location getLocation() { result = node.getLocation() }
}

private predicate synthDictSplatArgumentNodeStoreStep(
  ArgumentNode nodeFrom, DictionaryElementContent c, SynthDictSplatArgumentNode nodeTo
) {
  exists(string name, CallNode call, ArgumentPosition keywordPos |
    nodeTo = TSynthDictSplatArgumentNode(call) and
    getCallArg(call, _, _, nodeFrom, keywordPos) and
    keywordPos.isKeyword(name) and
    c.getKey() = name
  )
}

/**
 * Ensures that the a `**kwargs` parameter will not contain elements with names of
 * keyword parameters.
 *
 * For example, for the function below, it's not possible that the `kwargs` dictionary
 * can contain an element with the name `a`, since that parameter can be given as a
 * keyword argument.
 *
 * ```py
 * def func(a, **kwargs):
 *     ...
 * ```
 */
private predicate dictSplatParameterNodeClearStep(ParameterNode n, DictionaryElementContent c) {
  exists(DataFlowCallable callable, ParameterPosition dictSplatPos, ParameterPosition keywordPos |
    dictSplatPos.isDictSplat() and
    n = callable.getParameter(dictSplatPos) and
    exists(callable.getParameter(keywordPos)) and
    keywordPos.isKeyword(c.getKey())
  )
}

/**
 * A synthetic data-flow node to allow flow to keyword parameters from a `**kwargs` argument.
 *
 * Take the code snippet below as an example. Since the call only has a `**kwargs` argument,
 * with a `**` argument position, we add this synthetic parameter node with `**` parameter position,
 * and a read step to the `p1` parameter.
 *
 * ```py
 * def foo(p1, p2): ...
 *
 * kwargs = {"p1": 42, "p2": 43}
 * foo(**kwargs)
 * ```
 *
 *
 * Note that this will introduce a bit of redundancy in cases like
 *
 * ```py
 * foo(p1=taint(1), p2=taint(2))
 * ```
 *
 * where direct keyword matching is possible, since we construct a synthesized dict
 * splat argument (`SynthDictSplatArgumentNode`) at the call site, which means that
 * `taint(1)` will flow into `p1` both via normal keyword matching and via the synthesized
 * nodes (and similarly for `p2`). However, this redundancy is OK since
 *  (a) it means that type-tracking through keyword arguments also works in most cases,
 *  (b) read/store steps can be avoided when direct keyword matching is possible, and
 *      hence access path limits are not a concern, and
 *  (c) since the synthesized nodes are hidden, the reported data-flow paths will be
 *      collapsed anyway.
 */
class SynthDictSplatParameterNode extends ParameterNodeImpl, TSynthDictSplatParameterNode {
  DataFlowCallable callable;

  SynthDictSplatParameterNode() { this = TSynthDictSplatParameterNode(callable) }

  override string toString() { result = "SynthDictSplatParameterNode" }

  override Scope getScope() { result = callable.getScope() }

  override Location getLocation() { result = callable.getLocation() }

  override Parameter getParameter() { none() }
}

/**
 * Reads from the synthetic **kwargs parameter to each keyword parameter.
 */
predicate synthDictSplatParameterNodeReadStep(
  SynthDictSplatParameterNode nodeFrom, DictionaryElementContent c, ParameterNode nodeTo
) {
  exists(DataFlowCallable callable, ParameterPosition ppos |
    nodeFrom = TSynthDictSplatParameterNode(callable) and
    nodeTo = callable.getParameter(ppos) and
    ppos.isKeyword(c.getKey())
  )
}

// =============================================================================
// PostUpdateNode
// =============================================================================
abstract class PostUpdateNodeImpl extends Node {
  /** Gets the node before the state update. */
  abstract Node getPreUpdateNode();
}

class SyntheticPostUpdateNode extends PostUpdateNodeImpl, TSyntheticPostUpdateNode {
  ControlFlowNode node;

  SyntheticPostUpdateNode() { this = TSyntheticPostUpdateNode(node) }

  override Node getPreUpdateNode() { result.(CfgNode).getNode() = node }

  override string toString() { result = "[post] " + node.toString() }

  override Scope getScope() { result = node.getScope() }

  override Location getLocation() { result = node.getLocation() }
}

class NonSyntheticPostUpdateNode extends PostUpdateNodeImpl, CfgNode {
  SyntheticPreUpdateNode pre;

  NonSyntheticPostUpdateNode() { this = pre.getPostUpdateNode() }

  override Node getPreUpdateNode() { result = pre }
}

class DataFlowExpr = Expr;

/**
 * A module to compute local flow.
 *
 * Flow will generally go from control flow nodes for expressions into
 * control flow nodes for variables at definitions,
 * and from there via use-use flow to other control flow nodes.
 *
 * Some syntaxtic constructs are handled separately.
 */
module LocalFlow {
  /** Holds if `nodeFrom` is the expression defining the value for the variable `nodeTo`. */
  predicate definitionFlowStep(Node nodeFrom, Node nodeTo) {
    // Definition
    //   `x = f(42)`
    //   nodeFrom is `f(42)`
    //   nodeTo is `x`
    exists(AssignmentDefinition def |
      nodeFrom.(CfgNode).getNode() = def.getValue() and
      nodeTo.(CfgNode).getNode() = def.getDefiningNode()
    )
    or
    // With definition
    //   `with f(42) as x:`
    //   nodeFrom is `f(42)`
    //   nodeTo is `x`
    exists(With with, ControlFlowNode contextManager, WithDefinition withDef, ControlFlowNode var |
      var = withDef.getDefiningNode()
    |
      nodeFrom.(CfgNode).getNode() = contextManager and
      nodeTo.(CfgNode).getNode() = var and
      // see `with_flow` in `python/ql/src/semmle/python/dataflow/Implementation.qll`
      with.getContextExpr() = contextManager.getNode() and
      with.getOptionalVars() = var.getNode() and
      contextManager.strictlyDominates(var)
      // note: we allow this for both `with` and `async with`, since some
      // implementations do `async def __aenter__(self): return self`, so you can do
      // both:
      // * `foo = x.foo(); await foo.async_method(); foo.close()` and
      // * `async with x.foo() as foo: await foo.async_method()`.
    )
  }

  predicate expressionFlowStep(Node nodeFrom, Node nodeTo) {
    // If expressions
    nodeFrom.asCfgNode() = nodeTo.asCfgNode().(IfExprNode).getAnOperand()
    or
    // Assignment expressions
    nodeFrom.asCfgNode() = nodeTo.asCfgNode().(AssignmentExprNode).getValue()
    or
    // boolean inline expressions such as `x or y` or `x and y`
    nodeFrom.asCfgNode() = nodeTo.asCfgNode().(BoolExprNode).getAnOperand()
    or
    // Flow inside an unpacking assignment
    iterableUnpackingFlowStep(nodeFrom, nodeTo)
    or
    // Flow inside a match statement
    matchFlowStep(nodeFrom, nodeTo)
  }

  predicate useToNextUse(NameNode nodeFrom, NameNode nodeTo) {
    AdjacentUses::adjacentUseUse(nodeFrom, nodeTo)
  }

  predicate defToFirstUse(EssaVariable var, NameNode nodeTo) {
    AdjacentUses::firstUse(var.getDefinition(), nodeTo)
  }

  predicate useUseFlowStep(Node nodeFrom, Node nodeTo) {
    // First use after definition
    //   `y = 42`
    //   `x = f(y)`
    //   nodeFrom is `y` on first line
    //   nodeTo is `y` on second line
    exists(EssaDefinition def |
      nodeFrom.(CfgNode).getNode() = def.(EssaNodeDefinition).getDefiningNode()
      or
      nodeFrom.(ScopeEntryDefinitionNode).getDefinition() = def
    |
      AdjacentUses::firstUse(def, nodeTo.(CfgNode).getNode())
    )
    or
    // Next use after use
    //   `x = f(y)`
    //   `z = y + 1`
    //   nodeFrom is 'y' on first line, cfg node
    //   nodeTo is `y` on second line, cfg node
    useToNextUse(nodeFrom.asCfgNode(), nodeTo.asCfgNode())
  }

  predicate localFlowStep(Node nodeFrom, Node nodeTo) {
    IncludePostUpdateFlow<PhaseDependentFlow<definitionFlowStep/2>::step/2>::step(nodeFrom, nodeTo)
    or
    IncludePostUpdateFlow<PhaseDependentFlow<expressionFlowStep/2>::step/2>::step(nodeFrom, nodeTo)
    or
    // Blindly applying use-use flow can result in a node that steps to itself, for
    // example in while-loops. To uphold dataflow consistency checks, we don't want
    // that. However, we do want to allow `[post] n` to `n` (to handle while loops), so
    // we should only do the filtering after `IncludePostUpdateFlow` has ben applied.
    IncludePostUpdateFlow<PhaseDependentFlow<useUseFlowStep/2>::step/2>::step(nodeFrom, nodeTo) and
    nodeFrom != nodeTo
  }
}

//--------
// Local flow
//--------
/** A module for transforming step relations. */
module StepRelationTransformations {
  /**
   * Holds if there is a step from `nodeFrom` to `nodeTo` in
   * the step relation to be transformed.
   *
   * This is the input relation to the transformations.
   */
  signature predicate stepSig(Node nodeFrom, Node nodeTo);

  /**
   * A module to separate import-time from run-time.
   *
   * We really have two local flow relations, one for module initialisation time (or _import time_) and one for runtime.
   * Consider a read from a global variable `x = foo`. At import time there should be a local flow step from `foo` to `x`,
   * while at runtime there should be a jump step from the module variable corresponding to `foo` to `x`.
   *
   * Similarly, for a write `foo = y`, at import time, there is a local flow step from `y` to `foo` while at runtime there
   * is a jump step from `y` to the module variable corresponding to `foo`.
   *
   * We need a way of distinguishing if we are looking at import time or runtime. We have the following helpful facts:
   * - All top-level executable statements are import time (and import time only)
   * - All non-top-level code may be executed at runtime (but could also be executed at import time)
   *
   * We could write an analysis to determine which functions are called at import time, but until we have that, we will go
   * with the heuristic that global variables act according to import time rules at top-level program points and according
   * to runtime rules everywhere else. This will forego some import time local flow but otherwise be consistent.
   */
  module PhaseDependentFlow<stepSig/2 rawStep> {
    /**
     * Holds if `node` is found at the top level of a module.
     */
    pragma[inline]
    private predicate isTopLevel(Node node) { node.getScope() instanceof Module }

    /** Holds if a step can be taken from `nodeFrom` to `nodeTo` at import time. */
    predicate importTimeStep(Node nodeFrom, Node nodeTo) {
      // As a proxy for whether statements can be executed at import time,
      // we check if they appear at the top level.
      // This will miss statements inside functions called from the top level.
      isTopLevel(nodeFrom) and
      isTopLevel(nodeTo) and
      rawStep(nodeFrom, nodeTo)
    }

    /** Holds if a step can be taken from `nodeFrom` to `nodeTo` at runtime. */
    predicate runtimeStep(Node nodeFrom, Node nodeTo) {
      // Anything not at the top level can be executed at runtime.
      not isTopLevel(nodeFrom) and
      not isTopLevel(nodeTo) and
      rawStep(nodeFrom, nodeTo)
    }

    /**
     * Holds if a step can be taken from `nodeFrom` to `nodeTo`.
     */
    predicate step(Node nodeFrom, Node nodeTo) {
      importTimeStep(nodeFrom, nodeTo) or
      runtimeStep(nodeFrom, nodeTo)
    }
  }

  /**
   * A module to add steps from post-update nodes.
   * Whenever there is a step from `x` to `y`,
   * we add a step from `[post] x` to `y`.
   */
  module IncludePostUpdateFlow<stepSig/2 rawStep> {
    predicate step(Node nodeFrom, Node nodeTo) {
      // We either have a raw step from `nodeFrom`...
      rawStep(nodeFrom, nodeTo)
      or
      // ...or we have a raw step from a pre-update node of `nodeFrom`
      rawStep(nodeFrom.(PostUpdateNode).getPreUpdateNode(), nodeTo)
    }
  }
}

import StepRelationTransformations

/**
 * This is the local flow predicate that is used as a building block in global
 * data flow.
 *
 * It includes flow steps from flow summaries.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo, string model) {
  simpleLocalFlowStepForTypetracking(nodeFrom, nodeTo) and model = ""
  or
  summaryLocalStep(nodeFrom, nodeTo, model)
  or
  variableCaptureLocalFlowStep(nodeFrom, nodeTo) and model = ""
}

/**
 * This is the local flow predicate that is used as a building block in
 * type tracking, it does _not_ include steps from flow summaries.
 *
 * Local flow can happen either at import time, when the module is initialised
 * or at runtime when callables in the module are called.
 */
predicate simpleLocalFlowStepForTypetracking(Node nodeFrom, Node nodeTo) {
  LocalFlow::localFlowStep(nodeFrom, nodeTo)
}

private predicate summaryLocalStep(Node nodeFrom, Node nodeTo, string model) {
  FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
    nodeTo.(FlowSummaryNode).getSummaryNode(), true, model)
}

predicate variableCaptureLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // Blindly applying use-use flow can result in a node that steps to itself, for
  // example in while-loops. To uphold dataflow consistency checks, we don't want
  // that. However, we do want to allow `[post] n` to `n` (to handle while loops), so
  // we should only do the filtering after `IncludePostUpdateFlow` has ben applied.
  IncludePostUpdateFlow<PhaseDependentFlow<VariableCapture::valueStep/2>::step/2>::step(nodeFrom,
    nodeTo) and
  nodeFrom != nodeTo
}

/** `ModuleVariable`s are accessed via jump steps at runtime. */
predicate runtimeJumpStep(Node nodeFrom, Node nodeTo) {
  // Module variable read
  nodeFrom.(ModuleVariableNode).getARead() = nodeTo
  or
  // Module variable write
  nodeFrom = nodeTo.(ModuleVariableNode).getAWrite()
  or
  // Setting the possible values of the variable at the end of import time
  nodeFrom = nodeTo.(ModuleVariableNode).getADefiningWrite()
  or
  // a parameter with a default value, since the parameter will be in the scope of the
  // function, while the default value itself will be in the scope that _defines_ the
  // function.
  exists(ParameterDefinition param |
    // note: we go to the _control-flow node_ of the parameter, and not the ESSA node of the parameter, since for type-tracking, the ESSA node is not a LocalSourceNode, so we would get in trouble.
    nodeFrom.asCfgNode() = param.getDefault() and
    nodeTo.asCfgNode() = param.getDefiningNode()
  )
}

//--------
// Type pruning
//--------
newtype TDataFlowType = TAnyFlow()

class DataFlowType extends TDataFlowType {
  /** Gets a textual representation of this element. */
  string toString() { result = "DataFlowType" }
}

/** A node that performs a type cast. */
class CastNode extends Node {
  CastNode() { none() }
}

/**
 * Holds if `n` should never be skipped over in the `PathGraph` and in path
 * explanations.
 */
predicate neverSkipInPathGraph(Node n) {
  // NOTE: We could use RHS of a definition, but since we have use-use flow, in an
  // example like
  // ```py
  // x = SOURCE()
  // if <cond>:
  //     y = x
  // SINK(x)
  // ```
  // we would end up saying that the path MUST not skip the x in `y = x`, which is just
  // annoying and doesn't help the path explanation become clearer.
  n.asCfgNode() = any(EssaNodeDefinition def).getDefiningNode()
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

predicate typeStrongerThan(DataFlowType t1, DataFlowType t2) { none() }

predicate localMustFlowStep(Node nodeFrom, Node nodeTo) { none() }

/**
 * Gets the type of `node`.
 */
DataFlowType getNodeType(Node node) {
  result = TAnyFlow() and
  exists(node)
}

/** Gets a string representation of a type returned by `getErasedRepr`. */
string ppReprType(DataFlowType t) { none() }

//--------
// Extra flow
//--------
/**
 * Holds if `pred` can flow to `succ`, by jumping from one callable to
 * another. Additional steps specified by the configuration are *not*
 * taken into account.
 */
predicate jumpStep(Node nodeFrom, Node nodeTo) {
  jumpStepSharedWithTypeTracker(nodeFrom, nodeTo)
  or
  jumpStepNotSharedWithTypeTracker(nodeFrom, nodeTo)
  or
  FlowSummaryImpl::Private::Steps::summaryJumpStep(nodeFrom.(FlowSummaryNode).getSummaryNode(),
    nodeTo.(FlowSummaryNode).getSummaryNode())
}

/**
 * Set of jumpSteps that are shared with type-tracker implementation.
 *
 * For ORM modeling we want to add jumpsteps to global dataflow, but since these are
 * based on type-trackers, it's important that these new ORM jumpsteps are not used in
 * the type-trackers as well, as that would make evaluation of type-tracking recursive
 * with the new jumpsteps.
 *
 * Holds if `pred` can flow to `succ`, by jumping from one callable to
 * another. Additional steps specified by the configuration are *not*
 * taken into account.
 */
predicate jumpStepSharedWithTypeTracker(Node nodeFrom, Node nodeTo) {
  runtimeJumpStep(nodeFrom, nodeTo)
  or
  // Read of module attribute:
  exists(AttrRead r |
    ImportResolution::module_export(ImportResolution::getModule(r.getObject()),
      r.getAttributeName(), nodeFrom) and
    nodeTo = r
  )
}

/**
 * Set of jumpSteps that are NOT shared with type-tracker implementation.
 *
 * For ORM modeling we want to add jumpsteps to global dataflow, but since these are
 * based on type-trackers, it's important that these new ORM jumpsteps are not used in
 * the type-trackers as well, as that would make evaluation of type-tracking recursive
 * with the new jumpsteps.
 *
 * Holds if `pred` can flow to `succ`, by jumping from one callable to
 * another. Additional steps specified by the configuration are *not*
 * taken into account.
 */
predicate jumpStepNotSharedWithTypeTracker(Node nodeFrom, Node nodeTo) {
  any(Orm::AdditionalOrmSteps es).jumpStep(nodeFrom, nodeTo)
}

//--------
// Field flow
//--------
/**
 * Subset of `storeStep` that should be shared with type-tracking.
 *
 * NOTE: This does not include attributeStoreStep right now, since it has its' own
 * modeling in the type-tracking library (which is slightly different due to
 * PostUpdateNodes).
 *
 * As of 2024-04-02 the type-tracking library only supports precise content, so there is
 * no reason to include steps for list content right now.
 */
predicate storeStepCommon(Node nodeFrom, ContentSet c, Node nodeTo) {
  tupleStoreStep(nodeFrom, c, nodeTo)
  or
  dictStoreStep(nodeFrom, c, nodeTo)
  or
  moreDictStoreSteps(nodeFrom, c, nodeTo)
  or
  iterableUnpackingStoreStep(nodeFrom, c, nodeTo)
}

/**
 * Holds if data can flow from `nodeFrom` to `nodeTo` via an assignment to
 * content `c`.
 */
predicate storeStep(Node nodeFrom, ContentSet c, Node nodeTo) {
  storeStepCommon(nodeFrom, c, nodeTo)
  or
  listStoreStep(nodeFrom, c, nodeTo)
  or
  setStoreStep(nodeFrom, c, nodeTo)
  or
  comprehensionStoreStep(nodeFrom, c, nodeTo)
  or
  attributeStoreStep(nodeFrom, c, nodeTo)
  or
  matchStoreStep(nodeFrom, c, nodeTo)
  or
  any(Orm::AdditionalOrmSteps es).storeStep(nodeFrom, c, nodeTo)
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(nodeFrom.(FlowSummaryNode).getSummaryNode(), c,
    nodeTo.(FlowSummaryNode).getSummaryNode())
  or
  synthStarArgsElementParameterNodeStoreStep(nodeFrom, c, nodeTo)
  or
  synthDictSplatArgumentNodeStoreStep(nodeFrom, c, nodeTo)
  or
  VariableCapture::storeStep(nodeFrom, c, nodeTo)
}

/**
 * A synthesized data flow node representing a closure object that tracks
 * captured variables.
 */
class SynthCaptureNode extends Node, TSynthCaptureNode {
  private VariableCapture::Flow::SynthesizedCaptureNode cn;

  SynthCaptureNode() { this = TSynthCaptureNode(cn) }

  /** Gets the `SynthesizedCaptureNode` that this node represents. */
  VariableCapture::Flow::SynthesizedCaptureNode getSynthesizedCaptureNode() { result = cn }

  override Scope getScope() { result = cn.getEnclosingCallable() }

  override Location getLocation() { result = cn.getLocation() }

  override string toString() { result = cn.toString() }
}

private class SynthCapturePostUpdateNode extends PostUpdateNodeImpl, SynthCaptureNode {
  private SynthCaptureNode pre;

  SynthCapturePostUpdateNode() {
    VariableCapture::Flow::capturePostUpdateNode(this.getSynthesizedCaptureNode(),
      pre.getSynthesizedCaptureNode())
  }

  override Node getPreUpdateNode() { result = pre }
}

/**
 * INTERNAL: Do not use.
 *
 * Provides classes for modeling data-flow through ORM models saved in a DB.
 */
module Orm {
  /**
   * INTERNAL: Do not use.
   *
   * A unit class for adding additional data-flow steps for ORM models.
   */
  class AdditionalOrmSteps extends Unit {
    /**
     * Holds if data can flow from `nodeFrom` to `nodeTo` via an assignment to
     * content `c`.
     */
    abstract predicate storeStep(Node nodeFrom, Content c, Node nodeTo);

    /**
     * Holds if `pred` can flow to `succ`, by jumping from one callable to
     * another. Additional steps specified by the configuration are *not*
     * taken into account.
     */
    abstract predicate jumpStep(Node nodeFrom, Node nodeTo);
  }

  /** A synthetic node representing the data for an ORM model saved in a DB. */
  class SyntheticOrmModelNode extends Node, TSyntheticOrmModelNode {
    Class cls;

    SyntheticOrmModelNode() { this = TSyntheticOrmModelNode(cls) }

    override string toString() { result = "[orm-model] " + cls.toString() }

    override Scope getScope() { result = cls.getEnclosingScope() }

    override Location getLocation() { result = cls.getLocation() }

    /** Gets the class that defines this ORM model. */
    Class getClass() { result = cls }
  }
}

/** Data flows from an element of a list to the list. */
predicate listStoreStep(CfgNode nodeFrom, ListElementContent c, CfgNode nodeTo) {
  // List
  //   `[..., 42, ...]`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the list, `[..., 42, ...]`, cfg node
  //   c denotes element of list
  nodeTo.getNode().(ListNode).getAnElement() = nodeFrom.getNode() and
  not nodeTo.getNode() instanceof UnpackingAssignmentSequenceTarget and
  // Suppress unused variable warning
  c = c
}

/** Data flows from an element of a set to the set. */
predicate setStoreStep(CfgNode nodeFrom, SetElementContent c, CfgNode nodeTo) {
  // Set
  //   `{..., 42, ...}`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the set, `{..., 42, ...}`, cfg node
  //   c denotes element of list
  nodeTo.getNode().(SetNode).getAnElement() = nodeFrom.getNode() and
  // Suppress unused variable warning
  c = c
}

/** Data flows from an element of a tuple to the tuple at a specific index. */
predicate tupleStoreStep(CfgNode nodeFrom, TupleElementContent c, CfgNode nodeTo) {
  // Tuple
  //   `(..., 42, ...)`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the tuple, `(..., 42, ...)`, cfg node
  //   c denotes element of tuple and index of nodeFrom
  exists(int n |
    nodeTo.getNode().(TupleNode).getElement(n) = nodeFrom.getNode() and
    not nodeTo.getNode() instanceof UnpackingAssignmentSequenceTarget and
    c.getIndex() = n
  )
}

/** Data flows from an element of a dictionary to the dictionary at a specific key. */
predicate dictStoreStep(CfgNode nodeFrom, DictionaryElementContent c, Node nodeTo) {
  // Dictionary
  //   `{..., "key" = 42, ...}`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the dict, `{..., "key" = 42, ...}`, cfg node
  //   c denotes element of dictionary and the key `"key"`
  exists(KeyValuePair item |
    item = nodeTo.asCfgNode().(DictNode).getNode().(Dict).getAnItem() and
    nodeFrom.getNode().getNode() = item.getValue() and
    c.getKey() = item.getKey().(StringLiteral).getS()
  )
}

/**
 * This has been made private since `dictStoreStep` is used by taint-tracking, and
 * adding these extra steps made some alerts very noisy.
 *
 * TODO: Once TaintTracking no longer uses `dictStoreStep`, unify the two predicates.
 */
private predicate moreDictStoreSteps(CfgNode nodeFrom, DictionaryElementContent c, Node nodeTo) {
  // NOTE: It's important to add logic to the newtype definition of
  // DictionaryElementContent if you add new cases here.
  exists(SubscriptNode subscript |
    nodeTo.(PostUpdateNode).getPreUpdateNode().asCfgNode() = subscript.getObject() and
    nodeFrom.asCfgNode() = subscript.(DefinitionNode).getValue() and
    c.getKey() = subscript.getIndex().getNode().(StringLiteral).getText()
  )
  or
  // see https://docs.python.org/3.10/library/stdtypes.html#dict.setdefault
  exists(MethodCallNode call |
    call.calls(nodeTo.(PostUpdateNode).getPreUpdateNode(), "setdefault") and
    call.getArg(0).asExpr().(StringLiteral).getText() = c.getKey() and
    nodeFrom = call.getArg(1)
  )
}

predicate dictClearStep(Node node, DictionaryElementContent c) {
  exists(SubscriptNode subscript |
    subscript instanceof DefinitionNode and
    node.asCfgNode() = subscript.getObject() and
    c.getKey() = subscript.getIndex().getNode().(StringLiteral).getText()
  )
}

/** Data flows from an element expression in a comprehension to the comprehension. */
predicate comprehensionStoreStep(CfgNode nodeFrom, Content c, CfgNode nodeTo) {
  // Comprehension
  //   `[x+1 for x in l]`
  //   nodeFrom is `x+1`, cfg node
  //   nodeTo is `[x+1 for x in l]`, cfg node
  //   c denotes list or set or dictionary without index
  //
  // List
  nodeTo.getNode().getNode().(ListComp).getElt() = nodeFrom.getNode().getNode() and
  c instanceof ListElementContent
  or
  // Set
  nodeTo.getNode().getNode().(SetComp).getElt() = nodeFrom.getNode().getNode() and
  c instanceof SetElementContent
  or
  // Dictionary
  nodeTo.getNode().getNode().(DictComp).getElt() = nodeFrom.getNode().getNode() and
  c instanceof DictionaryElementAnyContent
  or
  // Generator
  nodeTo.getNode().getNode().(GeneratorExp).getElt() = nodeFrom.getNode().getNode() and
  c instanceof ListElementContent
}

/**
 * Holds if `nodeFrom` flows into the attribute `c` of `nodeTo` via an attribute assignment.
 *
 * For example, in
 * ```python
 * obj.foo = x
 * ```
 * data flows from `x` to the attribute `foo` of  (the post-update node for) `obj`.
 */
predicate attributeStoreStep(Node nodeFrom, AttributeContent c, Node nodeTo) {
  exists(Node object |
    // Normally we target a PostUpdateNode. However, for class definitions the class
    // is only constructed after evaluating its' entire scope, so in terms of python
    // evaluations there is no post or pre update nodes, just one node for the class
    // expression. Therefore we target the class expression directly.
    //
    // Note: Due to the way we handle decorators, using a class decorator will result in
    // there being a post-update node for the class (argument to the decorator). We do
    // not want to differentiate between these two cases, so still target the class
    // expression directly.
    object = nodeTo.(PostUpdateNode).getPreUpdateNode() and
    not object.asExpr() instanceof ClassExpr
    or
    object = nodeTo and
    object.asExpr() instanceof ClassExpr
  |
    exists(AttrWrite write |
      write.accesses(object, c.getAttribute()) and
      nodeFrom = write.getValue()
    )
  )
}

/**
 * Subset of `readStep` that should be shared with type-tracking.
 */
predicate readStepCommon(Node nodeFrom, ContentSet c, Node nodeTo) {
  subscriptReadStep(nodeFrom, c, nodeTo)
  or
  iterableUnpackingReadStep(nodeFrom, c, nodeTo)
}

/**
 * Holds if data can flow from `nodeFrom` to `nodeTo` via a read of content `c`.
 */
predicate readStep(Node nodeFrom, ContentSet c, Node nodeTo) {
  readStepCommon(nodeFrom, c, nodeTo)
  or
  matchReadStep(nodeFrom, c, nodeTo)
  or
  forReadStep(nodeFrom, c, nodeTo)
  or
  attributeReadStep(nodeFrom, c, nodeTo)
  or
  FlowSummaryImpl::Private::Steps::summaryReadStep(nodeFrom.(FlowSummaryNode).getSummaryNode(), c,
    nodeTo.(FlowSummaryNode).getSummaryNode())
  or
  synthDictSplatParameterNodeReadStep(nodeFrom, c, nodeTo)
  or
  VariableCapture::readStep(nodeFrom, c, nodeTo)
}

/** Data flows from a sequence to a subscript of the sequence. */
predicate subscriptReadStep(CfgNode nodeFrom, Content c, CfgNode nodeTo) {
  // Subscript
  //   `l[3]`
  //   nodeFrom is `l`, cfg node
  //   nodeTo is `l[3]`, cfg node
  //   c is compatible with 3
  nodeFrom.getNode() = nodeTo.getNode().(SubscriptNode).getObject() and
  (
    c instanceof ListElementContent
    or
    c instanceof SetElementContent
    or
    c instanceof DictionaryElementAnyContent
    or
    c.(TupleElementContent).getIndex() =
      nodeTo.getNode().(SubscriptNode).getIndex().getNode().(IntegerLiteral).getValue()
    or
    c.(DictionaryElementContent).getKey() =
      nodeTo.getNode().(SubscriptNode).getIndex().getNode().(StringLiteral).getS()
  )
}

predicate forReadStep(CfgNode nodeFrom, Content c, Node nodeTo) {
  exists(ForTarget target |
    nodeFrom.asExpr() = target.getSource() and
    nodeTo.asCfgNode() = target
  ) and
  (
    c instanceof ListElementContent
    or
    c instanceof SetElementContent
    or
    c = small_tuple()
  )
}

pragma[noinline]
TupleElementContent small_tuple() { result.getIndex() <= 7 }

/**
 * Holds if `nodeTo` is a read of the attribute `c` of the object `nodeFrom`.
 *
 * For example
 * ```python
 * obj.foo
 * ```
 * is a read of the attribute `foo` from the object `obj`.
 */
predicate attributeReadStep(Node nodeFrom, AttributeContent c, AttrRead nodeTo) {
  nodeTo.accesses(nodeFrom, c.getAttribute())
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, ContentSet c) {
  matchClearStep(n, c)
  or
  attributeClearStep(n, c)
  or
  dictClearStep(n, c)
  or
  FlowSummaryImpl::Private::Steps::summaryClearsContent(n.(FlowSummaryNode).getSummaryNode(), c)
  or
  dictSplatParameterNodeClearStep(n, c)
  or
  VariableCapture::clearsContent(n, c)
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) { none() }

/**
 * Holds if values stored inside attribute `c` are cleared at node `n`.
 *
 * In `obj.foo = x` any old value stored in `foo` is cleared at the pre-update node
 * associated with `obj`
 */
predicate attributeClearStep(Node n, AttributeContent c) {
  exists(PostUpdateNode post | post.getPreUpdateNode() = n | attributeStoreStep(_, c, post))
}

class NodeRegion instanceof Unit {
  string toString() { result = "NodeRegion" }

  predicate contains(Node n) { none() }

  int totalOrder() { result = 1 }
}

//--------
// Fancy context-sensitive guards
//--------
/**
 * Holds if the nodes in `nr` are unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(NodeRegion nr, DataFlowCall call) { none() }

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) { none() }

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  n instanceof ModuleVariableNode
  or
  n instanceof FlowSummaryNode
  or
  n instanceof SynthStarArgsElementParameterNode
  or
  n instanceof SynthDictSplatArgumentNode
  or
  n instanceof SynthDictSplatParameterNode
  or
  n instanceof SynthCaptureNode
  or
  n instanceof SynthCapturedVariablesParameterNode
}

class LambdaCallKind = Unit;

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) {
  // lambda and plain functions
  kind = kind and
  creation.asExpr() = c.(DataFlowPlainFunction).getScope().getDefinition()
  or
  // summarized function
  exists(kind) and // avoid warning on unused 'kind'
  exists(Call call |
    creation.asExpr() = call.getAnArg() and
    creation = c.(LibraryCallableValue).getACallback()
  )
}

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) {
  receiver.(FlowSummaryNode).getSummaryNode() = call.(SummaryCall).getReceiver() and
  exists(kind)
}

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

predicate knownSourceModel(Node source, string model) {
  source = ModelOutput::getASourceNode(_, model).asSource()
}

predicate knownSinkModel(Node sink, string model) {
  sink = ModelOutput::getASinkNode(_, model).asSink()
}

class DataFlowSecondLevelScope = Unit;

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) {
  exists(DataFlowCallable c, ParameterPosition pos |
    p.(ParameterNodeImpl).isParameterOf(c, pos) and
    FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(c.asLibraryCallable(), pos)
  )
  or
  exists(Function f |
    VariableCapture::Flow::heuristicAllowInstanceParameterReturnInSelf(f) and
    p = TSynthCapturedVariablesParameterNode(f)
  )
}

/** An approximated `Content`. */
class ContentApprox = Unit;

/** Gets an approximated value for content `c`. */
pragma[inline]
ContentApprox getContentApprox(Content c) { any() }

/** Helper for `.getEnclosingCallable`. */
DataFlowCallable getCallableScope(Scope s) {
  result.getScope() = s
  or
  not exists(DataFlowCallable c | c.getScope() = s) and
  result = getCallableScope(s.getEnclosingScope())
}
