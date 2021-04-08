private import AliasAnalysisInternal
private import InputIR
private import AliasAnalysisImports

private class IntValue = Ints::IntValue;

/**
 * Holds if the operand `tag` of instruction `instr` is used in a way that does
 * not result in any address held in that operand from escaping beyond the
 * instruction.
 */
private predicate operandIsConsumedWithoutEscaping(Operand operand) {
  // The source/destination address of a Load/Store does not escape (but the
  // loaded/stored value could).
  operand instanceof AddressOperand
  or
  exists(Instruction instr |
    instr = operand.getUse() and
    (
      // Neither operand of a Compare escapes.
      instr instanceof CompareInstruction
      or
      // Neither operand of a PointerDiff escapes.
      instr instanceof PointerDiffInstruction
      or
      // Converting an address to a `bool` does not escape the address.
      instr.(ConvertInstruction).getResultIRType() instanceof IRBooleanType
    )
  )
  or
  // Some standard function arguments never escape
  isNeverEscapesArgument(operand)
}

private predicate operandEscapesDomain(Operand operand) {
  not operandIsConsumedWithoutEscaping(operand) and
  not operandIsPropagated(operand, _) and
  not isArgumentForParameter(_, operand, _) and
  not isOnlyEscapesViaReturnArgument(operand) and
  not operand.getUse() instanceof ReturnValueInstruction and
  not operand.getUse() instanceof ReturnIndirectionInstruction and
  not operand instanceof PhiInputOperand
}

/**
 * If the result of instruction `instr` is an integer constant, returns the
 * value of that constant. Otherwise, returns unknown.
 */
IntValue getConstantValue(Instruction instr) {
  if instr instanceof IntegerConstantInstruction
  then result = instr.(IntegerConstantInstruction).getValue().toInt()
  else result = Ints::unknown()
}

/**
 * Computes the offset, in bits, by which the result of `instr` differs from the
 * pointer argument to `instr`, if that offset is a constant. Otherwise, returns
 * unknown.
 */
IntValue getPointerBitOffset(PointerOffsetInstruction instr) {
  exists(IntValue bitOffset |
    bitOffset = Ints::mul(Ints::mul(getConstantValue(instr.getRight()), instr.getElementSize()), 8) and
    (
      instr instanceof PointerAddInstruction and result = bitOffset
      or
      instr instanceof PointerSubInstruction and result = Ints::neg(bitOffset)
    )
  )
}

/**
 * Holds if any address held in operand `tag` of instruction `instr` is
 * propagated to the result of `instr`, offset by the number of bits in
 * `bitOffset`. If the address is propagated, but the offset is not known to be
 * a constant, then `bitOffset` is unknown.
 */
private predicate operandIsPropagated(Operand operand, IntValue bitOffset) {
  exists(Instruction instr |
    instr = operand.getUse() and
    (
      // Converting to a non-virtual base class adds the offset of the base class.
      exists(ConvertToNonVirtualBaseInstruction convert |
        convert = instr and
        bitOffset = Ints::mul(convert.getDerivation().getByteOffset(), 8)
      )
      or
      // Conversion using dynamic_cast results in an unknown offset
      instr instanceof CheckedConvertOrNullInstruction and
      bitOffset = Ints::unknown()
      or
      // Converting to a derived class subtracts the offset of the base class.
      exists(ConvertToDerivedInstruction convert |
        convert = instr and
        bitOffset = Ints::neg(Ints::mul(convert.getDerivation().getByteOffset(), 8))
      )
      or
      // Converting to a virtual base class adds an unknown offset.
      instr instanceof ConvertToVirtualBaseInstruction and
      bitOffset = Ints::unknown()
      or
      // Conversion to another pointer type propagates the source address.
      exists(ConvertInstruction convert, IRType resultType |
        convert = instr and
        resultType = convert.getResultIRType() and
        resultType instanceof IRAddressType and
        bitOffset = 0
      )
      or
      // Adding an integer to or subtracting an integer from a pointer propagates
      // the address with an offset.
      exists(PointerOffsetInstruction ptrOffset |
        ptrOffset = instr and
        operand = ptrOffset.getLeftOperand() and
        bitOffset = getPointerBitOffset(ptrOffset)
      )
      or
      // Computing a field address from a pointer propagates the address plus the
      // offset of the field.
      bitOffset = Language::getFieldBitOffset(instr.(FieldAddressInstruction).getField())
      or
      // A copy propagates the source value.
      operand = instr.(CopyInstruction).getSourceValueOperand() and bitOffset = 0
      or
      // Some functions are known to propagate an argument
      isAlwaysReturnedArgument(operand) and bitOffset = 0
    )
  )
}

