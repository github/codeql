/**
 * Provides an implementation for constructing control-flow graphs (CFGs) from
 * abstract syntax trees (ASTs), using the shared library from `codeql.controlflow.Cfg`.
 */

private import powershell
private import codeql.controlflow.Cfg as CfgShared
private import semmle.code.powershell.controlflow.ControlFlowGraph
private import Completion

private module CfgInput implements CfgShared::InputSig<Location> {
  private import ControlFlowGraphImpl as Impl
  private import Completion as Comp
  private import Splitting as Splitting
  private import semmle.code.powershell.Cfg as Cfg

  class Completion = Comp::Completion;

  predicate completionIsNormal(Completion c) { c instanceof Comp::NormalCompletion }

  predicate completionIsSimple(Completion c) { c instanceof Comp::SimpleCompletion }

  predicate completionIsValidFor(Completion c, Ast e) { c.isValidFor(e) }

  class AstNode = Ast;

  class CfgScope = Cfg::CfgScope;

  CfgScope getCfgScope(Ast n) { result = Impl::getCfgScope(n) }

  predicate scopeFirst(CfgScope scope, Ast first) { scope.(Impl::CfgScope).entry(first) }

  predicate scopeLast(CfgScope scope, Ast last, Completion c) {
    scope.(Impl::CfgScope).exit(last, c)
  }

  class SplitKindBase = Splitting::TSplitKind;

  class Split = Splitting::Split;

  class SuccessorType = Cfg::SuccessorType;

  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  predicate successorTypeIsSimple(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::NormalSuccessor
  }

  predicate successorTypeIsCondition(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::ConditionalSuccessor
  }

  predicate isAbnormalExitType(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::RaiseSuccessor or
    t instanceof Cfg::SuccessorTypes::ExitSuccessor
  }
}

private import CfgInput
import CfgShared::Make<Location, CfgInput>

class CfgScope extends Scope {
  predicate entry(Ast first) { first(this, first) }

  predicate exit(Ast last, Completion c) { last(this, last, c) }
}

/** Holds if `first` is first executed when entering `scope`. */
pragma[nomagic]
predicate succEntry(CfgScope scope, Ast first) { scope.entry(first) }

/** Holds if `last` with completion `c` can exit `scope`. */
pragma[nomagic]
predicate succExit(CfgScope scope, Ast last, Completion c) { scope.exit(last, c) }

/** Defines the CFG by dispatch on the various AST types. */
module Trees {
  class NonDefaultParameterTree extends LeafTree instanceof Parameter {
    NonDefaultParameterTree() { not exists(super.getDefaultValue()) }
  }

  class DefaultParameterTree extends StandardPostOrderTree instanceof Parameter {
    DefaultParameterTree() { exists(super.getDefaultValue()) }

    override AstNode getChildNode(int i) {
      i = 0 and
      result = super.getDefaultValue()
    }

    final override predicate propagatesAbnormal(AstNode child) { child = super.getDefaultValue() }
  }

  class ParameterBlockTree extends StandardPostOrderTree instanceof ParamBlock {
    override AstNode getChildNode(int i) { result = super.getParameter(i) }
  }

  abstract class ScriptBlockTree extends ControlFlowTree instanceof ScriptBlock {
    abstract predicate succEntry(AstNode n, Completion c);

