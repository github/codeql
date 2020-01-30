private import internal.ValueNumberingInternal
private import internal.ValueNumberingImports

/**
 * Provides additional information about value numbering in IR dumps.
 */
class ValueNumberPropertyProvider extends IRPropertyProvider {
  override string getInstructionProperty(Instruction instr, string key) {
    exists(ValueNumber vn |
      vn = valueNumber(instr) and
      key = "valnum" and
      if strictcount(vn.getAnInstruction()) > 1 then result = vn.toString() else result = "unique"
    )
  }
}

/**
 * The value number assigned to a particular set of instructions that produce equivalent results.
 */
class ValueNumber extends TValueNumber {
  final string toString() { result = "GVN" }

  final string getDebugString() {
    result = "ValueNumber: " +
        strictconcat(this.getAnInstruction().getUnconvertedResultExpression().toString(), ", ")
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this
        .getAnInstruction()
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /**
   * Gets the instructions that have been assigned this value number. This will always produce at
   * least one result.
   */
  final Instruction getAnInstruction() { this = valueNumber(result) }

  /**
   * Gets one of the instructions that was assigned this value number. The chosen instuction is
   * deterministic but arbitrary. Intended for use only in debugging.
   */
  final Instruction getExampleInstruction() {
    result = min(Instruction instr |
        instr = getAnInstruction()
      |
        instr order by instr.getBlock().getDisplayIndex(), instr.getDisplayIndexInBlock()
      )
  }

  /**
   * Gets an `Operand` whose definition is exact and has this value number.
   */
  final Operand getAUse() { this = valueNumber(result.getDef()) }

  final string getKind() {
    this instanceof TVariableAddressValueNumber and result = "VariableAddress"
    or
    this instanceof TInitializeParameterValueNumber and result = "InitializeParameter"
    or
    this instanceof TInitializeThisValueNumber and result = "InitializeThis"
    or
    this instanceof TStringConstantValueNumber and result = "StringConstant"
    or
    this instanceof TFieldAddressValueNumber and result = "FieldAddress"
    or
    this instanceof TBinaryValueNumber and result = "Binary"
    or
    this instanceof TPointerArithmeticValueNumber and result = "PointerArithmetic"
    or
    this instanceof TUnaryValueNumber and result = "Unary"
    or
    this instanceof TInheritanceConversionValueNumber and result = "InheritanceConversionr"
    or
    this instanceof TUniqueValueNumber and result = "Unique"
  }

  Language::Expr getAnExpr() { result = getAnInstruction().getUnconvertedResultExpression() }
}

/**
 * Gets the value number assigned to `instr`, if any. Returns at most one result.
 */
ValueNumber valueNumber(Instruction instr) { result = tvalueNumber(instr) }

/**
 * Gets the value number assigned to the exact definition of `op`, if any.
 * Returns at most one result.
 */
ValueNumber valueNumberOfOperand(Operand op) { result = valueNumber(op.getDef()) }
