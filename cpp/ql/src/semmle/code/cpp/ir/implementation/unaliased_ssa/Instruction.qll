private import internal.IRInternal
import FunctionIR
import IRBlock
import IRVariable
import Operand
import cpp
import semmle.code.cpp.ir.implementation.EdgeKind
import semmle.code.cpp.ir.implementation.MemoryAccessKind
import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.internal.OperandTag

class InstructionTag = Construction::InstructionTagType;

module InstructionSanity {
  /**
   * Holds if the instruction `instr` should be expected to have an operand
   * with operand tag `tag`. Only holds for singleton operand tags. Tags with
   * parameters, such as `PhiOperand` and `PositionalArgumentOperand` are handled
   * separately in `unexpectedOperand`.
   */
  private predicate expectsOperand(Instruction instr, OperandTag tag) {
    exists(Opcode opcode |
      opcode = instr.getOpcode() and
      (
        opcode instanceof UnaryOpcode and tag instanceof UnaryOperandTag or
        (
          opcode instanceof BinaryOpcode and
          (
            tag instanceof LeftOperandTag or
            tag instanceof RightOperandTag
          )
        ) or
        opcode instanceof CopyOpcode and tag instanceof CopySourceOperandTag or
        opcode instanceof MemoryAccessOpcode and tag instanceof AddressOperandTag or
        opcode instanceof BufferAccessOpcode and tag instanceof BufferSizeOperand or
        opcode instanceof OpcodeWithCondition and tag instanceof ConditionOperandTag or
        opcode instanceof Opcode::ReturnValue and tag instanceof ReturnValueOperandTag or
        opcode instanceof Opcode::ThrowValue and tag instanceof ExceptionOperandTag or
        opcode instanceof Opcode::UnmodeledUse and tag instanceof UnmodeledUseOperandTag or
        opcode instanceof Opcode::Call and tag instanceof CallTargetOperandTag or
        opcode instanceof Opcode::Chi and tag instanceof ChiTotalOperandTag or
        opcode instanceof Opcode::Chi and tag instanceof ChiPartialOperandTag or
        (
          (opcode instanceof ReadSideEffectOpcode or opcode instanceof MayWriteSideEffectOpcode) and
          tag instanceof SideEffectOperandTag
        )
      )
    )
  }

  /**
   * Holds if instruction `instr` is missing an expected operand with tag `tag`.
   */
  query predicate missingOperand(Instruction instr, OperandTag tag) {
    expectsOperand(instr, tag) and
    not exists(NonPhiOperand operand |
      operand = instr.getAnOperand() and
      operand.getOperandTag() = tag
    )
  }

  /**
   * Holds if instruction `instr` has an unexpected operand with tag `tag`.
   */
  query predicate unexpectedOperand(Instruction instr, OperandTag tag) {
    exists(NonPhiOperand operand |
      operand = instr.getAnOperand() and
      operand.getOperandTag() = tag) and
    not expectsOperand(instr, tag) and
    not (instr instanceof CallInstruction and tag instanceof ArgumentOperandTag) and
    not (instr instanceof BuiltInInstruction and tag instanceof PositionalArgumentOperandTag)
  }

  /**
   * Holds if instruction `instr` has multiple operands with tag `tag`.
   */
  query predicate duplicateOperand(Instruction instr, OperandTag tag) {
    strictcount(NonPhiOperand operand |
      operand = instr.getAnOperand() and
      operand.getOperandTag() = tag
    ) > 1 and
    not tag instanceof UnmodeledUseOperandTag
  }

  /**
   * Holds if `Phi` instruction `instr` is missing an operand corresponding to
   * the predecessor block `pred`.
   */
  query predicate missingPhiOperand(PhiInstruction instr, IRBlock pred) {
    pred = instr.getBlock().getAPredecessor() and
    not exists(PhiOperand operand |
      operand = instr.getAnOperand() and
      operand.getPredecessorBlock() = pred
    )
  }

  /**
   * Holds if an instruction, other than `ExitFunction`, has no successors.
   */
  query predicate instructionWithoutSuccessor(Instruction instr) {
    not exists(instr.getASuccessor()) and
    not instr instanceof ExitFunctionInstruction and
    // Phi instructions aren't linked into the instruction-level flow graph.
    not instr instanceof PhiInstruction and
    not instr instanceof UnreachedInstruction
  }

  /**
   * Holds if a `Phi` instruction is present in a block with fewer than two
   * predecessors.
   */
  query predicate unnecessaryPhiInstruction(PhiInstruction instr) {
    count(instr.getBlock().getAPredecessor()) < 2
  }

  /**
   * Holds if operand `operand` consumes a value that was defined in
   * a different function.
   */
  query predicate operandAcrossFunctions(Operand operand, Instruction instr, Instruction defInstr) {
    operand.getInstruction() = instr and
    operand.getDefinitionInstruction() = defInstr and
    instr.getFunctionIR() != defInstr.getFunctionIR()
  }

