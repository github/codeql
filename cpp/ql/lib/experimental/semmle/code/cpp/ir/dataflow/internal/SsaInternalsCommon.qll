import cpp as Cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.internal.IRCppLanguage
private import semmle.code.cpp.ir.implementation.raw.internal.SideEffects as SideEffects
private import DataFlowImplCommon as DataFlowImplCommon
private import DataFlowUtil

/**
 * Holds if `operand` is an operand that is not used by the dataflow library.
 * Ignored operands are not recognizd as uses by SSA, and they don't have a
 * corresponding `(Indirect)OperandNode`.
 */
predicate ignoreOperand(Operand operand) {
  operand = any(Instruction instr | ignoreInstruction(instr)).getAnOperand() or
  operand = any(Instruction instr | ignoreInstruction(instr)).getAUse() or
  operand instanceof MemoryOperand
}

/**
 * Holds if `instr` is an instruction that is not used by the dataflow library.
 * Ignored instructions are not recognized as reads/writes by SSA, and they
 * don't have a corresponding `(Indirect)InstructionNode`.
 */
predicate ignoreInstruction(Instruction instr) {
  DataFlowImplCommon::forceCachingInSameStage() and
  (
    instr instanceof WriteSideEffectInstruction or
    instr instanceof PhiInstruction or
    instr instanceof ReadSideEffectInstruction or
    instr instanceof ChiInstruction or
    instr instanceof InitializeIndirectionInstruction
  )
}

/**
 * Gets the C++ type of `this` in the member function `f`.
 * The result is a glvalue if `isGLValue` is true, and
 * a prvalue if `isGLValue` is false.
 */
bindingset[isGLValue]
private CppType getThisType(Cpp::MemberFunction f, boolean isGLValue) {
  result.hasType(f.getTypeOfThis(), isGLValue)
}

/**
 * Gets the C++ type of the instruction `i`.
 *
 * This is equivalent to `i.getResultLanguageType()` with the exception
 * of instructions that directly references a `this` IRVariable. In this
 * case, `i.getResultLanguageType()` gives an unknown type, whereas the
 * predicate gives the expected type (i.e., a potentially cv-qualified
 * type `A*` where `A` is the declaring type of the member function that
 * contains `i`).
 */
cached
CppType getResultLanguageType(Instruction i) {
  if i.(VariableAddressInstruction).getIRVariable() instanceof IRThisVariable
  then
    if i.isGLValue()
    then result = getThisType(i.getEnclosingFunction(), true)
    else result = getThisType(i.getEnclosingFunction(), false)
  else result = i.getResultLanguageType()
}

/**
 * Gets the C++ type of the operand `operand`.
 * This is equivalent to the type of the operand's defining instruction.
 *
 * See `getResultLanguageType` for a description of this behavior.
 */
CppType getLanguageType(Operand operand) { result = getResultLanguageType(operand.getDef()) }

/**
 * Gets the maximum number of indirections a glvalue of type `type` can have.
 * For example:
 * - If `type = int`, the result is 1
 * - If `type = MyStruct`, the result is 1
 * - If `type = char*`, the result is 2
 */
int getMaxIndirectionsForType(Type type) {
  result = countIndirectionsForCppType(getTypeForGLValue(type))
}

/**
 * Gets the maximum number of indirections a value of type `type` can have.
 *
 * Note that this predicate is intended to be called on unspecified types
 * (i.e., `countIndirections(e.getUnspecifiedType())`).
 */
private int countIndirections(Type t) {
  result =
    1 +
      countIndirections([t.(Cpp::PointerType).getBaseType(), t.(Cpp::ReferenceType).getBaseType()])
  or
  not t instanceof Cpp::PointerType and
  not t instanceof Cpp::ReferenceType and
  result = 0
}

/**
 * Gets the maximum number of indirections a value of C++
 * type `langType` can have.
 */
int countIndirectionsForCppType(LanguageType langType) {
  exists(Type type | langType.hasType(type, true) |
    result = 1 + countIndirections(type.getUnspecifiedType())
  )
  or
  exists(Type type | langType.hasType(type, false) |
    result = countIndirections(type.getUnspecifiedType())
  )
}

/**
 * A `CallInstruction` that calls an allocation function such
 * as `malloc` or `operator new`.
 */
class AllocationInstruction extends CallInstruction {
  AllocationInstruction() { this.getStaticCallTarget() instanceof Cpp::AllocationFunction }
}

/**
 * Holds if `i` is a base instruction that starts a sequence of uses
 * of some variable that SSA can handle.
 *
 * This is either when `i` is a `VariableAddressInstruction` or when
 * `i` is a fresh allocation produced by an `AllocationInstruction`.
 */
