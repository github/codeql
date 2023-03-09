private import python
private import DataFlowPublic
private import semmle.python.essa.SsaCompute
private import semmle.python.dataflow.new.internal.ImportResolution
private import FlowSummaryImpl as FlowSummaryImpl
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

/** Gets the callable in which this node occurs. */
DataFlowCallable nodeGetEnclosingCallable(Node n) { result = n.getEnclosingCallable() }

/** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
predicate isParameterNode(ParameterNodeImpl p, DataFlowCallable c, ParameterPosition pos) {
  p.isParameterOf(c, pos)
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
  TSynthStarArgsElementParameterNode {
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
    (
      n.getParameter() = callable.(DataFlowFunction).getScope().getKwarg()
      or
      n = TSummaryParameterNode(callable.asLibraryCallable(), dictSplatPos)
    ) and
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
 * Flow step from the synthetic `**kwargs` parameter to the real `**kwargs` parameter.
 * Due to restriction in dataflow library, we can only give one of them as result for
 * `DataFlowCallable.getParameter`, so this is a workaround to ensure there is flow to
 * _both_ of them.
 */
private predicate dictSplatParameterNodeFlowStep(
  ParameterNodeImpl nodeFrom, ParameterNodeImpl nodeTo
) {
  exists(DataFlowCallable callable |
    nodeFrom = TSynthDictSplatParameterNode(callable) and
    (
      nodeTo.getParameter() = callable.(DataFlowFunction).getScope().getKwarg()
      or
      exists(ParameterPosition pos |
        nodeTo = TSummaryParameterNode(callable.asLibraryCallable(), pos) and
        pos.isDictSplat()
      )
    )
  )
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
 * Flow between ESSA variables.
 * This includes both local and global variables.
 * Flow comes from definitions, uses and refinements.
 */
// TODO: Consider constraining `nodeFrom` and `nodeTo` to be in the same scope.
// If they have different enclosing callables, we get consistency errors.
module EssaFlow {
  predicate essaFlowStep(Node nodeFrom, Node nodeTo) {
    // Definition
    //   `x = f(42)`
    //   nodeFrom is `f(42)`, cfg node
    //   nodeTo is `x`, essa var
    nodeFrom.(CfgNode).getNode() =
      nodeTo.(EssaNode).getVar().getDefinition().(AssignmentDefinition).getValue()
    or
    // With definition
    //   `with f(42) as x:`
    //   nodeFrom is `f(42)`, cfg node
    //   nodeTo is `x`, essa var
    exists(With with, ControlFlowNode contextManager, ControlFlowNode var |
      nodeFrom.(CfgNode).getNode() = contextManager and
      nodeTo.(EssaNode).getVar().getDefinition().(WithDefinition).getDefiningNode() = var and
      // see `with_flow` in `python/ql/src/semmle/python/dataflow/Implementation.qll`
      with.getContextExpr() = contextManager.getNode() and
      with.getOptionalVars() = var.getNode() and
      not with.isAsync() and
      contextManager.strictlyDominates(var)
    )
    or
    // Async with var definition
    //  `async with f(42) as x:`
    //  nodeFrom is `x`, cfg node
    //  nodeTo is `x`, essa var
    //
    // This makes the cfg node the local source of the awaited value.
    exists(With with, ControlFlowNode var |
      nodeFrom.(CfgNode).getNode() = var and
      nodeTo.(EssaNode).getVar().getDefinition().(WithDefinition).getDefiningNode() = var and
      with.getOptionalVars() = var.getNode() and
      with.isAsync()
    )
    or
    // Parameter definition
    //   `def foo(x):`
    //   nodeFrom is `x`, cfgNode
    //   nodeTo is `x`, essa var
    exists(ParameterDefinition pd |
      nodeFrom.asCfgNode() = pd.getDefiningNode() and
      nodeTo.asVar() = pd.getVariable()
    )
    or
    // First use after definition
    //   `y = 42`
    //   `x = f(y)`
    //   nodeFrom is `y` on first line, essa var
    //   nodeTo is `y` on second line, cfg node
    defToFirstUse(nodeFrom.asVar(), nodeTo.asCfgNode())
    or
    // Next use after use
    //   `x = f(y)`
    //   `z = y + 1`
    //   nodeFrom is 'y' on first line, cfg node
    //   nodeTo is `y` on second line, cfg node
    useToNextUse(nodeFrom.asCfgNode(), nodeTo.asCfgNode())
    or
    // If expressions
    nodeFrom.asCfgNode() = nodeTo.asCfgNode().(IfExprNode).getAnOperand()
    or
    // boolean inline expressions such as `x or y` or `x and y`
    nodeFrom.asCfgNode() = nodeTo.asCfgNode().(BoolExprNode).getAnOperand()
    or
    // Flow inside an unpacking assignment
    iterableUnpackingFlowStep(nodeFrom, nodeTo)
    or
    matchFlowStep(nodeFrom, nodeTo)
  }

  predicate useToNextUse(NameNode nodeFrom, NameNode nodeTo) {
    AdjacentUses::adjacentUseUse(nodeFrom, nodeTo)
  }

  predicate defToFirstUse(EssaVariable var, NameNode nodeTo) {
    AdjacentUses::firstUse(var.getDefinition(), nodeTo)
  }
}

//--------
// Local flow
//--------
/**
 * This is the local flow predicate that is used as a building block in global
 * data flow.
 *
 * It includes flow steps from flow summaries.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  simpleLocalFlowStepForTypetracking(nodeFrom, nodeTo)
  or
  summaryFlowSteps(nodeFrom, nodeTo)
  or
  dictSplatParameterNodeFlowStep(nodeFrom, nodeTo)
}

/**
 * This is the local flow predicate that is used as a building block in
 * type tracking, it does _not_ include steps from flow summaries.
 *
 * Local flow can happen either at import time, when the module is initialised
 * or at runtime when callables in the module are called.
 */
predicate simpleLocalFlowStepForTypetracking(Node nodeFrom, Node nodeTo) {
  // If there is local flow out of a node `node`, we want flow
  // both out of `node` and any post-update node of `node`.
  exists(Node node |
    nodeFrom = update(node) and
    (
      importTimeLocalFlowStep(node, nodeTo) or
      runtimeLocalFlowStep(node, nodeTo)
    )
  )
}

/**
 * Holds if `node` is found at the top level of a module.
 */
pragma[inline]
predicate isTopLevel(Node node) { node.getScope() instanceof Module }

/** Holds if there is local flow from `nodeFrom` to `nodeTo` at import time. */
predicate importTimeLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // As a proxy for whether statements can be executed at import time,
  // we check if they appear at the top level.
  // This will miss statements inside functions called from the top level.
  isTopLevel(nodeFrom) and
  isTopLevel(nodeTo) and
  EssaFlow::essaFlowStep(nodeFrom, nodeTo)
}

