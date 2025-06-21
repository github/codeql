private import codeql.ssa.Ssa as SsaImplCommon
private import powershell
private import semmle.code.powershell.Cfg as Cfg
private import semmle.code.powershell.controlflow.internal.ControlFlowGraphImpl as ControlFlowGraphImpl
private import semmle.code.powershell.dataflow.Ssa
import Cfg::CfgNodes
private import ExprNodes
private import StmtNodes

module SsaInput implements SsaImplCommon::InputSig<Location> {
  private import semmle.code.powershell.controlflow.ControlFlowGraph as Cfg
  private import semmle.code.powershell.controlflow.BasicBlocks as BasicBlocks

  class BasicBlock = BasicBlocks::BasicBlock;

  class ControlFlowNode = Cfg::CfgNode;

  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) { result = bb.getImmediateDominator() }

  BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

  class SourceVariable = Variable;

  /**
   * Holds if the statement at index `i` of basic block `bb` contains a write to variable `v`.
   * `certain` is true if the write definitely occurs.
   */
  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    (
      uninitializedWrite(bb, i, v)
      or
      variableWriteActual(bb, i, v, _)
      or
      exists(ProcessBlockCfgNode processBlock | bb.getNode(i) = processBlock |
        processBlock.getPipelineIteratorVariable() = v
        or
        processBlock.getAPipelineBypropertyNameIteratorVariable() = v
      )
      or
      parameterWrite(bb, i, v)
    ) and
    certain = true
  }

  predicate variableRead(BasicBlock bb, int i, Variable v, boolean certain) {
    variableReadActual(bb, i, v) and
    certain = true
  }
}

import SsaImplCommon::Make<Location, SsaInput> as Impl

class Definition = Impl::Definition;

class WriteDefinition = Impl::WriteDefinition;

class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

class PhiNode = Impl::PhiNode;

module Consistency = Impl::Consistency;

/** Holds if `v` is uninitialized at index `i` in entry block `bb`. */
predicate uninitializedWrite(Cfg::EntryBasicBlock bb, int i, Variable v) {
  i = -1 and
  bb.getANode().getAstNode() = v
}

predicate parameterWrite(Cfg::EntryBasicBlock bb, int i, Parameter p) {
  bb.getNode(i).getAstNode() = p
}

/** Holds if `v` is read at index `i` in basic block `bb`. */
private predicate variableReadActual(Cfg::BasicBlock bb, int i, Variable v) {
  exists(VarReadAccess read |
    read.getVariable() = v and
    read = bb.getNode(i).getAstNode()
  )
}

cached
private module Cached {
  /**
   * Holds if `v` is written at index `i` in basic block `bb`, and the corresponding
   * AST write access is `write`.
   */
  cached
  predicate variableWriteActual(Cfg::BasicBlock bb, int i, Variable v, VarWriteAccessCfgNode write) {
    exists(Cfg::CfgNode n |
      write.getVariable() = v and
      n = bb.getNode(i)
    |
      write.isExplicitWrite(n)
      or
      write.isImplicitWrite() and
      n = write
    )
  }

  cached
  VarReadAccessCfgNode getARead(Definition def) {
    exists(Variable v, Cfg::BasicBlock bb, int i |
      Impl::ssaDefReachesRead(v, def, bb, i) and
      variableReadActual(bb, i, v) and
      result = bb.getNode(i)
    )
  }

  private import semmle.code.powershell.dataflow.Ssa

  cached
  Definition phiHasInputFromBlock(PhiNode phi, Cfg::BasicBlock bb) {
    Impl::phiHasInputFromBlock(phi, result, bb)
  }

  /**
   * Holds if the value defined at SSA definition `def` can reach a read at `read`,
   * without passing through any other non-pseudo read.
   */
  cached
  predicate firstRead(Definition def, VarReadAccessCfgNode read) {
    exists(Cfg::BasicBlock bb, int i | Impl::firstUse(def, bb, i, true) and read = bb.getNode(i))
  }

  /**
   * Holds if the read at `read2` is a read of the same SSA definition `def`
   * as the read at `read1`, and `read2` can be reached from `read1` without
   * passing through another non-pseudo read.
   */
  cached
  predicate adjacentReadPair(Definition def, VarReadAccessCfgNode read1, VarReadAccessCfgNode read2) {
    exists(Cfg::BasicBlock bb1, int i1, Cfg::BasicBlock bb2, int i2, Variable v |
      Impl::ssaDefReachesRead(v, def, bb1, i1) and
      Impl::adjacentUseUse(bb1, i1, bb2, i2, v, true) and
      read1 = bb1.getNode(i1) and
      read2 = bb2.getNode(i2)
    )
  }

