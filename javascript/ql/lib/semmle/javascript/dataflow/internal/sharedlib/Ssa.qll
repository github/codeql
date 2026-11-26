/**
 * Instantiates the shared SSA library for JavaScript data flow.
 *
 * Refinements are value-preserving uncertain writes, so shared SSA routes flow
 * through refinements and their phi inputs. Phi definitions are retained to
 * preserve the JavaScript SSA definition-node API.
 * Post-update reads are placed at operation completion so updates propagate
 * past argument and right-hand-side evaluation without revisiting earlier reads.
 */
overlay[local?]
module;

private import javascript as js
private import codeql.ssa.Ssa
private import semmle.javascript.dataflow.internal.VariableOrThis
private import semmle.javascript.dataflow.Refinements as Refinements

// Project away use and write witnesses before joining them with capture points.
pragma[noinline]
private predicate capturedReadInContainer(js::LocalVariable local, js::StmtContainer container) {
  local.isCaptured() and
  any(js::VarUse use | use.getVariable() = local).getContainer() = container
}

pragma[noinline]
private predicate hasExternalWrite(js::LocalVariable local) {
  local.getAnAccess().(js::LValue).getContainer() != local.getDeclaringContainer()
}

pragma[noinline]
private predicate capturePoint(
  js::Cfg::BasicBlock bb, int i, js::ControlFlowNode node, js::StmtContainer container
) {
  node = bb.getNode(i) and
  container = bb.getContainer() and
  (
    node instanceof js::ControlFlowEntryNode or
    node instanceof js::YieldExpr or
    node instanceof js::InvokeExpr
  )
}

private predicate captureAt(js::Cfg::BasicBlock bb, int i, SsaConfig::SourceVariable v) {
  exists(js::LocalVariable local, js::StmtContainer container, js::ControlFlowNode node |
    local = v.asLocalVariable() and
    capturePoint(bb, i, node, container) and
    capturedReadInContainer(local, container)
  |
    node instanceof js::ControlFlowEntryNode and
    container != local.getDeclaringContainer()
    or
    node instanceof js::YieldExpr and
    (
      container != local.getDeclaringContainer() or
      hasExternalWrite(local)
    )
    or
    node instanceof js::InvokeExpr and
    hasExternalWrite(local)
  )
}

private predicate refinementAt(js::Cfg::BasicBlock bb, int i, SsaConfig::SourceVariable v) {
  bb.getNode(i).(js::GuardControlFlowNode).getTest().(Refinements::Refinement).getRefinedVar() =
    v.asLocalVariable()
}

private predicate explicitVariableRead(js::ControlFlowNode read, SsaConfig::SourceVariable v) {
  read.(js::VarUse).getVariable() = v.asLocalVariable()
  or
  exists(ThisUse use, js::StmtContainer container |
    use = read and
    container = v.asThisContainer() and
    use.getBindingContainer() = container and
    use.getUseContainer() = container
  )
}

/** Gets an operation that may update the object evaluated at `read`. */
private js::ControlFlowNode postUpdateOperation(js::ControlFlowNode read) {
  exists(js::InvokeExpr call | read = call.getAnArgument() or read = call.getCallee() |
    result = call
  )
  or
  exists(js::PropAccess access | read = access.getBase() |
    result.(js::VarDef).getTarget() = access
    or
    result.(js::MethodCallExpr).getCallee().stripParens() = access
    or
    not exists(js::VarDef definition | definition.getTarget() = access) and
    not exists(js::MethodCallExpr call | call.getCallee().stripParens() = access) and
    result = access
  )
  or
  result.(js::AwaitExpr).getOperand() = read
  or
  exists(js::Assignment assignment |
    assignment.getTarget() instanceof js::PropAccess and
    assignment.getRhs() = read and
    result = assignment
  )
  or
  read instanceof ImplicitThisUse and
  read instanceof js::FieldDefinition and
  result = read
}

pragma[nomagic]
private int maxUseInBlock(js::Cfg::BasicBlock bb, js::LocalVariable local) {
  result = max(int j | bb.useAt(j, local, _))
}

// Post-update reads should only be materialized when the variable may be read afterwards.
bindingset[bb, i, v]
private predicate liveAfterOperation(js::Cfg::BasicBlock bb, int i, SsaConfig::SourceVariable v) {
  exists(v.asThisContainer())
  or
  exists(js::LocalVariable local | local = v.asLocalVariable() |
    if bb.defAt(_, local, _)
    then (
      exists(int j |
        j > i and
        bb.useAt(j, local, _) and
        not exists(int k | i < k and k < j | bb.defAt(k, local, _))
      )
      or
      not exists(int k | k > i | bb.defAt(k, local, _)) and
      bb.getASuccessor().localIsLiveAtEntry(local)
    ) else (
      i < maxUseInBlock(bb, local)
      or
      bb.getASuccessor().localIsLiveAtEntry(local)
    )
  )
}