  /**
   * Holds if instruction `instr` is not in exactly one block.
   */
  query predicate instructionWithoutUniqueBlock(Instruction instr, int blockCount) {
    blockCount = count(instr.getBlock()) and
    blockCount != 1
  } 
}

/**
 * Represents a single operation in the IR.
 */
class Instruction extends Construction::TInstruction {
  Opcode opcode;
  Locatable ast;
  InstructionTag instructionTag;
  Type resultType;
  FunctionIR funcIR;
  boolean glvalue;

  Instruction() {
    this = Construction::MkInstruction(funcIR, opcode, ast, instructionTag, resultType, glvalue)
  }

  final string toString() {
    result = getOpcode().toString() + ": " + getAST().toString()
  }

  /**
   * Gets a string showing the result, opcode, and operands of the instruction, equivalent to what
   * would be printed by PrintIR.ql. For example:
   *
   * `mu0_28(int) = Store r0_26, r0_27`
   */
  final string getDumpString() {
    result = getResultString() + " = " + getOperationString() + " " + getOperandsString()
  }

  /**
   * Gets a string describing the operation of this instruction. This includes
   * the opcode and the immediate value, if any. For example:
   *
   * VariableAddress[x]
   */
  final string getOperationString() {
    if exists(getImmediateString()) then
      result = getOperationPrefix() + opcode.toString() + "[" + getImmediateString() + "]"
    else
      result = getOperationPrefix() + opcode.toString()
  }

  /**
   * Gets a string describing the immediate value of this instruction, if any.
   */
  string getImmediateString() {
    none()
  }

  private string getOperationPrefix() {
    if this instanceof SideEffectInstruction then
      result = "^"
    else
      result = ""
  }

  private string getResultPrefix() {
    if resultType instanceof VoidType then
      result = "v"
    else if hasMemoryResult() then
      if isResultModeled() then
        result = "m"
      else
        result = "mu"
    else
      result = "r"
  }

  /**
   * Gets the zero-based index of this instruction within its block. This is
   * used by debugging and printing code only.
   */
  int getDisplayIndexInBlock() {
    exists(IRBlock block |
      block = getBlock() and
      (
        exists(int index, int phiCount |
          phiCount = count(block.getAPhiInstruction()) and
          this = block.getInstruction(index) and
          result = index + phiCount
        ) or
        (
          this instanceof PhiInstruction and
          this = rank[result + 1](PhiInstruction phiInstr |
            phiInstr = block.getAPhiInstruction() |
            phiInstr order by phiInstr.getUniqueId()
          )
        )
      )
    )
  }

  bindingset[type]
  private string getValueCategoryString(string type) {
    if isGLValue() then
      result = "glval<" + type + ">"
    else
      result = type
  }

  private string getResultTypeString() {
    exists(string valcat |
      valcat = getValueCategoryString(resultType.toString()) and
      if (resultType instanceof UnknownType and
          not isGLValue() and
          exists(getResultSize())) then (
        result = valcat + "[" + getResultSize().toString() + "]"
      )
      else
        result = valcat
    )
  }

  /**
   * Gets a human-readable string that uniquely identifies this instruction
   * within the function. This string is used to refer to this instruction when
   * printing IR dumps.
   *
   * Example: `r1_1`
   */
  string getResultId() {
    result = getResultPrefix() + getBlock().getDisplayIndex().toString() + "_" +
      getDisplayIndexInBlock().toString()
  }

  /**
   * Gets a string describing the result of this instruction, suitable for
   * display in IR dumps. This consists of the result ID plus the type of the
   * result.
   *
   * Example: `r1_1(int*)`
   */
  final string getResultString() {
    result = getResultId() + "(" + getResultTypeString() + ")"
  }

  /**
   * Gets a string describing the operands of this instruction, suitable for
   * display in IR dumps.
   *
   * Example: `func:r3_4, this:r3_5`
   */
  string getOperandsString() {
    result = concat(Operand operand |
      operand = getAnOperand() |
      operand.getDumpString(), ", " order by operand.getDumpSortOrder()
    )
  }

  /**
   * Gets a string identifier for this function that is unique among all
   * instructions in the same function.
   *
   * This is used for sorting IR output for tests, and is likely to be
   * inefficient for any other use.
   */
  final string getUniqueId() {
    result = Construction::getInstructionUniqueId(this)
  }

  /**
   * Gets the basic block that contains this instruction.
   */
  final IRBlock getBlock() {
    result.getAnInstruction() = this
  }

  /**
   * Gets the function that contains this instruction.
   */
  final Function getFunction() {
    result = funcIR.getFunction()
  }

  /**
   * Gets the FunctionIR object that contains the IR for this instruction.
   */
  final FunctionIR getFunctionIR() {
    result = funcIR
  }

  /**
   * Gets the AST that caused this instruction to be generated.
   */
  final Locatable getAST() {
    result = ast
  }

  /**
   * Gets the location of the source code for this instruction.
   */
  final Location getLocation() {
    result = ast.getLocation()
  }