private predicate operandEscapesNonReturn(Operand operand) {
  // The address is propagated to the result of the instruction, and that result itself is returned
  operandIsPropagated(operand, _) and resultEscapesNonReturn(operand.getUse())
  or
  // The operand is used in a function call which returns it, and the return value is then returned
  exists(CallInstruction ci, Instruction init |
    isArgumentForParameter(ci, operand, init) and
    (
      resultMayReachReturn(init) and
      resultEscapesNonReturn(ci)
      or
      resultEscapesNonReturn(init)
    )
  )
  or
  isOnlyEscapesViaReturnArgument(operand) and resultEscapesNonReturn(operand.getUse())
  or
  operand instanceof PhiInputOperand and
  resultEscapesNonReturn(operand.getUse())
  or
  operandEscapesDomain(operand)
}

private predicate operandMayReachReturn(Operand operand) {
  // The address is propagated to the result of the instruction, and that result itself is returned
  operandIsPropagated(operand, _) and
  resultMayReachReturn(operand.getUse())
  or
  // The operand is used in a function call which returns it, and the return value is then returned
  exists(CallInstruction ci, Instruction init |
    isArgumentForParameter(ci, operand, init) and
    resultMayReachReturn(init) and
    resultMayReachReturn(ci)
  )
  or
  // The address is returned
  operand.getUse() instanceof ReturnValueInstruction
  or
  isOnlyEscapesViaReturnArgument(operand) and resultMayReachReturn(operand.getUse())
  or
  operand instanceof PhiInputOperand and
  resultMayReachReturn(operand.getUse())
}

private predicate operandReturned(Operand operand, IntValue bitOffset) {
  // The address is propagated to the result of the instruction, and that result itself is returned
  exists(IntValue bitOffset1, IntValue bitOffset2 |
    operandIsPropagated(operand, bitOffset1) and
    resultReturned(operand.getUse(), bitOffset2) and
    bitOffset = Ints::add(bitOffset1, bitOffset2)
  )
  or
  // The operand is used in a function call which returns it, and the return value is then returned
  exists(CallInstruction ci, Instruction init, IntValue bitOffset1, IntValue bitOffset2 |
    isArgumentForParameter(ci, operand, init) and
    resultReturned(init, bitOffset1) and
    resultReturned(ci, bitOffset2) and
    bitOffset = Ints::add(bitOffset1, bitOffset2)
  )
  or
  // The address is returned
  operand.getUse() instanceof ReturnValueInstruction and
  bitOffset = 0
  or
  isOnlyEscapesViaReturnArgument(operand) and
  resultReturned(operand.getUse(), _) and
  bitOffset = Ints::unknown()
}

private predicate isArgumentForParameter(
  CallInstruction ci, Operand operand, InitializeParameterInstruction init
) {
  exists(Language::Function f |
    ci = operand.getUse() and
    f = ci.getStaticCallTarget() and
    (
      init.getParameter() = f.getParameter(operand.(PositionalArgumentOperand).getIndex())
      or
      init.getIRVariable() instanceof IRThisVariable and
      unique( | | init.getEnclosingFunction()) = f and
      operand instanceof ThisArgumentOperand
    ) and
    not Language::isFunctionVirtual(f) and
    not f instanceof AliasModels::AliasFunction
  )
}

private predicate isAlwaysReturnedArgument(Operand operand) {
  exists(AliasModels::AliasFunction f |
    f = operand.getUse().(CallInstruction).getStaticCallTarget() and
    f.parameterIsAlwaysReturned(operand.(PositionalArgumentOperand).getIndex())
  )
}

private predicate isOnlyEscapesViaReturnArgument(Operand operand) {
  exists(AliasModels::AliasFunction f |
    f = operand.getUse().(CallInstruction).getStaticCallTarget() and
    f.parameterEscapesOnlyViaReturn(operand.(PositionalArgumentOperand).getIndex())
  )
}

