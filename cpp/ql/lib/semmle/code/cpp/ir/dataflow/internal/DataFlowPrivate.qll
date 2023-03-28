private import cpp as Cpp
private import DataFlowUtil
private import semmle.code.cpp.ir.IR
private import DataFlowDispatch
private import DataFlowImplConsistency
private import semmle.code.cpp.ir.internal.IRCppLanguage
private import SsaInternals as Ssa
private import DataFlowImplCommon as DataFlowImplCommon
import codeql.util.Unit

cached
private module Cached {
  cached
  module Nodes0 {
    cached
    newtype TIRDataFlowNode0 =
      TInstructionNode0(Instruction i) {
        not Ssa::ignoreInstruction(i) and
        not exists(Operand op |
          not Ssa::ignoreOperand(op) and i = Ssa::getIRRepresentationOfOperand(op)
        ) and
        // We exclude `void`-typed instructions because they cannot contain data.
        // However, if the instruction is a glvalue, and their type is `void`, then the result
        // type of the instruction is really `void*`, and thus we still want to have a dataflow
        // node for it.
        (not i.getResultType() instanceof VoidType or i.isGLValue())
      } or
      TMultipleUseOperandNode0(Operand op) {
        not Ssa::ignoreOperand(op) and not exists(Ssa::getIRRepresentationOfOperand(op))
      } or
      TSingleUseOperandNode0(Operand op) {
        not Ssa::ignoreOperand(op) and exists(Ssa::getIRRepresentationOfOperand(op))
      }
  }

  /**
   * Gets an additional term that is added to the `join` and `branch` computations to reflect
   * an additional forward or backwards branching factor that is not taken into account
   * when calculating the (virtual) dispatch cost.
   *
   * Argument `arg` is part of a path from a source to a sink, and `p` is the target parameter.
   */
  pragma[nomagic]
  cached
  int getAdditionalFlowIntoCallNodeTerm(ArgumentNode arg, ParameterNode p) {
    DataFlowImplCommon::forceCachingInSameStage() and
    exists(
      ParameterNode switchee, SwitchInstruction switch, ConditionOperand op, DataFlowCall call
    |
      DataFlowImplCommon::viableParamArg(call, p, arg) and
      DataFlowImplCommon::viableParamArg(call, switchee, _) and
      switch.getExpressionOperand() = op and
      getAdditionalFlowIntoCallNodeTermStep+(switchee, operandNode(op)) and
      result = countNumberOfBranchesUsingParameter(switch, p)
    )
  }
}

import Cached
private import Nodes0

class Node0Impl extends TIRDataFlowNode0 {
  /**
   * INTERNAL: Do not use.
   */
  Declaration getEnclosingCallable() { none() } // overridden in subclasses

  /** Gets the function to which this node belongs, if any. */
  Declaration getFunction() { none() } // overridden in subclasses

  /**
   * Gets the type of this node.
   *
   * If `isGLValue()` holds, then the type of this node
   * should be thought of as "pointer to `getType()`".
   */
  DataFlowType getType() { none() } // overridden in subclasses

  /** Gets the instruction corresponding to this node, if any. */
  Instruction asInstruction() { result = this.(InstructionNode0).getInstruction() }

  /** Gets the operands corresponding to this node, if any. */
  Operand asOperand() { result = this.(OperandNode0).getOperand() }

  /** INTERNAL: Do not use. */
  string toStringImpl() {
    none() // overridden by subclasses
  }

  /** Gets a textual representation of this node. */
  final string toString() { result = this.toStringImpl() }

  /** Holds if the value of this node is a glvalue */
  predicate isGLValue() { none() } // overridden in subclasses
}

/**
 * Gets the type of the operand `op`.
 *
 * The boolean `isGLValue` is true if the operand represents a glvalue. In that case,
 * the returned type should be thought of as a pointer type whose base type is given
 * by this predicate.
 */
DataFlowType getOperandType(Operand op, boolean isGLValue) {
  Ssa::getLanguageType(op).hasType(result, isGLValue)
}

/**
 * Gets the type of the instruction `instr`.
 *
 * The boolean `isGLValue` is true if the operand represents a glvalue. In that case,
 * the returned type should be thought of as a pointer type whose base type is given
 * by this predicate.
 */
DataFlowType getInstructionType(Instruction instr, boolean isGLValue) {
  Ssa::getResultLanguageType(instr).hasType(result, isGLValue)
}