pragma[nomagic]
private predicate uncapturedExplicitRead(
  js::ControlFlowNode read, SsaConfig::SourceVariable v, js::Cfg::BasicBlock readBlock,
  int readIndex
) {
  readBlock instanceof js::ReachableBasicBlock and
  (
    exists(js::LocalVariable local |
      local = v.asLocalVariable() and
      not local.isCaptured() and
      readBlock.useAt(readIndex, local, read)
    )
    or
    not v.isCaptured() and
    exists(v.asThisContainer()) and
    explicitVariableRead(read, v) and
    read = readBlock.getNode(readIndex)
  )
}

pragma[nomagic]
private predicate rawPostUpdate(
  js::ControlFlowNode read, SsaConfig::SourceVariable v, js::Cfg::BasicBlock readBlock,
  int readIndex, js::Cfg::BasicBlock bb, int i
) {
  uncapturedExplicitRead(read, v, readBlock, readIndex) and
  postUpdateOperation(read) = bb.getNode(i) and
  bb instanceof js::ReachableBasicBlock
}

pragma[nomagic]
private predicate rawPostUpdateAt(js::Cfg::BasicBlock bb, int i, SsaConfig::SourceVariable v) {
  rawPostUpdate(_, v, _, _, bb, i)
}

module SsaConfig implements InputSig<js::Location, js::Cfg::BasicBlock> {
  class SourceVariable extends LocalVariableOrThis {
    SourceVariable() { exists(this.asLocalVariable()) or not this.isCaptured() }
  }

  pragma[nomagic]
  private js::EntryBasicBlock getEntryBlock(js::StmtContainer container) {
    result.getContainer() = container
  }

  predicate variableWrite(js::Cfg::BasicBlock bb, int i, SourceVariable v, boolean certain) {
    bb instanceof js::ReachableBasicBlock and
    (
      certain = true and
      (
        bb.defAt(i, v.asLocalVariable(), _)
        or
        // Implicit initialization
        bb = getEntryBlock(v.getDeclaringContainer().getFunctionBoundary()) and
        i = -1
        or
        captureAt(bb, i, v)
      )
      or
      // Refinements preserve the input value but introduce a new SSA definition.
      certain = false and
      refinementAt(bb, i, v)
    )
  }

  predicate variableRead(js::Cfg::BasicBlock bb, int i, SourceVariable v, boolean certain) {
    bb instanceof js::ReachableBasicBlock and
    (
      certain = true and
      explicitVariableRead(bb.getNode(i), v)
      or
      // Closures can observe captured writes without a subsequent local read.
      certain = false and
      v.asLocalVariable().isCaptured() and
      (
        bb.defAt(i - 1, v.asLocalVariable(), _)
        or
        i = 0 and
        bb = getEntryBlock(v.getDeclaringContainer().getFunctionBoundary())
      )
    )
  }

  predicate postUpdateRead(js::Cfg::BasicBlock bb, int i, SourceVariable v) {
    rawPostUpdateAt(bb, i, v) and
    liveAfterOperation(bb, i, v)
  }

  predicate ssaCachedStageRevRef() {
    DataFlowIntegrationImpl::ssaCachedStageRevRef2() and
    // Keep the JavaScript adapters in the same cached stage as their shared inputs.
    (exists(any(js::SsaPseudoDefinition def).getAnInput()) implies any())
  }
}

import Make<js::Location, js::Cfg, SsaConfig>

pragma[nomagic]
js::ControlFlowNode getARead(Definition def) {
  exists(SsaConfig::SourceVariable v, js::Cfg::BasicBlock bb, int i |
    ssaDefReachesRead(v, def, bb, i) and
    SsaConfig::variableRead(bb, i, v, true) and
    bb.getNode(i) = result
  )
}

module SsaDataflowInput implements DataFlowIntegrationInputSig {
  private import codeql.util.Boolean

  predicate ssaDefHasSource(WriteDefinition def) {
    exists(SsaConfig::SourceVariable v, js::Cfg::BasicBlock bb, int i |
      def.definesAt(v, bb, i) and
      (
        exists(js::VarDef write |
          bb.defAt(i, v.asLocalVariable(), write) and
          write.getTarget() instanceof js::VarRef and
          exists(write.getSource())
        )
        or
        i = -1 and exists(v.asThisContainer())
      )
    )
  }

