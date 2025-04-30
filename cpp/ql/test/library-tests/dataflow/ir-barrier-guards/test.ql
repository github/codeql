import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.controlflow.IRGuards
import utils.test.InlineExpectationsTest

predicate instructionGuardChecks(IRGuardCondition gc, Instruction checked, boolean branch) {
  exists(CallInstruction call |
    call.getStaticCallTarget().hasName("checkArgument") and
    checked = call.getAnArgument() and
    gc.comparesEq(call.getAUse(), 0, false, any(BooleanValue bv | bv.getValue() = branch))
  )
}

module BarrierGuard = DataFlow::InstructionBarrierGuard<instructionGuardChecks/3>;

predicate indirectBarrierGuard(DataFlow::Node node, int indirectionIndex) {
  node = BarrierGuard::getAnIndirectBarrierNode(indirectionIndex)
}

predicate barrierGuard(DataFlow::Node node) { node = BarrierGuard::getABarrierNode() }

module Test implements TestSig {
  string getARelevantTag() { result = "barrier" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node node |
      barrierGuard(node) and
      value = ""
      or
      exists(int indirectionIndex |
        indirectBarrierGuard(node, indirectionIndex) and
        value = indirectionIndex.toString()
      )
    |
      tag = "barrier" and
      element = node.toString() and
      location = node.getLocation()
    )
  }
}

import MakeTest<Test>