  /**
   * Gets the `Expr` whose result is computed by this instruction, if any.
   */
  final Expr getConvertedResultExpression() {
    result = Construction::getInstructionConvertedResultExpression(this) 
  }
  
    /**
   * Gets the unconverted `Expr` whose result is computed by this instruction, if any.
   */
  final Expr getUnconvertedResultExpression() {
    result = Construction::getInstructionUnconvertedResultExpression(this) 
  }
  
  /**
   * Gets the type of the result produced by this instruction. If the
   * instruction does not produce a result, its result type will be `VoidType`.
   */
  final Type getResultType() {
    result = resultType
  }

  /**
   * Holds if the result produced by this instruction is a glvalue. If this
   * holds, the result of the instruction represents the address of a location,
   * and the type of the location is given by `getResultType()`. If this does
   * not hold, the result of the instruction represents a value whose type is
   * given by `getResultType()`.
   *
   * For example, the statement `y = x;` generates the following IR:
   * r1_0(glval: int) = VariableAddress[x]
   * r1_1(int)        = Load r1_0, mu0_1
   * r1_2(glval: int) = VariableAddress[y]
   * mu1_3(int)       = Store r1_2, r1_1
   *
   * The result of each `VariableAddress` instruction is a glvalue of type
   * `int`, representing the address of the corresponding integer variable. The
   * result of the `Load` instruction is a prvalue of type `int`, representing
   * the integer value loaded from variable `x`.
   */
  final predicate isGLValue() {
    glvalue = true
  }

  /**
   * Gets the size of the result produced by this instruction, in bytes. If the
   * result does not have a known constant size, this predicate does not hold.
   *
   * If `this.isGLValue()` holds for this instruction, the value of
   * `getResultSize()` will always be the size of a pointer.
   */
  final int getResultSize() {
    if isGLValue() then (
      // a glvalue is always pointer-sized.
      exists(NullPointerType nullptr |
        result = nullptr.getSize()
      )
    )
    else if resultType instanceof UnknownType then
      result = Construction::getInstructionResultSize(this)
    else (
      result = resultType.getSize()
    )
  }

  /**
   * Gets the opcode that specifies the operation performed by this instruction.
   */
  final Opcode getOpcode() {
    result = opcode
  }

  final InstructionTag getTag() {
    result = instructionTag
  }

  /**
   * Gets all direct uses of the result of this instruction.
   */
  final Operand getAUse() {
    result.getDefinitionInstruction() = this
  }

  /**
   * Gets all of this instruction's operands.
   */
  final Operand getAnOperand() {
    result.getInstruction() = this
  }

  /**
   * Holds if this instruction produces a memory result.
   */
  final predicate hasMemoryResult() {
    exists(getResultMemoryAccess())
  }

  /**
   * Gets the kind of memory access performed by this instruction's result.
   * Holds only for instructions with a memory result.
   */
  MemoryAccessKind getResultMemoryAccess() {
    none()
  }

  /**
   * Holds if the result of this instruction is precisely modeled in SSA. Always
   * holds for a register result. For a memory result, a modeled result is
   * connected to its actual uses. An unmodeled result is connected to the
   * `UnmodeledUse` instruction.
   *
   * For example:
   * ```
   * int x = 1;
   * int *p = &x;
   * int y = *p;
   * ```
   * In non-aliased SSA, `x` will not be modeled because it has its address
   * taken. In that case, `isResultModeled()` would not hold for the result of
   * the `Store` to `x`.
   */
  final predicate isResultModeled() {
    // Register results are always in SSA form.
    not hasMemoryResult() or
    Construction::hasModeledMemoryResult(this)
  }

  /**
   * Gets the successor of this instruction along the control flow edge
   * specified by `kind`.
   */
  final Instruction getSuccessor(EdgeKind kind) {
    result = Construction::getInstructionSuccessor(this, kind)
  }

  /**
   * Gets all direct successors of this instruction.
   */
  final Instruction getASuccessor() {
    result = getSuccessor(_)
  }

  /**
   * Gets a predecessor of this instruction such that the predecessor reaches
   * this instruction along the control flow edge specified by `kind`.
   */
  final Instruction getPredecessor(EdgeKind kind) {
    result.getSuccessor(kind) = this
  }

  /**
   * Gets all direct predecessors of this instruction.
   */
  final Instruction getAPredecessor() {
    result = getPredecessor(_)
  }
}

class VariableInstruction extends Instruction {
  IRVariable var;

  VariableInstruction() {
    var = Construction::getInstructionVariable(this)
  }

  override final string getImmediateString() {
    result = var.toString()
  }

  final IRVariable getVariable() {
    result = var
  }
}

class FieldInstruction extends Instruction {
  Field field;

  FieldInstruction() {
    field = Construction::getInstructionField(this)
  }

  override final string getImmediateString() {
    result = field.toString()
  }

  final Field getField() {
    result = field
  }
}

