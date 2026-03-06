/**
 * Provides an SSA (Static Single Assignment) implementation for PHP.
 */

private import codeql.ssa.Ssa as SsaImplCommon
private import codeql.php.AST
private import codeql.php.controlflow.ControlFlowGraph as Cfg
private import codeql.php.controlflow.BasicBlocks as BasicBlocks
private import codeql.php.controlflow.internal.ControlFlowGraphImpl as CfgImpl

private class BasicBlock = BasicBlocks::Cfg::BasicBlock;

/**
 * A local variable, identified by name and scope. In PHP, variables within a function
 * or program scope are local to that scope; this class provides the source variable
 * for SSA analysis.
 */
class PhpLocalVariable extends VariableName {
  Cfg::CfgScope scope;

  PhpLocalVariable() {
    scope = CfgImpl::getCfgScope(this)
  }

  /** Gets the name of this variable. */
  string getVariableName() { result = this.getValue() }

  /** Gets the scope of this variable. */
  Cfg::CfgScope getScope() { result = scope }

  /** Gets a textual representation. */
  override string toString() { result = this.getValue() }
}

/**
 * A source variable for SSA, identified by variable name and scope.
 * Multiple `VariableName` AST nodes may refer to the same source variable
 * if they have the same name and are in the same scope.
 */
class SsaSourceVariable extends string {
  Cfg::CfgScope scope;

  SsaSourceVariable() {
    exists(VariableName vn |
      this = vn.getValue() and
      scope = CfgImpl::getCfgScope(vn)
    )
  }

  /** Gets the variable name. */
  string getVariableName() { result = this }

  /** Gets the scope. */
  Cfg::CfgScope getScope() { result = scope }

  /** Gets a location for this source variable (the first occurrence). */
  Location getLocation() {
    result =
      min(VariableName vn |
        vn.getValue() = this and CfgImpl::getCfgScope(vn) = scope
      |
        vn.getLocation()
        order by
          vn.getLocation().getStartLine(), vn.getLocation().getStartColumn()
      )
  }

  string toString() { result = this }
}

/** Gets the source variable for a `VariableName` AST node. */
SsaSourceVariable getSourceVariable(VariableName vn) {
  result = vn.getValue() and
  result.getScope() = CfgImpl::getCfgScope(vn)
}

module SsaInput implements SsaImplCommon::InputSig<Location, BasicBlock> {
  class SourceVariable = SsaSourceVariable;

  /**
   * Holds if the CFG node at index `i` of basic block `bb` writes to variable `v`.
   */
  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    exists(Cfg::CfgNode cfgNode, VariableName vn |
      cfgNode = bb.getNode(i) and
      vn = cfgNode.getAstNode() and
      v = getSourceVariable(vn)
    |
      // Direct assignment: $x = ...
      exists(AssignExpr assign | assign.getLeftOperand() = vn)
      or
      // Reference assignment: $x =& ...
      exists(RefAssignExpr assign | assign.getLeftOperand() = vn)
      or
      // Augmented assignment: $x += ...
      exists(AugmentedAssignExpr assign | assign.getLeftOperand() = vn)
      or
      // Update expression: $x++ / $x--
      exists(UpdateExpr upd | upd.getArgument() = vn)
      or
      // Foreach value/key variable
      exists(ForeachStmt foreach | foreach.getChild(_) = vn)
      or
      // Catch variable binding
      exists(CatchClause cc | cc.getVariable() = vn)
      or
      // Global declaration
      exists(GlobalDeclaration gd | gd.getAVariable() = vn)
    ) and
    certain = true
    or
    // Parameter initialization at entry block
    exists(Cfg::CfgNode cfgNode, VariableName vn, Parameter p |
      cfgNode = bb.getNode(i) and
      vn = cfgNode.getAstNode() and
      v = getSourceVariable(vn) and
      p.getChild(_) = vn and
      p.getParent+() instanceof Callable
    ) and
    certain = true
  }

  /**
   * Holds if the CFG node at index `i` of basic block `bb` reads variable `v`.
   */
  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    exists(Cfg::CfgNode cfgNode, VariableName vn |
      cfgNode = bb.getNode(i) and
      vn = cfgNode.getAstNode() and
      v = getSourceVariable(vn) and
      // A read is a use that isn't a pure write target
      not exists(AssignExpr assign | assign.getLeftOperand() = vn) and
      not exists(RefAssignExpr assign | assign.getLeftOperand() = vn) and
      not (
        exists(AugmentedAssignExpr assign | assign.getLeftOperand() = vn)
      ) and
      not exists(CatchClause cc | cc.getVariable() = vn) and
      not exists(GlobalDeclaration gd | gd.getAVariable() = vn)
    ) and
    certain = true
  }
}

import SsaImplCommon::Make<Location, BasicBlocks::Cfg, SsaInput> as Impl

class Definition = Impl::Definition;

class WriteDefinition = Impl::WriteDefinition;

class UncertainWriteDefinition = Impl::UncertainWriteDefinition;

class PhiNode = Impl::PhiNode;

module Consistency = Impl::Consistency;

/**
 * Gets a CFG node that reads the variable defined by `def`.
 */
Cfg::CfgNode getARead(Definition def) {
  exists(SsaSourceVariable v, BasicBlocks::BasicBlock bb, int i |
    Impl::ssaDefReachesRead(v, def, bb, i) and
    SsaInput::variableRead(bb, i, v, _) and
    result = bb.getNode(i)
  )
}

/**
 * Gets an input definition to phi node `phi` from basic block `bb`.
 */
Definition phiHasInputFromBlock(PhiNode phi, BasicBlocks::BasicBlock bb) {
  Impl::phiHasInputFromBlock(phi, result, bb)
}
