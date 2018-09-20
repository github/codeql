private import internal.ValueNumberingInternal
import cpp
private import IR

/**
 * Provides additional information about value numbering in IR dumps.
 */
class ValueNumberPropertyProvider extends IRPropertyProvider {
  override string getInstructionProperty(Instruction instr, string key) {
    exists(ValueNumber vn |
      vn = valueNumber(instr) and
      key = "valnum" and
      if strictcount(vn.getAnInstruction()) > 1 then
        result = vn.toString()
      else
        result = "unique"
    )
  }
}

newtype TValueNumber =
  TVariableAddressValueNumber(FunctionIR funcIR, IRVariable var) {
    variableAddressValueNumber(_, funcIR, var)
  } or
  TInitializeParameterValueNumber(FunctionIR funcIR, IRVariable var) {
    initializeParameterValueNumber(_, funcIR, var)
  } or
  TInitializeThisValueNumber(FunctionIR funcIR) {
    initializeThisValueNumber(_, funcIR)
  } or
  TConstantValueNumber(FunctionIR funcIR, Type type, string value) {
    constantValueNumber(_, funcIR, type, value)
  } or
  TFieldAddressValueNumber(FunctionIR funcIR, Field field, ValueNumber objectAddress) {
    fieldAddressValueNumber(_, funcIR, field, objectAddress)
  } or
  TBinaryValueNumber(FunctionIR funcIR, Opcode opcode, Type type, ValueNumber leftOperand,
      ValueNumber rightOperand) {
    binaryValueNumber(_, funcIR, opcode, type, leftOperand, rightOperand)
  } or
  TPointerArithmeticValueNumber(FunctionIR funcIR, Opcode opcode, Type type, int elementSize,
      ValueNumber leftOperand, ValueNumber rightOperand) {
    pointerArithmeticValueNumber(_, funcIR, opcode, type, elementSize, leftOperand, rightOperand)
  } or
  TUnaryValueNumber(FunctionIR funcIR, Opcode opcode, Type type, ValueNumber operand) {
    unaryValueNumber(_, funcIR, opcode, type, operand)
  } or
  TInheritanceConversionValueNumber(FunctionIR funcIR, Opcode opcode, Class baseClass,
      Class derivedClass, ValueNumber operand) {
    inheritanceConversionValueNumber(_, funcIR, opcode, baseClass, derivedClass, operand)
  } or
  TUniqueValueNumber(FunctionIR funcIR, Instruction instr) {
    uniqueValueNumber(instr, funcIR)
  }

/**
 * The value number assigned to a particular set of instructions that produce equivalent results.
 */
class ValueNumber extends TValueNumber {
  final string toString() {
    result = getExampleInstruction().getResultId()
  }

  final Location getLocation() {
    result = getExampleInstruction().getLocation()
  }

  /**
   * Gets the instructions that have been assigned this value number. This will always produce at
   * least one result.
   */
  final Instruction getAnInstruction() {
    this = valueNumber(result)
  }

  /**
   * Gets one of the instructions that was assigned this value number. The chosen instuction is
   * deterministic but arbitrary. Intended for use only in debugging.
   */
  final Instruction getExampleInstruction() {
    result = min(Instruction instr |
      instr = getAnInstruction() |
      instr order by instr.getBlock().getDisplayIndex(), instr.getDisplayIndexInBlock()
    )
  }
}

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
 *
 * This concept should probably be exposed in the public IR API.
 */
private class CongruentCopyInstruction extends CopyInstruction {
  CongruentCopyInstruction() {
    exists(Instruction def |
      def = this.getSourceValue() and
      (
        def.getResultMemoryAccess() instanceof IndirectMemoryAccess or
        not def.hasMemoryResult()
      )
    )
  }
}

/**
 * Holds if this library knows how to assign a value number to the specified instruction, other than
 * a `unique` value number that is never shared by multiple instructions.
 */
private predicate numberableInstruction(Instruction instr) {
  instr instanceof VariableAddressInstruction or
  instr instanceof InitializeParameterInstruction or
  instr instanceof InitializeThisInstruction or
  instr instanceof ConstantInstruction or
  instr instanceof FieldAddressInstruction or
  instr instanceof BinaryInstruction or
  instr instanceof UnaryInstruction or
  instr instanceof PointerArithmeticInstruction or
  instr instanceof CongruentCopyInstruction
}

private predicate variableAddressValueNumber(VariableAddressInstruction instr, FunctionIR funcIR,
    IRVariable var) {
  instr.getFunctionIR() = funcIR and
  instr.getVariable() = var
}

private predicate initializeParameterValueNumber(InitializeParameterInstruction instr,
    FunctionIR funcIR, IRVariable var) {
  instr.getFunctionIR() = funcIR and
  instr.getVariable() = var
}

private predicate initializeThisValueNumber(InitializeThisInstruction instr, FunctionIR funcIR) {
  instr.getFunctionIR() = funcIR
}

private predicate constantValueNumber(ConstantInstruction instr, FunctionIR funcIR, Type type,
    string value) {
  instr.getFunctionIR() = funcIR and
  instr.getResultType() = type and
  instr.getValue() = value
}