class FunctionInstruction extends Instruction {
  Function funcSymbol;

  FunctionInstruction() {
    funcSymbol = Construction::getInstructionFunction(this)
  }

  override final string getImmediateString() {
    result = funcSymbol.toString()
  }

  final Function getFunctionSymbol() {
    result = funcSymbol
  }
}

class ConstantValueInstruction extends Instruction {
  string value;

  ConstantValueInstruction() {
    value = Construction::getInstructionConstantValue(this)
  }

  override final string getImmediateString() {
    result = value
  }

  final string getValue() {
    result = value
  }
}

class EnterFunctionInstruction extends Instruction {
  EnterFunctionInstruction() {
    opcode instanceof Opcode::EnterFunction
  }
}

class VariableAddressInstruction extends VariableInstruction {
  VariableAddressInstruction() {
    opcode instanceof Opcode::VariableAddress
  }
}

class InitializeParameterInstruction extends VariableInstruction {
  InitializeParameterInstruction() {
    opcode instanceof Opcode::InitializeParameter
  }

  final Parameter getParameter() {
    result = var.(IRUserVariable).getVariable()
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof IndirectMemoryAccess
  }
}

/**
 * An instruction that initializes the `this` pointer parameter of the enclosing function.
 */
class InitializeThisInstruction extends Instruction {
  InitializeThisInstruction() {
    opcode instanceof Opcode::InitializeThis
  }
}

class FieldAddressInstruction extends FieldInstruction {
  FieldAddressInstruction() {
    opcode instanceof Opcode::FieldAddress
  }

  final Instruction getObjectAddress() {
    result = getAnOperand().(UnaryOperand).getDefinitionInstruction()
  }
}

class UninitializedInstruction extends VariableInstruction {
  UninitializedInstruction() {
    opcode instanceof Opcode::Uninitialized
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof IndirectMemoryAccess
  }

  /**
   * Gets the `LocalVariable` that is uninitialized.
   */
  final LocalVariable getLocalVariable() {
    result = var.(IRUserVariable).getVariable()
  }
}

class NoOpInstruction extends Instruction {
  NoOpInstruction() {
    opcode instanceof Opcode::NoOp
  }
}

class ReturnInstruction extends Instruction {
  ReturnInstruction() {
    opcode instanceof ReturnOpcode
  }
}

class ReturnVoidInstruction extends ReturnInstruction {
  ReturnVoidInstruction() {
    opcode instanceof Opcode::ReturnVoid
  }
}

class ReturnValueInstruction extends ReturnInstruction {
  ReturnValueInstruction() {
    opcode instanceof Opcode::ReturnValue
  }

  final Instruction getReturnValue() {
    result = getAnOperand().(ReturnValueOperand).getDefinitionInstruction()
  }
}

class CopyInstruction extends Instruction {
  CopyInstruction() {
    opcode instanceof CopyOpcode
  }

  final Instruction getSourceValue() {
    result = getAnOperand().(CopySourceOperand).getDefinitionInstruction()
  }
}

class CopyValueInstruction extends CopyInstruction {
  CopyValueInstruction() {
    opcode instanceof Opcode::CopyValue
  }
}

class LoadInstruction extends CopyInstruction {
  LoadInstruction() {
    opcode instanceof Opcode::Load
  }

  final Instruction getSourceAddress() {
    result = getAnOperand().(AddressOperand).getDefinitionInstruction()
  }
}

class StoreInstruction extends CopyInstruction {
  StoreInstruction() {
    opcode instanceof Opcode::Store
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof IndirectMemoryAccess
  }

  final Instruction getDestinationAddress() {
    result = getAnOperand().(AddressOperand).getDefinitionInstruction()
  }
}

class ConditionalBranchInstruction extends Instruction {
  ConditionalBranchInstruction() {
    opcode instanceof Opcode::ConditionalBranch
  }

  final Instruction getCondition() {
    result = getAnOperand().(ConditionOperand).getDefinitionInstruction()
  }

  final Instruction getTrueSuccessor() {
    result = getSuccessor(trueEdge())
  }

  final Instruction getFalseSuccessor() {
    result = getSuccessor(falseEdge())
  }
}

class ExitFunctionInstruction extends Instruction {
  ExitFunctionInstruction() {
    opcode instanceof Opcode::ExitFunction
  }
}

class ConstantInstruction extends ConstantValueInstruction {
  ConstantInstruction() {
    opcode instanceof Opcode::Constant
  }
}

class IntegerConstantInstruction extends ConstantInstruction {
  IntegerConstantInstruction() {
    resultType instanceof IntegralType
  }
}

class FloatConstantInstruction extends ConstantInstruction {
  FloatConstantInstruction() {
    resultType instanceof FloatingPointType
  }
}

class StringConstantInstruction extends Instruction {
  StringLiteral value;

  StringConstantInstruction() {
    value = Construction::getInstructionStringLiteral(this)
  }