private predicate isNeverEscapesArgument(Operand operand) {
  exists(AliasModels::AliasFunction f |
    f = operand.getUse().(CallInstruction).getStaticCallTarget() and
    f.parameterNeverEscapes(operand.(PositionalArgumentOperand).getIndex())
  )
}

private predicate resultReturned(Instruction instr, IntValue bitOffset) {
  operandReturned(instr.getAUse(), bitOffset)
}

private predicate resultMayReachReturn(Instruction instr) { operandMayReachReturn(instr.getAUse()) }

/**
 * Holds if any address held in the result of instruction `instr` escapes
 * outside the domain of the analysis.
 */
private predicate resultEscapesNonReturn(Instruction instr) {
  // The result escapes if it has at least one use that escapes.
  operandEscapesNonReturn(instr.getAUse())
  or
  // The result also escapes if it is not modeled in SSA, because we do not know where it might be
  // used.
  not instr.isResultModeled()
}

/**
 * Holds if the address of `allocation` escapes outside the domain of the analysis. This can occur
 * either because the allocation's address is taken within the function and escapes, or because the
 * allocation is marked as always escaping via `alwaysEscapes()`.
 */
predicate allocationEscapes(Configuration::Allocation allocation) {
  allocation.alwaysEscapes()
  or
  exists(IREscapeAnalysisConfiguration config |
    config.useSoundEscapeAnalysis() and resultEscapesNonReturn(allocation.getABaseInstruction())
  )
}

/**
 * Equivalent to `operandIsPropagated()`, but includes interprocedural propagation.
 */
private predicate operandIsPropagatedIncludingByCall(Operand operand, IntValue bitOffset) {
  operandIsPropagated(operand, bitOffset)
  or
  exists(CallInstruction call, Instruction init |
    isArgumentForParameter(call, operand, init) and
    resultReturned(init, bitOffset)
  )
}

/**
 * Holds if `addrOperand` is at offset `bitOffset` from the value of instruction `base`. The offset
 * may be `unknown()`.
 */
private predicate hasBaseAndOffset(AddressOperand addrOperand, Instruction base, IntValue bitOffset) {
  base = addrOperand.getDef() and bitOffset = 0 // Base case
  or
  exists(
    Instruction middle, int previousBitOffset, Operand middleOperand, IntValue additionalBitOffset
  |
    // We already have an offset from `middle`.
    hasBaseAndOffset(addrOperand, middle, previousBitOffset) and
    // `middle` is propagated from `base`.
    middleOperand = middle.getAnOperand() and
    operandIsPropagatedIncludingByCall(middleOperand, additionalBitOffset) and
    base = middleOperand.getDef() and
    bitOffset = Ints::add(previousBitOffset, additionalBitOffset)
  )
}

/**
 * Holds if `addrOperand` is at constant offset `bitOffset` from the value of instruction `base`.
 * Only holds for the `base` with the longest chain of propagation to `addrOperand`.
 */
predicate addressOperandBaseAndConstantOffset(
  AddressOperand addrOperand, Instruction base, int bitOffset
) {
  hasBaseAndOffset(addrOperand, base, bitOffset) and
  Ints::hasValue(bitOffset) and
  not exists(Instruction previousBase, int previousBitOffset |
    hasBaseAndOffset(addrOperand, previousBase, previousBitOffset) and
    previousBase = base.getAnOperand().getDef() and
    Ints::hasValue(previousBitOffset)
  )
}

/**
 * Gets the allocation into which `addrOperand` points, if known.
 */
Configuration::Allocation getAddressOperandAllocation(AddressOperand addrOperand) {
  addressOperandAllocationAndOffset(addrOperand, result, _)
}

/**
 * Holds if `addrOperand` is at offset `bitOffset` from a base instruction of `allocation`. The
 * offset may be `unknown()`.
 */
predicate addressOperandAllocationAndOffset(
  AddressOperand addrOperand, Configuration::Allocation allocation, IntValue bitOffset
) {
  exists(Instruction base |
    allocation.getABaseInstruction() = base and
    hasBaseAndOffset(addrOperand, base, bitOffset) and
    not exists(Instruction previousBase |
      hasBaseAndOffset(addrOperand, previousBase, _) and
      previousBase = base.getAnOperand().getDef()
    )
  )
}
