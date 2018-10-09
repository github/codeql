/**
 * Provides classes for control flow.
 */

private import CIL

/** A node in the control flow graph. */
class ControlFlowNode extends @cil_controlflow_node
{
  /** Gets a textual representation of this control flow node. */
  string toString() { none() }

  /**
   * Gets the number of items this node pushes onto the stack.
   * This value is either 0 or 1, except for the instruction `dup`
   * which pushes 2 values onto the stack.
   */
  int getPushCount() { result=0 }

  /** Gets the number of items this node pops from the stack. */
  int getPopCount() { result=0 }

  /** Gets a successor of this node, if any. */
  final Instruction getASuccessor() { result=getASuccessorType(_) }

  /** Gets a true successor of this node, if any. */
  final Instruction getTrueSuccessor() { result=getASuccessorType(any(TrueFlow f)) }

  /** Gets a false successor of this node, if any. */
  final Instruction getFalseSuccessor() { result=getASuccessorType(any(FalseFlow f)) }

  /** Gets a successor to this node, of type `type`, if any. */
  final Instruction getASuccessorType(FlowType t) {
    result = Internal::getASuccessorByType(this, t)
  }

  /** Gets a predecessor of this node, if any. */
  ControlFlowNode getAPredecessor() { result.getASuccessor() = this }

  /**
   * Gets an instruction that supplies the `i`th operand to this instruction.
   * Note that this can be multi-valued.
   */
  ControlFlowNode getOperand(int i) { result = Internal::getOperand(this, i) }

  /** Gets an operand of this instruction, if any. */
  ControlFlowNode getAnOperand() { result=getOperand(_) }

  /** Gets an expression that consumes the output of this instruction on the stack. */
  Instruction getParentExpr() {
    this=result.getAnOperand()
  }

  int getStackDelta() { result = getPushCount() - getPopCount() }

  /** Gets the stack size before this instruction. */
  int getStackSizeBefore()
  {
    result = getAPredecessor().getStackSizeAfter()
  }

  /** Gets the stack size after this instruction. */
  final int getStackSizeAfter()
  {
    // This is a guard to prevent ill formed programs
    // and other logic errors going into an infinite loop.
    result in [0..getImplementation().getStackSize()]
    and
    result = getStackSizeBefore() + getStackDelta()
  }

  /** Gets the method containing this control flow node. */
  MethodImplementation getImplementation() { none() }

  /** Gets the type of the item pushed onto the stack, if any. */
  Type getType() { result = Internal::getType(this) }

  /** Holds if this control flow node has more than one predecessor. */
  predicate isJoin() { count(getAPredecessor())>1 }
}