  predicate allowFlowIntoUncertainDef(UncertainWriteDefinition def) { any() }

  predicate uncertainWritePreservesValue(UncertainWriteDefinition def) {
    isRefinementDefinition(def)
  }

  predicate includePhiDefsInFlowStep() { any() }

  // Inferred values depend on this SSA graph, so branch feasibility must remain syntactic.
  private predicate createsObject(js::Expr value) {
    value.getUnderlyingValue() instanceof js::ObjectExpr or
    value.getUnderlyingValue() instanceof js::ArrayExpr or
    value.getUnderlyingValue() instanceof js::Function or
    value.getUnderlyingValue() instanceof js::ClassDefinition or
    value.getUnderlyingValue() instanceof js::RegExpLiteral or
    value.getUnderlyingValue() instanceof js::NewExpr
  }

  private predicate isKnownTruthy(js::Expr value) {
    createsObject(value)
    or
    value.getUnderlyingValue().(js::BooleanLiteral).getBoolValue() = true
    or
    value.getUnderlyingValue().(js::NumberLiteral).getValue().toFloat() != 0
    or
    value.getUnderlyingValue().(js::StringLiteral).getStringValue() != ""
  }

  private predicate isKnownFalsy(js::Expr value) {
    value.getUnderlyingValue() instanceof js::NullLiteral or
    value.getUnderlyingValue() instanceof js::SyntacticConstants::UndefinedConstant or
    value.getUnderlyingValue().(js::BooleanLiteral).getBoolValue() = false or
    value.getUnderlyingValue().(js::NumberLiteral).getValue().toFloat() = 0 or
    value.getUnderlyingValue().(js::StringLiteral).getStringValue() = ""
  }

  /** Gets a variable or `this` read supplying `value`, excluding tests and discarded operands. */
  private js::Expr getAValueInput(js::Expr value) {
    result = value.getUnderlyingValue() and
    explicitVariableRead(result, _)
    or
    exists(js::ConditionalExpr conditional | conditional = value.getUnderlyingValue() |
      not isKnownFalsy(conditional.getCondition()) and
      result = getAValueInput(conditional.getConsequent())
      or
      not isKnownTruthy(conditional.getCondition()) and
      result = getAValueInput(conditional.getAlternate())
    )
    or
    exists(js::LogicalOrExpr logical | logical = value.getUnderlyingValue() |
      result = getAValueInput(logical.getLeftOperand())
      or
      not isKnownTruthy(logical.getLeftOperand()) and
      result = getAValueInput(logical.getRightOperand())
    )
    or
    exists(js::NullishCoalescingExpr coalescing | coalescing = value.getUnderlyingValue() |
      result = getAValueInput(coalescing.getLeftOperand())
      or
      not createsObject(coalescing.getLeftOperand()) and
      not coalescing.getLeftOperand().getUnderlyingValue() instanceof
        js::SyntacticConstants::PrimitiveLiteralConstant and
      result = getAValueInput(coalescing.getRightOperand())
    )
    or
    exists(js::LogicalAndExpr logical | logical = value.getUnderlyingValue() |
      not isKnownFalsy(logical.getLeftOperand()) and
      result = getAValueInput(logical.getRightOperand())
    )
  }

  private predicate preservingInput(Definition after, Definition input) {
    uncertainWriteDefinitionInput(after, input)
    or
    phiHasInputFromBlock(after, input, _)
    or
    exists(
      SsaConfig::SourceVariable v, js::BasicBlock bb, int i, js::VarDef write, js::Expr read,
      js::BasicBlock readBlock, int readIndex
    |
      after.definesAt(v, bb, i) and
      bb.defAt(i, v.asLocalVariable(), write) and
      write.getTarget() instanceof js::VarRef and
      read = getAValueInput(write.getSource()) and
      read = readBlock.getNode(readIndex) and
      explicitVariableRead(read, input.getSourceVariable()) and
      ssaDefReachesRead(input.getSourceVariable(), input, readBlock, readIndex)
    )
  }

