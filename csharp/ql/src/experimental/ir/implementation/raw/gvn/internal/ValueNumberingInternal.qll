private import ValueNumberingImports

newtype TValueNumber =
  TVariableAddressValueNumber(IRFunction irFunc, Language::AST ast) {
    variableAddressValueNumber(_, irFunc, ast)
  } or
  TInitializeParameterValueNumber(IRFunction irFunc, Language::AST var) {
    initializeParameterValueNumber(_, irFunc, var)
  } or
  TConstantValueNumber(IRFunction irFunc, IRType type, string value) {
    constantValueNumber(_, irFunc, type, value)
  } or
  TStringConstantValueNumber(IRFunction irFunc, IRType type, string value) {
    stringConstantValueNumber(_, irFunc, type, value)
  } or
  TFieldAddressValueNumber(IRFunction irFunc, Language::Field field, TValueNumber objectAddress) {
    fieldAddressValueNumber(_, irFunc, field, objectAddress)
  } or
  TBinaryValueNumber(
    IRFunction irFunc, Opcode opcode, TValueNumber leftOperand, TValueNumber rightOperand
  ) {
    binaryValueNumber(_, irFunc, opcode, leftOperand, rightOperand)
  } or
  TPointerArithmeticValueNumber(
    IRFunction irFunc, Opcode opcode, int elementSize, TValueNumber leftOperand,
    TValueNumber rightOperand
  ) {
    pointerArithmeticValueNumber(_, irFunc, opcode, elementSize, leftOperand, rightOperand)
  } or
  TUnaryValueNumber(IRFunction irFunc, Opcode opcode, TValueNumber operand) {
    unaryValueNumber(_, irFunc, opcode, operand)
  } or
  TInheritanceConversionValueNumber(
    IRFunction irFunc, Opcode opcode, Language::Class baseClass, Language::Class derivedClass,
    TValueNumber operand
  ) {
    inheritanceConversionValueNumber(_, irFunc, opcode, baseClass, derivedClass, operand)
  } or
  TLoadTotalOverlapValueNumber(
    IRFunction irFunc, IRType type, TValueNumber memOperand, TValueNumber operand
  ) {
    loadTotalOverlapValueNumber(_, irFunc, type, memOperand, operand)
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
class CongruentCopyInstruction extends CopyInstruction {
  CongruentCopyInstruction() {
    this.getSourceValueOperand().getDefinitionOverlap() instanceof MustExactlyOverlap
  }
}

class LoadTotalOverlapInstruction extends LoadInstruction {
  LoadTotalOverlapInstruction() {
    this.getSourceValueOperand().getDefinitionOverlap() instanceof MustTotallyOverlap
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
  or
  instr instanceof LoadTotalOverlapInstruction
}

private predicate filteredNumberableInstruction(Instruction instr) {
  // count rather than strictcount to handle missing AST elements
  // separate instanceof and inline casts to avoid failed casts with a count of 0
  instr instanceof VariableAddressInstruction and
  count(instr.(VariableAddressInstruction).getIRVariable().getAST()) != 1
  or
  instr instanceof ConstantInstruction and
  count(instr.getResultIRType()) != 1
  or
  instr instanceof FieldAddressInstruction and
  count(instr.(FieldAddressInstruction).getField()) != 1
}

private predicate variableAddressValueNumber(
  VariableAddressInstruction instr, IRFunction irFunc, Language::AST ast
) {
  instr.getEnclosingIRFunction() = irFunc and
  // The underlying AST element is used as value-numbering key instead of the
  // `IRVariable` to work around a problem where a variable or expression with
  // multiple types gives rise to multiple `IRVariable`s.
  instr.getIRVariable().getAST() = ast and
  strictcount(instr.getIRVariable().getAST()) = 1
}

private predicate initializeParameterValueNumber(
  InitializeParameterInstruction instr, IRFunction irFunc, Language::AST var
) {
  instr.getEnclosingIRFunction() = irFunc and
  // The underlying AST element is used as value-numbering key instead of the
  // `IRVariable` to work around a problem where a variable or expression with
  // multiple types gives rise to multiple `IRVariable`s.
  instr.getIRVariable().getAST() = var
}

private predicate constantValueNumber(
  ConstantInstruction instr, IRFunction irFunc, IRType type, string value
) {
  instr.getEnclosingIRFunction() = irFunc and
  strictcount(instr.getResultIRType()) = 1 and
  instr.getResultIRType() = type and
  instr.getValue() = value
}

private predicate stringConstantValueNumber(
  StringConstantInstruction instr, IRFunction irFunc, IRType type, string value
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getResultIRType() = type and
  instr.getValue().getValue() = value
}

private predicate fieldAddressValueNumber(
  FieldAddressInstruction instr, IRFunction irFunc, Language::Field field,
  TValueNumber objectAddress
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getField() = field and
  strictcount(instr.getField()) = 1 and
  tvalueNumber(instr.getObjectAddress()) = objectAddress
}

private predicate binaryValueNumber(
  BinaryInstruction instr, IRFunction irFunc, Opcode opcode, TValueNumber leftOperand,
  TValueNumber rightOperand
) {
  instr.getEnclosingIRFunction() = irFunc and
  not instr instanceof PointerArithmeticInstruction and
  instr.getOpcode() = opcode and
  tvalueNumber(instr.getLeft()) = leftOperand and
  tvalueNumber(instr.getRight()) = rightOperand
}

private predicate pointerArithmeticValueNumber(
  PointerArithmeticInstruction instr, IRFunction irFunc, Opcode opcode, int elementSize,
  TValueNumber leftOperand, TValueNumber rightOperand
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getOpcode() = opcode and
  instr.getElementSize() = elementSize and
  tvalueNumber(instr.getLeft()) = leftOperand and
  tvalueNumber(instr.getRight()) = rightOperand
}

private predicate unaryValueNumber(
  UnaryInstruction instr, IRFunction irFunc, Opcode opcode, TValueNumber operand
) {
  instr.getEnclosingIRFunction() = irFunc and
  not instr instanceof InheritanceConversionInstruction and
  not instr instanceof CopyInstruction and
  not instr instanceof FieldAddressInstruction and
  instr.getOpcode() = opcode and
  tvalueNumber(instr.getUnary()) = operand
}

private predicate inheritanceConversionValueNumber(
  InheritanceConversionInstruction instr, IRFunction irFunc, Opcode opcode,
  Language::Class baseClass, Language::Class derivedClass, TValueNumber operand
) {
  instr.getEnclosingIRFunction() = irFunc and
  instr.getOpcode() = opcode and
  instr.getBaseClass() = baseClass and
  instr.getDerivedClass() = derivedClass and
  tvalueNumber(instr.getUnary()) = operand
}

private predicate loadTotalOverlapValueNumber(
  LoadTotalOverlapInstruction instr, IRFunction irFunc, IRType type, TValueNumber memOperand,
  TValueNumber operand
) {
  instr.getEnclosingIRFunction() = irFunc and
  tvalueNumber(instr.getAnOperand().(MemoryOperand).getAnyDef()) = memOperand and
  tvalueNumberOfOperand(instr.getAnOperand().(AddressOperand)) = operand and
  instr.getResultIRType() = type
}

/**
 * Holds if `instr` should be assigned a unique value number because this library does not know how
 * to determine if two instances of that instruction are equivalent.
 */
private predicate uniqueValueNumber(Instruction instr, IRFunction irFunc) {
  instr.getEnclosingIRFunction() = irFunc and
  not instr.getResultIRType() instanceof IRVoidType and
  (
    not numberableInstruction(instr)
    or
    filteredNumberableInstruction(instr)
  )
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
 * Gets the value number assigned to the exact definition of `op`, if any.
 * Returns at most one result.
 */
TValueNumber tvalueNumberOfOperand(Operand op) { result = tvalueNumber(op.getDef()) }

/**
 * Gets the value number assigned to `instr`, if any, unless that instruction is assigned a unique
 * value number.
 */
private TValueNumber nonUniqueValueNumber(Instruction instr) {
  exists(IRFunction irFunc |
    irFunc = instr.getEnclosingIRFunction() and
    (
      exists(Language::AST ast |
        variableAddressValueNumber(instr, irFunc, ast) and
        result = TVariableAddressValueNumber(irFunc, ast)
      )
      or
      exists(Language::AST var |
        initializeParameterValueNumber(instr, irFunc, var) and
        result = TInitializeParameterValueNumber(irFunc, var)
      )
      or
      exists(string value, IRType type |
        constantValueNumber(instr, irFunc, type, value) and
        result = TConstantValueNumber(irFunc, type, value)
      )
      or
      exists(IRType type, string value |
        stringConstantValueNumber(instr, irFunc, type, value) and
        result = TStringConstantValueNumber(irFunc, type, value)
      )
      or
      exists(Language::Field field, TValueNumber objectAddress |
        fieldAddressValueNumber(instr, irFunc, field, objectAddress) and
        result = TFieldAddressValueNumber(irFunc, field, objectAddress)
      )
      or
      exists(Opcode opcode, TValueNumber leftOperand, TValueNumber rightOperand |
        binaryValueNumber(instr, irFunc, opcode, leftOperand, rightOperand) and
        result = TBinaryValueNumber(irFunc, opcode, leftOperand, rightOperand)
      )
      or
      exists(Opcode opcode, TValueNumber operand |
        unaryValueNumber(instr, irFunc, opcode, operand) and
        result = TUnaryValueNumber(irFunc, opcode, operand)
      )
      or
      exists(
        Opcode opcode, Language::Class baseClass, Language::Class derivedClass, TValueNumber operand
      |
        inheritanceConversionValueNumber(instr, irFunc, opcode, baseClass, derivedClass, operand) and
        result = TInheritanceConversionValueNumber(irFunc, opcode, baseClass, derivedClass, operand)
      )
      or
      exists(Opcode opcode, int elementSize, TValueNumber leftOperand, TValueNumber rightOperand |
        pointerArithmeticValueNumber(instr, irFunc, opcode, elementSize, leftOperand, rightOperand) and
        result =
          TPointerArithmeticValueNumber(irFunc, opcode, elementSize, leftOperand, rightOperand)
      )
      or
      exists(IRType type, TValueNumber memOperand, TValueNumber operand |
        loadTotalOverlapValueNumber(instr, irFunc, type, memOperand, operand) and
        result = TLoadTotalOverlapValueNumber(irFunc, type, memOperand, operand)
      )
      or
      // The value number of a copy is just the value number of its source value.
      result = tvalueNumber(instr.(CongruentCopyInstruction).getSourceValue())
    )
  )
}
