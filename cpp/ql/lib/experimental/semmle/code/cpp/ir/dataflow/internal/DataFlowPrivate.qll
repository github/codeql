private import cpp as Cpp
private import DataFlowUtil
private import semmle.code.cpp.ir.IR
private import DataFlowDispatch
private import DataFlowImplConsistency
private import semmle.code.cpp.ir.internal.IRCppLanguage
private import SsaInternals as Ssa

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
abstract class ArgumentNode extends Node {
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
private class PrimaryArgumentNode extends ArgumentNode, OperandNode {
  override ArgumentOperand op;

  PrimaryArgumentNode() { exists(CallInstruction call | op = call.getAnArgumentOperand()) }

  override predicate argumentOf(DataFlowCall call, ArgumentPosition pos) {
    op = call.getArgumentOperand(pos.(DirectPosition).getIndex())
  }

  override string toStringImpl() { result = argumentOperandToString(op) }
}

private string argumentOperandToString(ArgumentOperand op) {
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

private class SideEffectArgumentNode extends ArgumentNode, SideEffectOperandNode {
  override predicate argumentOf(DataFlowCall dfCall, ArgumentPosition pos) {
    this.getCallInstruction() = dfCall and
    pos.(IndirectionPosition).getArgumentIndex() = this.getArgumentIndex() and
    pos.(IndirectionPosition).getIndirectionIndex() = super.getIndirectionIndex()
  }

  override string toStringImpl() {
    result = argumentOperandToString(this.getAddressOperand()) + " indirection"
  }
}

/** A parameter position represented by an integer. */
class ParameterPosition = Position;

/** An argument position represented by an integer. */
class ArgumentPosition = Position;

class Position extends TPosition {
  abstract string toString();
}

class DirectPosition extends Position, TDirectPosition {
  int index;

  DirectPosition() { this = TDirectPosition(index) }

  override string toString() { if index = -1 then result = "this" else result = index.toString() }

  int getIndex() { result = index }
}

class IndirectionPosition extends Position, TIndirectionPosition {
  int argumentIndex;
  int indirectionIndex;

  IndirectionPosition() { this = TIndirectionPosition(argumentIndex, indirectionIndex) }

  override string toString() {
    if argumentIndex = -1
    then if indirectionIndex > 0 then result = "this indirection" else result = "this"
    else
      if indirectionIndex > 0
      then result = argumentIndex.toString() + " indirection"
      else result = argumentIndex.toString()
  }

  int getArgumentIndex() { result = argumentIndex }

  int getIndirectionIndex() { result = indirectionIndex }
}

newtype TPosition =
  TDirectPosition(int index) { exists(any(CallInstruction c).getArgument(index)) } or
  TIndirectionPosition(int argumentIndex, int indirectionIndex) {
    hasOperandAndIndex(_, any(CallInstruction call).getArgumentOperand(argumentIndex),
      indirectionIndex)
  }

private newtype TReturnKind =
  TNormalReturnKind(int index) {
    exists(IndirectReturnNode return |
      return.getAddressOperand() = any(ReturnValueInstruction r).getReturnAddressOperand() and
      index = return.getIndirectionIndex() - 1 // We subtract one because the return loads the value.
    )
  } or
  TIndirectReturnKind(int argumentIndex, int indirectionIndex) {
    exists(IndirectReturnNode return, ReturnIndirectionInstruction returnInd |
      returnInd.hasIndex(argumentIndex) and
      return.getAddressOperand() = returnInd.getSourceAddressOperand() and
      indirectionIndex = return.getIndirectionIndex()
    )
  }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable. For C++, this is simply a function return.
 */
class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this return kind. */
  abstract string toString();
}

private class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  int index;

  NormalReturnKind() { this = TNormalReturnKind(index) }

  override string toString() { result = "indirect return" }
}

private class IndirectReturnKind extends ReturnKind, TIndirectReturnKind {
  int argumentIndex;
  int indirectionIndex;