private cached module Internal {
  private import Opcodes

  cached Instruction getASuccessorByType(ControlFlowNode cfn, FlowType t) {
    cfn = any(Instruction i |
      not i instanceof Branch and
      i.canFlowNext() and
      result = i.getImplementation().getInstruction(i.getIndex() + 1) and
      t instanceof NormalFlow
    )
    or
    cfn = any(UnconditionalBranch b |
      t instanceof NormalFlow and
      result = b.getTarget()
    )
    or
    cfn = any(ConditionalBranch b |
      if b instanceof Switch then
        t instanceof NormalFlow and
        (
          result = b.(Switch).getTarget(_)
          or
          result = b.getImplementation().getInstruction(b.getIndex() + 1)
        )
      else (
        t instanceof TrueFlow and
        result = b.getTarget()
        or
        t instanceof FalseFlow and
        result = b.getImplementation().getInstruction(b.getIndex() + 1)
      )
    )
    or
    cfn = any(MethodImplementation mi |
      t instanceof NormalFlow and
      result.getImplementation() = mi and
      result.getIndex() = 0
    )
    or
    cfn = any(Handler h |
      result = h.getHandlerStart() and
      t instanceof NormalFlow
    )
  }

  /**
   * Holds if `pred` is a transitive predecessor of `cfn`, `cfn`
   * pops operand `i`, `pushes` additional pushes are required
   * for operand `i` at node `pred`, and no instruction between
   * (and including) `pred` and `cfn` is a push for operand `i`.
   */
  private predicate getOperandRec(ControlFlowNode cfn, ControlFlowNode pred, int i, int pushes) {
    // Invariant: no node is a push for operand `i`
    pushes >= pred.getPushCount()
    and
    (
      i in [0 .. cfn.getPopCount() - 1] and
      pred = cfn.getAPredecessor() and
      pushes = i
      or
      exists(ControlFlowNode mid, int pushes0 |
        getOperandRec(cfn, mid, i, pushes0) |
        pushes = pushes0 - mid.getStackDelta() and
        // This is a guard to prevent ill formed programs
        // and other logic errors going into an infinite loop.
        pushes <= cfn.getImplementation().getStackSize() and
        pred = mid.getAPredecessor()
      )
    )
  }

  /**
   * Gets an instruction that supplies the `i`th operand to this instruction.
   * Note that this can be multi-valued.
   */
  cached
  ControlFlowNode getOperand(ControlFlowNode cfn, int i) {
    // Immediate predecessor pushes the operand
    i in [0 .. cfn.getPopCount() - 1] and
    result = cfn.getAPredecessor() and
    i < result.getPushCount()
    or
    // Transitive predecessor pushes the operand
    exists(ControlFlowNode mid, int pushes |
      getOperandRec(cfn, mid, i, pushes) |
      pushes - mid.getStackDelta() < result.getPushCount() and
      result = mid.getAPredecessor()
    )
  }

  cached Type getType(ControlFlowNode cfn) {
    cfn instanceof ComparisonOperation and
    result instanceof BoolType
    or
    exists(Type t0, Type t1, int conversionIndex0, int conversionIndex1 |
      getBinaryArithmeticExprOperandType01(cfn, t0, t1) and
      conversionIndex0 = t0.getConversionIndex() and
      conversionIndex1 = t1.getConversionIndex() |
      t0 = t1 and result = t0
      or
      conversionIndex0 < conversionIndex1 and result = t1
      or
      conversionIndex0 > conversionIndex1 and result = t0
    )
    or
    cfn instanceof UnaryBitwiseOperation and
    // This is wrong but efficient - should depend on the types of the operands.
    result instanceof IntType
    or
    cfn instanceof BinaryBitwiseOperation and
    // This is wrong but efficient - should depend on the types of the operands.
    result instanceof IntType
    or
    cfn instanceof IntLiteral and
    result instanceof IntType
    or
    not cfn instanceof Newobj and
    result = cfn.(Call).getTarget().getReturnType()
    or
    result = cfn.(ReadAccess).getTarget().getType()
    or
    cfn instanceof Ldnull and
    result instanceof ObjectType
    or
    cfn instanceof Ldc_r4 and
    result instanceof FloatType
    or
    cfn instanceof Ldc_r8 and
    result instanceof DoubleType
    or
    result = getNegOperandType(cfn, 0)
    or
    result = getDupOperandType(cfn, 0)
    or
    cfn instanceof Ldstr and
    result instanceof StringType
    or
    cfn instanceof Isinst and
    result instanceof BoolType
    or
    result = cfn.(Castclass).getAccess()
    or
    result = cfn.(Newobj).getTarget().getDeclaringType()
    or
    result = cfn.(Box).getAccess()
    or
    result = cfn.(Unbox_any).getAccess()
    or
    result = cfn.(Unbox).getAccess()
    or
    result = cfn.(Ldobj).getAccess()
    or
    cfn instanceof Ldtoken and
    // Not really sure what a type of a token is so use `object`.
    result instanceof ObjectType
    or
    cfn instanceof Ldlen and
    result instanceof IntType
    or
    // Note that this is technically wrong - it should be
    // result.(ArrayType).getElementType() = getAccess()
    // However the (ArrayType) may not be in the database.
    result = cfn.(Newarr).getAccess()
    or
    result = cfn.(Ldelem).getAccess()
    or
    result = getLdelem_refOperandType(cfn, 1)
    or
    result = cfn.(Ldelema).getAccess()
    or
    cfn instanceof Ldelem_i and
    result instanceof IntType
    or
    cfn instanceof Ldelem_i1 and
    result instanceof SByteType
    or
    cfn instanceof Ldelem_i2 and
    result instanceof ShortType
    or
    cfn instanceof Ldelem_i4 and
    result instanceof IntType
    or
    cfn instanceof Ldelem_i8 and
    result instanceof LongType
    or
    cfn instanceof Ldelem_r4 and
    result instanceof FloatType
    or
    cfn instanceof Ldelem_r8 and
    result instanceof DoubleType
    or
    cfn instanceof Ldelem_u1 and
    result instanceof ByteType
    or
    cfn instanceof Ldelem_u2 and
    result instanceof UShortType
    or
    cfn instanceof Ldelem_u4 and
    result instanceof UIntType
    or
    cfn instanceof Conv_i and
    result instanceof IntType
    or
    cfn instanceof Conv_ovf_i and
    result instanceof IntType
    or
    cfn instanceof Conv_ovf_i_un and
    result instanceof UIntType
    or
    cfn instanceof Conv_i1 and
    result instanceof SByteType
    or
    cfn instanceof Conv_ovf_i1 and
    result instanceof SByteType
    or
    cfn instanceof Conv_ovf_i1_un and
    result instanceof SByteType
    or
    cfn instanceof Conv_i2 and
    result instanceof ShortType
    or
    cfn instanceof Conv_ovf_i2 and
    result instanceof ShortType
    or
    cfn instanceof Conv_ovf_i2_un and
    result instanceof ShortType
    or
    cfn instanceof Conv_i4 and
    result instanceof IntType
    or
    cfn instanceof Conv_ovf_i4 and
    result instanceof IntType
    or
    cfn instanceof Conv_ovf_i4_un and
    result instanceof IntType
    or
    cfn instanceof Conv_i8 and
    result instanceof LongType
    or
    cfn instanceof Conv_ovf_i8 and
    result instanceof LongType
    or
    cfn instanceof Conv_ovf_i8_un and
    result instanceof LongType
    or
    cfn instanceof Conv_u and
    result instanceof UIntType
    or
    cfn instanceof Conv_ovf_u and
    result instanceof UIntType
    or
    cfn instanceof Conv_ovf_u_un and
    result instanceof UIntType
    or
    cfn instanceof Conv_u1 and
    result instanceof ByteType
    or
    cfn instanceof Conv_ovf_u1 and
    result instanceof ByteType
    or
    cfn instanceof Conv_ovf_u1_un and
    result instanceof ByteType
    or
    cfn instanceof Conv_u2 and
    result instanceof UShortType
    or
    cfn instanceof Conv_ovf_u2 and
    result instanceof UShortType
    or
    cfn instanceof Conv_ovf_u2_un and
    result instanceof UShortType
    or
    cfn instanceof Conv_u4 and
    result instanceof UIntType
    or
    cfn instanceof Conv_ovf_u4 and
    result instanceof UIntType
    or
    cfn instanceof Conv_ovf_u4_un and
    result instanceof UIntType
    or
    cfn instanceof Conv_u8 and
    result instanceof ULongType
    or
    cfn instanceof Conv_ovf_u8 and
    result instanceof ULongType
    or
    cfn instanceof Conv_ovf_u8_un and
    result instanceof ULongType
    or
    cfn instanceof Conv_r4 and
    result instanceof FloatType
    or
    cfn instanceof Conv_r8 and
    result instanceof DoubleType
    or
    cfn instanceof Conv_r_un and
    result instanceof DoubleType  // ??
    or
    cfn instanceof Ldind_i and
    result instanceof IntType
    or
    cfn instanceof Ldind_i1 and
    result instanceof SByteType
    or
    cfn instanceof Ldind_i2 and
    result instanceof ShortType
    or
    cfn instanceof Ldind_i4 and
    result instanceof IntType
    or
    cfn instanceof Ldind_i8 and
    result instanceof LongType
    or
    cfn instanceof Ldind_r4 and
    result instanceof FloatType
    or
    cfn instanceof Ldind_r8 and
    result instanceof DoubleType
    or
    cfn instanceof Ldind_ref and
    result instanceof ObjectType
    or
    cfn instanceof Ldind_u1 and
    result instanceof ByteType
    or
    cfn instanceof Ldind_u2 and
    result instanceof UShortType
    or
    cfn instanceof Ldind_u4 and
    result instanceof UIntType
    or
    cfn instanceof Sizeof and
    result instanceof IntType
    or
    result = cfn.(Mkrefany).getAccess()
    or
    cfn instanceof Refanytype and
    result instanceof SystemType
  }

  pragma [nomagic]
  private Type getBinaryArithmeticExprOperandType(BinaryArithmeticExpr bae, int i) {
    result = getType(bae.getOperand(i))
  }

  pragma [nomagic]
  private predicate getBinaryArithmeticExprOperandType01(BinaryArithmeticExpr bae, Type t0, Type t1) {
    t0 = getBinaryArithmeticExprOperandType(bae, 0).getUnderlyingType() and
    t1 = getBinaryArithmeticExprOperandType(bae, 1).getUnderlyingType()
  }

  pragma [nomagic]
  private Type getNegOperandType(Neg n, int i) {
    result = getType(n.getOperand(i))
  }

  pragma [nomagic]
  private Type getDupOperandType(Dup d, int i) {
    result = getType(d.getOperand(i))
  }

  pragma [nomagic]
  private Type getLdelem_refOperandType(Ldelem_ref l, int i) {
    result = getType(l.getOperand(i))
  }
}

/**
 * A control flow entry point. Either a method (`MethodImplementation`) or a handler (`Handler`).
 *
 * Handlers are control flow nodes because they push the handled exception onto the stack.
 */
class EntryPoint extends ControlFlowNode, @cil_entry_point {
  override int getStackSizeBefore() { result=0 }
}

private newtype TFlowType = TNormalFlow() or TTrueFlow() or TFalseFlow()

/** A type of control flow. Either normal flow (`NormalFlow`), true flow (`TrueFlow`) or false flow (`FalseFlow`). */
abstract class FlowType extends TFlowType {
  abstract string toString();
}

/** Normal control flow. */
class NormalFlow extends FlowType, TNormalFlow {
  override string toString() { result="" }
}

/** True control flow. */
class TrueFlow extends FlowType, TTrueFlow {
  override string toString() { result="true" }
}

/** False control flow. */
class FalseFlow extends FlowType, TTrueFlow {
  override string toString() { result="false" }
}
