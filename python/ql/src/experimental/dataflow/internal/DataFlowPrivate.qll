private import python
private import DataFlowPublic
import semmle.python.SpecialMethods
private import semmle.python.essa.SsaCompute

//--------
// Data flow graph
//--------
//--------
// Nodes
//--------
predicate isExpressionNode(ControlFlowNode node) { node.getNode() instanceof Expr }

/** A control flow node which is also a dataflow node */
class DataFlowCfgNode extends ControlFlowNode {
  DataFlowCfgNode() { isExpressionNode(this) }
}

/** A data flow node for which we should synthesise an associated pre-update node. */
abstract class NeedsSyntheticPreUpdateNode extends Node {
  abstract string label();
}

class SyntheticPreUpdateNode extends Node, TSyntheticPreUpdateNode {
  NeedsSyntheticPreUpdateNode post;

  SyntheticPreUpdateNode() { this = TSyntheticPreUpdateNode(post) }

  /** Gets the node for which this is a synthetic pre-update node. */
  Node getPostUpdateNode() { result = post }

  override string toString() { result = "[pre " + post.label() + "] " + post.toString() }

  override Scope getScope() { result = post.getScope() }

  override Location getLocation() { result = post.getLocation() }
}

/** A data flow node for which we should synthesise an associated post-update node. */
abstract class NeedsSyntheticPostUpdateNode extends Node {
  abstract string label();
}

/** An argument might have its value changed as a result of a call. */
class ArgumentPreUpdateNode extends NeedsSyntheticPostUpdateNode, ArgumentNode {
  // Certain arguments, such as implicit self arguments are already post-update nodes
  // and should not have an extra node synthesised.
  ArgumentPreUpdateNode() { this.isNotPostUpdate() }

  override string label() { result = "arg" }
}

/** An object might have its value changed after a store. */
class StorePreUpdateNode extends NeedsSyntheticPostUpdateNode, CfgNode {
  StorePreUpdateNode() {
    exists(Attribute a |
      node = a.getObject().getAFlowNode() and
      a.getCtx() instanceof Store
    )
  }

  override string label() { result = "store" }
}

/** A node marking the state change of an object after a read. */
class ReadPreUpdateNode extends NeedsSyntheticPostUpdateNode, CfgNode {
  ReadPreUpdateNode() {
    exists(Attribute a |
      node = a.getObject().getAFlowNode() and
      a.getCtx() instanceof Load
    )
  }

  override string label() { result = "read" }
}

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), or the qualifier of a field after
 * an update to the field.
 *
 * Nodes corresponding to AST elements, for example `ExprNode`s, usually refer
 * to the value before the update with the exception of `ObjectCreationNode`s,
 * which represents the value after the constructor has run.
 */
abstract class PostUpdateNode extends Node {
  /** Gets the node before the state update. */
  abstract Node getPreUpdateNode();
}

class SyntheticPostUpdateNode extends PostUpdateNode, TSyntheticPostUpdateNode {
  NeedsSyntheticPostUpdateNode pre;

  SyntheticPostUpdateNode() { this = TSyntheticPostUpdateNode(pre) }

  override Node getPreUpdateNode() { result = pre }

  override string toString() { result = "[post " + pre.label() + "] " + pre.toString() }

  override Scope getScope() { result = pre.getScope() }

  override Location getLocation() { result = pre.getLocation() }
}

class ObjectCreationNode extends PostUpdateNode, NeedsSyntheticPreUpdateNode, CfgNode {
  ObjectCreationNode() { node.(CallNode) = any(ClassValue c).getACall() }

  override Node getPreUpdateNode() { result.(SyntheticPreUpdateNode).getPostUpdateNode() = this }

  override string label() { result = "objCreate" }
}

class DataFlowExpr = Expr;

/**
 * Flow between ESSA variables.
 * This includes both local and global variables.
 * Flow comes from definitions, uses and refinements.
 */
// TODO: Consider constraining `nodeFrom` and `nodeTo` to be in the same scope.
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
      contextManager.strictlyDominates(var)
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
    // Refinements
    exists(EssaEdgeRefinement r |
      nodeTo.(EssaNode).getVar() = r.getVariable() and
      nodeFrom.(EssaNode).getVar() = r.getInput()
    )
    or
    exists(EssaNodeRefinement r |
      nodeTo.(EssaNode).getVar() = r.getVariable() and
      nodeFrom.(EssaNode).getVar() = r.getInput()
    )
    or
    exists(PhiFunction p |
      nodeTo.(EssaNode).getVar() = p.getVariable() and
      nodeFrom.(EssaNode).getVar() = p.getAnInput()
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
 * data flow. It is a strict subset of the `localFlowStep` predicate, as it
 * excludes SSA flow through instance fields.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  // If there is ESSA-flow out of a node `node`, we want flow
  // both out of `node` and any post-update node of `node`.
  exists(Node node |
    not node.(EssaNode).getVar() instanceof GlobalSsaVariable and
    not nodeTo.(EssaNode).getVar() instanceof GlobalSsaVariable and
    EssaFlow::essaFlowStep(node, nodeTo) and
    nodeFrom = update(node)
  )
}

