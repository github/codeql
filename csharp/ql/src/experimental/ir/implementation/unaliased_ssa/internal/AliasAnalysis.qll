private import AliasAnalysisInternal
private import InputIR
private import AliasAnalysisImports

private class IntValue = Ints::IntValue;

/**
 * If `instr` is a `SideEffectInstruction`, gets the primary `CallInstruction` that caused the side
 * effect. If `instr` is a `CallInstruction`, gets that same `CallInstruction`.
 */
private CallInstruction getPrimaryCall(Instruction instr) {
  result = instr
  or
  result = instr.(SideEffectInstruction).getPrimaryInstruction()
}

/**
 * Holds if `operand` serves as an input argument (or indirection) to `call`, in the position
 * specified by `input`.
 */
private predicate isCallInput(
  CallInstruction call, Operand operand, AliasModels::FunctionInput input
) {
  call = getPrimaryCall(operand.getUse()) and
  (
    exists(int index |
      input.isParameterOrQualifierAddress(index) and
      operand = call.getArgumentOperand(index)
    )
    or
    exists(int index, ReadSideEffectInstruction read |
      input.isParameterDerefOrQualifierObject(index) and
      read = call.getAParameterSideEffect(index) and
      operand = read.getSideEffectOperand()
    )
  )
}

/**
 * Holds if `instr` serves as a return value or output argument indirection for `call`, in the
 * position specified by `output`.
 */
private predicate isCallOutput(
  CallInstruction call, Instruction instr, AliasModels::FunctionOutput output
) {
  call = getPrimaryCall(instr) and
  (
    output.isReturnValue() and instr = call
    or
    exists(int index, WriteSideEffectInstruction write |
      output.isParameterDerefOrQualifierObject(index) and
      write = call.getAParameterSideEffect(index) and
      instr = write
    )
  )
}

/**
 * Holds if the address in `operand` flows directly to the result of `resultInstr` due to modeled
 * address flow through a function call.
 */
private predicate hasAddressFlowThroughCall(Operand operand, Instruction resultInstr) {
  exists(
    CallInstruction call, AliasModels::FunctionInput input, AliasModels::FunctionOutput output
  |
    call.getStaticCallTarget().(AliasModels::AliasFunction).hasAddressFlow(input, output) and
    isCallInput(call, operand, input) and
    isCallOutput(call, resultInstr, output)
  )
}

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
      or
      instr instanceof CallInstruction and
      not exists(IREscapeAnalysisConfiguration config | config.useSoundEscapeAnalysis())
    )
  )
  or
  // Some standard function arguments never escape
  isNeverEscapesArgument(operand)
}

private predicate operandEscapesDomain(Operand operand) {
  not operandIsConsumedWithoutEscaping(operand) and
  not operandIsPropagated(operand, _, _) and
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
 * Holds if any address held in operand `operand` is propagated to the result of `instr`, offset by
 * the number of bits in `bitOffset`. If the address is propagated, but the offset is not known to
 * be a constant, then `bitOffset` is `unknown()`.
 */
private predicate operandIsPropagated(Operand operand, IntValue bitOffset, Instruction instr) {
  // Some functions are known to propagate an argument
  hasAddressFlowThroughCall(operand, instr) and
  bitOffset = 0
  or
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
  )
}

