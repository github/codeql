private import AliasAnalysisInternal
import cpp
private import InputIR
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints

private class IntValue = Ints::IntValue;

/**
 * Converts the bit count in `bits` to a byte count and a bit count in the form
 * bytes:bits.
 */
bindingset[bits]
string bitsToBytesAndBits(int bits) {
  result = (bits / 8).toString() + ":" + (bits % 8).toString()
}

/**
 * Gets a printable string for a bit offset with possibly unknown value.
 */
bindingset[bitOffset]
string getBitOffsetString(IntValue bitOffset) {
  if Ints::hasValue(bitOffset) then
    if bitOffset >= 0 then
      result = "+" + bitsToBytesAndBits(bitOffset)
    else
      result = "-" + bitsToBytesAndBits(Ints::neg(bitOffset))
  else
    result = "+?"
}

/**
 * Gets the offset of field `field` in bits.
 */
private IntValue getFieldBitOffset(Field field) {
  if (field instanceof BitField) then (
    result = Ints::add(Ints::mul(field.getByteOffset(), 8),
      field.(BitField).getBitOffset())
  )
  else (
    result = Ints::mul(field.getByteOffset(), 8)
  )
}

/**
 * Holds if the operand `tag` of instruction `instr` is used in a way that does
 * not result in any address held in that operand from escaping beyond the
 * instruction.
 */
predicate operandIsConsumedWithoutEscaping(Operand operand) {
  // The source/destination address of a Load/Store does not escape (but the
  // loaded/stored value could).
  operand instanceof AddressOperand or
  exists (Instruction instr |
    instr = operand.getUseInstruction() and
    (
      // Neither operand of a Compare escapes.
      instr instanceof CompareInstruction or
      // Neither operand of a PointerDiff escapes.
      instr instanceof PointerDiffInstruction or
      // Converting an address to a `bool` does not escape the address.
      instr.(ConvertInstruction).getResultType() instanceof BoolType
    )
  )
}
/**
 * If the result of instruction `instr` is an integer constant, returns the
 * value of that constant. Otherwise, returns unknown.
 */
IntValue getConstantValue(Instruction instr) {
  if instr instanceof IntegerConstantInstruction then
    result = instr.(IntegerConstantInstruction).getValue().toInt()
  else
    result = Ints::unknown()
}

/**
 * Computes the offset, in bits, by which the result of `instr` differs from the
 * pointer argument to `instr`, if that offset is a constant. Otherwise, returns
 * unknown.
 */
