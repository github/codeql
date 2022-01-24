private import cpp
private import DataFlowUtil
private import semmle.code.cpp.ir.IR
private import DataFlowDispatch
private import DataFlowImplConsistency

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

/**
 * A data flow node that occurs as the argument of a call and is passed as-is
 * to the callable. Instance arguments (`this` pointer) and read side effects
 * on parameters are also included.
 */
abstract class ArgumentNode extends OperandNode {
  /**
   * Holds if this argument occurs at the given position in the given call.
   * The instance argument is considered to have index `-1`.
   */
  abstract predicate argumentOf(DataFlowCall call, ArgumentPosition pos);

  /** Gets the call in which this node is an argument. */
  DataFlowCall getCall() { this.argumentOf(result, _) }
}

/**
 * A data flow node that occurs as the argument to a call, or an
 * implicit `this` pointer argument.
 */
private class PrimaryArgumentNode extends ArgumentNode {
  override ArgumentOperand op;

  PrimaryArgumentNode() { exists(CallInstruction call | op = call.getAnArgumentOperand()) }

  override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
    op = call.getArgumentOperand(pos.(DirectPosition).getIndex())
  }

  override string toString() {
    exists(Expr unconverted |
      unconverted = op.getDef().getUnconvertedResultExpression() and
      result = unconverted.toString()
    )
    or
    // Certain instructions don't map to an unconverted result expression. For these cases
    // we fall back to a simpler naming scheme. This can happen in IR-generated constructors.
    not exists(op.getDef().getUnconvertedResultExpression()) and
    (
      result = "Argument " + op.(PositionalArgumentOperand).getIndex()
      or
      op instanceof ThisArgumentOperand and result = "Argument this"
    )
  }
}

/**
 * A data flow node representing the read side effect of a call on a
 * specific parameter.
 */
private class SideEffectArgumentNode extends ArgumentNode {
  override SideEffectOperand op;
  ReadSideEffectInstruction read;

  SideEffectArgumentNode() { op = read.getSideEffectOperand() }

  override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
    read.getPrimaryInstruction() = call and
    pos.(IndirectionPosition).getIndex() = read.getIndex()
  }

  override string toString() {
    result = read.getArgumentDef().getUnconvertedResultExpression().toString() + " indirection"
    or
    // Some instructions don't map to an unconverted result expression. For these cases
    // we fall back to a simpler naming scheme. This can happen in IR-generated constructors.
    not exists(read.getArgumentDef().getUnconvertedResultExpression()) and
    (
      if read.getIndex() = -1
      then result = "Argument this indirection"
      else result = "Argument " + read.getIndex() + " indirection"
    )
  }
}

/** A parameter position represented by an integer. */
class ParameterPosition = Position;

/** An argument position represented by an integer. */
class ArgumentPosition = Position;

class Position extends TPosition {
  abstract string toString();
}

class DirectPosition extends TDirectPosition {
  int index;

  DirectPosition() { this = TDirectPosition(index) }

  string toString() {
    index = -1 and
    result = "this"
    or
    index != -1 and
    result = index.toString()
  }

  int getIndex() { result = index }
}

class IndirectionPosition extends TIndirectionPosition {
  int index;

  IndirectionPosition() { this = TIndirectionPosition(index) }

  string toString() {
    index = -1 and
    result = "this"
    or
    index != -1 and
    result = index.toString()
  }

  int getIndex() { result = index }
}

newtype TPosition =
  TDirectPosition(int index) { exists(any(CallInstruction c).getArgument(index)) } or
  TIndirectionPosition(int index) {
    exists(ReadSideEffectInstruction instr | instr.getIndex() = index)
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
    exists(ReturnValueInstruction ret | instr = ret and primary = ret)
    or
    exists(ReturnIndirectionInstruction rii | instr = rii and primary = rii)
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
    exists(int index |
      primary.hasIndex(index) and
      result = TIndirectReturnKind(index)
    )
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
  // There should be only one `OutNode` for a given `(call, kind)` pair. Showing the optimizer that
  // this is true helps it make better decisions downstream, especially in virtual dispatch.
  result =
    unique(OutNode outNode |
      outNode.getCall() = call and
      outNode.getReturnKind() = kind
    )
}

/**
 * Holds if data can flow from `node1` to `node2` in a way that loses the
 * calling context. For example, this would happen with flow through a
 * global or static variable.
 */
predicate jumpStep(Node n1, Node n2) { none() }

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(StoreNodeInstr node1, FieldContent f, StoreNodeInstr node2) {
  exists(FieldAddressInstruction fai |
    node1.getInstruction() = fai and
    node2.getInstruction() = fai.getObjectAddress() and
    f.getField() = fai.getField()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(ReadNode node1, FieldContent f, ReadNode node2) {
  exists(FieldAddressInstruction fai |
    node1.getInstruction() = fai.getObjectAddress() and
    node2.getInstruction() = fai and
    f.getField() = fai.getField()
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`.
 */
predicate clearsContent(Node n, Content c) {
  none() // stub implementation
}

/** Gets the type of `n` used for type pruning. */
IRType getNodeType(Node n) {
  suppressUnusedNode(n) and
  result instanceof IRVoidType // stub implementation
}

/** Gets a string representation of a type returned by `getNodeType`. */
string ppReprType(IRType t) { none() } // stub implementation

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(IRType t1, IRType t2) {
  any() // stub implementation
}

private predicate suppressUnusedNode(Node n) { any() }

//////////////////////////////////////////////////////////////////////////////
// Java QL library compatibility wrappers
//////////////////////////////////////////////////////////////////////////////
/** A node that performs a type cast. */
class CastNode extends Node {
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

class DataFlowType = IRType;

/** A function call relevant for data flow. */
class DataFlowCall extends CallInstruction {
  Function getEnclosingCallable() { result = this.getEnclosingFunction() }
}

predicate isUnreachableInCall(Node n, DataFlowCall call) { none() } // stub implementation

int accessPathLimit() { result = 5 }

/**
 * Holds if access paths with `c` at their head always should be tracked at high
 * precision. This disables adaptive access path precision for such access paths.
 */
predicate forceHighPrecision(Content c) { none() }

/** The unit type. */
private newtype TUnit = TMkUnit()

/** The trivial type with a single element. */
class Unit extends TUnit {
  /** Gets a textual representation of this element. */
  string toString() { result = "unit" }
}

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  n instanceof OperandNode and not n instanceof ArgumentNode
  or
  StoreNodeFlow::flowThrough(n, _) and
  not StoreNodeFlow::flowOutOf(n, _) and
  not StoreNodeFlow::flowInto(_, n)
  or
  ReadNodeFlow::flowThrough(n, _) and
  not ReadNodeFlow::flowOutOf(n, _) and
  not ReadNodeFlow::flowInto(_, n)
}

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

private class MyConsistencyConfiguration extends Consistency::ConsistencyConfiguration {
  override predicate argHasPostUpdateExclude(ArgumentNode n) {
    // The rules for whether an IR argument gets a post-update node are too
    // complex to model here.
    any()
  }
}