private predicate isSourceVariableBase(Instruction i) {
  i instanceof VariableAddressInstruction or i instanceof AllocationInstruction
}

/**
 * Holds if the value pointed to by `operand` can potentially be
 * modified be the caller.
 */
predicate isModifiableByCall(ArgumentOperand operand) {
  exists(CallInstruction call, int index, CppType type |
    type = getLanguageType(operand) and
    call.getArgumentOperand(index) = operand and
    if index = -1
    then not call.getStaticCallTarget() instanceof Cpp::ConstMemberFunction
    else not SideEffects::isConstPointerLike(any(Type t | type.hasType(t, _)))
  )
}

cached
private module Cached {
  /**
   * Holds if `op` is a use of an SSA variable rooted at `base` with `ind` number
   * of indirections.
   *
   * `certain` is `true` if the operand is guaranteed to read the variable, and
   * `indirectionIndex` specifies the number of loads required to read the variable.
   */
  cached
  predicate isUse(boolean certain, Operand op, Instruction base, int ind, int indirectionIndex) {
    not ignoreOperand(op) and
    certain = true and
    exists(LanguageType type, int m, int ind0 |
      type = getLanguageType(op) and
      m = countIndirectionsForCppType(type) and
      isUseImpl(op, base, ind0) and
      ind = ind0 + [0 .. m] and
      indirectionIndex = ind - ind0
    )
  }

  /**
   * Holds if `operand` is a use of an SSA variable rooted at `base`, and the
   * path from `base` to `operand` passes through `ind` load-like instructions.
   */
  private predicate isUseImpl(Operand operand, Instruction base, int ind) {
    DataFlowImplCommon::forceCachingInSameStage() and
    ind = 0 and
    operand.getDef() = base and
    isSourceVariableBase(base)
    or
    exists(Operand mid, Instruction instr |
      isUseImpl(mid, base, ind) and
      instr = operand.getDef() and
      conversionFlow(mid, instr, false)
    )
    or
    exists(int ind0 |
      isUseImpl(operand.getDef().(LoadInstruction).getSourceAddressOperand(), base, ind0)
      or
      isUseImpl(operand.getDef().(InitializeParameterInstruction).getAnOperand(), base, ind0)
    |
      ind0 = ind - 1
    )
  }

  /**
   * Holds if `address` is an address of an SSA variable rooted at `base`,
   * and `instr` is a definition of the SSA variable with `ind` number of indirections.
   *
   * `certain` is `true` if `instr` is guaranteed to write to the variable, and
   * `indirectionIndex` specifies the number of loads required to read the variable
   * after the write operation.
   */
  cached
  predicate isDef(
    boolean certain, Instruction instr, Operand address, Instruction base, int ind,
    int indirectionIndex
  ) {
    certain = true and
    exists(int ind0, CppType type, int m |
      address =
        [
          instr.(StoreInstruction).getDestinationAddressOperand(),
          instr.(InitializeParameterInstruction).getAnOperand(),
          instr.(InitializeDynamicAllocationInstruction).getAllocationAddressOperand(),
          instr.(UninitializedInstruction).getAnOperand()
        ]
    |
      isDefImpl(address, base, ind0) and
      type = getLanguageType(address) and
      m = countIndirectionsForCppType(type) and
      ind = ind0 + [1 .. m] and
      indirectionIndex = ind - (ind0 + 1)
    )
  }

  /**
   * Holds if `address` is a use of an SSA variable rooted at `base`, and the
   * path from `base` to `address` passes through `ind` load-like instructions.
   *
   * Note: Unlike `isUseImpl`, this predicate recurses through pointer-arithmetic
   * instructions.
   */
  private predicate isDefImpl(Operand address, Instruction base, int ind) {
    DataFlowImplCommon::forceCachingInSameStage() and
    ind = 0 and
    address.getDef() = base and
    isSourceVariableBase(base)
    or
    exists(Operand mid, Instruction instr |
      isDefImpl(mid, base, ind) and
      instr = address.getDef() and
      conversionFlow(mid, instr, _)
    )
    or
    exists(int ind0 |
      isDefImpl(address.getDef().(LoadInstruction).getSourceAddressOperand(), base, ind0)
      or
      isDefImpl(address.getDef().(InitializeParameterInstruction).getAnOperand(), base, ind0)
    |
      ind0 = ind - 1
    )
  }
}

import Cached

/**
 * Inputs to the shared SSA library's parameterized module that is shared
 * between the SSA pruning stage, and the final SSA stage.
 */
module InputSigCommon {
  class BasicBlock = IRBlock;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result.immediatelyDominates(bb) }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class ExitBasicBlock extends IRBlock {
    ExitBasicBlock() { this.getLastInstruction() instanceof ExitFunctionInstruction }
  }
}