/** Holds if there is local flow from `nodeFrom` to `nodeTo` at runtime. */
predicate runtimeLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // Anything not at the top level can be executed at runtime.
  not isTopLevel(nodeFrom) and
  not isTopLevel(nodeTo) and
  EssaFlow::essaFlowStep(nodeFrom, nodeTo)
}

predicate summaryFlowSteps(Node nodeFrom, Node nodeTo) {
  // If there is local flow out of a node `node`, we want flow
  // both out of `node` and any post-update node of `node`.
  exists(Node node |
    nodeFrom = update(node) and
    (
      importTimeSummaryFlowStep(node, nodeTo) or
      runtimeSummaryFlowStep(node, nodeTo)
    )
  )
}

predicate importTimeSummaryFlowStep(Node nodeFrom, Node nodeTo) {
  // As a proxy for whether statements can be executed at import time,
  // we check if they appear at the top level.
  // This will miss statements inside functions called from the top level.
  isTopLevel(nodeFrom) and
  isTopLevel(nodeTo) and
  FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, true)
}

predicate runtimeSummaryFlowStep(Node nodeFrom, Node nodeTo) {
  // Anything not at the top level can be executed at runtime.
  not isTopLevel(nodeFrom) and
  not isTopLevel(nodeTo) and
  FlowSummaryImpl::Private::Steps::summaryLocalStep(nodeFrom, nodeTo, true)
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
}

