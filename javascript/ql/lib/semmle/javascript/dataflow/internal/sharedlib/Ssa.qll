/**
 * Instantiates the shared SSA library for JavaScript data flow.
 *
 * Refinements are value-preserving uncertain writes, so shared SSA routes flow
 * through refinements and their phi inputs. Phi definitions are retained to
 * preserve the JavaScript SSA definition-node API.
 * Synthetic reads at operation completion carry post-updates past argument
 * and right-hand-side evaluation without changing the earlier expression values.
 */
overlay[local?]
module;

private import javascript as js
private import codeql.ssa.Ssa
private import semmle.javascript.internal.BasicBlockInternal as BasicBlockInternal
private import semmle.javascript.dataflow.internal.VariableOrThis
private import semmle.javascript.dataflow.Refinements as Refinements

private predicate captureAt(js::Cfg::BasicBlock bb, int i, SsaConfig::SourceVariable v) {
  exists(js::LocalVariable local, js::StmtContainer container |
    local = v.asLocalVariable() and
    local.isCaptured() and
    container = bb.getContainer() and
    any(js::VarUse use | use.getVariable() = local).getContainer() = container
  |
    bb.getNode(i) instanceof js::ControlFlowEntryNode and
    container != local.getDeclaringContainer()
    or
    bb.getNode(i) instanceof js::YieldExpr and
    (
      container != local.getDeclaringContainer() or
      local.getAnAccess().(js::LValue).getContainer() != local.getDeclaringContainer()
    )
    or
    bb.getNode(i) instanceof js::InvokeExpr and
    local.getAnAccess().(js::LValue).getContainer() != local.getDeclaringContainer()
  )
}

private predicate refinementAt(js::Cfg::BasicBlock bb, int i, SsaConfig::SourceVariable v) {
  bb.getNode(i).(js::GuardControlFlowNode).getTest().(Refinements::Refinement).getRefinedVar() =
    v.asLocalVariable()
}

private predicate explicitVariableRead(js::ControlFlowNode read, SsaConfig::SourceVariable v) {
  read.(js::VarUse).getVariable() = v.asLocalVariable()
  or
  read.(ThisUse).getBindingContainer() = v.asThisContainer()
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
    not exists(js::VarDef definition | definition.getTarget() = access) and
    result = access
    or
    access = any(js::CompoundAssignExpr assignment).getTarget() and
    result = access
    or
    access = any(js::UpdateExpr update).getOperand().getUnderlyingReference() and
    result = access
    or
    result.(js::MethodCallExpr).getCallee() = access
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

// Continuations must not make otherwise dead variable definitions live.
bindingset[bb, i, v]
private predicate liveAfterOperation(js::Cfg::BasicBlock bb, int i, SsaConfig::SourceVariable v) {
  exists(v.asThisContainer())
  or
  exists(js::LocalVariable local |
    local = v.asLocalVariable() and
    (
      exists(int j |
        j > i and
        bb.useAt(j, local, _) and
        not exists(int k | i < k and k < j | bb.defAt(k, local, _))
      )
      or
      not exists(int k | k > i | bb.defAt(k, local, _)) and
      bb.getASuccessor().localIsLiveAtEntry(local)
    )
  )
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
      (
        explicitVariableRead(bb.getNode(i), v)
        or
        not v.isCaptured() and
        liveAfterOperation(bb, i, v) and
        exists(js::ControlFlowNode read |
          explicitVariableRead(read, v) and
          postUpdateOperation(read) = bb.getNode(i)
        )
      )
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
}

import Make<js::Location, js::Cfg, SsaConfig>

module SsaDataflowInput implements DataFlowIntegrationInputSig {
  private import codeql.util.Boolean

  class Expr extends js::ControlFlowNode {
    Expr() {
      this = any(SsaConfig::SourceVariable v).getAUse()
      or
      exists(js::ControlFlowNode read |
        explicitVariableRead(read, _) and
        this = postUpdateOperation(read)
      )
    }

    predicate hasCfgNode(js::Cfg::BasicBlock bb, int i) { this = bb.getNode(i) }
  }

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

  /** Gets an expression supplying `value`, excluding tests and discarded operands. */
  private js::Expr getAValueInput(js::Expr value) {
    result = value.getUnderlyingValue()
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
  private predicate preservesDefinition(Definition before, Definition after) {
    before = after
    or
    exists(Definition input |
      preservingInput(after, input) and
      preservesDefinition(before, input)
    )
  }

  predicate postUpdateCfgNode(Expr read, js::Cfg::BasicBlock bb, int i) {
    postUpdateOperation(read) = bb.getNode(i) and
    exists(
      SsaConfig::SourceVariable v, Definition before, Definition after, js::BasicBlock readBlock,
      int readIndex
    |
      explicitVariableRead(read, v) and
      read = readBlock.getNode(readIndex) and
      ssaDefReachesRead(v, before, readBlock, readIndex) and
      SsaConfig::variableRead(bb, i, v, true) and
      ssaDefReachesRead(v, after, bb, i) and
      // A later argument may have reassigned the variable to a different object.
      preservesDefinition(before, after)
    )
  }

  /**
   * Holds if early SSA did not establish preservation and global flow should
   * consult its modeled value-flow steps.
   */
  additional predicate additionalPostUpdateCfgNode(Expr read, js::Cfg::BasicBlock bb, int i) {
    postUpdateOperation(read) = bb.getNode(i) and
    not postUpdateCfgNode(read, bb, i) and
    exists(SsaConfig::SourceVariable v |
      explicitVariableRead(read, v) and
      ssaDefReachesRead(v, _, bb, i)
    )
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

import DataFlowIntegration<SsaDataflowInput>

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

/** Holds if `read` is an original variable or `this` read, not a continuation reference. */
predicate isExplicitRead(SsaDataflowInput::Expr read) { explicitVariableRead(read, _) }

/** Holds if `read` is a synthetic continuation at a potentially mutating operation. */
predicate isPostUpdateRead(ExprNode read) {
  not explicitVariableRead(read.getExpr(), read.getSourceVariable())
}

/**
 * Holds if `continuation` follows an operation using `read`, but early SSA did
 * not connect the post-update to that continuation's subsequent references.
 */
predicate additionalPostUpdateContinuation(ExprNode read, ExprNode continuation) {
  explicitVariableRead(read.getExpr(), read.getSourceVariable()) and
  continuation.getExpr() = postUpdateOperation(read.getExpr()) and
  isPostUpdateRead(continuation) and
  exists(js::Cfg::BasicBlock bb, int i |
    continuation.(ReadNode).readsAt(bb, i, read.getSourceVariable()) and
    SsaDataflowInput::additionalPostUpdateCfgNode(read.getExpr(), bb, i)
  )
}
