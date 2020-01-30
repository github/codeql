import cpp
private import TestUtilities.InlineExpectationsTest
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints

private predicate ignoreAllocation(string name) {
  name = "i" or
  name = "p" or
  name = "q"
}

module Raw {
  private import semmle.code.cpp.ir.implementation.raw.IR
  private import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.SimpleSSA

  private MemoryLocation getAMemoryAccess(Instruction instr) {
    result = getResultMemoryLocation(instr) or
    result = getOperandMemoryLocation(instr.getAnOperand())
  }

  class RawPointsToTest extends InlineExpectationsTest {
    RawPointsToTest() { this = "RawPointsToTest" }

    override string getARelevantTag() { result = "raw" }

    override predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(Instruction instr, MemoryLocation memLocation |
        memLocation = getAMemoryAccess(instr) and
        tag = "raw" and
        not ignoreAllocation(memLocation.getAllocation().getAllocationString()) and
        value = memLocation.toString() and
        element = instr.toString() and
        location = instr.getLocation()
      )
    }
  }
}

module UnaliasedSSA {
  private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
  private import semmle.code.cpp.ir.implementation.aliased_ssa.internal.AliasedSSA

  private MemoryLocation getAMemoryAccess(Instruction instr) {
    result = getResultMemoryLocation(instr) or
    result = getOperandMemoryLocation(instr.getAnOperand())
  }

  class UnaliasedSSAPointsToTest extends InlineExpectationsTest {
    UnaliasedSSAPointsToTest() { this = "UnaliasedSSAPointsToTest" }

    override string getARelevantTag() { result = "ussa" }

    override predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(Instruction instr, MemoryLocation memLocation |
        memLocation = getAMemoryAccess(instr) and
        not memLocation instanceof AliasedVirtualVariable and
        not memLocation instanceof AllNonLocalMemory and
        tag = "ussa" and
        not ignoreAllocation(memLocation.getAllocation().getAllocationString()) and
        value = memLocation.toString() and
        element = instr.toString() and
        location = instr.getLocation()
      )
    }
  }
}
