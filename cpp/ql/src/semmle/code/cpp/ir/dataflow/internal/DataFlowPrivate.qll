private import cpp
private import DataFlowUtil
private import semmle.code.cpp.ir.IR
private import DataFlowDispatch

/**
 * A data flow node that occurs as the argument of a call and is passed as-is
 * to the callable. Instance arguments (`this` pointer) are also included.
 */
class ArgumentNode extends InstructionNode {
  ArgumentNode() { exists(CallInstruction call | this.getInstruction() = call.getAnArgument()) }

  /**
   * Holds if this argument occurs at the given position in the given call.
   * The instance argument is considered to have index `-1`.
   */
  predicate argumentOf(DataFlowCall call, int pos) {
    this.getInstruction() = call.getPositionalArgument(pos)
    or
    this.getInstruction() = call.getThisArgument() and pos = -1
  }

  /** Gets the call in which this node is an argument. */
  DataFlowCall getCall() { this.argumentOf(result, _) }
}

private newtype TReturnKind =
  TNormalReturnKind() or
  TIndirectReturnKind(ParameterIndex index)

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For C++, this is simply a function return.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this return kind. */
  abstract string toString();
}

private class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  override string toString() { result = "return" }
}

private class IndirectReturnKind extends ReturnKind, TIndirectReturnKind {
  ParameterIndex index;

  IndirectReturnKind() { this = TIndirectReturnKind(index) }

  override string toString() { result = "outparam[" + index.toString() + "]" }
}

/** A data flow node that occurs as the result of a `ReturnStmt`. */
class ReturnNode extends InstructionNode {
  Instruction primary;

  ReturnNode() {
    exists(ReturnValueInstruction ret | instr = ret.getReturnValue() and primary = ret)
    or
    exists(ReturnIndirectionInstruction rii |
      instr = rii.getSideEffectOperand().getAnyDef() and primary = rii
    )
  }

  /** Gets the kind of this returned value. */
  abstract ReturnKind getKind();
}

class ReturnValueNode extends ReturnNode {
  override ReturnValueInstruction primary;

  override ReturnKind getKind() { result = TNormalReturnKind() }
}

class ReturnIndirectionNode extends ReturnNode {
  override ReturnIndirectionInstruction primary;

  override ReturnKind getKind() { 
    result = TIndirectReturnKind(-1) and
    primary.isThisIndirection()
    or
    result = TIndirectReturnKind(primary.getParameter().getIndex())
  }

}

/** A data flow node that represents the output of a call. */
class OutNode extends InstructionNode {
  OutNode() {
    instr instanceof CallInstruction or
    instr instanceof WriteSideEffectInstruction
  }

  /** Gets the underlying call. */
  abstract DataFlowCall getCall();

  abstract ReturnKind getReturnKind();
}

private class CallOutNode extends OutNode {
  override CallInstruction instr;

  override DataFlowCall getCall() { result = instr }

  override ReturnKind getReturnKind() { result instanceof NormalReturnKind }
}

private class SideEffectOutNode extends OutNode {
  override WriteSideEffectInstruction instr;

  override DataFlowCall getCall() { result = instr.getPrimaryInstruction() }

  override ReturnKind getReturnKind() { result = TIndirectReturnKind(instr.getIndex()) }
}

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  result.getCall() = call and
  result.getReturnKind() = kind
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that loses the
 * calling context. For example, this would happen with flow through a
 * global or static variable.
 */
predicate jumpStep(Node n1, Node n2) { none() }

private newtype TContent =
  TFieldContent(Field f) or
  TCollectionContent() or
  TArrayContent()

/**
 * A reference contained in an object. Examples include instance fields, the
 * contents of a collection object, or the contents of an array.
 */
class Content extends TContent {
  /** Gets a textual representation of this element. */
  abstract string toString();

  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = "" and sl = 0 and sc = 0 and el = 0 and ec = 0
  }

  /** Gets the type of the object containing this content. */
  abstract Type getContainerType();

  /** Gets the type of this content. */
  abstract Type getType();
}

