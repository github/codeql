import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.controlflow.IRGuards
import utils.test.InlineExpectationsTest
import semmle.code.cpp.dataflow.ExternalFlow

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

predicate externalBarrierGuard(DataFlow::Node node, string s) {
  barrierNode(node, "test-barrier") and
  if node.isGLValue()
  then s = "glval<" + node.getType().toString().replaceAll(" ", "") + ">"
  else s = node.getType().toString().replaceAll(" ", "")
}

module Test implements TestSig {
  string getARelevantTag() { result = ["barrier", "indirect_barrier", "external"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node node |
      indirectBarrierGuard(node, value) and
      tag = "indirect_barrier"
      or
      barrierGuard(node, value) and
      tag = "barrier"
      or
      externalBarrierGuard(node, value) and
      tag = "external"
    |
      element = node.toString() and
      location = node.getLocation()
    )
  }
}

import MakeTest<Test>
