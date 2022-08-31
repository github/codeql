import cpp as Cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.internal.IRCppLanguage
private import semmle.code.cpp.ir.implementation.raw.internal.SideEffects as SideEffects
private import DataFlowImplCommon as DataFlowImplCommon
private import DataFlowUtil

predicate ignoreOperand(Operand operand) {
  operand = any(Instruction instr | ignoreInstruction(instr)).getAnOperand()
}

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

bindingset[isGLValue]
private CppType getThisType(Cpp::MemberFunction f, boolean isGLValue) {
  result.hasType(f.getTypeOfThis(), isGLValue)
}

cached
CppType getResultLanguageType(Instruction i) {
  if i.(VariableAddressInstruction).getIRVariable() instanceof IRThisVariable
  then
    if i.isGLValue()
    then result = getThisType(i.getEnclosingFunction(), true)
    else result = getThisType(i.getEnclosingFunction(), false)
  else result = i.getResultLanguageType()
}

CppType getLanguageType(Operand operand) { result = getResultLanguageType(operand.getDef()) }

int getMaxIndirectionsForType(Type type) {
  result = countIndirectionsForCppType(getTypeForGLValue(type))
}

private int countIndirections(Type t) {
  result =
    1 +
      countIndirections([t.(Cpp::PointerType).getBaseType(), t.(Cpp::ReferenceType).getBaseType()])
  or
  not t instanceof Cpp::PointerType and
  not t instanceof Cpp::ReferenceType and
  result = 0
}

int countIndirectionsForCppType(LanguageType langType) {
  exists(Type type | langType.hasType(type, true) |
    result = 1 + countIndirections(type.getUnspecifiedType())
  )
  or
  exists(Type type | langType.hasType(type, false) |
    result = countIndirections(type.getUnspecifiedType())
  )
}

class AllocationInstruction extends CallInstruction {
  AllocationInstruction() { this.getStaticCallTarget() instanceof Cpp::AllocationFunction }
}

private predicate isSourceVariableBase(Instruction i) {
  i instanceof VariableAddressInstruction or i instanceof AllocationInstruction
}

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
private module DefCached {
  cached
  predicate isDef(
    boolean certain, Instruction instr, Operand address, Instruction base, int ind,
    int indirectionIndex
  ) {
    exists(int ind0, CppType type, int m |
      certain = true and
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
      ind = [ind0 + 1 .. ind0 + m] and
      indirectionIndex = ind - (ind0 + 1)
    )
  }

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

import DefCached

cached
private module UseCached {
  cached
  predicate isUse(boolean certain, Operand op, Instruction base, int ind, int indirectionIndex) {
    not ignoreOperand(op) and
    certain = true and
    exists(LanguageType type, int m, int ind0 |
      type = getLanguageType(op) and
      m = countIndirectionsForCppType(type) and
      isUseImpl(op, base, ind0) and
      ind = [ind0 .. m + ind0] and
      indirectionIndex = ind - ind0
    )
  }

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
}

import UseCached