  IndirectReturnKind() { this = TIndirectReturnKind(argumentIndex, indirectionIndex) }

  override string toString() { result = "indirect outparam[" + argumentIndex.toString() + "]" }
}

/** A data flow node that occurs as the result of a `ReturnStmt`. */
class ReturnNode extends Node instanceof IndirectReturnNode {
  /** Gets the kind of this returned value. */
  abstract ReturnKind getKind();
}

/**
 * This predicate represents an annoying hack that we have to do. We use the
 * `ReturnIndirectionInstruction` to determine which variables need flow back
 * out of a function. However, the IR will unconditionally create those for a
 * variable passed to a function even though the variable was never updated by
 * the function. And if a function has too many `ReturnNode`s the dataflow
 * library lowers its precision for that function by disabling field flow.
 *
 * So we those eliminate `ReturnNode`s that would have otherwise been created
 * by this unconditional `ReturnIndirectionInstruction` by requiring that there
 * must exist an SSA definition of the IR variable in the function.
 */
private predicate hasNonInitializeParameterDef(IRVariable v) {
  exists(Ssa::Def def |
    not def.getDefiningInstruction() instanceof InitializeParameterInstruction and
    v = def.getSourceVariable().getBaseVariable().(Ssa::BaseIRVariable).getIRVariable()
  )
}

class ReturnIndirectionNode extends IndirectReturnNode, ReturnNode {
  override ReturnKind getKind() {
    exists(int argumentIndex, ReturnIndirectionInstruction returnInd |
      returnInd.hasIndex(argumentIndex) and
      this.getAddressOperand() = returnInd.getSourceAddressOperand() and
      result = TIndirectReturnKind(argumentIndex, this.getIndirectionIndex()) and
      hasNonInitializeParameterDef(returnInd.getIRVariable())
    )
    or
    this.getAddressOperand() = any(ReturnValueInstruction r).getReturnAddressOperand() and
    result = TNormalReturnKind(this.getIndirectionIndex() - 1)
  }
}

private Operand fullyConvertedCallStep(Operand op) {
  not exists(getANonConversionUse(op)) and
  exists(Instruction instr |
    conversionFlow(op, instr, _) and
    result = getAUse(instr)
  )
}

/**
 * Gets the instruction that uses this operand, if the instruction is not
 * ignored for dataflow purposes.
 */
private Instruction getUse(Operand op) {
  result = op.getUse() and
  not Ssa::ignoreOperand(op)
}

/** Gets a use of the instruction `instr` that is not ignored for dataflow purposes. */
Operand getAUse(Instruction instr) {
  result = instr.getAUse() and
  not Ssa::ignoreOperand(result)
}

/**
 * Gets a use of `operand` that is:
 * - not ignored for dataflow purposes, and
 * - not a conversion-like instruction.
 */
private Instruction getANonConversionUse(Operand operand) {
  result = getUse(operand) and
  not conversionFlow(_, result, _)
}

/**
 * Gets the operand that represents the first use of the value of `call` following
 * a sequence of conversion-like instructions.
 */
predicate operandForfullyConvertedCall(Operand operand, CallInstruction call) {
  exists(getANonConversionUse(operand)) and
  (
    operand = getAUse(call)
    or
    operand = fullyConvertedCallStep*(getAUse(call))
  )
}

/**
 * Gets the instruction that represents the first use of the value of `call` following
 * a sequence of conversion-like instructions.
 *
 * This predicate only holds if there is no suitable operand (i.e., no operand of a non-
 * conversion instruction) to use to represent the value of `call` after conversions.
 */
predicate instructionForfullyConvertedCall(Instruction instr, CallInstruction call) {
  not operandForfullyConvertedCall(_, call) and
  (
    // If there is no use of the call then we pick the call instruction
    not exists(getAUse(call)) and
    instr = call
    or
    // Otherwise, flow to the first non-conversion use.
    exists(Operand operand | operand = fullyConvertedCallStep*(getAUse(call)) |
      instr = getANonConversionUse(operand)
    )
  )
}