/**
 * Holds if `result` is either `node`, or the post-update node for `node`.
 */
private Node update(Node node) {
  exists(PostUpdateNode pun |
    node = pun.getPreUpdateNode() and
    result = pun
  )
  or
  result = node
}

// TODO: Make modules for these headings
//--------
// Global flow
//--------
/**
 * A DataFlowCallable is any callable value.
 */
class DataFlowCallable = CallableValue;

newtype TDataFlowCall =
  TCallNode(CallNode call) { call = any(CallableValue c).getACall() } or
  TClassCall(CallNode call) { call = any(ClassValue c).getACall() } or
  TSpecialCall(SpecialMethodCallNode special)

abstract class DataFlowCall extends TDataFlowCall {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Get the callable to which this call goes. */
  abstract DataFlowCallable getCallable();

  /** Get the specified argument to this call. */
  abstract Node getArg(int n);

  /** Get the control flow node representing this call. */
  abstract ControlFlowNode getNode();

  /** Gets the enclosing callable of this call. */
  abstract DataFlowCallable getEnclosingCallable();
}

/** Represents a call to a callable. */
class CallNodeCall extends DataFlowCall, TCallNode {
  CallNode call;
  DataFlowCallable callable;

  CallNodeCall() {
    this = TCallNode(call) and
    call = callable.getACall()
  }

  override string toString() { result = call.toString() }

  override Node getArg(int n) { result = TCfgNode(call.getArg(n)) }

  override ControlFlowNode getNode() { result = call }

  override DataFlowCallable getCallable() { result = callable }

  override DataFlowCallable getEnclosingCallable() { result.getScope() = call.getNode().getScope() }
}

/** Represents a call to a class. */
class ClassCall extends DataFlowCall, TClassCall {
  CallNode call;
  ClassValue c;

  ClassCall() {
    this = TClassCall(call) and
    call = c.getACall()
  }

  override string toString() { result = call.toString() }

  override Node getArg(int n) {
    n > 0 and result = TCfgNode(call.getArg(n - 1))
    or
    n = 0 and result = TSyntheticPreUpdateNode(TCfgNode(call))
  }

  override ControlFlowNode getNode() { result = call }

  override DataFlowCallable getCallable() {
    exists(CallableValue callable |
      result = callable and
      c.getScope().getInitMethod() = callable.getScope()
    )
  }

  override DataFlowCallable getEnclosingCallable() { result.getScope() = call.getNode().getScope() }
}

/** Represents a call to a special method. */
class SpecialCall extends DataFlowCall, TSpecialCall {
  SpecialMethodCallNode special;

  SpecialCall() { this = TSpecialCall(special) }

  override string toString() { result = special.toString() }

  override Node getArg(int n) { result = TCfgNode(special.(SpecialMethod::Potential).getArg(n)) }

  override ControlFlowNode getNode() { result = special }

  override DataFlowCallable getCallable() { result = special.getResolvedSpecialMethod() }

  override DataFlowCallable getEnclosingCallable() {
    result.getScope() = special.getNode().getScope()
  }
}

/** A data flow node that represents a call argument. */
class ArgumentNode extends Node {
  ArgumentNode() { this = any(DataFlowCall c).getArg(_) }

  /** Holds if this argument occurs at the given position in the given call. */
  predicate argumentOf(DataFlowCall call, int pos) { this = call.getArg(pos) }

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }

  predicate isNotPostUpdate() {
    // Avoid argument 0 of class calls as those have non-synthetic post-update nodes.
    exists(CallNodeCall c | this = c.getArg(_))
    or
    exists(ClassCall c, int n | n > 0 | this = c.getArg(n))
    or
    exists(SpecialCall c | this = c.getArg(_))
  }
}

/** Gets a viable run-time target for the call `call`. */
DataFlowCallable viableCallable(DataFlowCall call) { result = call.getCallable() }

private newtype TReturnKind = TNormalReturnKind()

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For Python, this is simply a method return.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this element. */
  string toString() { result = "return" }
}

/** A data flow node that represents a value returned by a callable. */
class ReturnNode extends CfgNode {
  Return ret;

  // See `TaintTrackingImplementation::returnFlowStep`
  ReturnNode() { node = ret.getValue().getAFlowNode() }

  /** Gets the kind of this return node. */
  ReturnKind getKind() { any() }

  override DataFlowCallable getEnclosingCallable() {
    result.getScope().getAStmt() = ret // TODO: check nested function definitions
  }
}

