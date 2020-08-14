private import python
private import DataFlowPublic
import semmle.python.Magic

//--------
// Data flow graph
//--------
//--------
// Nodes
//--------
/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), or the qualifier of a field after
 * an update to the field.
 *
 * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
 * to the value before the update with the exception of `ObjectCreation`,
 * which represents the value after the constructor has run.
 */
abstract class PostUpdateNode extends Node {
  /** Gets the node before the state update. */
  abstract Node getPreUpdateNode();
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
    // Use
    //   `y = 42`
    //   `x = f(y)`
    //   nodeFrom is `y` on first line, essa var
    //   nodeTo is `y` on second line, cfg node
    nodeFrom.(EssaNode).getVar().getAUse() = nodeTo.(CfgNode).getNode()
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
  not nodeFrom.(EssaNode).getVar() instanceof GlobalSsaVariable and
  not nodeTo.(EssaNode).getVar() instanceof GlobalSsaVariable and
  EssaFlow::essaFlowStep(nodeFrom, nodeTo)
}

// TODO: Make modules for these headings
//--------
// Global flow
//--------
/**
 * IPA type for DataFlowCallable.
 * A callable is either a callable value or a class.
 */
newtype TDataFlowCallable =
  TCallableValue(CallableValue callable) or
  TClassValue(ClassValue c)

/** Represents a callable */
abstract class DataFlowCallable extends TDataFlowCallable {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets a call to this callable. */
  abstract CallNode getACall();

  /** Gets the scope of this callable */
  abstract Scope getScope();

  /** Gets the specified parameter of this callable */
  abstract NameNode getParameter(int n);

  /** Gets the name of this callable. */
  abstract string getName();
}

class DataFlowCallableValue extends DataFlowCallable, TCallableValue {
  CallableValue callable;

  DataFlowCallableValue() { this = TCallableValue(callable) }

  override string toString() { result = callable.toString() }

  override CallNode getACall() { result = callable.getACall() }

  override Scope getScope() { result = callable.getScope() }

  override NameNode getParameter(int n) { result = callable.getParameter(n) }

  override string getName() { result = callable.getName() }
}

class DataFlowClassValue extends DataFlowCallable, TClassValue {
  ClassValue c;

  DataFlowClassValue() { this = TClassValue(c) }

  override string toString() { result = c.toString() }

  override CallNode getACall() { result = c.getACall() }

  override Scope getScope() { result = c.getScope() }

  override NameNode getParameter(int n) {
    result.getNode() = c.getScope().getInitMethod().getArg(n + 1).asName()
  }

  override string getName() { result = c.getName() }
}

newtype TDataFlowCall =
  TCallNode(CallNode call) or
  TMagicCall(MagicMethod::Actual magic)

abstract class DataFlowCall extends TDataFlowCall {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Get the callable to which this call goes. */
  abstract DataFlowCallable getCallable();

  /** Get the specified arguemnt to this call. */
  abstract ControlFlowNode getArg(int n);

  /** Get the control flow node representing this call. */
  abstract ControlFlowNode getNode();

  /** Gets the enclosing callable of this call. */
  abstract DataFlowCallable getEnclosingCallable();
}


/** Represents a call to a callable */
class CallNodeCall extends DataFlowCall, TCallNode {
  CallNode call;
  DataFlowCallable callable;

  CallNodeCall() {
    this = TCallNode(call) and
    call = callable.getACall()
  }

  override string toString() { result = call.toString() }

  override ControlFlowNode getArg(int n) {
    result = call.getArg(n)
  }

  override ControlFlowNode getNode() { result = call }

  override DataFlowCallable getCallable() { result = callable }

  override DataFlowCallable getEnclosingCallable() { result.getScope() = call.getNode().getScope() }
}

class MagicCall extends DataFlowCall, TMagicCall {
  MagicMethod::Actual magic;

  MagicCall() { this = TMagicCall(magic) }

  override string toString() { result = magic.toString() }

  override ControlFlowNode getArg(int n) {
    result = magic.(MagicMethod::Potential).getArg(n)
  }

  override ControlFlowNode getNode() { result = magic }

  override DataFlowCallable getCallable() { result = TCallableValue(magic.getResolvedMagicMethod()) }

  override DataFlowCallable getEnclosingCallable() { result.getScope() = magic.getNode().getScope() }
}

/** A data flow node that represents a call argument. */
class ArgumentNode extends CfgNode {
  ArgumentNode() { exists(DataFlowCall call, int pos | node = call.getArg(pos)) }

  /** Holds if this argument occurs at the given position in the given call. */
  predicate argumentOf(DataFlowCall call, int pos) { node = call.getArg(pos) }

  /** Gets the call in which this node is an argument. */
  final DataFlowCall getCall() { this.argumentOf(result, _) }
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
class CastNode extends Node {
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
predicate jumpStep(Node pred, Node succ) {
  // As we have ESSA variables for global variables,
  // we include ESSA flow steps involving global variables.
  (
    pred.(EssaNode).getVar() instanceof GlobalSsaVariable
    or
    succ.(EssaNode).getVar() instanceof GlobalSsaVariable
  ) and
  EssaFlow::essaFlowStep(pred, succ)
}

//--------
// Field flow
//--------
/**
 * Holds if data can flow from `node1` to `node2` via an assignment to
 * content `c`.
 */
predicate storeStep(Node node1, Content c, Node node2) { none() }

/**
 * Holds if data can flow from `node1` to `node2` via a read of content `c`.
 */
predicate readStep(Node node1, Content c, Node node2) { none() }

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