/** Holds if `node` represents the output node for `call`. */
private predicate simpleOutNode(Node node, CallInstruction call) {
  operandForfullyConvertedCall(node.asOperand(), call)
  or
  instructionForfullyConvertedCall(node.asInstruction(), call)
}

/** A data flow node that represents the output of a call. */
class OutNode extends Node {
  OutNode() {
    // Return values not hidden behind indirections
    simpleOutNode(this, _)
    or
    // Return values hidden behind indirections
    this instanceof IndirectReturnOutNode
    or
    // Modified arguments hidden behind indirections
    this instanceof IndirectArgumentOutNode
  }

  /** Gets the underlying call. */
  abstract DataFlowCall getCall();

  abstract ReturnKind getReturnKind();
}

private class DirectCallOutNode extends OutNode {
  CallInstruction call;

  DirectCallOutNode() { simpleOutNode(this, call) }

  override DataFlowCall getCall() { result = call }

  override ReturnKind getReturnKind() { result = TNormalReturnKind(0) }
}

private class IndirectCallOutNode extends OutNode, IndirectReturnOutNode {
  override DataFlowCall getCall() { result = this.getCallInstruction() }

  override ReturnKind getReturnKind() { result = TNormalReturnKind(this.getIndirectionIndex()) }
}

private class SideEffectOutNode extends OutNode, IndirectArgumentOutNode {
  override DataFlowCall getCall() { result = this.getCallInstruction() }