private predicate operandEscapesNonReturn(Operand operand) {
  exists(Instruction instr |
    // The address is propagated to the result of the instruction, and that result itself is returned
    operandIsPropagated(operand, _, instr) and resultEscapesNonReturn(instr)
  )
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
  exists(Instruction instr |
    // The address is propagated to the result of the instruction, and that result itself is returned
    operandIsPropagated(operand, _, instr) and
    resultMayReachReturn(instr)
  )
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
  exists(Instruction instr, IntValue bitOffset1, IntValue bitOffset2 |
    operandIsPropagated(operand, bitOffset1, instr) and
    resultReturned(instr, bitOffset2) and
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

pragma[nomagic]
private predicate initializeParameterInstructionHasVariable(
  IRVariable var, InitializeParameterInstruction init
) {
  init.getIRVariable() = var
}

private predicate instructionInitializesThisInFunction(
  Language::Function f, InitializeParameterInstruction init
) {
  initializeParameterInstructionHasVariable(any(IRThisVariable var), pragma[only_bind_into](init)) and
  init.getEnclosingFunction() = f
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
      instructionInitializesThisInFunction(f, init) and
      operand instanceof ThisArgumentOperand
    ) and
    not Language::isFunctionVirtual(f) and
    not f instanceof AliasModels::AliasFunction
  )
}

private predicate isOnlyEscapesViaReturnArgument(Operand operand) {
  exists(AliasModels::AliasFunction f |
    f = operand.getUse().(CallInstruction).getStaticCallTarget() and
    (
      f.parameterEscapesOnlyViaReturn(operand.(PositionalArgumentOperand).getIndex())
      or
      f.parameterEscapesOnlyViaReturn(-1) and
      operand instanceof ThisArgumentOperand
    )
  )
}

private predicate isNeverEscapesArgument(Operand operand) {
  exists(AliasModels::AliasFunction f |
    f = operand.getUse().(CallInstruction).getStaticCallTarget() and
    (
      f.parameterNeverEscapes(operand.(PositionalArgumentOperand).getIndex())
      or
      f.parameterNeverEscapes(-1) and
      operand instanceof ThisArgumentOperand
    )
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
  or
  Configuration::phaseNeedsSoundEscapeAnalysis() and
  resultEscapesNonReturn(allocation.getABaseInstruction())
}

/**
 * Equivalent to `operandIsPropagated()`, but includes interprocedural propagation.
 */
private predicate operandIsPropagatedIncludingByCall(
  Operand operand, IntValue bitOffset, Instruction instr
) {
  operandIsPropagated(operand, bitOffset, instr)
  or
  exists(CallInstruction call, Instruction init |
    isArgumentForParameter(call, operand, init) and
    resultReturned(init, bitOffset) and
    instr = call
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
    operandIsPropagatedIncludingByCall(middleOperand, additionalBitOffset, middle) and
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
      hasBaseAndOffset(addrOperand, pragma[only_bind_out](previousBase), _) and
      previousBase = base.getAnOperand().getDef()
    )
  )
}

/**
 * Predicates used only for printing annotated IR dumps. These should not be used in production
 * queries.
 */
module Print {
  string getOperandProperty(Operand operand, string key) {
    key = "alloc" and
    result =
      strictconcat(Configuration::Allocation allocation, IntValue bitOffset |
        addressOperandAllocationAndOffset(operand, allocation, bitOffset)
      |
        allocation.toString() + Ints::getBitOffsetString(bitOffset), ", "
      )
    or
    key = "prop" and
    result =
      strictconcat(Instruction destInstr, IntValue bitOffset, string value |
        operandIsPropagatedIncludingByCall(operand, bitOffset, destInstr) and
        if destInstr = operand.getUse()
        then value = "@" + Ints::getBitOffsetString(bitOffset) + "->result"
        else value = "@" + Ints::getBitOffsetString(bitOffset) + "->" + destInstr.getResultId()
      |
        value, ", "
      )
  }

  string getInstructionProperty(Instruction instr, string key) {
    key = "prop" and
    result =
      strictconcat(IntValue bitOffset, Operand sourceOperand, string value |
        operandIsPropagatedIncludingByCall(sourceOperand, bitOffset, instr) and
        if instr = sourceOperand.getUse()
        then value = sourceOperand.getDumpId() + Ints::getBitOffsetString(bitOffset) + "->@"
        else
          value =
            sourceOperand.getUse().getResultId() + "." + sourceOperand.getDumpId() +
              Ints::getBitOffsetString(bitOffset) + "->@"
      |
        value, ", "
      )
  }
}
