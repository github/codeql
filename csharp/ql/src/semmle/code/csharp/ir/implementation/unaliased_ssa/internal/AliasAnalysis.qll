private import AliasAnalysisInternal
private import csharp
private import InputIR
private import semmle.code.csharp.ir.internal.IntegerConstant as Ints

private class IntValue = Ints::IntValue;

/**
 * Converts the bit count in `bits` to a byte count and a bit count in the form
 * bytes:bits.
 */
bindingset[bits]
string bitsToBytesAndBits(int bits) { result = (bits / 8).toString() + ":" + (bits % 8).toString() }

/**
 * Gets a printable string for a bit offset with possibly unknown value.
 */
bindingset[bitOffset]
string getBitOffsetString(IntValue bitOffset) {
  if Ints::hasValue(bitOffset)
  then
    if bitOffset >= 0
    then result = "+" + bitsToBytesAndBits(bitOffset)
    else result = "-" + bitsToBytesAndBits(Ints::neg(bitOffset))
  else result = "+?"
}

///**
// * Gets the offset of field `field` in bits.
// */
//private IntValue getFieldBitOffset(Field field) {
//  if field instanceof BitField
//  then result = Ints::add(Ints::mul(field.getByteOffset(), 8), field.(BitField).getBitOffset())
//  else result = Ints::mul(field.getByteOffset(), 8)
//}
/**
 * Holds if the operand `operand` of instruction `instr` is used in a way that does
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
    )
  )
  //  or
  //  // Some standard function arguments never escape
  //  isNeverEscapesArgument(operand)
}

private predicate operandEscapesDomain(Operand operand) {
  not operandIsConsumedWithoutEscaping(operand) and
  not operandIsPropagated(operand, _) and
  not isArgumentForParameter(_, operand, _) and
  //  not isOnlyEscapesViaReturnArgument(operand) and
  not operand.getUse() instanceof ReturnValueInstruction and
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
 * Holds if any address held in operand `operand` of instruction `instr` is
 * propagated to the result of `instr`, offset by the number of bits in
 * `bitOffset`. If the address is propagated, but the offset is not known to be
 * a constant, then `bitOffset` is unknown.
 */
