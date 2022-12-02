import cpp as Cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.internal.IRCppLanguage
private import semmle.code.cpp.ir.implementation.raw.internal.SideEffects as SideEffects
private import DataFlowImplCommon as DataFlowImplCommon
private import DataFlowUtil
private import DataFlowPrivate

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
    instr instanceof InitializeIndirectionInstruction or
    instr instanceof AliasedDefinitionInstruction or
    instr instanceof InitializeNonLocalInstruction
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

private class PointerOrReferenceType extends Cpp::DerivedType {
  PointerOrReferenceType() {
    this instanceof Cpp::PointerType
    or
    this instanceof Cpp::ReferenceType
  }
}

/**
 * Gets the maximum number of indirections a value of type `type` can have.
 *
 * Note that this predicate is intended to be called on unspecified types
 * (i.e., `countIndirections(e.getUnspecifiedType())`).
 */
private int countIndirections(Type t) {
  result = 1 + countIndirections(t.(PointerOrReferenceType).getBaseType())
  or
  not t instanceof PointerOrReferenceType and
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

predicate isWrite(Node0Impl value, Operand address, boolean certain) {
  certain = true and
  (
    exists(StoreInstruction store |
      value.asInstruction() = store and
      address = store.getDestinationAddressOperand()
    )
    or
    exists(InitializeParameterInstruction init |
      value.asInstruction() = init and
      address = init.getAnOperand()
    )
    or
    exists(InitializeDynamicAllocationInstruction init |
      value.asInstruction() = init and
      address = init.getAllocationAddressOperand()
    )
    or
    exists(UninitializedInstruction uninitialized |
      value.asInstruction() = uninitialized and
      address = uninitialized.getAnOperand()
    )
  )
}

predicate isAdditionalConversionFlow(Operand opFrom, Instruction instrTo) {
  any(Indirection ind).isAdditionalConversionFlow(opFrom, instrTo)
}

predicate ignoreSourceVariableBase(BaseSourceVariableInstruction base, Node0Impl value) {
  any(Indirection ind).ignoreSourceVariableBase(base, value)
}

newtype TBaseSourceVariable =
  // Each IR variable gets its own source variable
  TBaseIRVariable(IRVariable var) or
  // Each allocation gets its own source variable
  TBaseCallVariable(AllocationInstruction call)

abstract class BaseSourceVariable extends TBaseSourceVariable {
  abstract string toString();

  abstract DataFlowType getType();
}

class BaseIRVariable extends BaseSourceVariable, TBaseIRVariable {
  IRVariable var;

  IRVariable getIRVariable() { result = var }

  BaseIRVariable() { this = TBaseIRVariable(var) }

  override string toString() { result = var.toString() }

  override DataFlowType getType() { result = var.getType() }
}

class BaseCallVariable extends BaseSourceVariable, TBaseCallVariable {
  AllocationInstruction call;

  BaseCallVariable() { this = TBaseCallVariable(call) }

  AllocationInstruction getCallInstruction() { result = call }

  override string toString() { result = call.toString() }

  override DataFlowType getType() { result = call.getResultType() }
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
    then
      // A qualifier is "modifiable" if:
      // 1. the member function is not const specified, or
      // 2. the member function is `const` specified, but returns a pointer or reference
      // type that is non-const.
      //
      // To see why this is necessary, consider the following function:
      // ```
      // struct C {
      //   void* data_;
      //   void* data() const { return data; }
      // };
      // ...
      // C c;
      // memcpy(c.data(), source, 16)
      // ```
      // the data pointed to by `c.data_` is potentially modified by the call to `memcpy` even though
      // `C::data` has a const specifier. So we further place the restriction that the type returned
      // by `call` should not be of the form `const T*` (for some deeply const type `T`).
      if call.getStaticCallTarget() instanceof Cpp::ConstMemberFunction
      then
        exists(PointerOrReferenceType resultType |
          resultType = call.getResultType() and
          not resultType.isDeeplyConstBelow()
        )
      else any()
    else
      // An argument is modifiable if it's a non-const pointer or reference type.
      exists(Type t, boolean isGLValue | type.hasType(t, isGLValue) |
        // If t is a glvalue it means that t is always a pointer-like type.
        isGLValue = true
        or
        t instanceof PointerOrReferenceType and
        not SideEffects::isConstPointerLike(t)
      )
  )
}

