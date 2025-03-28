/**
 * Provides an implementation for constructing control-flow graphs (CFGs) from
 * abstract syntax trees (ASTs), using the shared library from `codeql.controlflow.Cfg`.
 */

private import powershell
private import codeql.controlflow.Cfg as CfgShared
private import codeql.util.Boolean
private import semmle.code.powershell.controlflow.ControlFlowGraph
private import Completion
private import semmle.code.powershell.ast.internal.Raw.Raw as Raw
private import semmle.code.powershell.ast.internal.TAst

private module CfgInput implements CfgShared::InputSig<Location> {
  private import ControlFlowGraphImpl as Impl
  private import Completion as Comp
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

  class SuccessorType = Cfg::SuccessorType;

  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  predicate successorTypeIsSimple(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::NormalSuccessor
  }

  predicate successorTypeIsCondition(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::ConditionalSuccessor
  }

  predicate isAbnormalExitType(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::ThrowSuccessor or
    t instanceof Cfg::SuccessorTypes::ExitSuccessor
  }

  private predicate id(Raw::Ast node1, Raw::Ast node2) { node1 = node2 }

  private predicate idOf(Raw::Ast node, int id) = equivalenceRelation(id/2)(node, id)

  int idOfAstNode(AstNode node) { idOf(toRawIncludingSynth(node), result) }

  int idOfCfgScope(CfgScope node) { result = idOfAstNode(node) }
}

private import CfgInput

private module CfgSplittingInput implements CfgShared::SplittingInputSig<Location, CfgInput> {
  private import Splitting as S

  class SplitKindBase = S::TSplitKind;

  class Split = S::Split;
}

private module ConditionalCompletionSplittingInput implements
  CfgShared::ConditionalCompletionSplittingInputSig<Location, CfgInput, CfgSplittingInput>
{
  import Splitting::ConditionalCompletionSplitting::ConditionalCompletionSplittingInput
}

import CfgShared::MakeWithSplitting<Location, CfgInput, CfgSplittingInput, ConditionalCompletionSplittingInput>

class CfgScope extends ScriptBlock {
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
  class ParameterTree extends ControlFlowTree instanceof Parameter {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getDefaultValue() }

    final override predicate first(AstNode first) { first = this }

    final override predicate last(AstNode last, Completion c) {
      last(super.getDefaultValue(), last, c) and
      completionIsNormal(c)
      or
      not super.hasDefaultValue() and
      last = this and
      completionIsSimple(c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(super.getDefaultValue(), succ) and
      completionIsSimple(c)
    }
  }