  override final string getImmediateString() {
    result = value.getValueText().replaceAll("\n", " ").replaceAll("\r", "").replaceAll("\t", " ")
  }

  final StringLiteral getValue() {
    result = value
  }
}

class BinaryInstruction extends Instruction {
  BinaryInstruction() {
    opcode instanceof BinaryOpcode
  }

  final Instruction getLeftOperand() {
    result = getAnOperand().(LeftOperand).getDefinitionInstruction()
  }

  final Instruction getRightOperand() {
    result = getAnOperand().(RightOperand).getDefinitionInstruction()
  }
}

class AddInstruction extends BinaryInstruction {
  AddInstruction() {
    opcode instanceof Opcode::Add
  }
}

class SubInstruction extends BinaryInstruction {
  SubInstruction() {
    opcode instanceof Opcode::Sub
  }
}

class MulInstruction extends BinaryInstruction {
  MulInstruction() {
    opcode instanceof Opcode::Mul
  }
}

class DivInstruction extends BinaryInstruction {
  DivInstruction() {
    opcode instanceof Opcode::Div
  }
}

class RemInstruction extends BinaryInstruction {
  RemInstruction() {
    opcode instanceof Opcode::Rem
  }
}

class NegateInstruction extends UnaryInstruction {
  NegateInstruction() {
    opcode instanceof Opcode::Negate
  }
}

class BitAndInstruction extends BinaryInstruction {
  BitAndInstruction() {
    opcode instanceof Opcode::BitAnd
  }
}

class BitOrInstruction extends BinaryInstruction {
  BitOrInstruction() {
    opcode instanceof Opcode::BitOr
  }
}

class BitXorInstruction extends BinaryInstruction {
  BitXorInstruction() {
    opcode instanceof Opcode::BitXor
  }
}

class ShiftLeftInstruction extends BinaryInstruction {
  ShiftLeftInstruction() {
    opcode instanceof Opcode::ShiftLeft
  }
}

class ShiftRightInstruction extends BinaryInstruction {
  ShiftRightInstruction() {
    opcode instanceof Opcode::ShiftRight
  }
}

class PointerArithmeticInstruction extends BinaryInstruction {
  int elementSize;

  PointerArithmeticInstruction() {
    opcode instanceof PointerArithmeticOpcode and
    elementSize = Construction::getInstructionElementSize(this)
  }

  override final string getImmediateString() {
    result = elementSize.toString()
  }

  final int getElementSize() {
    result = elementSize
  }
}

class PointerOffsetInstruction extends PointerArithmeticInstruction {
  PointerOffsetInstruction() {
    opcode instanceof PointerOffsetOpcode
  }
}

class PointerAddInstruction extends PointerOffsetInstruction {
  PointerAddInstruction() {
    opcode instanceof Opcode::PointerAdd
  }
}

class PointerSubInstruction extends PointerOffsetInstruction {
  PointerSubInstruction() {
    opcode instanceof Opcode::PointerSub
  }
}

class PointerDiffInstruction extends PointerArithmeticInstruction {
  PointerDiffInstruction() {
    opcode instanceof Opcode::PointerDiff
  }
}

class UnaryInstruction extends Instruction {
  UnaryInstruction() {
    opcode instanceof UnaryOpcode
  }

  final Instruction getOperand() {
    result = getAnOperand().(UnaryOperand).getDefinitionInstruction()
  }
}

class ConvertInstruction extends UnaryInstruction {
  ConvertInstruction() {
    opcode instanceof Opcode::Convert
  }
}

/**
 * Represents an instruction that converts between two addresses
 * related by inheritance.
 */
class InheritanceConversionInstruction extends UnaryInstruction {
  Class baseClass;
  Class derivedClass;

  InheritanceConversionInstruction() {
    Construction::getInstructionInheritance(this, baseClass, derivedClass)
  }

  override final string getImmediateString() {
    result = derivedClass.toString() + " : " + baseClass.toString()
  }

  /**
   * Gets the `ClassDerivation` for the inheritance relationship between
   * the base and derived classes. This predicate does not hold if the
   * conversion is to an indirect virtual base class.
   */
  final ClassDerivation getDerivation() {
    result.getBaseClass() = baseClass and result.getDerivedClass() = derivedClass
  }

  /**
   * Gets the base class of the conversion. This will be either a direct
   * base class of the derived class, or a virtual base class of the
   * derived class.
   */
  final Class getBaseClass() {
    result = baseClass
  }

  /**
   * Gets the derived class of the conversion.
   */
  final Class getDerivedClass() {
    result = derivedClass
  }
}

/**
 * Represents an instruction that converts from the address of a derived class
 * to the address of a direct non-virtual base class.
 */
class ConvertToBaseInstruction extends InheritanceConversionInstruction {
  ConvertToBaseInstruction() {
    opcode instanceof Opcode::ConvertToBase
  }
}

/**
 * Represents an instruction that converts from the address of a derived class
 * to the address of a virtual base class.
 */