  override ReturnKind getReturnKind() {
    result = TIndirectReturnKind(this.getArgumentIndex(), this.getIndirectionIndex())
  }
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
predicate jumpStep(Node n1, Node n2) {
  exists(Cpp::GlobalOrNamespaceVariable v |
    v =
      n1.asInstruction()
          .(StoreInstruction)
          .getResultAddress()
          .(VariableAddressInstruction)
          .getAstVariable() and
    v = n2.asVariable()
    or
    v =
      n2.asInstruction()
          .(LoadInstruction)
          .getSourceAddress()
          .(VariableAddressInstruction)
          .getAstVariable() and
    v = n1.asVariable()
  )
}

/**
 * Holds if data can flow from `node1` to `node2` via an assignment to `f`.
 * Thus, `node2` references an object with a field `f` that contains the
 * value of `node1`.
 */
predicate storeStep(Node node1, Content c, PostFieldUpdateNode node2) {
  exists(int indirectionIndex1, int numberOfLoads, StoreInstruction store |
    nodeHasInstruction(node1, store, pragma[only_bind_into](indirectionIndex1)) and
    node2.getIndirectionIndex() = 1 and
    numberOfLoadsFromOperand(node2.getFieldAddress(), store.getDestinationAddressOperand(),
      numberOfLoads)
  |
    exists(FieldContent fc | fc = c |
      fc.getField() = node2.getUpdatedField() and
      fc.getIndirectionIndex() = 1 + indirectionIndex1 + numberOfLoads
    )
    or
    exists(UnionContent uc | uc = c |
      uc.getAField() = node2.getUpdatedField() and
      uc.getIndirectionIndex() = 1 + indirectionIndex1 + numberOfLoads
    )
  )
}

/**
 * Holds if `operandFrom` flows to `operandTo` using a sequence of conversion-like
 * operations and exactly `n` `LoadInstruction` operations.
 */
private predicate numberOfLoadsFromOperandRec(Operand operandFrom, Operand operandTo, int ind) {
  exists(LoadInstruction load | load.getSourceAddressOperand() = operandFrom |
    operandTo = operandFrom and ind = 0
    or
    numberOfLoadsFromOperand(load.getAUse(), operandTo, ind - 1)
  )
  or
  exists(Operand op, Instruction instr |
    instr = op.getDef() and
    conversionFlow(operandFrom, instr, _) and
    numberOfLoadsFromOperand(op, operandTo, ind)
  )
}

/**
 * Holds if `operandFrom` flows to `operandTo` using a sequence of conversion-like
 * operations and exactly `n` `LoadInstruction` operations.
 */
private predicate numberOfLoadsFromOperand(Operand operandFrom, Operand operandTo, int n) {
  numberOfLoadsFromOperandRec(operandFrom, operandTo, n)
  or
  not any(LoadInstruction load).getSourceAddressOperand() = operandFrom and
  not conversionFlow(operandFrom, _, _) and
  operandFrom = operandTo and
  n = 0
}

// Needed to join on both an operand and an index at the same time.
pragma[noinline]
predicate nodeHasOperand(Node node, Operand operand, int indirectionIndex) {
  node.asOperand() = operand and indirectionIndex = 0
  or
  hasOperandAndIndex(node, operand, indirectionIndex)
}

// Needed to join on both an instruction and an index at the same time.
pragma[noinline]
predicate nodeHasInstruction(Node node, Instruction instr, int indirectionIndex) {
  node.asInstruction() = instr and indirectionIndex = 0
  or
  hasInstructionAndIndex(node, instr, indirectionIndex)
}

/**
 * Holds if data can flow from `node1` to `node2` via a read of `f`.
 * Thus, `node1` references an object with a field `f` whose value ends up in
 * `node2`.
 */
predicate readStep(Node node1, Content c, Node node2) {
  exists(FieldAddress fa1, Operand operand, int numberOfLoads, int indirectionIndex2 |
    nodeHasOperand(node2, operand, indirectionIndex2) and
    nodeHasOperand(node1, fa1.getObjectAddressOperand(), _) and
    numberOfLoadsFromOperand(fa1, operand, numberOfLoads)
  |
    exists(FieldContent fc | fc = c |
      fc.getField() = fa1.getField() and
      fc.getIndirectionIndex() = indirectionIndex2 + numberOfLoads
    )
    or
    exists(UnionContent uc | uc = c |
      uc.getAField() = fa1.getField() and
      uc.getIndirectionIndex() = indirectionIndex2 + numberOfLoads
    )
  )
}

/**
 * Holds if values stored inside content `c` are cleared at node `n`.
 */
predicate clearsContent(Node n, Content c) {
  none() // stub implementation
}

/**
 * Holds if the value that is being tracked is expected to be stored inside content `c`
 * at node `n`.
 */
predicate expectsContent(Node n, ContentSet c) { none() }

/** Gets the type of `n` used for type pruning. */
DataFlowType getNodeType(Node n) {
  suppressUnusedNode(n) and
  result instanceof VoidType // stub implementation
}

/** Gets a string representation of a type returned by `getNodeType`. */
string ppReprType(DataFlowType t) { none() } // stub implementation

/**
 * Holds if `t1` and `t2` are compatible, that is, whether data can flow from
 * a node of type `t1` to a node of type `t2`.
 */
pragma[inline]
predicate compatibleTypes(DataFlowType t1, DataFlowType t2) {
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
class DataFlowCallable = Cpp::Declaration;

class DataFlowExpr = Expr;

class DataFlowType = Type;

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
predicate nodeIsHidden(Node n) { n instanceof OperandNode and not n instanceof ArgumentNode }

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

/** An approximated `Content`. */
class ContentApprox = Unit;

/** Gets an approximated value for content `c`. */
pragma[inline]
ContentApprox getContentApprox(Content c) { any() }

private class MyConsistencyConfiguration extends Consistency::ConsistencyConfiguration {
  override predicate argHasPostUpdateExclude(ArgumentNode n) {
    // The rules for whether an IR argument gets a post-update node are too
    // complex to model here.
    any()
  }
}