/**
 * Holds if `result` is either `node`, or the post-update node for `node`.
 */
private Node update(Node node) {
  result = node
  or
  result.(PostUpdateNode).getPreUpdateNode() = node
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
  // We include read- and store steps here to force them to be
  // shown in path explanations.
  // This hack is necessary, because we have included some of these
  // steps as default taint steps, making them be suppressed in path
  // explanations.
  // We should revert this once, we can remove this steps from the
  // default taint steps; this should be possible once we have
  // implemented flow summaries and recursive content.
  CastNode() { readStep(_, _, this) or storeStep(_, _, this) }
}

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) { any() }

/**
 * Gets the type of `node`.
 */
DataFlowType getNodeType(Node node) {
  result = TAnyFlow() and
  // Suppress unused variable warning
  node = node
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
  FlowSummaryImpl::Private::Steps::summaryJumpStep(nodeFrom, nodeTo)
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
  or
  // Default value for parameter flows to that parameter
  defaultValueFlowStep(nodeFrom, nodeTo)
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
 * Holds if data can flow from `nodeFrom` to `nodeTo` via an assignment to
 * content `c`.
 */
predicate storeStep(Node nodeFrom, Content c, Node nodeTo) {
  listStoreStep(nodeFrom, c, nodeTo)
  or
  setStoreStep(nodeFrom, c, nodeTo)
  or
  tupleStoreStep(nodeFrom, c, nodeTo)
  or
  dictStoreStep(nodeFrom, c, nodeTo)
  or
  comprehensionStoreStep(nodeFrom, c, nodeTo)
  or
  iterableUnpackingStoreStep(nodeFrom, c, nodeTo)
  or
  attributeStoreStep(nodeFrom, c, nodeTo)
  or
  matchStoreStep(nodeFrom, c, nodeTo)
  or
  any(Orm::AdditionalOrmSteps es).storeStep(nodeFrom, c, nodeTo)
  or
  FlowSummaryImpl::Private::Steps::summaryStoreStep(nodeFrom, c, nodeTo)
  or
  synthStarArgsElementParameterNodeStoreStep(nodeFrom, c, nodeTo)
  or
  synthDictSplatArgumentNodeStoreStep(nodeFrom, c, nodeTo)
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
predicate dictStoreStep(CfgNode nodeFrom, DictionaryElementContent c, CfgNode nodeTo) {
  // Dictionary
  //   `{..., "key" = 42, ...}`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the dict, `{..., "key" = 42, ...}`, cfg node
  //   c denotes element of dictionary and the key `"key"`
  exists(KeyValuePair item |
    item = nodeTo.getNode().(DictNode).getNode().(Dict).getAnItem() and
    nodeFrom.getNode().getNode() = item.getValue() and
    c.getKey() = item.getKey().(StrConst).getS()
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
predicate attributeStoreStep(Node nodeFrom, AttributeContent c, PostUpdateNode nodeTo) {
  exists(AttrWrite write |
    write.accesses(nodeTo.getPreUpdateNode(), c.getAttribute()) and
    nodeFrom = write.getValue()
  )
}

predicate defaultValueFlowStep(CfgNode nodeFrom, CfgNode nodeTo) {
  exists(Function f, Parameter p, ParameterDefinition def |
    // `getArgByName` supports, unlike `getAnArg`, keyword-only parameters
    p = f.getArgByName(_) and
    nodeFrom.asExpr() = p.getDefault() and
    // The following expresses
    // nodeTo.(ParameterNode).getParameter() = p
    // without non-monotonic recursion
    def.getParameter() = p and
    nodeTo.getNode() = def.getDefiningNode()
  )
}

/**
 * Holds if data can flow from `nodeFrom` to `nodeTo` via a read of content `c`.
 */
predicate readStep(Node nodeFrom, Content c, Node nodeTo) {
  subscriptReadStep(nodeFrom, c, nodeTo)
  or
  iterableUnpackingReadStep(nodeFrom, c, nodeTo)
  or
  matchReadStep(nodeFrom, c, nodeTo)
  or
  popReadStep(nodeFrom, c, nodeTo)
  or
  forReadStep(nodeFrom, c, nodeTo)
  or
  attributeReadStep(nodeFrom, c, nodeTo)
  or
  FlowSummaryImpl::Private::Steps::summaryReadStep(nodeFrom, c, nodeTo)
  or
  synthDictSplatParameterNodeReadStep(nodeFrom, c, nodeTo)
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
      nodeTo.getNode().(SubscriptNode).getIndex().getNode().(StrConst).getS()
  )
}

/** Data flows from a sequence to a call to `pop` on the sequence. */
predicate popReadStep(CfgNode nodeFrom, Content c, CfgNode nodeTo) {
  // set.pop or list.pop
  //   `s.pop()`
  //   nodeFrom is `s`, cfg node
  //   nodeTo is `s.pop()`, cfg node
  //   c denotes element of list or set
  exists(CallNode call, AttrNode a |
    call.getFunction() = a and
    a.getName() = "pop" and // Should match appropriate call since we tracked a sequence here.
    not exists(call.getAnArg()) and
    nodeFrom.getNode() = a.getObject() and
    nodeTo.getNode() = call and
    (
      c instanceof ListElementContent
      or
      c instanceof SetElementContent
    )
  )
  or
  // dict.pop
  //   `d.pop("key")`
  //   nodeFrom is `d`, cfg node
  //   nodeTo is `d.pop("key")`, cfg node
  //   c denotes the key `"key"`
  exists(CallNode call, AttrNode a |
    call.getFunction() = a and
    a.getName() = "pop" and // Should match appropriate call since we tracked a dictionary here.
    nodeFrom.getNode() = a.getObject() and
    nodeTo.getNode() = call and
    c.(DictionaryElementContent).getKey() = call.getArg(0).getNode().(StrConst).getS()
  )
}

predicate forReadStep(CfgNode nodeFrom, Content c, Node nodeTo) {
  exists(ForTarget target |
    nodeFrom.asExpr() = target.getSource() and
    nodeTo.asVar().(EssaNodeDefinition).getDefiningNode() = target
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
predicate clearsContent(Node n, Content c) {
  matchClearStep(n, c)
  or
  attributeClearStep(n, c)
  or
  FlowSummaryImpl::Private::Steps::summaryClearsContent(n, c)
  or
  dictSplatParameterNodeClearStep(n, c)
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

//--------
// Fancy context-sensitive guards
//--------
/**
 * Holds if the node `n` is unreachable when the call context is `call`.
 */
predicate isUnreachableInCall(Node n, DataFlowCall call) { none() }

//--------
// Virtual dispatch with call context
//--------
/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context. This is the case if the qualifier accesses a parameter of
 * the enclosing callable `c` (including the implicit `this` parameter).
 */
predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c) { none() }

int accessPathLimit() { result = 5 }

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) { none() }

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  n instanceof SummaryNode
  or
  n instanceof SummaryParameterNode
  or
  n instanceof SynthStarArgsElementParameterNode
  or
  n instanceof SynthDictSplatArgumentNode
  or
  n instanceof SynthDictSplatParameterNode
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
  receiver = call.(SummaryCall).getReceiver() and
  exists(kind)
}

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) {
  FlowSummaryImpl::Private::summaryAllowParameterReturnInSelf(p)
}

/** An approximated `Content`. */
class ContentApprox = Unit;

/** Gets an approximated value for content `c`. */
pragma[inline]
ContentApprox getContentApprox(Content c) { any() }

/**
 * Gets an additional term that is added to the `join` and `branch` computations to reflect
 * an additional forward or backwards branching factor that is not taken into account
 * when calculating the (virtual) dispatch cost.
 *
 * Argument `arg` is part of a path from a source to a sink, and `p` is the target parameter.
 */
int getAdditionalFlowIntoCallNodeTerm(ArgumentNode arg, ParameterNode p) { none() }
