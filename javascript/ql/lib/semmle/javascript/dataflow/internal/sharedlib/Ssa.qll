/**
 * Instantiates the shared SSA library for JavaScript, but only to establish use-use flow.
 *
 * JavaScript's old SSA library is still responsible for the ordinary SSA flow.
 */

private import javascript as js
private import codeql.ssa.Ssa
private import semmle.javascript.internal.BasicBlockInternal as BasicBlockInternal
private import semmle.javascript.dataflow.internal.VariableOrThis

module SsaConfig implements InputSig<js::Location, js::Cfg::BasicBlock> {
  class SourceVariable extends LocalVariableOrThis {
    SourceVariable() { not this.isCaptured() }
  }

  pragma[nomagic]
  private js::EntryBasicBlock getEntryBlock(js::StmtContainer container) {
    result.getContainer() = container
  }

  predicate variableWrite(js::Cfg::BasicBlock bb, int i, SourceVariable v, boolean certain) {
    certain = true and
    (
      bb.defAt(i, v.asLocalVariable(), _)
      or
      // Implicit initialization and function parameters
      bb = getEntryBlock(v.getDeclaringContainer()) and
      i = -1
    )
  }

  predicate variableRead(js::Cfg::BasicBlock bb, int i, SourceVariable v, boolean certain) {
    bb.useAt(i, v.asLocalVariable(), _) and certain = true
    or
    certain = true and
    bb.getNode(i).(ThisUse).getBindingContainer() = v.asThisContainer()
  }
}

import Make<js::Location, js::Cfg, SsaConfig>

module SsaDataflowInput implements DataFlowIntegrationInputSig {
  private import codeql.util.Boolean

  class Expr extends js::ControlFlowNode {
    Expr() { this = any(SsaConfig::SourceVariable v).getAUse() }

    predicate hasCfgNode(js::Cfg::BasicBlock bb, int i) { this = bb.getNode(i) }
  }

  predicate ssaDefHasSource(WriteDefinition def) {
    // This library only handles use-use flow after a post-update, there are no definitions, only uses.
    none()
  }

  cached
  Expr getARead(Definition def) {
    // Copied from implementation so we can cache it here
    exists(SsaConfig::SourceVariable v, js::BasicBlock bb, int i |
      ssaDefReachesRead(v, def, bb, i) and
      SsaConfig::variableRead(bb, i, v, true) and
      result.hasCfgNode(bb, i)
    )
  }

  class GuardValue = Boolean;

  class Guard extends js::ControlFlowNode {
    Guard() { this = any(js::ConditionGuardNode g).getTest() }

    /**
     * Holds if the evaluation of this guard to `branch` corresponds to the edge
     * from `bb1` to `bb2`.
     */
    predicate hasValueBranchEdge(js::Cfg::BasicBlock bb1, js::Cfg::BasicBlock bb2, GuardValue branch) {
      exists(js::ConditionGuardNode g |
        g.getTest() = this and
        bb1 = this.getBasicBlock() and
        bb2 = g.getBasicBlock() and
        branch = g.getOutcome()
      )
    }

    /**
     * Holds if this guard evaluating to `branch` controls the control-flow
     * branch edge from `bb1` to `bb2`. That is, following the edge from
     * `bb1` to `bb2` implies that this guard evaluated to `branch`.
     */
    predicate valueControlsBranchEdge(
      js::Cfg::BasicBlock bb1, js::Cfg::BasicBlock bb2, GuardValue branch
    ) {
      this.hasValueBranchEdge(bb1, bb2, branch)
    }
  }

  pragma[inline]
  predicate guardDirectlyControlsBlock(Guard guard, js::Cfg::BasicBlock bb, GuardValue branch) {
    exists(js::ConditionGuardNode g |
      g.getTest() = guard and
      g.dominates(bb) and
      branch = g.getOutcome()
    )
  }
}

import DataFlowIntegration<SsaDataflowInput>
