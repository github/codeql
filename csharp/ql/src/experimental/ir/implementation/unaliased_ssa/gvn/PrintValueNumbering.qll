private import internal.ValueNumberingImports
private import ValueNumbering

/**
 * Provides additional information about value numbering in IR dumps.
 */
class ValueNumberPropertyProvider extends IRPropertyProvider {
  override string getInstructionProperty(Instruction instr, string key) {
    exists(ValueNumber vn |
      vn = valueNumber(instr) and
      key = "valnum" and
      if strictcount(vn.getAnInstruction()) > 1
      then result = vn.getDebugString()
      else result = "unique"
    )
  }
}
