private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
private import AliasedSSA

/**
 * Property provide that dumps the memory access of each result. Useful for debugging SSA
 * construction.
 */
class PropertyProvider extends IRPropertyProvider {
  override string getInstructionProperty(Instruction instruction, string key) {
    key = "ResultMemoryAccess" and result = getResultMemoryAccess(instruction).toString()
  }
}
