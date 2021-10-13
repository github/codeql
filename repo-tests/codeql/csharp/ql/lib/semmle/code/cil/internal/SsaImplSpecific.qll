/** Provides the CIL specific parameters for `SsaImplCommon.qll`. */

private import cil
private import SsaImpl

class BasicBlock = CIL::BasicBlock;

BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

class ExitBasicBlock = CIL::ExitBasicBlock;

class SourceVariable = CIL::StackVariable;

predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  forceCachingInSameStage() and
  exists(CIL::VariableUpdate vu |
    vu.updatesAt(bb, i) and
    v = vu.getVariable() and
    certain = true
  )
}

predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  exists(CIL::ReadAccess ra | bb.getNode(i) = ra |
    ra.getTarget() = v and
    certain = true
  )
}
