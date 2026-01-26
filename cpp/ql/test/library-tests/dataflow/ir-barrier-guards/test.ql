import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.controlflow.IRGuards
import utils.test.InlineExpectationsTest

predicate instructionGuardChecks(IRGuardCondition gc, Instruction checked, boolean branch) {
  exists(CallInstruction call |
    call.getStaticCallTarget().hasName("checkArgument") and
    checked = call.getAnArgument() and
    gc.comparesEq(call.getAUse(), 0, false, any(GuardValue bv | bv.asBooleanValue() = branch))
  )
}

module BarrierGuard = DataFlow::InstructionBarrierGuard<instructionGuardChecks/3>;

predicate indirectBarrierGuard(DataFlow::Node node, string s) {
  node = BarrierGuard::getAnIndirectBarrierNode(_) and
  if node.isGLValue()
  then s = "glval<" + node.getType().toString().replaceAll(" ", "") + ">"
  else s = node.getType().toString().replaceAll(" ", "")
}

predicate barrierGuard(DataFlow::Node node, string s) {
  node = BarrierGuard::getABarrierNode() and
  if node.isGLValue()
  then s = "glval<" + node.getType().toString().replaceAll(" ", "") + ">"
  else s = node.getType().toString().replaceAll(" ", "")
}

module Test implements TestSig {
  string getARelevantTag() { result = ["barrier", "indirect_barrier"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node node, string s |
      indirectBarrierGuard(node, s) and
      value = s and
      tag = "indirect_barrier"
      or
      barrierGuard(node, s) and
      value = s and
      tag = "barrier"
    |
      element = node.toString() and
      location = node.getLocation()
    )
  }
}

import MakeTest<Test>