private predicate operandIsPropagated(Operand operand, IntValue bitOffset) {
  exists(Instruction instr |
    instr = operand.getUse() and
    (
      // REVIEW: See the REVIEW comment bellow
      //      // Converting to a non-virtual base class adds the offset of the base class.
      //      exists(ConvertToBaseInstruction convert |
      //        convert = instr and
      //        bitOffset = Ints::mul(convert.getDerivation().getByteOffset(), 8)
      //      )
      //      or
      //      // Converting to a derived class subtracts the offset of the base class.
      //      exists(ConvertToDerivedInstruction convert |
      //        convert = instr and
      //        bitOffset = Ints::neg(Ints::mul(convert.getDerivation().getByteOffset(), 8))
      //      )
      //      or
      //      // Converting to a virtual base class adds an unknown offset.
      //      instr instanceof ConvertToVirtualBaseInstruction and
      //      bitOffset = Ints::unknown()
      //      or
      // REVIEW: In the C# IR, we should ignore the above types of conversion all together,
      //         since first of all they do not provide correct information (nothing is known
      //         for sure about heap allocated objects) and second of all even if we create a
      //         virtual memory model for the IR I don't think such conversions provide any meaningful
      //         information;
      // Conversion to another pointer type propagates the source address.
      // REVIEW: Is this needed?
      exists(ConvertInstruction convert, Type resultType |
        convert = instr and
        resultType = convert.getResultType() and
        (
          resultType instanceof PointerType or
          resultType instanceof RefType
        ) and
        bitOffset = 0
      )
      or
      // Adding an integer to or subtracting an integer from a pointer propagates
      // the address with an offset.
      bitOffset = getPointerBitOffset(instr.(PointerOffsetInstruction))
      or
      //      or
      //      // Computing a field address from a pointer propagates the address plus the
      //      // offset of the field.
      //      bitOffset = getFieldBitOffset(instr.(FieldAddressInstruction).getField())
      // A copy propagates the source value.
      operand = instr.(CopyInstruction).getSourceValueOperand() and bitOffset = 0
      //      or
      //      // Some functions are known to propagate an argument
      //      isAlwaysReturnedArgument(operand) and bitOffset = 0
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
  //  or
  //  isOnlyEscapesViaReturnArgument(operand) and resultEscapesNonReturn(operand.getUse())
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
  //  or
  //  isOnlyEscapesViaReturnArgument(operand) and resultMayReachReturn(operand.getUse())
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
  //  isOnlyEscapesViaReturnArgument(operand) and
  resultReturned(operand.getUse(), _) and
  bitOffset = Ints::unknown()
}

private predicate isArgumentForParameter(CallInstruction ci, Operand operand, Instruction init) {
  exists(Callable c |
    ci = operand.getUse() and
    c = ci.getStaticCallTarget() and
    (
      init.(InitializeParameterInstruction).getParameter() = c
            .getParameter(operand.(PositionalArgumentOperand).getIndex())
      or
      init instanceof InitializeThisInstruction and
      init.getEnclosingFunction() = c and
      operand instanceof ThisArgumentOperand
    ) // and
    //    not f.isVirtual() and
    //    not f instanceof AliasFunction
  )
}

// REVIEW: Those three predicates are used to model the behaviour of C++ library functions
//         for which the code was not accessible, so we should ignore them
//private predicate isAlwaysReturnedArgument(Operand operand) {
//  exists(AliasFunction f |
//    f = operand.getUse().(CallInstruction).getStaticCallTarget() and
//    f.parameterIsAlwaysReturned(operand.(PositionalArgumentOperand).getIndex())
//  )
//}
//
//private predicate isOnlyEscapesViaReturnArgument(Operand operand) {
//  exists(AliasFunction f |
//    f = operand.getUse().(CallInstruction).getStaticCallTarget() and
//    f.parameterEscapesOnlyViaReturn(operand.(PositionalArgumentOperand).getIndex())
//  )
//}
//
//private predicate isNeverEscapesArgument(Operand operand) {
//  exists(AliasFunction f |
//    f = operand.getUse().(CallInstruction).getStaticCallTarget() and
//    f.parameterNeverEscapes(operand.(PositionalArgumentOperand).getIndex())
//  )
//}
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
}

/**
 * Holds if the address of the specified local variable or parameter escapes the
 * domain of the analysis.
 */
private predicate automaticVariableAddressEscapes(IRAutomaticVariable var) {
  // The variable's address escapes if the result of any
  // VariableAddressInstruction that computes the variable's address escapes.
  exists(VariableAddressInstruction instr |
    instr.getVariable() = var and
    resultEscapesNonReturn(instr)
  )
}

/**
 * Holds if the address of the specified variable escapes the domain of the
 * analysis.
 */
predicate variableAddressEscapes(IRVariable var) {
  automaticVariableAddressEscapes(var.(IRAutomaticVariable))
  or
  // All variables with static storage duration have their address escape.
  not var instanceof IRAutomaticVariable
}

/**
 * Holds if the result of instruction `instr` points within variable `var`, at
 * bit offset `bitOffset` within the variable. If the result points within
 * `var`, but at an unknown or non-constant offset, then `bitOffset` is unknown.
 */
predicate resultPointsTo(Instruction instr, IRVariable var, IntValue bitOffset) {
  // The address of a variable points to that variable, at offset 0.
  instr.(VariableAddressInstruction).getVariable() = var and
  bitOffset = 0
  or
  exists(Operand operand, IntValue originalBitOffset, IntValue propagatedBitOffset |
    operand = instr.getAnOperand() and
    // If an operand is propagated, then the result points to the same variable,
    // offset by the bit offset from the propagation.
    resultPointsTo(operand.getAnyDef(), var, originalBitOffset) and
    (
      operandIsPropagated(operand, propagatedBitOffset)
      or
      exists(CallInstruction ci, Instruction init |
        isArgumentForParameter(ci, operand, init) and
        resultReturned(init, propagatedBitOffset)
      )
    ) and
    bitOffset = Ints::add(originalBitOffset, propagatedBitOffset)
  )
}
