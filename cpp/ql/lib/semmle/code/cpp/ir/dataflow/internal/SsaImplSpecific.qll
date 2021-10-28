private import semmle.code.cpp.ir.IR
private import DataFlowUtil
private import DataFlowPrivate
private import DataFlowImplCommon as DataFlowImplCommon
private import Ssa as Ssa

class BasicBlock = IRBlock;

BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result.immediatelyDominates(bb) }

BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

class ExitBasicBlock extends IRBlock {
  ExitBasicBlock() { this.getLastInstruction() instanceof ExitFunctionInstruction }
}

private newtype TSourceVariable =
  TSourceIRVariable(IRVariable var) or
  TSourceIRVariableIndirection(InitializeIndirectionInstruction init)

abstract class SourceVariable extends TSourceVariable {
  IRVariable var;

  IRVariable getIRVariable() { result = var }

  abstract string toString();

  predicate isIndirection() { none() }
}

class SourceIRVariable extends SourceVariable, TSourceIRVariable {
  SourceIRVariable() { this = TSourceIRVariable(var) }

  override string toString() { result = this.getIRVariable().toString() }
}

class SourceIRVariableIndirection extends SourceVariable, TSourceIRVariableIndirection {
  InitializeIndirectionInstruction init;

  SourceIRVariableIndirection() {
    this = TSourceIRVariableIndirection(init) and var = init.getIRVariable()
  }

  override string toString() { result = "*" + this.getIRVariable().toString() }

  override predicate isIndirection() { any() }
}

predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  DataFlowImplCommon::forceCachingInSameStage() and
  exists(Ssa::Def def |
    def.hasRankInBlock(bb, i) and
    v = def.getSourceVariable() and
    (if def.isCertain() then certain = true else certain = false)
  )
}

predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
  exists(Ssa::Use use |
    use.hasRankInBlock(bb, i) and
    v = use.getSourceVariable() and
    certain = true
  )
}