private class FieldContent extends Content, TFieldContent {
  Field f;

  FieldContent() { this = TFieldContent(f) }

  Field getField() { result = f }

  override string toString() { result = f.toString() }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    f.getLocation().hasLocationInfo(path, sl, sc, el, ec)
  }

  override Type getContainerType() { result = f.getDeclaringType() }

  override Type getType() { result = f.getType() }
}

private class CollectionContent extends Content, TCollectionContent {
  override string toString() { result = "collection" }

  override Type getContainerType() { none() }

  override Type getType() { none() }
}

private class ArrayContent extends Content, TArrayContent {
  override string toString() { result = "array" }

  override Type getContainerType() { none() }

  override Type getType() { none() }
}

private predicate storeStepNoChi(Node node1, Content f, PostUpdateNode node2) {
  exists(FieldAddressInstruction fa, StoreInstruction store |
    store = node2.asInstruction() and
    store.getDestinationAddress() = fa and
    store.getSourceValue() = node1.asInstruction() and
    f.(FieldContent).getField() = fa.getField()
  )
}

private predicate storeStepChi(Node node1, Content f, PostUpdateNode node2) {
  exists(FieldAddressInstruction fa, StoreInstruction store |
    node1.asInstruction() = store and
    store.getDestinationAddress() = fa and
    node2.asInstruction().(ChiInstruction).getPartial() = store and
    f.(FieldContent).getField() = fa.getField()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content f, PostUpdateNode node2) {
  storeStepNoChi(node1, f, node2) or
  storeStepChi(node1, f, node2)
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content f, Node node2) {
  exists(FieldAddressInstruction fa, LoadInstruction load |
    load.getSourceAddress() = fa and
    node1.asInstruction() = load.getSourceValueOperand().getAnyDef() and
    fa.getField() = f.(FieldContent).getField() and
    load = node2.asInstruction()
  )
}

/**
 * Gets a representative (boxed) type for `t` for the purpose of pruning
 * possible flow. A single type is used for all numeric types to account for
 * numeric conversions, and otherwise the erasure is used.
 */
Type getErasedRepr(Type t) {
  suppressUnusedType(t) and
  result instanceof VoidType // stub implementation
}

/** Gets a string representation of a type returned by `getErasedRepr`. */
string ppReprType(Type t) { none() } // stub implementation

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(Type t1, Type t2) {
  any() // stub implementation
}

private predicate suppressUnusedType(Type t) { any() }

//////////////////////////////////////////////////////////////////////////////
// Java QL library compatibility wrappers
//////////////////////////////////////////////////////////////////////////////
/** A node that performs a type cast. */
class CastNode extends InstructionNode {
  CastNode() { none() } // stub implementation
}

/**
 * A function that may contain code or a variable that may contain itself. When
 * flow crosses from one _enclosing callable_ to another, the interprocedural
 * data-flow library discards call contexts and inserts a node in the big-step
 * relation used for human-readable path explanations.
 */
class DataFlowCallable = Declaration;

class DataFlowExpr = Expr;

class DataFlowType = Type;

/** A function call relevant for data flow. */
class DataFlowCall extends CallInstruction {
  /**
   * Gets the nth argument for this call.
   *
   * The range of `n` is from `0` to `getNumberOfArguments() - 1`.
   */
  Node getArgument(int n) { result.asInstruction() = this.getPositionalArgument(n) }

  Function getEnclosingCallable() { result = this.getEnclosingFunction() }
}

predicate isUnreachableInCall(Node n, DataFlowCall call) { none() } // stub implementation

int accessPathLimit() { result = 5 }

/**
 * Holds if `n` does not require a `PostUpdateNode` as it either cannot be
 * modified or its modification cannot be observed, for example if it is a
 * freshly created object that is not saved in a variable.
 *
 * This predicate is only used for consistency checks.
 */
predicate isImmutableOrUnobservable(Node n) {
  // The rules for whether an IR argument gets a post-update node are too
  // complex to model here.
  any()
}
