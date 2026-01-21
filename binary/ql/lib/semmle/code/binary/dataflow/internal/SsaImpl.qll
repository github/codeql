private import semmle.code.binary.ast.ir.IR
private import codeql.ssa.Ssa as SsaImplCommon

private predicate variableReadCertain(BasicBlock bb, int i, Operand va, Variable v) {
  bb.getNode(i).asOperand() = va and
  va = v.getAnAccess()
}

private module SsaInput implements SsaImplCommon::InputSig<Location, BasicBlock> {
  class SourceVariable = Variable;

  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    bb.getNode(i).asInstruction().getResultVariable() = v and
    certain = true
  }

  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    variableReadCertain(bb, i, _, v) and certain = true
  }
}

import SsaImplCommon::Make<Location, BinaryCfg, SsaInput> as Impl

class Definition = Impl::Definition;

class WriteDefinition = Impl::WriteDefinition;

class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

class PhiDefinition = Impl::PhiNode;

cached
private module Cached {
  cached
  predicate variableWriteActual(BasicBlock bb, int i, Variable v, Instruction write) {
    SsaInput::variableWrite(bb, i, v, true) and
    bb.getNode(i).asInstruction() = write
  }

  cached
  Operand getARead(Definition def) {
    exists(Variable v, BasicBlock bb, int i |
      Impl::ssaDefReachesRead(v, def, bb, i) and
      variableReadCertain(bb, i, result, v)
    )
  }

  cached
  Definition phiHasInputFromBlock(PhiDefinition phi, BasicBlock bb) {
    Impl::phiHasInputFromBlock(phi, result, bb)
  }

  cached
  module DataFlowIntegration {
    import DataFlowIntegrationImpl

    cached
    predicate localFlowStep(
      SsaInput::SourceVariable v, Node nodeFrom, Node nodeTo, boolean isUseStep
    ) {
      DataFlowIntegrationImpl::localFlowStep(v, nodeFrom, nodeTo, isUseStep)
    }

    cached
    predicate localMustFlowStep(SsaInput::SourceVariable v, Node nodeFrom, Node nodeTo) {
      DataFlowIntegrationImpl::localMustFlowStep(v, nodeFrom, nodeTo)
    }

    signature predicate guardChecksSig(ControlFlowNode g, ControlFlowNode e, boolean branch);

    cached // nothing is actually cached
    module BarrierGuard<guardChecksSig/3 guardChecks> {
      private predicate guardChecksAdjTypes(
        DataFlowIntegrationInput::Guard g, DataFlowIntegrationInput::Expr e,
        DataFlowIntegrationInput::GuardValue branch
      ) {
        guardChecks(g, e, branch)
      }

      private Node getABarrierNodeImpl() {
        result = DataFlowIntegrationImpl::BarrierGuard<guardChecksAdjTypes/3>::getABarrierNode()
      }

      predicate getABarrierNode = getABarrierNodeImpl/0;
    }
  }
}

import Cached
private import semmle.code.binary.dataflow.Ssa

private module DataFlowIntegrationInput implements Impl::DataFlowIntegrationInputSig {
  private import codeql.util.Boolean

  class Expr extends ControlFlowNode {
    predicate hasCfgNode(BinaryCfg::BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  Expr getARead(Definition def) { result.asOperand() = Cached::getARead(def) }

  predicate ssaDefHasSource(WriteDefinition def) { none() }

  predicate allowFlowIntoUncertainDef(UncertainWriteDefinition def) { none() }

  predicate includeWriteDefsInFlowStep() { any() }

  class GuardValue = Boolean;

  class Guard extends ControlFlowNode {
    /**
     * Holds if the evaluation of this guard to `branch` corresponds to the edge
     * from `bb1` to `bb2`.
     */
    predicate hasValueBranchEdge(
      BinaryCfg::BasicBlock bb1, BinaryCfg::BasicBlock bb2, GuardValue branch
    ) {
      exists(ConditionalSuccessor s |
        this = bb1.getANode() and
        bb2 = bb1.getASuccessor(s) and
        s.getValue() = branch
      )
    }

    /**
     * Holds if this guard evaluating to `branch` controls the control-flow
     * branch edge from `bb1` to `bb2`. That is, following the edge from
     * `bb1` to `bb2` implies that this guard evaluated to `branch`.
     */
    predicate valueControlsBranchEdge(
      BinaryCfg::BasicBlock bb1, BinaryCfg::BasicBlock bb2, GuardValue branch
    ) {
      this.hasValueBranchEdge(bb1, bb2, branch)
    }
  }

  /** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
  predicate guardDirectlyControlsBlock(Guard guard, BinaryCfg::BasicBlock bb, GuardValue branch) {
    exists(ConditionBasicBlock conditionBlock, ConditionalSuccessor s |
      guard = conditionBlock.getLastNode() and
      s.getValue() = branch and
      conditionBlock.edgeDominates(bb, s)
    )
  }
}

private module DataFlowIntegrationImpl = Impl::DataFlowIntegration<DataFlowIntegrationInput>;
