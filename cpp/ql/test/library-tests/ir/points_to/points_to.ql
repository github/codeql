import cpp
private import utils.test.InlineExpectationsTest
private import semmle.code.cpp.ir.internal.IntegerConstant as Ints

private predicate ignoreAllocation(string name) {
  name = ["i", "p", "q", "s", "t", "?{AllAliased}"]
}

private predicate ignoreFile(File file) {
  // Ignore standard headers.
  file.getBaseName() = ["memory.h", "type_traits.h", "utility.h"] or
  not file.fromSource()
}

module Raw {
  private import semmle.code.cpp.ir.implementation.raw.IR
  private import semmle.code.cpp.ir.implementation.unaliased_ssa.internal.SimpleSSA

  private MemoryLocation getAMemoryAccess(Instruction instr) {
    result = getResultMemoryLocation(instr) or
    result = getOperandMemoryLocation(instr.getAnOperand())
  }

  module RawPointsToTest implements TestSig {
    string getARelevantTag() { result = "raw" }

    predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(Instruction instr, MemoryLocation memLocation |
        memLocation = getAMemoryAccess(instr) and
        tag = "raw" and
        not ignoreAllocation(memLocation.getAllocation().getAllocationString()) and
        value = memLocation.toString() and
        element = instr.toString() and
        location = instr.getLocation() and
        not ignoreFile(location.getFile())
      )
    }
  }
}

module UnaliasedSsa {
  private import semmle.code.cpp.ir.implementation.unaliased_ssa.IR
  private import semmle.code.cpp.ir.implementation.aliased_ssa.internal.AliasedSSA

  private MemoryLocation getAMemoryAccess(Instruction instr) {
    result = getResultMemoryLocation(instr) or
    result = getOperandMemoryLocation(instr.getAnOperand())
  }

  module UnaliasedSsaPointsToTest implements TestSig {
    string getARelevantTag() { result = "ussa" }

    predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(Instruction instr, MemoryLocation memLocation |
        memLocation = getAMemoryAccess(instr) and
        not memLocation.getVirtualVariable() instanceof AliasedVirtualVariable and
        not memLocation instanceof AllNonLocalMemory and
        tag = "ussa" and
        not ignoreAllocation(memLocation.getAnAllocation().getAllocationString()) and
        value = memLocation.toString() and
        element = instr.toString() and
        location = instr.getLocation() and
        not ignoreFile(location.getFile())
      )
    }
  }
}

import MakeTest<MergeTests<Raw::RawPointsToTest, UnaliasedSsa::UnaliasedSsaPointsToTest>>
