private import ValueNumberingImports
private import cpp
private import IR

newtype TValueNumber =
  TVariableAddressValueNumber(IRFunction irFunc, IRVariable var) {
    variableAddressValueNumber(_, irFunc, var)
  } or
  TInitializeParameterValueNumber(IRFunction irFunc, IRVariable var) {
    initializeParameterValueNumber(_, irFunc, var)
  } or
  TInitializeThisValueNumber(IRFunction irFunc) { initializeThisValueNumber(_, irFunc) } or
  TConstantValueNumber(IRFunction irFunc, Type type, string value) {
    constantValueNumber(_, irFunc, type, value)
  } or
  TStringConstantValueNumber(IRFunction irFunc, Type type, string value) {
    stringConstantValueNumber(_, irFunc, type, value)
  } or
  TFieldAddressValueNumber(IRFunction irFunc, Field field, TValueNumber objectAddress) {
    fieldAddressValueNumber(_, irFunc, field, objectAddress)
  } or
  TBinaryValueNumber(
    IRFunction irFunc, Opcode opcode, Type type, TValueNumber leftOperand, TValueNumber rightOperand
  ) {
    binaryValueNumber(_, irFunc, opcode, type, leftOperand, rightOperand)
  } or
  TPointerArithmeticValueNumber(
    IRFunction irFunc, Opcode opcode, Type type, int elementSize, TValueNumber leftOperand,
    TValueNumber rightOperand
  ) {
    pointerArithmeticValueNumber(_, irFunc, opcode, type, elementSize, leftOperand, rightOperand)
  } or
  TUnaryValueNumber(IRFunction irFunc, Opcode opcode, Type type, TValueNumber operand) {
    unaryValueNumber(_, irFunc, opcode, type, operand)
  } or
  TInheritanceConversionValueNumber(
    IRFunction irFunc, Opcode opcode, Class baseClass, Class derivedClass, TValueNumber operand
  ) {
    inheritanceConversionValueNumber(_, irFunc, opcode, baseClass, derivedClass, operand)
  } or
  TUniqueValueNumber(IRFunction irFunc, Instruction instr) { uniqueValueNumber(instr, irFunc) }

/**
 * A `CopyInstruction` whose source operand's value is congruent to the definition of that source
 * operand.
 * For example:
 * ```
 * Point p = { 1, 2 };
 * Point q = p;
 * int a = p.x;
 * ```
 * The use of `p` on line 2 is linked to the definition of `p` on line 1, and is congruent to that
 * definition because it accesses the exact same memory.
 * The use of `p.x` on line 3 is linked to the definition of `p` on line 1 as well, but is not
 * congruent to that definition because `p.x` accesses only a subset of the memory defined by `p`.
 */
private class CongruentCopyInstruction extends CopyInstruction {
  CongruentCopyInstruction() {
    this.getSourceValueOperand().getDefinitionOverlap() instanceof MustExactlyOverlap
  }
}

/**
 * Holds if this library knows how to assign a value number to the specified instruction, other than
 * a `unique` value number that is never shared by multiple instructions.
 */
private predicate numberableInstruction(Instruction instr) {
  instr instanceof VariableAddressInstruction
  or
  instr instanceof InitializeParameterInstruction
  or
  instr instanceof InitializeThisInstruction
  or
  instr instanceof ConstantInstruction
  or
  instr instanceof StringConstantInstruction
  or
  instr instanceof FieldAddressInstruction
  or
  instr instanceof BinaryInstruction
  or
  instr instanceof UnaryInstruction and not instr instanceof CopyInstruction
  or
  instr instanceof PointerArithmeticInstruction
  or
  instr instanceof CongruentCopyInstruction
}

private predicate variableAddressValueNumber(
  VariableAddressInstruction instr, IRFunction irFunc, IRVariable var
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getIRVariable() = var
}

private predicate initializeParameterValueNumber(
  InitializeParameterInstruction instr, IRFunction irFunc, IRVariable var
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getIRVariable() = var
}

private predicate initializeThisValueNumber(InitializeThisInstruction instr, IRFunction irFunc) {
  instr.getEnclosingIRFunction() = irFunc
}

private predicate constantValueNumber(
  ConstantInstruction instr, IRFunction irFunc, Type type, string value
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getResultType() = type and
  instr.getValue() = value
}

private predicate stringConstantValueNumber(
  StringConstantInstruction instr, IRFunction irFunc, Type type, string value
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getResultType() = type and
  instr.getValue().getValue() = value
}

private predicate fieldAddressValueNumber(
  FieldAddressInstruction instr, IRFunction irFunc, Field field, TValueNumber objectAddress
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getField() = field and
  tvalueNumber(instr.getObjectAddress()) = objectAddress
}

private predicate binaryValueNumber(
  BinaryInstruction instr, IRFunction irFunc, Opcode opcode, Type type, TValueNumber leftOperand,
  TValueNumber rightOperand
) {
  instr.getEnclosingIRFunction() = irFunc and
  not instr instanceof PointerArithmeticInstruction and
  instr.getOpcode() = opcode and
  instr.getResultType() = type and
  tvalueNumber(instr.getLeft()) = leftOperand and
  tvalueNumber(instr.getRight()) = rightOperand
}