    override predicate last(AstNode last, Completion c) {
      last(super.getEndBlock(), last, c)
      or
      not exists(super.getEndBlock()) and
      last(super.getProcessBlock(), last, c)
      or
      not exists(super.getEndBlock()) and
      not exists(super.getProcessBlock()) and
      last(super.getBeginBlock(), last, c)
      or
      not exists(super.getEndBlock()) and
      not exists(super.getProcessBlock()) and
      not exists(super.getBeginBlock()) and
      last(super.getParamBlock(), last, c)
      or
      not exists(super.getEndBlock()) and
      not exists(super.getProcessBlock()) and
      not exists(super.getBeginBlock()) and
      not exists(super.getParamBlock()) and
      // No blocks at all. We end where we started
      this.succEntry(last, c)
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      this.succEntry(pred, c) and
      (
        first(super.getParamBlock(), succ)
        or
        not exists(super.getParamBlock()) and
        first(super.getBeginBlock(), succ)
        or
        not exists(super.getParamBlock()) and
        not exists(super.getBeginBlock()) and
        first(super.getProcessBlock(), succ)
        or
        not exists(super.getParamBlock()) and
        not exists(super.getBeginBlock()) and
        not exists(super.getProcessBlock()) and
        first(super.getEndBlock(), succ)
      )
      or
      last(super.getParamBlock(), pred, c) and
      completionIsNormal(c) and
      (
        first(super.getBeginBlock(), succ)
        or
        not exists(super.getBeginBlock()) and
        first(super.getProcessBlock(), succ)
        or
        not exists(super.getBeginBlock()) and
        not exists(super.getProcessBlock()) and
        first(super.getEndBlock(), succ)
      )
      or
      last(super.getBeginBlock(), pred, c) and
      completionIsNormal(c) and
      (
        first(super.getProcessBlock(), succ)
        or
        not exists(super.getProcessBlock()) and
        first(super.getEndBlock(), succ)
      )
      or
      last(super.getProcessBlock(), pred, c) and
      completionIsNormal(c) and
      (
        // If we process multiple items we will loop back to the process block
        first(super.getProcessBlock(), succ)
        or
        // Once we're done process all items we will go to the end block
        first(super.getEndBlock(), succ)
      )
    }

    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getParamBlock() or
      child = super.getBeginBlock() or
      child = super.getProcessBlock() or
      child = super.getEndBlock()
    }
  }

  class FunctionScriptBlockTree extends PreOrderTree, ScriptBlockTree {
    Function func;

    FunctionScriptBlockTree() { func.getBody() = this }

    AstNode getParameter(int i) { result = func.getFunctionParameter(i) }

    int getNumberOfParameters() { result = func.getNumberOfFunctionParameters() }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Step to the first parameter
      pred = this and
      first(this.getParameter(0), succ) and
      completionIsSimple(c)
      or
      // Step to the next parameter
      exists(int i |
        last(this.getParameter(i), pred, c) and
        completionIsNormal(c) and
        first(this.getParameter(i + 1), succ)
      )
      or
      // Body steps
      super.succ(pred, succ, c)
    }

    final override predicate succEntry(AstNode n, Completion c) {
      // If there are no paramters we enter the body directly
      not exists(this.getParameter(0)) and
      n = this and
      completionIsSimple(c)
      or
      // Once we are done with the last parameter we enter the body
      last(this.getParameter(this.getNumberOfParameters() - 1), n, c) and
      completionIsNormal(c)
    }
  }

  class TopLevelScriptBlockTree extends PreOrderTree, ScriptBlockTree {
    TopLevelScriptBlockTree() { this.(ScriptBlock).isTopLevel() }

    final override predicate succEntry(Ast n, Completion c) { n = this and completionIsSimple(c) }
  }

  class NamedBlockTree extends StandardPostOrderTree instanceof NamedBlock {
    // TODO: Handle trap
    override AstNode getChildNode(int i) { result = super.getStatement(i) }
  }

  class AssignStmtTree extends StandardPostOrderTree instanceof AssignStmt {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getLeftHandSide()
      or
      i = 1 and result = super.getRightHandSide()
    }
  }

  class StmtBlockTree extends PreOrderTree instanceof StmtBlock {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getAStmt() }

    final override predicate last(AstNode last, Completion c) {
      last(super.getStmt(super.getNumberOfStmts() - 1), last, c)
      or
      not exists(super.getAStmt()) and
      last = this and
      completionIsSimple(c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      this = pred and
      first(super.getStmt(0), succ) and
      completionIsSimple(c)
      or
      exists(int i |
        last(super.getStmt(i), pred, c) and
        completionIsNormal(c) and
        first(super.getStmt(i + 1), succ)
      )
    }
  }

  class GotoStmtTree extends LeafTree instanceof GotoStmt { }

  class FunctionStmtTree extends LeafTree instanceof Function { }

  class VarAccessTree extends LeafTree instanceof VarAccess { }

  class BinaryExprTree extends StandardPostOrderTree instanceof BinaryExpr {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getLeft()
      or
      i = 1 and result = super.getRight()
    }
  }

  class UnaryExprTree extends StandardPostOrderTree instanceof UnaryExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getOperand() }
  }

  class ArrayLiteralTree extends StandardPostOrderTree instanceof ArrayLiteral {
    override AstNode getChildNode(int i) { result = super.getElement(i) }
  }

  class ConstExprTree extends LeafTree instanceof ConstExpr { }

  class CmdExprTree extends StandardPreOrderTree instanceof CmdExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class PipelineTree extends StandardPreOrderTree instanceof Pipeline {
    override AstNode getChildNode(int i) { result = super.getComponent(i) }
  }
}

private import Scope

cached
private CfgScope getCfgScopeImpl(Ast n) { result = scopeOf(n) }

/** Gets the CFG scope of node `n`. */
pragma[inline]
CfgScope getCfgScope(Ast n) {
  exists(Ast n0 |
    pragma[only_bind_into](n0) = n and
    pragma[only_bind_into](result) = getCfgScopeImpl(n0)
  )
}

cached
private module Cached {
  cached
  newtype TSuccessorType =
    TSuccessorSuccessor() or
    TBooleanSuccessor(boolean b) { b in [false, true] } or
    TReturnSuccessor() or
    TBreakSuccessor() or
    TContinueSuccessor() or
    TRaiseSuccessor() or
    TExitSuccessor()
}

import Cached
