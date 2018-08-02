import sbb_test

class CutCall extends SubBasicBlockCutNode {
  CutCall() {
    this.(FunctionCall).getTarget().getName() = "cut"
  }
}

from SubBasicBlock sbb, int i
select subBasicBlockDebugInfo(sbb), i, sbb.getNode(i)