/**
 * An instruction, viewed as a node in a data flow graph.
 */
abstract class InstructionNode0 extends Node0Impl {
  Instruction instr;

  /** Gets the instruction corresponding to this node. */
  Instruction getInstruction() { result = instr }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = instr.getEnclosingFunction() }

  override DataFlowType getType() { result = getInstructionType(instr, _) }

  override string toStringImpl() {
    // This predicate is overridden in subclasses. This default implementation
    // does not use `Instruction.toString` because that's expensive to compute.
    result = instr.getOpcode().toString()
  }

  final override predicate isGLValue() { exists(getInstructionType(instr, true)) }
}

/**
 * An instruction without an operand that is used only once, viewed as a node in a data flow graph.
 */
private class InstructionInstructionNode0 extends InstructionNode0, TInstructionNode0 {
  InstructionInstructionNode0() { this = TInstructionNode0(instr) }
}

/**
 * An instruction with an operand that is used only once, viewed as a node in a data flow graph.
 */
private class SingleUseOperandInstructionNode0 extends InstructionNode0, TSingleUseOperandNode0 {
  SingleUseOperandInstructionNode0() {
    exists(Operand op |
      this = TSingleUseOperandNode0(op) and
      instr = Ssa::getIRRepresentationOfOperand(op)
    )
  }
}

/**
 * An operand, viewed as a node in a data flow graph.
 */
abstract class OperandNode0 extends Node0Impl {
  Operand op;

  /** Gets the operand corresponding to this node. */
  Operand getOperand() { result = op }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Declaration getFunction() { result = op.getUse().getEnclosingFunction() }

  override DataFlowType getType() { result = getOperandType(op, _) }

  override string toStringImpl() { result = op.toString() }

  final override predicate isGLValue() { exists(getOperandType(op, true)) }
}

/**
 * An operand that is used multiple times, viewed as a node in a data flow graph.
 */
private class MultipleUseOperandNode0 extends OperandNode0, TMultipleUseOperandNode0 {
  MultipleUseOperandNode0() { this = TMultipleUseOperandNode0(op) }
}

/**
 * An operand that is used only once, viewed as a node in a data flow graph.
 */
private class SingleUseOperandNode0 extends OperandNode0, TSingleUseOperandNode0 {
  SingleUseOperandNode0() { this = TSingleUseOperandNode0(op) }
}

/**
 * INTERNAL: Do not use.
 *
 * A node that represents the indirect value of an operand in the IR
 * after `index` number of loads.
 *
 * Note: Unlike `RawIndirectOperand`, a value of type `IndirectOperand` may
 * be an `OperandNode`.
 */
class IndirectOperand extends Node {
  Operand operand;
  int indirectionIndex;

  IndirectOperand() {
    this.(RawIndirectOperand).getOperand() = operand and
    this.(RawIndirectOperand).getIndirectionIndex() = indirectionIndex
    or
    this.(OperandNode).getOperand() =
      Ssa::getIRRepresentationOfIndirectOperand(operand, indirectionIndex)
  }

  /** Gets the underlying operand. */
  Operand getOperand() { result = operand }

  /** Gets the underlying indirection index. */
  int getIndirectionIndex() { result = indirectionIndex }

  /**
   * Holds if this `IndirectOperand` is represented directly in the IR instead of
   * a `RawIndirectionOperand` with operand `op` and indirection index `index`.
   */
  predicate isIRRepresentationOf(Operand op, int index) {
    this instanceof OperandNode and
    (
      op = operand and
      index = indirectionIndex
    )
  }
}

/**
 * INTERNAL: Do not use.
 *
 * A node that represents the indirect value of an instruction in the IR
 * after `index` number of loads.
 *
 * Note: Unlike `RawIndirectInstruction`, a value of type `IndirectInstruction` may
 * be an `InstructionNode`.
 */
class IndirectInstruction extends Node {
  Instruction instr;
  int indirectionIndex;

  IndirectInstruction() {
    this.(RawIndirectInstruction).getInstruction() = instr and
    this.(RawIndirectInstruction).getIndirectionIndex() = indirectionIndex
    or
    this.(InstructionNode).getInstruction() =
      Ssa::getIRRepresentationOfIndirectInstruction(instr, indirectionIndex)
  }

  /** Gets the underlying instruction. */
  Instruction getInstruction() { result = instr }

  /** Gets the underlying indirection index. */
  int getIndirectionIndex() { result = indirectionIndex }