  /** Holds if `after` can still refer to the object represented by `before`. */
  additional predicate preservesDefinition(Definition before, Definition after) {
    before = after
    or
    exists(Definition input |
      preservingInput(after, input) and
      preservesDefinition(before, input)
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

  overlay[caller?]
  pragma[inline]
  predicate guardDirectlyControlsBlock(Guard guard, js::Cfg::BasicBlock bb, GuardValue branch) {
    exists(js::ConditionGuardNode g |
      g.getTest() = guard and
      g.dominates(bb) and
      branch = g.getOutcome()
    )
  }
}

private module DataFlowIntegrationImpl = DataFlowIntegration<SsaDataflowInput>;

import DataFlowIntegrationImpl

/** Holds if `definition` represents a conservative capture or recapture. */
predicate isCaptureDefinition(Definition definition) {
  exists(SsaConfig::SourceVariable variable, js::Cfg::BasicBlock bb, int i |
    definition.definesAt(variable, bb, i) and
    captureAt(bb, i, variable)
  )
}

/** Holds if `definition` represents a value-preserving refinement. */
predicate isRefinementDefinition(Definition definition) {
  definition instanceof UncertainWriteDefinition
}

/** Holds if `read` is an original variable or `this` read. */
predicate isExplicitRead(js::ControlFlowNode read) { explicitVariableRead(read, _) }

pragma[nomagic]
private predicate livePostUpdate(
  js::ControlFlowNode read, SsaConfig::SourceVariable v, js::Cfg::BasicBlock readBlock,
  int readIndex, js::Cfg::BasicBlock bb, int i
) {
  rawPostUpdate(read, v, readBlock, readIndex, bb, i) and
  SsaConfig::postUpdateRead(bb, i, v)
}

pragma[nomagic]
private predicate sameBlockUnchangedPostUpdate(
  js::ControlFlowNode read, js::Cfg::BasicBlock bb, int i, SsaConfig::SourceVariable v
) {
  exists(js::Cfg::BasicBlock readBlock, int readIndex |
    livePostUpdate(read, v, readBlock, readIndex, bb, i) and
    (
      exists(v.asThisContainer())
      or
      readBlock = bb and
      readIndex <= i and
      not exists(int k | readIndex < k and k <= i and SsaConfig::variableWrite(bb, k, v, _))
    )
  )
}

pragma[nomagic]
private predicate candidateSlowPostUpdate(
  js::ControlFlowNode read, SsaConfig::SourceVariable v, js::Cfg::BasicBlock readBlock,
  int readIndex, js::Cfg::BasicBlock bb, int i
) {
  livePostUpdate(read, v, readBlock, readIndex, bb, i) and
  not sameBlockUnchangedPostUpdate(read, bb, i, v)
}

pragma[nomagic]
private predicate ssaDefReachesPostUpdate(
  SsaConfig::SourceVariable v, Definition after, js::Cfg::BasicBlock bb, int i
) {
  candidateSlowPostUpdate(_, v, _, _, bb, i) and
  (
    exists(int lastIdx |
      lastIdx = max(int k | any(Definition d).definesAt(v, bb, k) and k <= i) and
      after.definesAt(v, bb, lastIdx)
    )
    or
    not exists(Definition d, int k | d.definesAt(v, bb, k) and k <= i) and
    ssaDefReachesEndOfBlock(bb.getImmediateDominator(), after, v)
  )
}

/**
 * Holds if `read`'s post-update completes at node `i` of `bb` without `v`
 * being reassigned to a distinct object before completion.
 */
predicate postUpdateCfgNode(
  js::ControlFlowNode read, js::Cfg::BasicBlock bb, int i, SsaConfig::SourceVariable v
) {
  sameBlockUnchangedPostUpdate(read, bb, i, v)
  or
  exists(Definition before, Definition after, js::Cfg::BasicBlock readBlock, int readIndex |
    candidateSlowPostUpdate(read, v, readBlock, readIndex, bb, i) and
    ssaDefReachesRead(v, before, readBlock, readIndex) and
    ssaDefReachesPostUpdate(v, after, bb, i) and
    // A later argument may have reassigned the variable to a different object.
    SsaDataflowInput::preservesDefinition(before, after)
  )
}

/**
 * Holds if `post` completes an operation using `read` where `v` now holds `after`,
 * and global flow should consult modeled value-flow steps to check preservation.
 */
predicate additionalPostUpdate(ReadNode read, PostUpdateReadNode post, Definition after) {
  exists(
    js::Cfg::BasicBlock readBlock, int readIndex, js::Cfg::BasicBlock bb, int i,
    SsaConfig::SourceVariable v, js::ControlFlowNode readCfg
  |
    candidateSlowPostUpdate(readCfg, v, readBlock, readIndex, bb, i) and
    not postUpdateCfgNode(readCfg, bb, i, v) and
    read.readsAt(readBlock, readIndex, v) and
    post.readsAt(bb, i, v) and
    ssaDefReachesPostUpdate(v, after, bb, i)
  )
}
