private import semmle.code.cpp.ir.IR
private import SsaInternals as Ssa

class BasicBlock = IRBlock;

class SourceVariable = Ssa::SourceVariable;

BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result.immediatelyDominates(bb) }

BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

class ExitBasicBlock extends IRBlock {
  ExitBasicBlock() { this.getLastInstruction() instanceof ExitFunctionInstruction }
}

predicate variableWrite = Ssa::variableWrite/4;

predicate variableRead = Ssa::variableRead/4;