class ConvertToVirtualBaseInstruction extends InheritanceConversionInstruction {
  ConvertToVirtualBaseInstruction() {
    opcode instanceof Opcode::ConvertToVirtualBase
  }
}

/**
 * Represents an instruction that converts from the address of a base class
 * to the address of a direct non-virtual derived class.
 */
class ConvertToDerivedInstruction extends InheritanceConversionInstruction {
  ConvertToDerivedInstruction() {
    opcode instanceof Opcode::ConvertToDerived
  }
}

class BitComplementInstruction extends UnaryInstruction {
  BitComplementInstruction() {
    opcode instanceof Opcode::BitComplement
  }
}

class LogicalNotInstruction extends UnaryInstruction {
  LogicalNotInstruction() {
    opcode instanceof Opcode::LogicalNot
  }
}

class CompareInstruction extends BinaryInstruction {
  CompareInstruction() {
    opcode instanceof CompareOpcode
  }
}

class CompareEQInstruction extends CompareInstruction {
  CompareEQInstruction() {
    opcode instanceof Opcode::CompareEQ
  }
}

class CompareNEInstruction extends CompareInstruction {
  CompareNEInstruction() {
    opcode instanceof Opcode::CompareNE
  }
}

/**
 * Represents an instruction that does a relative comparison of two values, such as `<` or `>=`.
 */
class RelationalInstruction extends CompareInstruction {
  RelationalInstruction() {
    opcode instanceof RelationalOpcode
  }

  /**
   * Gets the operand on the "greater" (or "greater-or-equal") side
   * of this relational instruction, that is, the side that is larger
   * if the overall instruction evaluates to `true`; for example on
   * `x <= 20` this is the `20`, and on `y > 0` it is `y`.
   */
  Instruction getGreaterOperand() {
    none()
  }

  /**
   * Gets the operand on the "lesser" (or "lesser-or-equal") side
   * of this relational instruction, that is, the side that is smaller
   * if the overall instruction evaluates to `true`; for example on
   * `x <= 20` this is `x`, and on `y > 0` it is the `0`.
   */
  Instruction getLesserOperand() {
    none()
  }

  /**
   * Holds if this relational instruction is strict (is not an "or-equal" instruction).
   */
  predicate isStrict() {
    none()
  }
}

class CompareLTInstruction extends RelationalInstruction {
  CompareLTInstruction() {
    opcode instanceof Opcode::CompareLT
  }

  override Instruction getLesserOperand() {
    result = getLeftOperand()
  }

  override Instruction getGreaterOperand() {
    result = getRightOperand()
  }

  override predicate isStrict() {
    any()
  }
}

class CompareGTInstruction extends RelationalInstruction {
  CompareGTInstruction() {
    opcode instanceof Opcode::CompareGT
  }

  override Instruction getLesserOperand() {
    result = getRightOperand()
  }

  override Instruction getGreaterOperand() {
    result = getLeftOperand()
  }

  override predicate isStrict() {
    any()
  }
}

class CompareLEInstruction extends RelationalInstruction {
  CompareLEInstruction() {
    opcode instanceof Opcode::CompareLE
  }

  override Instruction getLesserOperand() {
    result = getLeftOperand()
  }

  override Instruction getGreaterOperand() {
    result = getRightOperand()
  }

  override predicate isStrict() {
    none()
  }
}

class CompareGEInstruction extends RelationalInstruction {
  CompareGEInstruction() {
    opcode instanceof Opcode::CompareGE
  }

  override Instruction getLesserOperand() {
    result = getRightOperand()
  }

  override Instruction getGreaterOperand() {
    result = getLeftOperand()
  }

  override predicate isStrict() {
    none()
  }
}

class SwitchInstruction extends Instruction {
  SwitchInstruction() {
    opcode instanceof Opcode::Switch
  }

  final Instruction getExpression() {
    result = getAnOperand().(ConditionOperand).getDefinitionInstruction()
  }

  final Instruction getACaseSuccessor() {
    exists(CaseEdge edge |
      result = getSuccessor(edge)
    )
  }

  final Instruction getDefaultSuccessor() {
    result = getSuccessor(defaultEdge())
  }
}

/**
 * An instruction that calls a function.
 */
class CallInstruction extends Instruction {
  CallInstruction() {
    opcode instanceof Opcode::Call
  }

  /**
   * Gets the `Instruction` that computes the target function of the call. This is usually a
   * `FunctionAddress` instruction, but can also be an arbitrary instruction that produces a
   * function pointer.
   */
  final Instruction getCallTarget() {
    result = getAnOperand().(CallTargetOperand).getDefinitionInstruction()
  }

  /**
   * Gets all of the arguments of the call, including the `this` pointer, if any.
   */
  final Instruction getAnArgument() {
    result = getAnOperand().(ArgumentOperand).getDefinitionInstruction()
  }

  /**
   * Gets the `this` pointer argument of the call, if any.
   */
  final Instruction getThisArgument() {
    result = getAnOperand().(ThisArgumentOperand).getDefinitionInstruction()
  }