private predicate pointerArithmeticValueNumber(
  PointerArithmeticInstruction instr, IRFunction irFunc, Opcode opcode, Type type, int elementSize,
  TValueNumber leftOperand, TValueNumber rightOperand
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getOpcode() = opcode and
  instr.getResultType() = type and
  instr.getElementSize() = elementSize and
  tvalueNumber(instr.getLeft()) = leftOperand and
  tvalueNumber(instr.getRight()) = rightOperand
}

private predicate unaryValueNumber(
  UnaryInstruction instr, IRFunction irFunc, Opcode opcode, Type type, TValueNumber operand
) {
  instr.getEnclosingIRFunction() = irFunc and
  not instr instanceof InheritanceConversionInstruction and
  not instr instanceof CopyInstruction and
  instr.getOpcode() = opcode and
  instr.getResultType() = type and
  tvalueNumber(instr.getUnary()) = operand
}

private predicate inheritanceConversionValueNumber(
  InheritanceConversionInstruction instr, IRFunction irFunc, Opcode opcode, Class baseClass,
  Class derivedClass, TValueNumber operand
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getOpcode() = opcode and
  instr.getBaseClass() = baseClass and
  instr.getDerivedClass() = derivedClass and
  tvalueNumber(instr.getUnary()) = operand
}

/**
 * Holds if `instr` should be assigned a unique value number because this library does not know how
 * to determine if two instances of that instruction are equivalent.
 */
private predicate uniqueValueNumber(Instruction instr, IRFunction irFunc) {
  instr.getEnclosingIRFunction() = irFunc and
  not instr.getResultType() instanceof VoidType and
  not numberableInstruction(instr)
}

/**
 * Gets the value number assigned to `instr`, if any. Returns at most one result.
 */
cached
TValueNumber tvalueNumber(Instruction instr) {
  result = nonUniqueValueNumber(instr)
  or
  exists(IRFunction irFunc |
    uniqueValueNumber(instr, irFunc) and
    result = TUniqueValueNumber(irFunc, instr)
  )
}

/**
 * Gets the value number assigned to `instr`, if any, unless that instruction is assigned a unique
 * value number.
 */
private TValueNumber nonUniqueValueNumber(Instruction instr) {
  exists(IRFunction irFunc |
    irFunc = instr.getEnclosingIRFunction() and
    (
      exists(IRVariable var |
        variableAddressValueNumber(instr, irFunc, var) and
        result = TVariableAddressValueNumber(irFunc, var)
      )
      or
      exists(IRVariable var |
        initializeParameterValueNumber(instr, irFunc, var) and
        result = TInitializeParameterValueNumber(irFunc, var)
      )
      or
      initializeThisValueNumber(instr, irFunc) and
      result = TInitializeThisValueNumber(irFunc)
      or
      exists(Type type, string value |
        constantValueNumber(instr, irFunc, type, value) and
        result = TConstantValueNumber(irFunc, type, value)
      )
      or
      exists(Type type, string value |
        stringConstantValueNumber(instr, irFunc, type, value) and
        result = TStringConstantValueNumber(irFunc, type, value)
      )
      or
      exists(Field field, TValueNumber objectAddress |
        fieldAddressValueNumber(instr, irFunc, field, objectAddress) and
        result = TFieldAddressValueNumber(irFunc, field, objectAddress)
      )
      or
      exists(Opcode opcode, Type type, TValueNumber leftOperand, TValueNumber rightOperand |
        binaryValueNumber(instr, irFunc, opcode, type, leftOperand, rightOperand) and
        result = TBinaryValueNumber(irFunc, opcode, type, leftOperand, rightOperand)
      )
      or
      exists(Opcode opcode, Type type, TValueNumber operand |
        unaryValueNumber(instr, irFunc, opcode, type, operand) and
        result = TUnaryValueNumber(irFunc, opcode, type, operand)
      )
      or
      exists(Opcode opcode, Class baseClass, Class derivedClass, TValueNumber operand |
        inheritanceConversionValueNumber(instr, irFunc, opcode, baseClass, derivedClass, operand) and
        result = TInheritanceConversionValueNumber(irFunc, opcode, baseClass, derivedClass, operand)
      )
      or
      exists(
        Opcode opcode, Type type, int elementSize, TValueNumber leftOperand,
        TValueNumber rightOperand
      |
        pointerArithmeticValueNumber(instr, irFunc, opcode, type, elementSize, leftOperand,
          rightOperand) and
        result = TPointerArithmeticValueNumber(irFunc, opcode, type, elementSize, leftOperand,
            rightOperand)
      )
      or
      // The value number of a copy is just the value number of its source value.
      result = tvalueNumber(instr.(CongruentCopyInstruction).getSourceValue())
    )
  )
}
