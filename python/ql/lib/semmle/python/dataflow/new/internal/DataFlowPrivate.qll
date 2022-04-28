private import python
private import DataFlowPublic
private import semmle.python.essa.SsaCompute
private import semmle.python.dataflow.new.internal.ImportStar
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
import DataFlowDispatchPointsTo

/** Gets the callable in which this node occurs. */
DataFlowCallable nodeGetEnclosingCallable(Node n) { result = n.getEnclosingCallable() }

/** Holds if `p` is a `ParameterNode` of `c` with position `pos`. */
predicate isParameterNode(ParameterNode p, DataFlowCallable c, ParameterPosition pos) {
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

/** DEPRECATED: Alias for `SyntheticPreUpdateNode` */
deprecated module syntheticPreUpdateNode = SyntheticPreUpdateNode;

/** A module collecting the different reasons for synthesising a pre-update node. */
module SyntheticPreUpdateNode {
  class SyntheticPreUpdateNode extends Node, TSyntheticPreUpdateNode {
    NeedsSyntheticPreUpdateNode post;

    SyntheticPreUpdateNode() { this = TSyntheticPreUpdateNode(post) }

    /** Gets the node for which this is a synthetic pre-update node. */
    Node getPostUpdateNode() { result = post }

    override string toString() { result = "[pre " + post.label() + "] " + post.toString() }

    override Scope getScope() { result = post.getScope() }

    override Location getLocation() { result = post.getLocation() }
  }

  /** A data flow node for which we should synthesise an associated pre-update node. */
  class NeedsSyntheticPreUpdateNode extends PostUpdateNode {
    NeedsSyntheticPreUpdateNode() { this = objectCreationNode() }

    override Node getPreUpdateNode() { result.(SyntheticPreUpdateNode).getPostUpdateNode() = this }

    /**
     * Gets the label for this kind of node. This will figure in the textual representation of the synthesized pre-update node.
     *
     * There is currently only one reason for needing a pre-update node, so we always use that as the label.
     */
    string label() { result = "objCreate" }
  }

  /**
   * Calls to constructors are treated as post-update nodes for the synthesized argument
   * that is mapped to the `self` parameter. That way, constructor calls represent the value of the
   * object after the constructor (currently only `__init__`) has run.
   */
  CfgNode objectCreationNode() { result.getNode().(CallNode) = any(ClassCall c).getNode() }
}

import SyntheticPreUpdateNode

/** DEPRECATED: Alias for `SyntheticPostUpdateNode` */
deprecated module syntheticPostUpdateNode = SyntheticPostUpdateNode;

/** A module collecting the different reasons for synthesising a post-update node. */
module SyntheticPostUpdateNode {
  /** A post-update node is synthesized for all nodes which satisfy `NeedsSyntheticPostUpdateNode`. */
  class SyntheticPostUpdateNode extends PostUpdateNode, TSyntheticPostUpdateNode {
    NeedsSyntheticPostUpdateNode pre;

    SyntheticPostUpdateNode() { this = TSyntheticPostUpdateNode(pre) }

    override Node getPreUpdateNode() { result = pre }

    override string toString() { result = "[post " + pre.label() + "] " + pre.toString() }

    override Scope getScope() { result = pre.getScope() }

    override Location getLocation() { result = pre.getLocation() }
  }

  /** A data flow node for which we should synthesise an associated post-update node. */
  class NeedsSyntheticPostUpdateNode extends Node {
    NeedsSyntheticPostUpdateNode() {
      this = argumentPreUpdateNode()
      or
      this = storePreUpdateNode()
      or
      this = readPreUpdateNode()
    }

    /**
     * Gets the label for this kind of node. This will figure in the textual representation of the synthesized post-update node.
     * We favour being an arguments as the reason for the post-update node in case multiple reasons apply.
     */
    string label() {
      if this = argumentPreUpdateNode()
      then result = "arg"
      else
        if this = storePreUpdateNode()
        then result = "store"
        else result = "read"
    }
  }

  /**
   * Gets the pre-update node for this node.
   *
   * An argument might have its value changed as a result of a call.
   * Certain arguments, such as implicit self arguments are already post-update nodes
   * and should not have an extra node synthesised.
   */
  Node argumentPreUpdateNode() {
    result = any(FunctionCall c).getArg(_)
    or
    // Avoid argument 0 of method calls as those have read post-update nodes.
    exists(MethodCall c, int n | n > 0 | result = c.getArg(n))
    or
    result = any(SpecialCall c).getArg(_)
    or
    // Avoid argument 0 of class calls as those have non-synthetic post-update nodes.
    exists(ClassCall c, int n | n > 0 | result = c.getArg(n))
    or
    // any argument of any call that we have not been able to resolve
    exists(CallNode call | not call = any(DataFlowCall c).getNode() |
      result.(CfgNode).getNode() in [call.getArg(_), call.getArgByName(_)]
    )
  }

  /** Gets the pre-update node associated with a store. This is used for when an object might have its value changed after a store. */
  CfgNode storePreUpdateNode() {
    exists(Attribute a |
      result.getNode() = a.getObject().getAFlowNode() and
      a.getCtx() instanceof Store
    )
  }

  /**
   * Gets a node marking the state change of an object after a read.
   *
   * A reverse read happens when the result of a read is modified, e.g. in
   * ```python
   * l = [ mutable ]
   * l[0].mutate()
   * ```
   * we may now have changed the content of `l`. To track this, there must be
   * a postupdate node for `l`.
   */
  CfgNode readPreUpdateNode() {
    exists(Attribute a |
      result.getNode() = a.getObject().getAFlowNode() and
      a.getCtx() instanceof Load
    )
    or
    result.getNode() = any(SubscriptNode s).getObject()
    or
    // The dictionary argument is read from if the callable has parameters matching the keys.
    result.getNode().getNode() = any(Call call).getKwargs()
  }
}

import SyntheticPostUpdateNode

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
    or
    // Overflow keyword argument
    exists(CallNode call, CallableValue callable |
      call = callable.getACall() and
      nodeTo = TKwOverflowNode(call, callable) and
      nodeFrom.asCfgNode() = call.getNode().getKwargs().getAFlowNode()
    )
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
 * Local flow can happen either at import time, when the module is initialised
 * or at runtime when callables in the module are called.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
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

/** `ModuleVariable`s are accessed via jump steps at runtime. */
predicate runtimeJumpStep(Node nodeFrom, Node nodeTo) {
  // Module variable read
  nodeFrom.(ModuleVariableNode).getARead() = nodeTo
  or
  // Module variable write
  nodeFrom = nodeTo.(ModuleVariableNode).getAWrite()
  or
  // Setting the possible values of the variable at the end of import time
  exists(SsaVariable def |
    def = any(SsaVariable var).getAnUltimateDefinition() and
    def.getDefinition() = nodeFrom.asCfgNode() and
    def.getVariable() = nodeTo.(ModuleVariableNode).getVariable()
  )
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
}

/**
 * Set of jumpSteps that are shared with type-tracker implementation.
 *
 * For ORM modeling we want to add jumpsteps to global dataflow, but since these are
 * based on type-trackers, it's important that these new ORM jumsteps are not used in
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
  exists(AttrRead r, ModuleValue mv |
    r.getObject().asCfgNode().pointsTo(mv) and
    module_export(mv.getScope(), r.getAttributeName(), nodeFrom) and
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
 * based on type-trackers, it's important that these new ORM jumsteps are not used in
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

/**
 * Holds if the module `m` defines a name `name` by assigning `defn` to it. This is an
 * overapproximation, as `name` may not in fact be exported (e.g. by defining an `__all__` that does
 * not include `name`).
 */
private predicate module_export(Module m, string name, CfgNode defn) {
  exists(EssaVariable v |
    v.getName() = name and
    v.getAUse() = ImportStar::getStarImported*(m).getANormalExit()
  |
    defn.getNode() = v.getDefinition().(AssignmentDefinition).getValue()
    or
    defn.getNode() = v.getDefinition().(ArgumentRefinement).getArgument()
  )
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
  posOverflowStoreStep(nodeFrom, c, nodeTo)
  or
  kwOverflowStoreStep(nodeFrom, c, nodeTo)
  or
  matchStoreStep(nodeFrom, c, nodeTo)
  or
  any(Orm::AdditionalOrmSteps es).storeStep(nodeFrom, c, nodeTo)
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

/**
 * Holds if `nodeFrom` flows into the synthezised positional overflow argument (`nodeTo`)
 * at the position indicated by `c`.
 */
predicate posOverflowStoreStep(CfgNode nodeFrom, TupleElementContent c, Node nodeTo) {
  exists(CallNode call, CallableValue callable, int n |
    nodeFrom.asCfgNode() = getPositionalOverflowArg(call, callable, n) and
    nodeTo = TPosOverflowNode(call, callable) and
    c.getIndex() = n
  )
}

/**
 * Holds if `nodeFrom` flows into the synthezised keyword overflow argument (`nodeTo`)
 * at the key indicated by `c`.
 */
predicate kwOverflowStoreStep(CfgNode nodeFrom, DictionaryElementContent c, Node nodeTo) {
  exists(CallNode call, CallableValue callable, string key |
    nodeFrom.asCfgNode() = getKeywordOverflowArg(call, callable, key) and
    nodeTo = TKwOverflowNode(call, callable) and
    c.getKey() = key
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
  kwUnpackReadStep(nodeFrom, c, nodeTo)
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
 * Holds if `nodeFrom` is a dictionary argument being unpacked and `nodeTo` is the
 * synthezised unpacked argument with the name indicated by `c`.
 */
predicate kwUnpackReadStep(CfgNode nodeFrom, DictionaryElementContent c, Node nodeTo) {
  exists(CallNode call, CallableValue callable, string name |
    nodeFrom.asCfgNode() = call.getNode().getKwargs().getAFlowNode() and
    nodeTo = TKwUnpackedNode(call, callable, name) and
    name = c.getKey()
  )
}

/**
 * Clear content at key `name` of the synthesized dictionary `TKwOverflowNode(call, callable)`,
 * whenever `call` unpacks `name`.
 */
predicate kwOverflowClearStep(Node n, Content c) {
  exists(CallNode call, CallableValue callable, string name |
    call_unpacks(call, _, callable, name, _) and
    n = TKwOverflowNode(call, callable) and
    c.(DictionaryElementContent).getKey() = name
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
predicate clearsContent(Node n, Content c) {
  kwOverflowClearStep(n, c)
  or
  matchClearStep(n, c)
  or
  attributeClearStep(n, c)
}

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
predicate nodeIsHidden(Node n) { none() }

class LambdaCallKind = Unit;

/** Holds if `creation` is an expression that creates a lambda of kind `kind` for `c`. */
predicate lambdaCreation(Node creation, LambdaCallKind kind, DataFlowCallable c) { none() }

/** Holds if `call` is a lambda call of kind `kind` where `receiver` is the lambda expression. */
predicate lambdaCall(DataFlowCall call, LambdaCallKind kind, Node receiver) { none() }

/** Extra data-flow steps needed for lambda flow analysis. */
predicate additionalLambdaFlowStep(Node nodeFrom, Node nodeTo, boolean preservesValue) { none() }

/**
 * Holds if flow is allowed to pass from parameter `p` and back to itself as a
 * side-effect, resulting in a summary from `p` to itself.
 *
 * One example would be to allow flow like `p.foo = p.bar;`, which is disallowed
 * by default as a heuristic.
 */
predicate allowParameterReturnInSelf(ParameterNode p) { none() }