  cached
  Definition uncertainWriteDefinitionInput(UncertainWriteDefinition def) {
    Impl::uncertainWriteDefinitionInput(def, result)
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

    signature predicate guardChecksSig(Cfg::CfgNodes::AstCfgNode g, Cfg::CfgNode e, boolean branch);

    cached // nothing is actually cached
    module BarrierGuard<guardChecksSig/3 guardChecks> {
      private predicate guardChecksAdjTypes(
        DataFlowIntegrationInput::Guard g, DataFlowIntegrationInput::Expr e, boolean branch
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

/** Gets the SSA definition node corresponding to parameter `p`. */
pragma[nomagic]
Definition getParameterDef(Parameter p) {
  exists(Cfg::BasicBlock bb, int i |
    bb.getNode(i).getAstNode() = p and
    result.definesAt(_, bb, i)
  )
}

private Parameter getANonPipelineParameter(FunctionBase f) {
  result = f.getAParameter() and
  not result instanceof PipelineParameter and
  not result instanceof PipelineByPropertyNameParameter
}

class NormalParameter extends Parameter {
  NormalParameter() {
    not this instanceof PipelineParameter and
    not this instanceof PipelineByPropertyNameParameter and
    not this instanceof ThisParameter
  }

  int getIndexExcludingPipelines() {
    exists(FunctionBase f |
      f = this.getFunction() and
      this =
        rank[result + 1](int index, Parameter p |
          p = getANonPipelineParameter(f) and index = p.getIndex()
        |
          p order by index
        )
    )
  }
}

private newtype TParameterExt =
  TNormalParameter(NormalParameter p) or
  TThisMethodParameter(Method m) or
  TPipelineParameter(PipelineParameter p) or
  TPipelineByPropertyNameParameter(PipelineByPropertyNameParameter p)

/** A normal parameter or an implicit `this` parameter. */
class ParameterExt extends TParameterExt {
  NormalParameter asParameter() { this = TNormalParameter(result) }

  Method asThis() { this = TThisMethodParameter(result) }

  PipelineParameter asPipelineParameter() { this = TPipelineParameter(result) }

  PipelineByPropertyNameParameter asPipelineByPropertyNameParameter() {
    this = TPipelineByPropertyNameParameter(result)
  }

  predicate isInitializedBy(WriteDefinition def) {
    def = getParameterDef(this.asParameter())
    or
    def = getParameterDef(this.asPipelineParameter())
    or
    def = getParameterDef(this.asPipelineByPropertyNameParameter())
    or
    def.(Ssa::ThisDefinition).getSourceVariable().getDeclaringScope() = this.asThis().getBody()
  }

  string toString() {
    result =
      [
        this.asParameter().toString(), this.asThis().toString(),
        this.asPipelineParameter().toString(), this.asPipelineByPropertyNameParameter().toString()
      ]
  }

  Location getLocation() {
    result =
      [
        this.asParameter().getLocation(), this.asThis().getLocation(),
        this.asPipelineParameter().getLocation(),
        this.asPipelineByPropertyNameParameter().getLocation()
      ]
  }
}

private module DataFlowIntegrationInput implements Impl::DataFlowIntegrationInputSig {
  class Expr extends Cfg::CfgNodes::ExprCfgNode {
    predicate hasCfgNode(SsaInput::BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  Expr getARead(Definition def) { result = Cached::getARead(def) }

  predicate ssaDefHasSource(WriteDefinition def) {
    any(ParameterExt p).isInitializedBy(def) or def.(Ssa::WriteDefinition).assigns(_)
  }

  class Guard extends Cfg::CfgNodes::AstCfgNode {
    /**
     * Holds if the control flow branching from `bb1` is dependent on this guard,
     * and that the edge from `bb1` to `bb2` corresponds to the evaluation of this
     * guard to `branch`.
     */
    predicate controlsBranchEdge(SsaInput::BasicBlock bb1, SsaInput::BasicBlock bb2, boolean branch) {
      this.hasBranchEdge(bb1, bb2, branch)
    }
    /**
     * Holds if the evaluation of this guard to `branch` corresponds to the edge
     * from `bb1` to `bb2`.
     */
    predicate hasBranchEdge(SsaInput::BasicBlock bb1, SsaInput::BasicBlock bb2, boolean branch) {
      exists(Cfg::SuccessorTypes::ConditionalSuccessor s |
        this.getBasicBlock() = bb1 and
        bb2 = bb1.getASuccessor(s) and
        s.getValue() = branch
      )
    }

    
  }

  /** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
  predicate guardDirectlyControlsBlock(Guard guard, SsaInput::BasicBlock bb, boolean branch) {
    none()
  }
}

private module DataFlowIntegrationImpl = Impl::DataFlowIntegration<DataFlowIntegrationInput>;
