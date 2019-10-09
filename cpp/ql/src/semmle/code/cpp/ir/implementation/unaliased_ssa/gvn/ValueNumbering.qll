private import internal.ValueNumberingInternal
private import internal.ValueNumberingImports
private import IR

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
  final string toString() { result = getExampleInstruction().getResultId() }

  final Language::Location getLocation() { result = getExampleInstruction().getLocation() }

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
