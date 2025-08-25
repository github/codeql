import cpp
import semmle.code.cpp.security.InvalidPointerDereference.AllocationToInvalidPointer
import utils.test.InlineExpectationsTest
import semmle.code.cpp.ir.IR
import semmle.code.cpp.dataflow.new.DataFlow

module AllocationToInvalidPointerTest implements TestSig {
  string getARelevantTag() { result = "alloc" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node allocation, PointerAddInstruction pai, int delta |
      pointerAddInstructionHasBounds(allocation, pai, _, delta) and
      location = pai.getLocation() and
      element = pai.toString() and
      tag = "alloc"
    |
      delta > 0 and
      value = "L" + allocation.getLocation().getStartLine().toString() + "+" + delta.toString()
      or
      delta = 0 and
      value = "L" + allocation.getLocation().getStartLine().toString()
      or
      delta < 0 and
      value = "L" + allocation.getLocation().getStartLine().toString() + "-" + (-delta).toString()
    )
  }
}

import MakeTest<AllocationToInvalidPointerTest>
