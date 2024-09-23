/**
 * Instantiates the shared SSA library for JavaScript, but only to establish use-use flow.
 *
 * JavaScript's old SSA library is still responsible for the ordinary SSA flow.
 */

private import javascript as js
private import codeql.ssa.Ssa
private import semmle.javascript.internal.BasicBlockInternal as BasicBlockInternal
private import semmle.javascript.dataflow.internal.VariableOrThis

module SsaConfig implements InputSig<js::DbLocation> {
  class ControlFlowNode = js::ControlFlowNode;

  class BasicBlock = js::BasicBlock;

  class ExitBasicBlock extends BasicBlock {
    ExitBasicBlock() { this.isExitBlock() }
  }

  class SourceVariable extends LocalVariableOrThis {
    SourceVariable() { not this.isCaptured() }
  }

  pragma[nomagic]
  private js::EntryBasicBlock getEntryBlock(js::StmtContainer container) {
    result.getContainer() = container
  }

  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    certain = true and
    (
      bb.defAt(i, v.asLocalVariable(), _)
      or
      // Implicit initialization and function parameters
      bb = getEntryBlock(v.getDeclaringContainer()) and
      i = -1
    )
  }

  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    bb.useAt(i, v.asLocalVariable(), _) and certain = true
    or
    certain = true and
    bb.getNode(i).(ThisUse).getBindingContainer() = v.asThisContainer()
  }

  predicate getImmediateBasicBlockDominator = BasicBlockInternal::immediateDominator/1;

  pragma[inline]
  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }
}

import Make<js::DbLocation, SsaConfig>

private module SsaDataflowInput implements DataFlowIntegrationInputSig {
  class Expr extends js::ControlFlowNode {
    Expr() { this = any(SsaConfig::SourceVariable v).getAUse() }

    predicate hasCfgNode(js::BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  predicate ssaDefAssigns(WriteDefinition def, Expr value) { none() } // Not handled here

  class Parameter = js::Parameter;

  predicate ssaDefInitializesParam(WriteDefinition def, Parameter p) { none() } // Not handled here

  abstract class Guard extends Expr { } // empty class

  predicate guardControlsBlock(Guard guard, js::BasicBlock bb, boolean branch) { none() }

  js::BasicBlock getAConditionalBasicBlockSuccessor(js::BasicBlock bb, boolean branch) { none() }
}

import DataFlowIntegration<SsaDataflowInput>