abstract class BaseSourceVariableInstruction extends Instruction {
  abstract BaseSourceVariable getBaseSourceVariable();
}

private class BaseIRVariableInstruction extends BaseSourceVariableInstruction,
  VariableAddressInstruction {
  override BaseIRVariable getBaseSourceVariable() { result.getIRVariable() = this.getIRVariable() }
}

private class BaseAllocationInstruction extends BaseSourceVariableInstruction, AllocationInstruction {
  override BaseCallVariable getBaseSourceVariable() { result.getCallInstruction() = this }
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
  predicate isUse(
    boolean certain, Operand op, BaseSourceVariableInstruction base, int ind, int indirectionIndex
  ) {
    not ignoreOperand(op) and
    certain = true and
    exists(LanguageType type, int upper, int ind0 |
      type = getLanguageType(op) and
      upper = countIndirectionsForCppType(type) and
      isUseImpl(op, base, ind0) and
      ind = ind0 + [0 .. upper] and
      indirectionIndex = ind - ind0
    )
  }

  /**
   * Holds if the underlying IR has a suitable operand to represent a value
   * that would otherwise need to be represented by a dedicated `RawIndirectOperand` value.
   *
   * Such operands do not create new `RawIndirectOperand` values, but are
   * instead associated with the operand returned by this predicate.
   */
  cached
  Operand getIRRepresentationOfIndirectOperand(Operand operand, int indirectionIndex) {
    exists(LoadInstruction load |
      operand = load.getSourceAddressOperand() and
      result = unique( | | load.getAUse()) and
      isUseImpl(operand, _, indirectionIndex - 1)
    )
  }

  /**
   * Holds if the underlying IR has a suitable instruction to represent a value
   * that would otherwise need to be represented by a dedicated `RawIndirectInstruction` value.
   *
   * Such instruction do not create new `RawIndirectOperand` values, but are
   * instead associated with the instruction returned by this predicate.
   */
  cached
  Instruction getIRRepresentationOfIndirectInstruction(Instruction instr, int indirectionIndex) {
    exists(LoadInstruction load |
      load.getSourceAddress() = instr and
      isUseImpl(load.getSourceAddressOperand(), _, indirectionIndex - 1) and
      result = instr
    )
  }

  /**
   * Holds if `operand` is a use of an SSA variable rooted at `base`, and the
   * path from `base` to `operand` passes through `ind` load-like instructions.
   */
  private predicate isUseImpl(Operand operand, BaseSourceVariableInstruction base, int ind) {
    DataFlowImplCommon::forceCachingInSameStage() and
    ind = 0 and
    operand = base.getAUse()
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
    boolean certain, Node0Impl value, Operand address, BaseSourceVariableInstruction base, int ind,
    int indirectionIndex
  ) {
    exists(int ind0, CppType type, int lower, int upper |
      isWrite(value, address, certain) and
      isDefImpl(address, base, ind0) and
      type = getLanguageType(address) and
      upper = countIndirectionsForCppType(type) and
      ind = ind0 + [lower .. upper] and
      indirectionIndex = ind - (ind0 + lower) and
      (if type.hasType(any(Cpp::ArrayType arrayType), true) then lower = 0 else lower = 1)
    )
  }

  /**
   * Holds if `address` is a use of an SSA variable rooted at `base`, and the
   * path from `base` to `address` passes through `ind` load-like instructions.
   *
   * Note: Unlike `isUseImpl`, this predicate recurses through pointer-arithmetic
   * instructions.
   */
  private predicate isDefImpl(Operand address, BaseSourceVariableInstruction base, int ind) {
    DataFlowImplCommon::forceCachingInSameStage() and
    ind = 0 and
    address = base.getAUse()
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