IntValue getPointerBitOffset(PointerOffsetInstruction instr) {
  exists(IntValue bitOffset |
    (
      bitOffset = Ints::mul(Ints::mul(getConstantValue(instr.getRight()),
        instr.getElementSize()), 8)
    ) and
    (
      instr instanceof PointerAddInstruction and result = bitOffset or
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
predicate operandIsPropagated(Operand operand, IntValue bitOffset) {
  exists(Instruction instr |
    instr = operand.getUseInstruction() and
    (
      // Converting to a non-virtual base class adds the offset of the base class.
      exists(ConvertToBaseInstruction convert |
        convert = instr and
        bitOffset = Ints::mul(convert.getDerivation().getByteOffset(), 8)
      ) or
      // Converting to a derived class subtracts the offset of the base class.
      exists(ConvertToDerivedInstruction convert |
        convert = instr and
        bitOffset = Ints::neg(Ints::mul(convert.getDerivation().getByteOffset(), 8))
      ) or
      // Converting to a virtual base class adds an unknown offset.
      (
        instr instanceof ConvertToVirtualBaseInstruction and
        bitOffset = Ints::unknown()
      ) or
      // Conversion to another pointer type propagates the source address.
      exists(ConvertInstruction convert, Type resultType |
        convert = instr and
        resultType = convert.getResultType() and
        (
          resultType instanceof PointerType or
          resultType instanceof Class  //REVIEW: Remove when all glvalues are pointers
        ) and
        bitOffset = 0
      ) or
      // Adding an integer to or subtracting an integer from a pointer propagates
      // the address with an offset.
      bitOffset = getPointerBitOffset(instr.(PointerOffsetInstruction)) or
      // Computing a field address from a pointer propagates the address plus the
      // offset of the field.
      bitOffset = getFieldBitOffset(instr.(FieldAddressInstruction).getField()) or
      // A copy propagates the source value.
      operand = instr.(CopyInstruction).getSourceValueOperand() and bitOffset = 0
    )
  )
}

/**
 * Holds if any address held in operand number `tag` of instruction `instr`
 * escapes outside the domain of the analysis.
 */
 predicate operandEscapes(Operand operand) {
  // Conservatively assume that the address escapes unless one of the following
  // holds:
  not (
    // The operand is used in a way that does not escape the instruction
    operandIsConsumedWithoutEscaping(operand) or
    // The address is propagated to the result of the instruction, but that
    // result does not itself escape.
    operandIsPropagated(operand, _) and not resultEscapes(operand.getUseInstruction())
    or
    // The address is passed as an argument to a function from which it does not escape
    exists(CallInstruction ci, FunctionIR f, InitializeParameterInstruction ipi |
      ci = operand.getUseInstruction() and
      f.getFunction() = ci.getStaticCallTarget() and
      ipi.getParameter() = f.getFunction().getParameter(operand.(PositionalArgumentOperand).getIndex()) and
      not resultEscapesNonReturn(ipi) and
      (
        not resultReturned(ipi)
        or
        not resultEscapes(operand.getUseInstruction())
      )
    )
  )
}

predicate operandEscapesNonReturn(Operand operand) {
  // Conservatively assume that the address escapes unless one of the following
  // holds:
  not (
    // The operand is used in a way that does not escape the instruction
    operandIsConsumedWithoutEscaping(operand) or
    // The address is propagated to the result of the instruction, but that
    // result does not itself escape.
    operandIsPropagated(operand, _) and
    not resultEscapesNonReturn(operand.getUseInstruction())
    or
    // The operand is used in a function call from which the operand does not escape
    exists(CallInstruction ci, FunctionIR f, InitializeParameterInstruction ipi |
      ci = operand.getUseInstruction() and
      f.getFunction() = ci.getStaticCallTarget() and
      ipi.getParameter() = f.getFunction().getParameter(operand.(PositionalArgumentOperand).getIndex()) and
      not resultEscapesNonReturn(ipi) and
      not resultEscapesNonReturn(ci)
    ) or
    operand instanceof ReturnValueOperand
  )
}

predicate operandReturned(Operand operand) {
  // The address is propagated to the result of the instruction, and that result itself is returned
  operandIsPropagated(operand, _) and resultReturned(operand.getUseInstruction())
  or
  // The operand is used in a function call which returns it, and the return value is then returned
  exists(CallInstruction ci, FunctionIR f, InitializeParameterInstruction ipi |
    ci = operand.getUseInstruction() and
    f.getFunction() = ci.getStaticCallTarget() and
    ipi.getParameter() = f.getFunction().getParameter(operand.(PositionalArgumentOperand).getIndex()) and
    resultReturned(ipi) and
    resultReturned(ci)
  )
  or
  // The address is returned
  operand instanceof ReturnValueOperand
}

predicate resultReturned(Instruction instr) {
  operandReturned(instr.getAUse())
}

/**
 * Holds if any address held in the result of instruction `instr` escapes
 * outside the domain of the analysis.
 */
predicate resultEscapes(Instruction instr) {
  // The result escapes if it has at least one use that escapes.
  operandEscapes(instr.getAUse())
}

 predicate resultEscapesNonReturn(Instruction instr) {
  // The result escapes if it has at least one use that escapes.
  operandEscapesNonReturn(instr.getAUse())
}

/**
 * Holds if the address of the specified local variable or parameter escapes the
 * domain of the analysis.
 */
private predicate automaticVariableAddressEscapes(IRAutomaticVariable var) {
  exists(FunctionIR funcIR |
    funcIR = var.getEnclosingFunctionIR() and
    // The variable's address escapes if the result of any
    // VariableAddressInstruction that computes the variable's address escapes.
    exists(VariableAddressInstruction instr |
      instr.getEnclosingFunctionIR() = funcIR and
      instr.getVariable() = var and
      resultEscapesNonReturn(instr)
    )
  )
}

/**
 * Holds if the address of the specified variable escapes the domain of the
 * analysis.
 */
predicate variableAddressEscapes(IRVariable var) {
  automaticVariableAddressEscapes(var.(IRAutomaticVariable)) or
  // All variables with static storage duration have their address escape.
  not var instanceof IRAutomaticVariable
}

/**
 * Holds if the result of instruction `instr` points within variable `var`, at
 * bit offset `bitOffset` within the variable. If the result points within
 * `var`, but at an unknown or non-constant offset, then `bitOffset` is unknown.
 */
predicate resultPointsTo(Instruction instr, IRVariable var, IntValue bitOffset) {
  (
    // The address of a variable points to that variable, at offset 0.
    instr.(VariableAddressInstruction).getVariable() = var and
    bitOffset = 0
  ) or
  exists(Operand operand, IntValue originalBitOffset, IntValue propagatedBitOffset |
    operand = instr.getAnOperand() and
    // If an operand is propagated, then the result points to the same variable,
    // offset by the bit offset from the propagation.
    resultPointsTo(operand.getDefinitionInstruction(), var, originalBitOffset) and
    (
      operandIsPropagated(operand, propagatedBitOffset)
      or
      exists(CallInstruction ci, FunctionIR f, InitializeParameterInstruction ipi |
        ci = operand.getUseInstruction() and
        f.getFunction() = ci.getStaticCallTarget() and
        ipi.getParameter() = f.getFunction().getParameter(operand.(PositionalArgumentOperand).getIndex()) and
        resultReturned(ipi) and
        propagatedBitOffset = Ints::unknown()
      )
    ) and
    bitOffset = Ints::add(originalBitOffset, propagatedBitOffset)
  )
}