  /**
   * Holds if this `IndirectInstruction` is represented directly in the IR instead of
   * a `RawIndirectionInstruction` with instruction `i` and indirection index `index`.
   */
  predicate isIRRepresentationOf(Instruction i, int index) {
    this instanceof InstructionNode and
    (
      i = instr and
      index = indirectionIndex
    )
  }
}

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
}

private class SideEffectArgumentNode extends ArgumentNode, SideEffectOperandNode {
  override predicate argumentOf(DataFlowCall dfCall, ArgumentPosition pos) {
    this.getCallInstruction() = dfCall and
    pos.(IndirectionPosition).getArgumentIndex() = this.getArgumentIndex() and
    pos.(IndirectionPosition).getIndirectionIndex() = super.getIndirectionIndex()
  }
}

/** A parameter position represented by an integer. */
class ParameterPosition = Position;

/** An argument position represented by an integer. */
class ArgumentPosition = Position;

abstract class Position extends TPosition {
  abstract string toString();
}

class DirectPosition extends Position, TDirectPosition {
  int index;

  DirectPosition() { this = TDirectPosition(index) }

  override string toString() {
    index = -1 and
    result = "this"
    or
    index != -1 and
    result = index.toString()
  }

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
      return.isNormalReturn() and
      index = return.getIndirectionIndex() - 1 // We subtract one because the return loads the value.
    )
  } or
  TIndirectReturnKind(int argumentIndex, int indirectionIndex) {
    exists(IndirectReturnNode return |
      return.isParameterReturn(argumentIndex) and
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

pragma[nomagic]
private predicate finalParameterNodeHasArgumentAndIndex(
  FinalParameterNode node, int argumentIndex, int indirectionIndex
) {
  node.getArgumentIndex() = argumentIndex and
  node.getIndirectionIndex() = indirectionIndex
}

class ReturnIndirectionNode extends IndirectReturnNode, ReturnNode {
  override ReturnKind getKind() {
    exists(Operand op, int indirectionIndex |
      hasOperandAndIndex(this, pragma[only_bind_into](op), pragma[only_bind_into](indirectionIndex))
    |
      exists(ReturnValueInstruction return |
        op = return.getReturnAddressOperand() and
        result = TNormalReturnKind(indirectionIndex - 1)
      )
    )
    or
    exists(int argumentIndex, int indirectionIndex |
      finalParameterNodeHasArgumentAndIndex(this, argumentIndex, indirectionIndex) and
      result = TIndirectReturnKind(argumentIndex, indirectionIndex)
    )
  }
}

private Operand fullyConvertedCallStepImpl(Operand op) {
  not exists(getANonConversionUse(op)) and
  exists(Instruction instr |
    conversionFlow(op, instr, _, _) and
    result = getAUse(instr)
  )
}

private Operand fullyConvertedCallStep(Operand op) {
  result = unique( | | fullyConvertedCallStepImpl(op))
}

/**
 * Gets the instruction that uses this operand, if the instruction is not
 * ignored for dataflow purposes.
 */
private Instruction getUse(Operand op) {
  result = op.getUse() and
  not Ssa::ignoreInstruction(result)
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
  not conversionFlow(_, result, _, _)
}

/**
 * Gets an operand that represents the use of the value of `call` following
 * a sequence of conversion-like instructions.
 *
 * Note that `operand` is not functionally determined by `call` since there
 * can be multiple sequences of disjoint conversions following a call. For example,
 * consider an example like:
 * ```cpp
 * long f();
 * int y;
 * long x = (long)(y = (int)f());
 * ```
 * in this case, there'll be a long-to-int conversion on `f()` before the value is assigned to `y`,
 * and there will be an int-to-long conversion on `(int)f()` before the value is assigned to `x`.
 */
private predicate operandForFullyConvertedCallImpl(Operand operand, CallInstruction call) {
  exists(getANonConversionUse(operand)) and
  (
    operand = getAUse(call)
    or
    operand = fullyConvertedCallStep*(getAUse(call))
  )
}

/**
 * Gets the operand that represents the use of the value of `call` following
 * a sequence of conversion-like instructions, if a unique operand exists.
 */
predicate operandForFullyConvertedCall(Operand operand, CallInstruction call) {
  operand = unique(Operand cand | operandForFullyConvertedCallImpl(cand, call))
}

private predicate instructionForFullyConvertedCallWithConversions(
  Instruction instr, CallInstruction call
) {
  instr =
    getUse(unique(Operand operand |
        operand = fullyConvertedCallStep*(getAUse(call)) and
        not exists(fullyConvertedCallStep(operand))
      ))
}

/**
 * Gets the instruction that represents the first use of the value of `call` following
 * a sequence of conversion-like instructions.
 *
 * This predicate only holds if there is no suitable operand (i.e., no operand of a non-
 * conversion instruction) to use to represent the value of `call` after conversions.
 */
predicate instructionForFullyConvertedCall(Instruction instr, CallInstruction call) {
  // Only pick an instruction for the call if we cannot pick a unique operand.
  not operandForFullyConvertedCall(_, call) and
  (
    // If there is no use of the call then we pick the call instruction
    not instructionForFullyConvertedCallWithConversions(_, call) and
    instr = call
    or
    // Otherwise, flow to the first instruction that defines multiple operands.
    instructionForFullyConvertedCallWithConversions(instr, call)
  )
}

/** Holds if `node` represents the output node for `call`. */
private predicate simpleOutNode(Node node, CallInstruction call) {
  operandForFullyConvertedCall(node.asOperand(), call)
  or
  instructionForFullyConvertedCall(node.asInstruction(), call)
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
    exists(Ssa::GlobalUse globalUse |
      v = globalUse.getVariable() and
      n1.(FinalGlobalValue).getGlobalUse() = globalUse
    |
      globalUse.getIndirectionIndex() = 1 and
      v = n2.asVariable()
      or
      v = n2.asIndirectVariable(globalUse.getIndirectionIndex())
    )
    or
    exists(Ssa::GlobalDef globalDef |
      v = globalDef.getVariable() and
      n2.(InitialGlobalValue).getGlobalDef() = globalDef
    |
      globalDef.getIndirectionIndex() = 1 and
      v = n1.asVariable()
      or
      v = n1.asIndirectVariable(globalDef.getIndirectionIndex())
    )
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
  exists(Instruction load | Ssa::isDereference(load, operandFrom) |
    operandTo = operandFrom and ind = 0
    or
    numberOfLoadsFromOperand(load.getAUse(), operandTo, ind - 1)
  )
  or
  exists(Operand op, Instruction instr |
    instr = op.getDef() and
    conversionFlow(operandFrom, instr, _, _) and
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
  not Ssa::isDereference(_, operandFrom) and
  not conversionFlow(operandFrom, _, _, _) and
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
    // The `1` here matches the `node2.getIndirectionIndex() = 1` conjunct
    // in `storeStep`.
    nodeHasOperand(node1, fa1.getObjectAddressOperand(), 1) and
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

/** Holds if `n` should be hidden from path explanations. */
predicate nodeIsHidden(Node n) {
  n instanceof OperandNode and
  not n instanceof ArgumentNode and
  not n.asOperand() instanceof StoreValueOperand
  or
  n instanceof FinalGlobalValue
  or
  n instanceof InitialGlobalValue
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

private predicate fieldHasApproxName(Field f, string s) {
  s = f.getName().charAt(0) and
  // Reads and writes of union fields are tracked using `UnionContent`.
  not f.getDeclaringType() instanceof Cpp::Union
}

private predicate unionHasApproxName(Cpp::Union u, string s) { s = u.getName().charAt(0) }

cached
private newtype TContentApprox =
  TFieldApproxContent(string s) { fieldHasApproxName(_, s) } or
  TUnionApproxContent(string s) { unionHasApproxName(_, s) }

/** An approximated `Content`. */
class ContentApprox extends TContentApprox {
  string toString() { none() } // overridden in subclasses
}

private class FieldApproxContent extends ContentApprox, TFieldApproxContent {
  string s;

  FieldApproxContent() { this = TFieldApproxContent(s) }

  Field getAField() { fieldHasApproxName(result, s) }

  string getPrefix() { result = s }

  final override string toString() { result = s }
}

private class UnionApproxContent extends ContentApprox, TUnionApproxContent {
  string s;

  UnionApproxContent() { this = TUnionApproxContent(s) }

  Cpp::Union getAUnion() { unionHasApproxName(result, s) }

  string getPrefix() { result = s }

  final override string toString() { result = s }
}

/** Gets an approximated value for content `c`. */
pragma[inline]
ContentApprox getContentApprox(Content c) {
  exists(string prefix, Field f |
    prefix = result.(FieldApproxContent).getPrefix() and
    f = c.(FieldContent).getField() and
    fieldHasApproxName(f, prefix)
  )
  or
  exists(string prefix, Cpp::Union u |
    prefix = result.(UnionApproxContent).getPrefix() and
    u = c.(UnionContent).getUnion() and
    unionHasApproxName(u, prefix)
  )
}

private class MyConsistencyConfiguration extends Consistency::ConsistencyConfiguration {
  override predicate argHasPostUpdateExclude(ArgumentNode n) {
    // The rules for whether an IR argument gets a post-update node are too
    // complex to model here.
    any()
  }
}

/**
 * Gets the basic block of `node`.
 */
IRBlock getBasicBlock(Node node) {
  node.asInstruction().getBlock() = result
  or
  node.asOperand().getUse().getBlock() = result
  or
  node.(SsaPhiNode).getPhiNode().getBasicBlock() = result
  or
  node.(RawIndirectOperand).getOperand().getUse().getBlock() = result
  or
  node.(RawIndirectInstruction).getInstruction().getBlock() = result
  or
  result = getBasicBlock(node.(PostUpdateNode).getPreUpdateNode())
}

/**
 * A local flow relation that includes both local steps, read steps and
 * argument-to-return flow through summarized functions.
 */
private predicate localFlowStepWithSummaries(Node node1, Node node2) {
  localFlowStep(node1, node2)
  or
  readStep(node1, _, node2)
  or
  DataFlowImplCommon::argumentValueFlowsThrough(node1, _, node2)
}

/** Holds if `node` flows to a node that is used in a `SwitchInstruction`. */
private predicate localStepsToSwitch(Node node) {
  node.asOperand() = any(SwitchInstruction switch).getExpressionOperand()
  or
  exists(Node succ |
    localStepsToSwitch(succ) and
    localFlowStepWithSummaries(node, succ)
  )
}

/**
 * Holds if `node` is part of a path from a `ParameterNode` to an operand
 * of a `SwitchInstruction`.
 */
private predicate localStepsFromParameterToSwitch(Node node) {
  localStepsToSwitch(node) and
  (
    node instanceof ParameterNode
    or
    exists(Node prev |
      localStepsFromParameterToSwitch(prev) and
      localFlowStepWithSummaries(prev, node)
    )
  )
}

/**
 * The local flow relation `localFlowStepWithSummaries` pruned to only
 * include steps that are part of a path from a `ParameterNode` to an
 * operand of a `SwitchInstruction`.
 */
private predicate getAdditionalFlowIntoCallNodeTermStep(Node node1, Node node2) {
  localStepsFromParameterToSwitch(node1) and
  localStepsFromParameterToSwitch(node2) and
  localFlowStepWithSummaries(node1, node2)
}

/** Gets the `IRVariable` associated with the parameter node `p`. */
pragma[nomagic]
private IRVariable getIRVariableForParameterNode(ParameterNode p) {
  result = p.(DirectParameterNode).getIRVariable()
  or
  result.getAst() = p.(IndirectParameterNode).getParameter()
}

/** Holds if `v` is the source variable corresponding to the parameter represented by `p`. */
pragma[nomagic]
private predicate parameterNodeHasSourceVariable(ParameterNode p, Ssa::SourceIRVariable v) {
  v.getIRVariable() = getIRVariableForParameterNode(p) and
  exists(Position pos | p.isParameterOf(_, pos) |
    pos instanceof DirectPosition and
    v.getIndirection() = 1
    or
    pos.(IndirectionPosition).getIndirectionIndex() + 1 = v.getIndirection()
  )
}

private EdgeKind caseOrDefaultEdge() {
  result instanceof CaseEdge or
  result instanceof DefaultEdge
}

/**
 * Gets the number of switch branches that that read from (or write to) the parameter `p`.
 */
private int countNumberOfBranchesUsingParameter(SwitchInstruction switch, ParameterNode p) {
  exists(Ssa::SourceVariable sv |
    parameterNodeHasSourceVariable(p, sv) and
    // Count the number of cases that use the parameter. We do this by finding the phi node
    // that merges the uses/defs of the parameter. There might be multiple such phi nodes, so
    // we pick the one with the highest edge count.
    result =
      max(SsaPhiNode phi |
        switch.getSuccessor(caseOrDefaultEdge()).getBlock().dominanceFrontier() = getBasicBlock(phi) and
        phi.getSourceVariable() = sv
      |
        strictcount(phi.getAnInput())
      )
  )
}