/** A data flow node that represents the output of a call. */
class OutNode extends CfgNode {
  OutNode() { node instanceof CallNode }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  call.getNode() = result.getNode() and
  kind = TNormalReturnKind()
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
class CastNode extends CfgNode {
  CastNode() { none() }
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
DataFlowType getNodeType(Node node) { result = TAnyFlow() }

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
  // As we have ESSA variables for global variables,
  // we include ESSA flow steps involving global variables.
  (
    nodeFrom.(EssaNode).getVar() instanceof GlobalSsaVariable
    or
    nodeTo.(EssaNode).getVar() instanceof GlobalSsaVariable
  ) and
  (
    EssaFlow::essaFlowStep(nodeFrom, nodeTo)
    or
    // As jump steps do not respect chronology,
    // we add jump steps for each def-use pair.
    nodeFrom.asVar() instanceof GlobalSsaVariable and
    nodeTo.asCfgNode() = nodeFrom.asVar().getASourceUse()
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
  attributeStoreStep(nodeFrom, c, nodeTo)
}

/** Data flows from an element of a list to the list. */
predicate listStoreStep(CfgNode nodeFrom, ListElementContent c, CfgNode nodeTo) {
  // List
  //   `[..., 42, ...]`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the list, `[..., 42, ...]`, cfg node
  //   c denotes element of list
  nodeTo.getNode().(ListNode).getAnElement() = nodeFrom.getNode()
}

/** Data flows from an element of a set to the set. */
predicate setStoreStep(CfgNode nodeFrom, ListElementContent c, CfgNode nodeTo) {
  // Set
  //   `{..., 42, ...}`
  //   nodeFrom is `42`, cfg node
  //   nodeTo is the set, `{..., 42, ...}`, cfg node
  //   c denotes element of list
  nodeTo.getNode().(SetNode).getAnElement() = nodeFrom.getNode()
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
 * In
 * ```python
 * obj.foo = x
 * ```
 * data flows from `x` to (the post-update node for) `obj` via assignment to `foo`.
 */
predicate attributeStoreStep(CfgNode nodeFrom, Content c, PostUpdateNode nodeTo) {
  exists(AssignStmt a, Attribute attr |
    a.getValue().getAFlowNode() = nodeFrom.getNode() and
    a.getATarget().(Attribute) = attr and
    attr.getName() = c.(AttributeContent).getAttribute() and
    attr.getObject().getAFlowNode() = nodeTo.getPreUpdateNode().(CfgNode).getNode() and
    attr.getCtx() instanceof Store
  )
  or
  exists(AssignExpr ae |
    ae.getValue().getAFlowNode() = nodeFrom.getNode() and
    ae.getTarget().(Attribute).getName() = c.(AttributeContent).getAttribute() and
    ae.getTarget().(Attribute).getObject().getAFlowNode() =
      nodeTo.getPreUpdateNode().(CfgNode).getNode()
  )
}

/**
 * Holds if data can flow from `nodeFrom` to `nodeTo` via a read of content `c`.
 */
predicate readStep(Node nodeFrom, Content c, Node nodeTo) {
  subscriptReadStep(nodeFrom, c, nodeTo)
  or
  popReadStep(nodeFrom, c, nodeTo)
  or
  comprehensionReadStep(nodeFrom, c, nodeTo)
  or
  attributeReadStep(nodeFrom, c, nodeTo)
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

/** Data flows from a iterated sequence to the variable iterating over the sequence. */
predicate comprehensionReadStep(CfgNode nodeFrom, Content c, EssaNode nodeTo) {
  // Comprehension
  //   `[x+1 for x in l]`
  //   nodeFrom is `l`, cfg node
  //   nodeTo is `x`, essa var
  //   c denotes element of list or set
  exists(Comp comp |
    // outermost for
    nodeFrom.getNode().getNode() = comp.getIterable() and
    nodeTo.getVar().getDefinition().(AssignmentDefinition).getDefiningNode().getNode() =
      comp.getIterationVariable(0).getAStore()
    or
    // an inner for
    exists(int n | n > 0 |
      nodeFrom.getNode().getNode() = comp.getNthInnerLoop(n).getIter() and
      nodeTo.getVar().getDefinition().(AssignmentDefinition).getDefiningNode().getNode() =
        comp.getNthInnerLoop(n).getTarget()
    )
  ) and
  (
    c instanceof ListElementContent
    or
    c instanceof SetElementContent
  )
}

/**
 * In
 * ```python
 * obj.foo
 * ```
 * data flows from `obj` to `obj.foo` via a read from `foo`.
 */
predicate attributeReadStep(CfgNode nodeFrom, Content c, CfgNode nodeTo) {
  exists(Attribute attr |
    nodeTo.asCfgNode().(AttrNode).getNode() = attr and
    nodeFrom.asCfgNode() = attr.getObject().getAFlowNode() and
    attr.getName() = c.(AttributeContent).getAttribute() and
    attr.getCtx() instanceof Load
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`. For example,
 * any value stored inside `f` is cleared at the pre-update node associated with `x`
 * in `x.f = newValue`.
 */
cached
predicate clearsContent(Node n, Content c) { none() }

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

//--------
// Misc
//--------
/**
 * Holds if `n` does not require a `PostUpdateNode` as it either cannot be
 * modified or its modification cannot be observed, for example if it is a
 * freshly created object that is not saved in a variable.
 *
 * This predicate is only used for consistency checks.
 */
predicate isImmutableOrUnobservable(Node n) { none() }

int accessPathLimit() { result = 5 }

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) { none() }