  class AttributeTree extends StandardPostOrderTree instanceof Attribute {
    override AstNode getChildNode(int i) {
      result = super.getPositionalArgument(i)
      or
      exists(int n |
        n = super.getNumberOfPositionalArguments() and
        i >= n and
        result = super.getNamedArgument(i - n)
      )
    }
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
      // No blocks at all. We end where we started
      this.succEntry(last, c)
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      this.succEntry(pred, c) and
      (
        first(super.getThisParameter(), succ)
        or
        not exists(super.getThisParameter()) and
        first(super.getParameter(0), succ)
        or
        not exists(super.getThisParameter()) and
        not exists(super.getAParameter()) and
        first(super.getBeginBlock(), succ)
        or
        not exists(super.getThisParameter()) and
        not exists(super.getAParameter()) and
        not exists(super.getBeginBlock()) and
        first(super.getProcessBlock(), succ)
        or
        not exists(super.getThisParameter()) and
        not exists(super.getAParameter()) and
        not exists(super.getBeginBlock()) and
        not exists(super.getProcessBlock()) and
        first(super.getEndBlock(), succ)
      )
      or
      last(super.getThisParameter(), pred, c) and
      completionIsNormal(c) and
      (
        first(super.getParameter(0), succ)
        or
        not exists(super.getAParameter()) and
        first(super.getBeginBlock(), succ)
        or
        not exists(super.getAParameter()) and
        not exists(super.getBeginBlock()) and
        first(super.getProcessBlock(), succ)
        or
        not exists(super.getAParameter()) and
        not exists(super.getBeginBlock()) and
        not exists(super.getProcessBlock()) and
        first(super.getEndBlock(), succ)
      )
      or
      exists(int i |
        last(super.getParameter(i), pred, c) and
        completionIsNormal(c) and
        first(super.getParameter(i + 1), succ)
      )
      or
      last(super.getParameter(super.getNumberOfParameters() - 1), pred, c) and
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
      child = super.getAParameter() or
      child = super.getBeginBlock() or
      child = super.getProcessBlock() or
      child = super.getEndBlock()
    }
  }

  class FunctionScriptBlockTree extends PreOrderTree, ScriptBlockTree {
    FunctionBase func;

    FunctionScriptBlockTree() { func.getBody() = this }

    Expr getDefaultValue(int i) {
      exists(Parameter p |
        p =
          rank[i + 1](Parameter cand, int j |
            cand.hasDefaultValue() and func.getParameter(j) = cand
          |
            cand order by j
          ) and
        result = p.getDefaultValue()
      )
    }

    int getNumberOfDefaultValues() { result = count(int i | exists(this.getDefaultValue(i))) }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Step to the first parameter
      pred = this and
      first(this.getDefaultValue(0), succ) and
      completionIsSimple(c)
      or
      // Step to the next parameter
      exists(int i |
        last(this.getDefaultValue(i), pred, c) and
        completionIsNormal(c) and
        first(this.getDefaultValue(i + 1), succ)
      )
      or
      // Body steps
      super.succ(pred, succ, c)
    }

    final override predicate succEntry(AstNode n, Completion c) {
      // If there are no paramters we enter the body directly
      not exists(this.getDefaultValue(_)) and
      n = this and
      completionIsSimple(c)
      or
      // Once we are done with the last parameter we enter the body
      last(this.getDefaultValue(this.getNumberOfDefaultValues() - 1), n, c) and
      completionIsNormal(c)
    }
  }

  class TopLevelScriptBlockTree extends PreOrderTree, ScriptBlockTree {
    TopLevelScriptBlockTree() { this.(ScriptBlock).isTopLevel() }

    final override predicate succEntry(Ast n, Completion c) { n = this and completionIsSimple(c) }
  }

  class NamedBlockTree extends StandardPreOrderTree instanceof NamedBlock {
    // TODO: Handle trap
    override AstNode getChildNode(int i) { result = super.getStmt(i) }
  }

  class AssignStmtTree extends StandardPreOrderTree instanceof AssignStmt {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getLeftHandSide()
      or
      i = 1 and result = super.getRightHandSide()
    }
  }

  abstract class LoopStmtTree extends ControlFlowTree instanceof LoopStmt {
    final AstNode getBody() { result = super.getBody() }

    override predicate last(AstNode last, Completion c) {
      // Exit the loop body when we encounter a break
      last(this.getBody(), last, c) and
      c instanceof BreakCompletion
      or
      // Body exits abnormally
      last(this.getBody(), last, c) and
      not c instanceof BreakCompletion and
      not c.continuesLoop()
    }
  }

  abstract class ConditionalLoopStmtTree extends PreOrderTree, LoopStmtTree {
    abstract AstNode getCondition();

    abstract predicate entersLoopWhenConditionIs(boolean value);

    final override predicate propagatesAbnormal(AstNode child) { child = this.getCondition() }

    override predicate last(AstNode last, Completion c) {
      // Exit the loop body when the condition is false
      last(this.getCondition(), last, c) and
      this.entersLoopWhenConditionIs(c.(BooleanCompletion).getValue().booleanNot())
      or
      super.last(last, c)
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Condition -> body
      last(this.getCondition(), pred, c) and
      this.entersLoopWhenConditionIs(c.(BooleanCompletion).getValue()) and
      first(this.getBody(), succ)
      or
      // Body -> condition
      last(this.getBody(), pred, c) and
      c.continuesLoop() and
      first(this.getCondition(), succ)
    }
  }

  class WhileStmtTree extends ConditionalLoopStmtTree instanceof WhileStmt {
    override predicate entersLoopWhenConditionIs(boolean value) { value = true }

    override AstNode getCondition() { result = WhileStmt.super.getCondition() }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Start with the condition
      this = pred and
      first(this.getCondition(), succ) and
      completionIsSimple(c)
      or
      super.succ(pred, succ, c)
    }
  }

  abstract class DoBasedLoopStmtTree extends ConditionalLoopStmtTree {
    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Start with the body
      this = pred and
      first(this.getBody(), succ) and
      completionIsSimple(c)
      or
      super.succ(pred, succ, c)
    }
  }

  class DoWhileStmtTree extends DoBasedLoopStmtTree instanceof DoWhileStmt {
    override AstNode getCondition() { result = DoWhileStmt.super.getCondition() }

    override predicate entersLoopWhenConditionIs(boolean value) { value = true }
  }

  class DoUntilStmtTree extends DoBasedLoopStmtTree instanceof DoUntilStmt {
    override AstNode getCondition() { result = DoUntilStmt.super.getCondition() }

    override predicate entersLoopWhenConditionIs(boolean value) { value = false }
  }

  class ForStmtTree extends PreOrderTree, LoopStmtTree instanceof ForStmt {
    final override predicate propagatesAbnormal(AstNode child) {
      child = [super.getInitializer(), super.getIterator()]
    }

    override predicate last(AstNode last, Completion c) {
      // Condition returns false
      last(super.getCondition(), last, c) and
      c instanceof FalseCompletion
      or
      super.last(last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Start with initialization
      this = pred and
      (
        first(super.getInitializer(), succ)
        or
        not exists(super.getInitializer()) and
        first(super.getCondition(), succ)
        or
        not exists(super.getInitializer()) and
        not exists(super.getCondition()) and
        first(this.getBody(), succ)
      ) and
      completionIsSimple(c)
      or
      // Initialization -> condition
      last(super.getInitializer(), pred, c) and
      completionIsNormal(c) and
      first(super.getCondition(), succ)
      or
      // Condition -> body
      last(super.getCondition(), pred, c) and
      c instanceof TrueCompletion and
      first(this.getBody(), succ)
      or
      // Body -> iterator
      last(this.getBody(), pred, c) and
      completionIsNormal(c) and
      (
        first(super.getIterator(), succ)
        or
        not exists(super.getIterator()) and
        first(super.getCondition(), succ)
        or
        not exists(super.getIterator()) and
        not exists(super.getCondition()) and
        first(this.getBody(), succ)
      )
      or
      // Iterator -> condition
      last(super.getIterator(), pred, c) and
      completionIsNormal(c) and
      first(super.getCondition(), succ)
      or
      // Body -> condition
      last(this.getBody(), pred, c) and
      c.continuesLoop() and
      first(super.getCondition(), succ)
    }
  }

  class ForEachStmtTree extends LoopStmtTree instanceof ForEachStmt {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getIterableExpr() }

    final override predicate first(AstNode first) {
      // Unlike most other statements, `foreach` statements are not modeled in
      // pre-order, because we use the `foreach` node itself to represent the
      // emptiness test that determines whether to execute the loop body
      first(super.getIterableExpr(), first)
    }

    final override predicate last(AstNode last, Completion c) {
      // Emptiness test exits with no more elements
      last = this and
      c.(EmptinessCompletion).isEmpty()
      or
      super.last(last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Emptiness test
      last(super.getIterableExpr(), pred, c) and
      completionIsNormal(c) and
      succ = this
      or
      // Emptiness test to variable declaration
      pred = this and
      first(super.getVarAccess(), succ) and
      c = any(EmptinessCompletion ec | not ec.isEmpty())
      or
      // Variable declaration to body
      last(super.getVarAccess(), pred, c) and
      completionIsNormal(c) and
      first(this.getBody(), succ)
      or
      // Body to emptiness test
      last(this.getBody(), pred, c) and
      c.continuesLoop() and
      succ = this
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

  class MemberExprTree extends StandardPostOrderTree instanceof MemberExpr {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getQualifier()
      or
      i = 1 and result = super.getMemberExpr()
    }
  }

  class IfTree extends PostOrderTree instanceof If {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getACondition()
      or
      child = super.getAThen()
      or
      child = super.getElse()
    }

    final override predicate first(AstNode first) { first(super.getCondition(0), first) }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      exists(int i, boolean value |
        last(super.getCondition(i), pred, c) and value = c.(BooleanCompletion).getValue()
      |
        value = true and
        first(super.getThen(i), succ)
        or
        value = false and
        (
          first(super.getCondition(i + 1), succ)
          or
          i = super.getNumberOfConditions() - 1 and
          (
            first(super.getElse(), succ)
            or
            not exists(super.getElse()) and
            succ = this
          )
        )
      )
      or
      (
        last(super.getAThen(), pred, c) or
        last(super.getElse(), pred, c)
      ) and
      completionIsNormal(c) and
      succ = this
    }
  }

  class SwitchStmtTree extends PreOrderTree instanceof SwitchStmt {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getCondition()
      or
      child = super.getACase()
      or
      child = super.getDefault()
      or
      child = super.getAPattern()
    }

    final override predicate last(AstNode last, Completion c) {
      // There are no cases and no default
      not exists(super.getACase()) and
      not exists(super.getDefault()) and
      last(super.getCondition(), last, c) and
      completionIsNormal(c)
      or
      // The last element can be the last statement in the default block
      last(super.getDefault(), last, c)
      or
      // ... or any of the last elements in a case block
      last(super.getACase(), last, c)
      or
      // No default and we reached the final pattern and failed to match
      not exists(super.getDefault()) and
      last(super.getPattern(super.getNumberOfCases() - 1), last, c) and
      c.(MatchCompletion).isNonMatch()
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Preorder: Flow from the switch to the condition
      pred = this and
      first(super.getCondition(), succ) and
      completionIsSimple(c)
      or
      // Flow from the condition to the first pattern
      last(super.getCondition(), pred, c) and
      completionIsNormal(c) and
      first(super.getPattern(0), succ)
      or
      // Flow from a match to:
      // 1. the corresponding case if the match succeeds, or
      // 2. the next pattern if the match failed, or
      // 3. the default case if this is the last pattern and the match failed.
      exists(int i, boolean match |
        last(super.getPattern(i), pred, c) and c.(MatchCompletion).getValue() = match
      |
        // Case 1
        match = true and
        first(super.getCase(i), succ)
        or
        match = false and
        (
          // Case 2
          first(super.getPattern(i + 1), succ)
          or
          // Case 3
          i = super.getNumberOfCases() - 1 and
          first(super.getDefault(), succ)
        )
      )
    }
  }

  class GotoStmtTree extends LeafTree instanceof GotoStmt { }

  class FunctionStmtTree extends LeafTree instanceof Function { }

  class VarAccessTree extends LeafTree instanceof VarAccess { }

  class VarTree extends LeafTree instanceof Variable { }

  class EnvVariableTree extends LeafTree instanceof EnvVariable { }

  class AutomaticVariableTree extends LeafTree instanceof AutomaticVariable { }

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

  class ScriptBlockExprTree extends LeafTree instanceof ScriptBlockExpr { }

  class ConvertExprTree extends StandardPostOrderTree instanceof ConvertExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class IndexExprTree extends StandardPostOrderTree instanceof IndexExpr {
    override AstNode getChildNode(int i) {
      i = 0 and result = super.getBase()
      or
      i = 1 and result = super.getIndex()
    }
  }

  class ParenExprTree extends StandardPostOrderTree instanceof ParenExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class TypeNameExprTree extends LeafTree instanceof TypeNameExpr { }

  class ArrayLiteralTree extends StandardPostOrderTree instanceof ArrayLiteral {
    override AstNode getChildNode(int i) { result = super.getExpr(i) }
  }

  class ArrayExprTree extends StandardPostOrderTree instanceof ArrayExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getStmtBlock() }
  }

  class CatchClauseTree extends PreOrderTree instanceof CatchClause {
    final override predicate propagatesAbnormal(Ast child) { none() }

    final override predicate last(AstNode last, Completion c) {
      last(super.getBody(), last, c)
      or
      // The last catch type failed to matchs
      last(super.getCatchType(super.getNumberOfCatchTypes() - 1), last, c) and
      c.(MatchCompletion).isNonMatch()
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Preorder: Flow from the catch clause to the first catch type to test,
      // or to the body if this is a catch all
      pred = this and
      completionIsSimple(c) and
      (
        first(super.getCatchType(0), succ)
        or
        super.isCatchAll() and
        first(super.getBody(), succ)
      )
      or
      // Flow from a catch type to the next catch type when it fails to match
      exists(int i, boolean match |
        last(super.getCatchType(i), pred, c) and
        match = c.(MatchCompletion).getValue()
      |
        match = true and
        first(super.getBody(), succ)
        or
        match = false and
        first(super.getCatchType(i + 1), succ)
      )
    }
  }

  class TypeConstraintTree extends LeafTree instanceof TypeConstraint { }

  class TypeDefinitionTree extends LeafTree instanceof TypeDefinitionStmt { }

  class TryStmtBlock extends PreOrderTree instanceof TryStmt {
    final override predicate propagatesAbnormal(AstNode child) { child = super.getFinally() }

    final override predicate last(AstNode last, Completion c) {
      last(super.getFinally(), last, c)
      or
      not super.hasFinally() and
      (
        // Body exits without an exception
        last(super.getBody(), last, c) and
        completionIsNormal(c)
        or
        // In case there's an exception we exit by evaluating one of the catch clauses
        // Note that there will always be at least one catch clause if there is no `try`.
        last(super.getACatchClause(), last, c)
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Preorder: The try/catch statment flows to the body
      pred = this and
      first(super.getBody(), succ) and
      completionIsSimple(c)
      or
      // Flow from the body to the finally when the body didn't throw
      last(super.getBody(), pred, c) and
      if c instanceof ThrowCompletion
      then first(super.getCatchClause(0), succ)
      else first(super.getFinally(), succ)
    }
  }

  class ExpandableSubExprTree extends StandardPostOrderTree instanceof ExpandableSubExpr {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class ExpandableStringExprTree extends StandardPostOrderTree instanceof ExpandableStringExpr {
    override AstNode getChildNode(int i) { result = super.getExpr(i) }
  }

  class ReturnStmtTree extends StandardPreOrderTree instanceof ReturnStmt {
    override AstNode getChildNode(int i) { i = 0 and result = super.getPipeline() }
  }

  class ExitStmtTre extends StandardPreOrderTree instanceof ExitStmt {
    override AstNode getChildNode(int i) { i = 0 and result = super.getPipeline() }
  }

  class ExitStmtTree extends StandardPreOrderTree instanceof ExitStmt {
    override AstNode getChildNode(int i) { i = 0 and result = super.getPipeline() }
  }

  class ThrowStmtTree extends StandardPreOrderTree instanceof ThrowStmt {
    override AstNode getChildNode(int i) { i = 0 and result = super.getPipeline() }
  }

  class ConstExprTree extends LeafTree instanceof ConstExpr { }

  class HashTableTree extends StandardPostOrderTree instanceof HashTableExpr {
    override AstNode getChildNode(int i) {
      exists(int k |
        // First evaluate the key
        i = 2 * k and
        super.hasEntry(k, result, _)
        or
        // Then evaluate the value
        i = 2 * k + 1 and
        super.hasEntry(k, _, result)
      )
    }
  }

  class CallExprTree extends StandardPostOrderTree instanceof CallExpr {
    override AstNode getChildNode(int i) {
      i = -2 and result = super.getQualifier()
      or
      i = -1 and result = super.getCallee()
      or
      result = super.getArgument(i)
    }
  }

  class ExprStmtTree extends StandardPreOrderTree instanceof ExprStmt {
    override AstNode getChildNode(int i) { i = 0 and result = super.getExpr() }
  }

  class StringConstTree extends LeafTree instanceof StringConstExpr { }

  class PipelineTree extends StandardPreOrderTree instanceof Pipeline {
    override AstNode getChildNode(int i) { result = super.getComponent(i) }
  }

  class FunctionDefinitionStmtTree extends LeafTree instanceof FunctionDefinitionStmt { }

  class LiteralTree extends LeafTree instanceof Literal { }
}

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
    TBooleanSuccessor(Boolean b) or
    TReturnSuccessor() or
    TBreakSuccessor() or
    TContinueSuccessor() or
    TThrowSuccessor() or
    TExitSuccessor() or
    TMatchingSuccessor(Boolean b) or
    TEmptinessSuccessor(Boolean b)
}

import Cached
