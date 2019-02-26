private import SSAConstructionInternal
private import OldIR
private import Alias

/**
 * Property provide that dumps the memory access of each result. Useful for debugging SSA
 * construction.
 */
class PropertyProvider extends IRPropertyProvider {
  override string getInstructionProperty(Instruction instruction, string key) {
    (
      key = "ResultMemoryAccess" and
      result = getResultMemoryAccess(instruction).toString()
    ) or
    (
      key = "OperandMemoryAccess" and
      result = getOperandMemoryAccess(instruction.getAnOperand().(MemoryOperand)).toString()
    )
  }
}