  /**
   * Gets the argument at the specified index.
   */
  final Instruction getPositionalArgument(int index) {
    exists(PositionalArgumentOperand operand |
      operand = getAnOperand() and
      operand.getIndex() = index and
      result = operand.getDefinitionInstruction()
    )
  }
}

/**
 * An instruction representing a side effect of a function call.
 */
class SideEffectInstruction extends Instruction {
  SideEffectInstruction() {
    opcode instanceof SideEffectOpcode
  }

  final Instruction getPrimaryInstruction() {
    result = Construction::getPrimaryInstructionForSideEffect(this)
  }
}

/**
 * An instruction representing the side effect of a function call on any memory that might be
 * accessed by that call.
 */
class CallSideEffectInstruction extends SideEffectInstruction {
  CallSideEffectInstruction() {
    opcode instanceof Opcode::CallSideEffect
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof EscapedMemoryAccess
  }
}

/**
 * An instruction representing the side effect of a function call on any memory that might be read
 * by that call.
 */
class CallReadSideEffectInstruction extends SideEffectInstruction {
  CallReadSideEffectInstruction() {
    opcode instanceof Opcode::CallReadSideEffect
  }
}

/**
 * An instruction representing the read of an indirect parameter within a function call.
 */
class IndirectReadSideEffectInstruction extends SideEffectInstruction {
  IndirectReadSideEffectInstruction() {
    opcode instanceof Opcode::IndirectReadSideEffect
  }
}

/**
 * An instruction representing the read of an indirect buffer parameter within a function call.
 */
class BufferReadSideEffectInstruction extends SideEffectInstruction {
  BufferReadSideEffectInstruction() {
    opcode instanceof Opcode::BufferReadSideEffect
  }
}

/**
 * An instruction representing the write of an indirect parameter within a function call.
 */
class IndirectWriteSideEffectInstruction extends SideEffectInstruction {
  IndirectWriteSideEffectInstruction() {
    opcode instanceof Opcode::IndirectWriteSideEffect
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof IndirectMemoryAccess
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call. The
 * entire buffer is overwritten.
 */
class BufferWriteSideEffectInstruction extends SideEffectInstruction {
  BufferWriteSideEffectInstruction() {
    opcode instanceof Opcode::BufferWriteSideEffect
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof BufferMemoryAccess
  }
}

/**
 * An instruction representing the potential write of an indirect parameter within a function call.
 * Unlike `IndirectWriteSideEffectInstruction`, the location might not be completely overwritten.
 * written.
 */
class IndirectMayWriteSideEffectInstruction extends SideEffectInstruction {
  IndirectMayWriteSideEffectInstruction() {
    opcode instanceof Opcode::IndirectMayWriteSideEffect
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof IndirectMayMemoryAccess
  }
}

/**
 * An instruction representing the write of an indirect buffer parameter within a function call.    
 * Unlike `BufferWriteSideEffectInstruction`, the buffer might not be completely overwritten.
 */
class BufferMayWriteSideEffectInstruction extends SideEffectInstruction {
  BufferMayWriteSideEffectInstruction() {
    opcode instanceof Opcode::BufferMayWriteSideEffect
  }
  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof BufferMayMemoryAccess
  }
}

/**
 * An instruction that throws an exception.
 */
class ThrowInstruction extends Instruction {
  ThrowInstruction() {
    opcode instanceof ThrowOpcode
  }
}

/**
 * An instruction that throws a new exception.
 */
class ThrowValueInstruction extends ThrowInstruction {
  ThrowValueInstruction() {
    opcode instanceof Opcode::ThrowValue
  }

  /**
   * Gets the address of the exception thrown by this instruction.
   */
  final Instruction getExceptionAddress() {
    result = getAnOperand().(AddressOperand).getDefinitionInstruction()
  }

  /**
   * Gets the exception thrown by this instruction.
   */
  final Instruction getException() {
    result = getAnOperand().(ExceptionOperand).getDefinitionInstruction()
  }
}

/**
 * An instruction that re-throws the current exception.
 */
class ReThrowInstruction extends ThrowInstruction {
  ReThrowInstruction() {
    opcode instanceof Opcode::ReThrow
  }
}

/**
 * An instruction that exits the current function by propagating an exception.
 */
class UnwindInstruction extends Instruction {
  UnwindInstruction() {
    opcode instanceof Opcode::Unwind
  }
}

/**
 * An instruction that starts a `catch` handler.
 */
class CatchInstruction extends Instruction {
  CatchInstruction() {
    opcode instanceof CatchOpcode
  }
}

/**
 * An instruction that catches an exception of a specific type.
 */
class CatchByTypeInstruction extends CatchInstruction {
  Type exceptionType;

  CatchByTypeInstruction() {
    opcode instanceof Opcode::CatchByType and
    exceptionType = Construction::getInstructionExceptionType(this)
  }

  final override string getImmediateString() {
    result = exceptionType.toString()
  }