private predicate fieldAddressValueNumber(FieldAddressInstruction instr, FunctionIR funcIR,
    Field field, ValueNumber objectAddress) {
  instr.getFunctionIR() = funcIR and
  instr.getField() = field and
  valueNumber(instr.getObjectAddress()) = objectAddress
}

private predicate binaryValueNumber(BinaryInstruction instr, FunctionIR funcIR, Opcode opcode,
    Type type, ValueNumber leftOperand, ValueNumber rightOperand) {
  instr.getFunctionIR() = funcIR and
  (not instr instanceof PointerArithmeticInstruction) and
  instr.getOpcode() = opcode and
  instr.getResultType() = type and
  valueNumber(instr.getLeftOperand()) = leftOperand and
  valueNumber(instr.getRightOperand()) = rightOperand
}

private predicate pointerArithmeticValueNumber(PointerArithmeticInstruction instr,
    FunctionIR funcIR, Opcode opcode, Type type, int elementSize, ValueNumber leftOperand,
    ValueNumber rightOperand) {
  instr.getFunctionIR() = funcIR and
  instr.getOpcode() = opcode and
  instr.getResultType() = type and
  instr.getElementSize() = elementSize and
  valueNumber(instr.getLeftOperand()) = leftOperand and
  valueNumber(instr.getRightOperand()) = rightOperand
}

private predicate unaryValueNumber(UnaryInstruction instr, FunctionIR funcIR, Opcode opcode,
    Type type, ValueNumber operand) {
  instr.getFunctionIR() = funcIR and
  (not instr instanceof InheritanceConversionInstruction) and
  instr.getOpcode() = opcode and
  instr.getResultType() = type and
  valueNumber(instr.getOperand()) = operand
}

private predicate inheritanceConversionValueNumber(InheritanceConversionInstruction instr,
    FunctionIR funcIR, Opcode opcode, Class baseClass, Class derivedClass, ValueNumber operand) {
  instr.getFunctionIR() = funcIR and
  instr.getOpcode() = opcode and
  instr.getBaseClass() = baseClass and
  instr.getDerivedClass() = derivedClass and
  valueNumber(instr.getOperand()) = operand
}

/**
 * Holds if `instr` should be assigned a unique value number because this library does not know how
 * to determine if two instances of that instruction are equivalent.
 */
private predicate uniqueValueNumber(Instruction instr, FunctionIR funcIR) {
  instr.getFunctionIR() = funcIR and
  (not instr.getResultType() instanceof VoidType) and
  not numberableInstruction(instr)
}

/**
 * Gets the value number assigned to `instr`, if any. Returns at most one result.
 */
ValueNumber valueNumber(Instruction instr) {
  result = nonUniqueValueNumber(instr) or
  exists(FunctionIR funcIR |
    uniqueValueNumber(instr, funcIR) and
    result = TUniqueValueNumber(funcIR, instr)
  )
}

/**
 * Gets the value number assigned to `instr`, if any, unless that instruction is assigned a unique
 * value number.
 */
private ValueNumber nonUniqueValueNumber(Instruction instr) {
  exists(FunctionIR funcIR |
    funcIR = instr.getFunctionIR() and
    (
      exists(IRVariable var |
        variableAddressValueNumber(instr, funcIR, var) and
        result = TVariableAddressValueNumber(funcIR, var)
      ) or
      exists(IRVariable var |
        initializeParameterValueNumber(instr, funcIR, var) and
        result = TInitializeParameterValueNumber(funcIR, var)
      ) or
      (
        initializeThisValueNumber(instr, funcIR) and
        result = TInitializeThisValueNumber(funcIR)
      ) or
      exists(Type type, string value |
        constantValueNumber(instr, funcIR, type, value) and
        result = TConstantValueNumber(funcIR, type, value)
      ) or
      exists(Field field, ValueNumber objectAddress |
        fieldAddressValueNumber(instr, funcIR, field, objectAddress) and
        result = TFieldAddressValueNumber(funcIR, field, objectAddress)
      ) or
      exists(Opcode opcode, Type type, ValueNumber leftOperand, ValueNumber rightOperand |
        binaryValueNumber(instr, funcIR, opcode, type, leftOperand, rightOperand) and
        result = TBinaryValueNumber(funcIR, opcode, type, leftOperand, rightOperand)
      ) or
      exists(Opcode opcode, Type type, ValueNumber operand |
        unaryValueNumber(instr, funcIR, opcode, type, operand) and
        result = TUnaryValueNumber(funcIR, opcode, type, operand)
      ) or
      exists(Opcode opcode, Class baseClass, Class derivedClass, ValueNumber operand |
        inheritanceConversionValueNumber(instr, funcIR, opcode, baseClass, derivedClass,
            operand) and
        result = TInheritanceConversionValueNumber(funcIR, opcode, baseClass, derivedClass, operand)
      ) or
      exists(Opcode opcode, Type type, int elementSize, ValueNumber leftOperand,
          ValueNumber rightOperand |
        pointerArithmeticValueNumber(instr, funcIR, opcode, type, elementSize, leftOperand,
            rightOperand) and
        result = TPointerArithmeticValueNumber(funcIR, opcode, type, elementSize, leftOperand,
            rightOperand)
      ) or
      // The value number of a copy is just the value number of its source value.
      result = valueNumber(instr.(CongruentCopyInstruction).getSourceValue())
    )
  )
}