  /**
   * Gets the type of exception to be caught.
   */
  final Type getExceptionType() {
    result = exceptionType
  }
}

/**
 * An instruction that catches any exception.
 */
class CatchAnyInstruction extends CatchInstruction {
  CatchAnyInstruction() {
    opcode instanceof Opcode::CatchAny
  }
}

class UnmodeledDefinitionInstruction extends Instruction {
  UnmodeledDefinitionInstruction() {
    opcode instanceof Opcode::UnmodeledDefinition
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof UnmodeledMemoryAccess
  }
}

/**
 * An instruction that initializes all escaped memory.
 */
class AliasedDefinitionInstruction extends Instruction {
  AliasedDefinitionInstruction() {
    opcode instanceof Opcode::AliasedDefinition
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof EscapedMemoryAccess
  }
}

class UnmodeledUseInstruction extends Instruction {
  UnmodeledUseInstruction() {
    opcode instanceof Opcode::UnmodeledUse
  }

  override string getOperandsString() {
    result = "mu*"
  }
}

/**
 * An instruction representing the choice of one of multiple input values based on control flow.
 *
 * A `PhiInstruction` is inserted at the beginning of a block whenever two different definitions of
 * the same variable reach that block. The `PhiInstruction` will have one operand corresponding to
 * each control flow predecessor of the block, with that operand representing the version of the
 * variable that flows from that predecessor. The result value of the `PhiInstruction` will be
 * a copy of whichever operand corresponds to the actual predecessor that entered the block at
 * runtime.
 */
class PhiInstruction extends Instruction {
  PhiInstruction() {
    opcode instanceof Opcode::Phi
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof PhiMemoryAccess
  }
}

/**
 * An instruction representing the effect that a write to a memory may have on potential aliases of
 * that memory.
 *
 * A `ChiInstruction` is inserted immediately after an instruction that writes to memory. The
 * `ChiInstruction` has two operands. The first operand, given by `getTotalOperand()`, represents
 * the previous state of all of the memory that might be alised by the memory write. The second
 * operand, given by `getPartialOperand()`, represents the memory that was actually modified by the
 * memory write. The result of the `ChiInstruction` represents the same memory as
 * `getTotalOperand()`, updated to include the changes due to the value that was actually stored by
 * the memory write.
 *
 * As an example, suppose that variable `p` and `q` are pointers that may or may not point to the
 * same memory:
 * ```
 * *p = 5;
 * x = *q;
 * ```
 *
 * The IR would look like:
 * ```
 * r1_1 = VariableAddress[p]
 * r1_2 = Load r1_1, m0_0  // Load the value of `p`
 * r1_3 = Constant[5]
 * m1_4 = Store r1_2, r1_3  // Store to `*p`
 * m1_5 = ^Chi m0_1, m1_4  // Side effect of the previous Store on aliased memory
 * r1_6 = VariableAddress[x]
 * r1_7 = VariableAddress[q]
 * r1_8 = Load r1_7, m0_2  // Load the value of `q`
 * r1_9 = Load r1_8, m1_5  // Load the value of `*q`
 * m1_10 = Store r1_6, r1_9  // Store to x
 * ```
 *
 * Note the `Chi` instruction after the store to `*p`. The indicates that the previous contents of
 * aliased memory (`m0_1`) are merged with the new value written by the store (`m1_4`), producing a
 * new version of aliased memory (`m1_5`). On the subsequent load from `*q`, the source operand of
 * `*q` is `m1_5`, indicating that the store to `*p` may (or may not) have updated the memory
 * pointed to by `q`.
 *
 * For more information about how `Chi` instructions are used to model memory side effects, see
 * https://link.springer.com/content/pdf/10.1007%2F3-540-61053-7_66.pdf.
 */
class ChiInstruction extends Instruction {
  ChiInstruction() {
    opcode instanceof Opcode::Chi
  }

  override final MemoryAccessKind getResultMemoryAccess() {
    result instanceof ChiTotalMemoryAccess
  }

  /**
   * Gets the operand that represents the previous state of all memory that might be aliased by the
   * memory write.
   */
  final Instruction getTotalOperand() {
    result = getAnOperand().(ChiTotalOperand).getDefinitionInstruction()
  }

  /**
   * Gets the operand that represents the new value written by the memory write.
   */
  final Instruction getPartialOperand() {
    result = getAnOperand().(ChiPartialOperand).getDefinitionInstruction()
  }
}

/**
 * An instruction representing unreachable code. Inserted in place of the original target
 * instruction of a `ConditionalBranch` or `Switch` instruction where that particular edge is
 * infeasible.
 */
class UnreachedInstruction extends Instruction {
  UnreachedInstruction() {
    opcode instanceof Opcode::Unreached
  }
}

/**
 * An instruction representing a built-in operation. This is used to represent
 * operations such as access to variable argument lists.
 */
class BuiltInInstruction extends Instruction {
  BuiltInInstruction() {
    opcode instanceof BuiltInOpcode
  }
}
