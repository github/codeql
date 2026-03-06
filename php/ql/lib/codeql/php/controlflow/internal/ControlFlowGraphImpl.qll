/**
 * Provides an implementation for constructing control-flow graphs (CFGs) from
 * abstract syntax trees (ASTs), using the shared library from `codeql.controlflow.Cfg`.
 */

private import codeql.controlflow.Cfg as CfgShared
private import codeql.controlflow.SuccessorType
private import codeql.util.Unit
private import codeql.php.AST
private import codeql.php.AST as PhpAST
private import codeql.php.ast.internal.TreeSitter
private import Completion

private module CfgInput implements CfgShared::InputSig<Location> {
  private import ControlFlowGraphImpl as Impl
  private import Completion as Comp

  class AstNode = Impl::AstNode;

  class Completion = Comp::Completion;

  predicate completionIsNormal(Completion c) { c instanceof Comp::NormalCompletion }

  predicate completionIsSimple(Completion c) { c instanceof Comp::SimpleCompletion }

  predicate completionIsValidFor(Completion c, AstNode e) { c.isValidFor(e) }

  class CfgScope = Impl::CfgScopeImpl;

  CfgScope getCfgScope(AstNode n) { result = Impl::getCfgScope(n) }

  predicate scopeFirst(CfgScope scope, AstNode first) { scope.entry(first) }

  predicate scopeLast(CfgScope scope, AstNode last, Completion c) { scope.exit(last, c) }

  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  private predicate id(Php::AstNode node1, Php::AstNode node2) { node1 = node2 }

  private predicate idOf(Php::AstNode node, int id) = equivalenceRelation(id/2)(node, id)

  int idOfAstNode(AstNode node) { idOf(node, result) }

  int idOfCfgScope(CfgScope node) { result = idOfAstNode(node) }
}

private module CfgSplittingInput implements CfgShared::SplittingInputSig<Location, CfgInput> {
  class SplitKindBase = Unit;

  class Split extends Unit {
    string toString() { result = "split" }
  }
}

private module ConditionalCompletionSplittingInput implements
  CfgShared::ConditionalCompletionSplittingInputSig<Location, CfgInput, CfgSplittingInput>
{
  private import Completion as CompMod

  class ConditionalCompletion = CompMod::ConditionalCompletion;

  class ConditionalCompletionSplitKind extends Unit {
    ConditionalCompletionSplitKind() { none() }
  }

  class ConditionalCompletionSplit extends CfgSplittingInput::Split {
    ConditionalCompletion getCompletion() { none() }

    ConditionalCompletionSplit() { none() }
  }

  bindingset[parent, parentCompletion]
  predicate condPropagateExpr(
    CfgInput::AstNode parent, ConditionalCompletion parentCompletion, CfgInput::AstNode child,
    ConditionalCompletion childCompletion
  ) {
    none()
  }
}

import CfgShared::MakeWithSplitting<Location, CfgInput, CfgSplittingInput, ConditionalCompletionSplittingInput>

/** An AST node used for control flow. */
class AstNode = PhpAST::AstNode;

/** A CFG scope. Each scope gets its own control-flow graph. */
abstract class CfgScopeImpl extends AstNode {
  abstract predicate entry(AstNode first);

  abstract predicate exit(AstNode last, Completion c);
}

/** Gets the nearest enclosing CFG scope of `n`. */
CfgScopeImpl getCfgScope(AstNode n) {
  exists(AstNode parent |
    parent = n.getParent() and
    (
      result = parent
      or
      not parent instanceof CfgScopeImpl and
      result = getCfgScope(parent)
    )
  )
}

/** A function definition scope. */
private class FunctionScope extends CfgScopeImpl instanceof FunctionDef {
  override predicate entry(AstNode first) {
    first(super.getBody().(ControlFlowTree), first)
  }

  override predicate exit(AstNode last, Completion c) {
    last(super.getBody().(ControlFlowTree), last, c)
  }
}

/** A method declaration scope. */
private class MethodScope extends CfgScopeImpl instanceof MethodDecl {
  override predicate entry(AstNode first) {
    first(super.getBody().(ControlFlowTree), first)
  }

  override predicate exit(AstNode last, Completion c) {
    last(super.getBody().(ControlFlowTree), last, c)
  }
}

/** An anonymous function (closure) scope. */
private class AnonymousFunctionScope extends CfgScopeImpl instanceof AnonymousFunction {
  override predicate entry(AstNode first) {
    first(super.getBody().(ControlFlowTree), first)
  }

  override predicate exit(AstNode last, Completion c) {
    last(super.getBody().(ControlFlowTree), last, c)
  }
}

/** An arrow function scope. */
private class ArrowFunctionScope extends CfgScopeImpl instanceof ArrowFunction {
  override predicate entry(AstNode first) {
    first(super.getBody().(ControlFlowTree), first)
  }

  override predicate exit(AstNode last, Completion c) {
    last(super.getBody().(ControlFlowTree), last, c)
  }
}

/** A program (file-level) scope. */
private class ProgramScope extends CfgScopeImpl instanceof Program {
  override predicate entry(AstNode first) { first(this, first) }

  override predicate exit(AstNode last, Completion c) { last(this, last, c) }
}

// ============================================================================
// CFG Tree implementations for each AST node type
// ============================================================================
module Trees {
  // --------------------------------------------------------------------------
  // Program (file scope)
  // --------------------------------------------------------------------------

  /** A program (file-level) tree: evaluate statements sequentially. */
  private class ProgramTree extends StandardPreOrderTree instanceof Program {
    override ControlFlowTree getChildNode(int i) {
      exists(int j |
        result = super.getStatement(j) and
        j = rank[i + 1](int k | exists(super.getStatement(k)))
      )
    }
  }

  // --------------------------------------------------------------------------
  // Statements
  // --------------------------------------------------------------------------

  /** An expression statement: evaluate the expression then continue. */
  private class ExprStmtTree extends StandardPreOrderTree instanceof ExprStmt {
    override ControlFlowTree getChildNode(int i) {
      result = super.getExpr() and i = 0
    }
  }

  /** A compound (block) statement: evaluate children in sequence. */
  private class CompoundStmtTree extends StandardPreOrderTree instanceof CompoundStmt {
    override ControlFlowTree getChildNode(int i) {
      result = super.getStatement(i)
    }
  }

  /** An empty statement (`;`): a leaf. */
  private class EmptyStmtTree extends LeafTree instanceof EmptyStmt { }

  /** A return statement. */
  private class ReturnStmtTree extends ControlFlowTree instanceof ReturnStmt {
    override predicate first(AstNode first) {
      first(super.getValue().(ControlFlowTree), first)
      or
      not super.hasValue() and first = this
    }

    override predicate last(AstNode last, Completion c) {
      last = this and c instanceof ReturnCompletion
    }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getValue()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // After evaluating the return value, flow to the return statement itself
      last(super.getValue().(ControlFlowTree), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  /** A break statement. */
  private class BreakStmtTree extends LeafTree instanceof BreakStmt {
    override predicate last(AstNode last, Completion c) {
      last = this and c instanceof BreakCompletion
    }
  }

  /** A continue statement. */
  private class ContinueStmtTree extends LeafTree instanceof ContinueStmt {
    override predicate last(AstNode last, Completion c) {
      last = this and c instanceof ContinueCompletion
    }
  }

  /** An echo statement: evaluate the expressions then continue. */
  private class EchoStmtTree extends StandardPreOrderTree instanceof EchoStmt {
    override ControlFlowTree getChildNode(int i) {
      result = super.getExpression() and i = 0
    }
  }

  /** An unset statement. */
  private class UnsetStmtTree extends StandardPreOrderTree instanceof UnsetStmt {
    override ControlFlowTree getChildNode(int i) {
      result = super.getExpression(i)
    }
  }

  /** A global declaration. */
  private class GlobalDeclTree extends LeafTree instanceof GlobalDeclaration { }

  // --------------------------------------------------------------------------
  // Control flow statements
  // --------------------------------------------------------------------------

  /** An if statement. */
  private class IfStmtTree extends PreOrderTree instanceof IfStmt {
    override predicate last(AstNode last, Completion c) {
      // Then branch completes
      last(super.getThen().(ControlFlowTree), last, c) and
      c instanceof NormalCompletion
      or
      // Alternative (elseif/else) completes
      last(super.getAnAlternative().(ControlFlowTree), last, c) and
      c instanceof NormalCompletion
      or
      // Condition is false and there is no alternative
      last(super.getCondition().(ControlFlowTree), last, c) and
      c instanceof BooleanCompletion and
      not exists(super.getAnAlternative()) and
      not exists(super.getThen())
      or
      // Abnormal completions from any child
      (
        last(super.getCondition().(ControlFlowTree), last, c) or
        last(super.getThen().(ControlFlowTree), last, c) or
        last(super.getAnAlternative().(ControlFlowTree), last, c)
      ) and
      not c instanceof NormalCompletion
      or
      // No else and condition is false
      last(super.getCondition().(ControlFlowTree), last, c) and
      c.(BooleanCompletion).getValue() = false and
      not exists(super.getAlternative(0))
      or
      // Then branch completions (abnormal pass through)
      last(super.getThen().(ControlFlowTree), last, c)
      or
      // Last alternative branch completes (normal or abnormal)
      exists(int maxIdx |
        maxIdx = max(int i | exists(super.getAlternative(i))) and
        last(super.getAlternative(maxIdx).(ControlFlowTree), last, c)
      )
    }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getCondition() or
      child = super.getThen() or
      child = super.getAnAlternative()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Entry: evaluate condition
      pred = this and
      first(super.getCondition().(ControlFlowTree), succ) and
      c instanceof SimpleCompletion
      or
      // Condition true -> then branch
      last(super.getCondition().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = true and
      first(super.getThen().(ControlFlowTree), succ)
      or
      // Condition false -> first alternative (elseif/else)
      last(super.getCondition().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = false and
      first(super.getAlternative(0).(ControlFlowTree), succ)
    }
  }

  /** An elseif clause. */
  private class ElseIfClauseTree extends PreOrderTree instanceof ElseIfClause {
    override predicate last(AstNode last, Completion c) {
      last(super.getBody().(ControlFlowTree), last, c)
      or
      last(super.getCondition().(ControlFlowTree), last, c) and
      c.(BooleanCompletion).getValue() = false
      or
      last(super.getCondition().(ControlFlowTree), last, c) and
      not c instanceof NormalCompletion
    }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getCondition() or
      child = super.getBody()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      pred = this and
      first(super.getCondition().(ControlFlowTree), succ) and
      c instanceof SimpleCompletion
      or
      last(super.getCondition().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = true and
      first(super.getBody().(ControlFlowTree), succ)
    }
  }

  /** A while statement. */
  private class WhileStmtTree extends PreOrderTree instanceof WhileStmt {
    override predicate last(AstNode last, Completion c) {
      // Condition is false -> exit loop
      last(super.getCondition().(ControlFlowTree), last, c) and
      c.(BooleanCompletion).getValue() = false
      or
      // Body break -> exit loop
      last(super.getBody().(ControlFlowTree), last, c) and
      c instanceof BreakCompletion
      or
      // Body abnormal (not break, not continue, not normal)
      last(super.getBody().(ControlFlowTree), last, c) and
      not c instanceof NormalCompletion and
      not c instanceof BreakCompletion and
      not c instanceof ContinueCompletion
      or
      // Condition abnormal
      last(super.getCondition().(ControlFlowTree), last, c) and
      not c instanceof NormalCompletion
    }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getCondition()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Entry -> condition
      pred = this and
      first(super.getCondition().(ControlFlowTree), succ) and
      c instanceof SimpleCompletion
      or
      // Condition true -> body
      last(super.getCondition().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = true and
      first(super.getBody().(ControlFlowTree), succ)
      or
      // Body normal/continue -> back to condition
      last(super.getBody().(ControlFlowTree), pred, c) and
      c.continuesLoop() and
      first(super.getCondition().(ControlFlowTree), succ)
    }
  }

  /** A do-while statement. */
  private class DoWhileStmtTree extends PreOrderTree instanceof DoWhileStmt {
    override predicate last(AstNode last, Completion c) {
      // Condition false -> exit
      last(super.getCondition().(ControlFlowTree), last, c) and
      c.(BooleanCompletion).getValue() = false
      or
      // Body break -> exit
      last(super.getBody().(ControlFlowTree), last, c) and
      c instanceof BreakCompletion
      or
      // Body abnormal (not break, not continue, not normal)
      last(super.getBody().(ControlFlowTree), last, c) and
      not c instanceof NormalCompletion and
      not c instanceof BreakCompletion and
      not c instanceof ContinueCompletion
      or
      // Condition abnormal
      last(super.getCondition().(ControlFlowTree), last, c) and
      not c instanceof NormalCompletion
    }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getBody() or
      child = super.getCondition()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Entry -> body
      pred = this and
      first(super.getBody().(ControlFlowTree), succ) and
      c instanceof SimpleCompletion
      or
      // Body normal/continue -> condition
      last(super.getBody().(ControlFlowTree), pred, c) and
      c.continuesLoop() and
      first(super.getCondition().(ControlFlowTree), succ)
      or
      // Condition true -> body (loop back)
      last(super.getCondition().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = true and
      first(super.getBody().(ControlFlowTree), succ)
    }
  }

  /** A for statement. */
  private class ForStmtTree extends PreOrderTree instanceof ForStmt {
    override predicate last(AstNode last, Completion c) {
      // Condition false -> exit
      last(super.getCondition().(ControlFlowTree), last, c) and
      c.(BooleanCompletion).getValue() = false
      or
      // No condition - exit only via body break/return/throw
      not exists(super.getCondition()) and
      last(super.getABodyStmt().(ControlFlowTree), last, c) and
      c instanceof BreakCompletion
      or
      // Body break -> exit
      last(super.getABodyStmt().(ControlFlowTree), last, c) and
      c instanceof BreakCompletion
      or
      // Body abnormal (not break/continue/normal)
      last(super.getABodyStmt().(ControlFlowTree), last, c) and
      not c instanceof NormalCompletion and
      not c instanceof BreakCompletion and
      not c instanceof ContinueCompletion
      or
      // Init/condition abnormal
      (
        last(super.getInitialize().(ControlFlowTree), last, c) or
        last(super.getCondition().(ControlFlowTree), last, c)
      ) and
      not c instanceof NormalCompletion
    }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getInitialize() or
      child = super.getCondition()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Entry -> initialize (or condition if no init)
      pred = this and
      c instanceof SimpleCompletion and
      (
        first(super.getInitialize().(ControlFlowTree), succ)
        or
        not exists(super.getInitialize()) and
        first(super.getCondition().(ControlFlowTree), succ)
        or
        not exists(super.getInitialize()) and
        not exists(super.getCondition()) and
        first(super.getBodyStmt(0).(ControlFlowTree), succ)
      )
      or
      // Initialize -> condition (or body)
      last(super.getInitialize().(ControlFlowTree), pred, c) and
      c instanceof NormalCompletion and
      (
        first(super.getCondition().(ControlFlowTree), succ)
        or
        not exists(super.getCondition()) and
        first(super.getBodyStmt(0).(ControlFlowTree), succ)
      )
      or
      // Condition true -> body
      last(super.getCondition().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = true and
      first(super.getBodyStmt(0).(ControlFlowTree), succ)
      or
      // Body statement sequence
      exists(int i |
        last(super.getBodyStmt(i).(ControlFlowTree), pred, c) and
        c instanceof NormalCompletion and
        first(super.getBodyStmt(i + 1).(ControlFlowTree), succ)
      )
      or
      // Body end / continue -> update (or condition, or body)
      (
        exists(int lst |
          last(super.getBodyStmt(lst).(ControlFlowTree), pred, c) and
          not exists(super.getBodyStmt(lst + 1)) and
          c.continuesLoop()
        )
        or
        last(super.getABodyStmt().(ControlFlowTree), pred, c) and
        c instanceof ContinueCompletion
      ) and
      (
        first(super.getUpdate().(ControlFlowTree), succ)
        or
        not exists(super.getUpdate()) and
        first(super.getCondition().(ControlFlowTree), succ)
        or
        not exists(super.getUpdate()) and
        not exists(super.getCondition()) and
        first(super.getBodyStmt(0).(ControlFlowTree), succ)
      )
      or
      // Update -> condition (or body)
      last(super.getUpdate().(ControlFlowTree), pred, c) and
      c instanceof NormalCompletion and
      (
        first(super.getCondition().(ControlFlowTree), succ)
        or
        not exists(super.getCondition()) and
        first(super.getBodyStmt(0).(ControlFlowTree), succ)
      )
    }
  }

  /** A foreach statement. */
  private class ForeachStmtTree extends PreOrderTree instanceof ForeachStmt {
    override predicate last(AstNode last, Completion c) {
      last = this and c instanceof SimpleCompletion
      or
      last(super.getBody().(ControlFlowTree), last, c) and
      c instanceof BreakCompletion
      or
      last(super.getBody().(ControlFlowTree), last, c) and
      not c instanceof NormalCompletion and
      not c instanceof BreakCompletion and
      not c instanceof ContinueCompletion
    }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getBody()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Entry -> evaluate collection (first child is the iterable expression)
      pred = this and
      first(super.getChild(0).(ControlFlowTree), succ) and
      c instanceof SimpleCompletion
      or
      // Collection -> body (on each iteration)
      last(super.getChild(0).(ControlFlowTree), pred, c) and
      c instanceof NormalCompletion and
      first(super.getBody().(ControlFlowTree), succ)
      or
      // Body end/continue -> back to collection (next iteration)
      last(super.getBody().(ControlFlowTree), pred, c) and
      c.continuesLoop() and
      first(super.getChild(0).(ControlFlowTree), succ)
    }
  }

  /** A switch statement. */
  private class SwitchStmtTree extends PreOrderTree instanceof SwitchStmt {
    private Php::SwitchBlock getBody() { result = this.(Php::SwitchStatement).getBody() }

    override predicate last(AstNode last, Completion c) {
      // The switch body (switch_block) completes
      last(this.getBody().(ControlFlowTree), last, c)
      or
      // Condition abnormal
      last(super.getCondition().(ControlFlowTree), last, c) and
      not c instanceof NormalCompletion
    }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getCondition()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Entry -> condition
      pred = this and
      first(super.getCondition().(ControlFlowTree), succ) and
      c instanceof SimpleCompletion
      or
      // Condition -> switch body
      last(super.getCondition().(ControlFlowTree), pred, c) and
      c instanceof NormalCompletion and
      first(this.getBody().(ControlFlowTree), succ)
    }
  }

  /** A switch block containing case/default statements. */
  private class SwitchBlockTree extends StandardPreOrderTree instanceof Php::SwitchBlock {
    override ControlFlowTree getChildNode(int i) {
      result = this.(Php::SwitchBlock).getChild(i)
    }
  }

  /** A case statement (within switch). */
  private class CaseStmtTree extends StandardPreOrderTree instanceof CaseStmt {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getValue()
      or
      result = super.getStatement(i - 1)
    }
  }

  /** A default statement (within switch). */
  private class DefaultStmtTree extends StandardPreOrderTree instanceof DefaultStmt {
    override ControlFlowTree getChildNode(int i) {
      result = super.getStatement(i)
    }
  }

  /** A try statement. */
  private class TryStmtTree extends PreOrderTree instanceof TryStmt {
    override predicate last(AstNode last, Completion c) {
      // Body completes normally (no catch needed)
      last(super.getBody().(ControlFlowTree), last, c) and
      c instanceof NormalCompletion and
      not super.hasFinally()
      or
      // Catch block completes
      last(super.getACatch().(ControlFlowTree), last, c) and
      not super.hasFinally()
      or
      // Finally block completes
      last(super.getFinally().(ControlFlowTree), last, c)
      or
      // Body throws and there's no catch
      last(super.getBody().(ControlFlowTree), last, c) and
      c instanceof ThrowCompletion and
      not exists(super.getACatch()) and
      not super.hasFinally()
      or
      // Body abnormal (not throw, not normal)
      last(super.getBody().(ControlFlowTree), last, c) and
      not c instanceof NormalCompletion and
      not c instanceof ThrowCompletion
    }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getBody()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Entry -> body
      pred = this and
      first(super.getBody().(ControlFlowTree), succ) and
      c instanceof SimpleCompletion
      or
      // Body throws -> first catch
      last(super.getBody().(ControlFlowTree), pred, c) and
      c instanceof ThrowCompletion and
      first(super.getCatch(0).(ControlFlowTree), succ)
      or
      // Catch to next catch (fall-through)
      exists(int i |
        last(super.getCatch(i).(ControlFlowTree), pred, c) and
        c instanceof ThrowCompletion and
        first(super.getCatch(i + 1).(ControlFlowTree), succ)
      )
      or
      // Body normal -> finally
      last(super.getBody().(ControlFlowTree), pred, c) and
      c instanceof NormalCompletion and
      super.hasFinally() and
      first(super.getFinally().(ControlFlowTree), succ)
      or
      // Catch -> finally
      last(super.getACatch().(ControlFlowTree), pred, c) and
      c instanceof NormalCompletion and
      super.hasFinally() and
      first(super.getFinally().(ControlFlowTree), succ)
    }
  }

  /** A catch clause. */
  private class CatchClauseTree extends StandardPreOrderTree instanceof CatchClause {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getBody()
    }
  }

  /** A finally clause. */
  private class FinallyClauseTree extends StandardPreOrderTree instanceof FinallyClause {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getBody()
    }
  }

  // --------------------------------------------------------------------------
  // Expressions
  // --------------------------------------------------------------------------

  /** An assignment expression: evaluate RHS then LHS. */
  private class AssignExprTree extends StandardPostOrderTree instanceof AssignExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getRightOperand()
      or
      i = 1 and result = super.getLeftOperand()
    }
  }

  /** A reference assignment expression. */
  private class RefAssignExprTree extends StandardPostOrderTree instanceof RefAssignExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getRightOperand()
      or
      i = 1 and result = super.getLeftOperand()
    }
  }

  /** An augmented assignment expression. */
  private class AugAssignExprTree extends StandardPostOrderTree instanceof AugmentedAssignExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getLeftOperand()
      or
      i = 1 and result = super.getRightOperand()
    }
  }

  /** A binary expression. */
  private class BinaryExprTree extends StandardPostOrderTree instanceof BinaryExpr {
    BinaryExprTree() {
      not super.getOperator() = ["&&", "||", "and", "or"]
    }

    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getLeftOperand()
      or
      i = 1 and result = super.getRightOperand()
    }
  }

  /** A short-circuit logical AND expression (`&&` or `and`). */
  private class LogicalAndExprTree extends PostOrderTree instanceof BinaryExpr {
    LogicalAndExprTree() { super.getOperator() = ["&&", "and"] }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getLeftOperand() or child = super.getRightOperand()
    }

    override predicate first(AstNode first) {
      first(super.getLeftOperand().(ControlFlowTree), first)
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Left true -> right
      last(super.getLeftOperand().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = true and
      first(super.getRightOperand().(ControlFlowTree), succ)
      or
      // Right -> this
      last(super.getRightOperand().(ControlFlowTree), pred, c) and
      c instanceof NormalCompletion and
      succ = this
      or
      // Left false -> this (short-circuit)
      last(super.getLeftOperand().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = false and
      succ = this
    }
  }

  /** A short-circuit logical OR expression (`||` or `or`). */
  private class LogicalOrExprTree extends PostOrderTree instanceof BinaryExpr {
    LogicalOrExprTree() { super.getOperator() = ["||", "or"] }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getLeftOperand() or child = super.getRightOperand()
    }

    override predicate first(AstNode first) {
      first(super.getLeftOperand().(ControlFlowTree), first)
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Left false -> right
      last(super.getLeftOperand().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = false and
      first(super.getRightOperand().(ControlFlowTree), succ)
      or
      // Right -> this
      last(super.getRightOperand().(ControlFlowTree), pred, c) and
      c instanceof NormalCompletion and
      succ = this
      or
      // Left true -> this (short-circuit)
      last(super.getLeftOperand().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = true and
      succ = this
    }
  }

  /** A unary expression. */
  private class UnaryExprTree extends StandardPostOrderTree instanceof UnaryExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getOperand()
    }
  }

  /** An update expression (pre/post increment/decrement). */
  private class UpdateExprTree extends StandardPostOrderTree instanceof UpdateExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getArgument()
    }
  }

  /** A conditional (ternary) expression. */
  private class ConditionalExprTree extends PostOrderTree instanceof ConditionalExpr {
    override predicate propagatesAbnormal(AstNode child) {
      child = super.getCondition() or
      child = super.getConsequence() or
      child = super.getAlternative()
    }

    override predicate first(AstNode first) {
      first(super.getCondition().(ControlFlowTree), first)
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Condition true -> consequence
      last(super.getCondition().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = true and
      first(super.getConsequence().(ControlFlowTree), succ)
      or
      // Condition false -> alternative
      last(super.getCondition().(ControlFlowTree), pred, c) and
      c.(BooleanCompletion).getValue() = false and
      first(super.getAlternative().(ControlFlowTree), succ)
      or
      // Branch -> this
      (
        last(super.getConsequence().(ControlFlowTree), pred, c) or
        last(super.getAlternative().(ControlFlowTree), pred, c)
      ) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  /** A cast expression. */
  private class CastExprTree extends StandardPostOrderTree instanceof CastExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getValue()
    }
  }

  /** An error suppression expression. */
  private class ErrorSuppressExprTree extends StandardPostOrderTree instanceof ErrorSuppressExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getExpr()
    }
  }

  /** A clone expression. */
  private class CloneExprTree extends StandardPostOrderTree instanceof CloneExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getExpr()
    }
  }

  /** A throw expression. */
  private class ThrowExprTree extends ControlFlowTree instanceof ThrowExpr {
    override predicate first(AstNode first) {
      first(super.getExpr().(ControlFlowTree), first)
    }

    override predicate last(AstNode last, Completion c) {
      last = this and c instanceof ThrowCompletion
    }

    override predicate propagatesAbnormal(AstNode child) {
      child = super.getExpr()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getExpr().(ControlFlowTree), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  /** A parenthesized expression. */
  private class ParenExprTree extends StandardPostOrderTree instanceof ParenExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getExpr()
    }
  }

  /** An include/require expression. */
  private class IncludeExprTree extends StandardPostOrderTree instanceof IncludeExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getArgument()
    }
  }

  private class IncludeOnceExprTree extends StandardPostOrderTree instanceof IncludeOnceExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getArgument()
    }
  }

  private class RequireExprTree extends StandardPostOrderTree instanceof RequireExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getArgument()
    }
  }

  private class RequireOnceExprTree extends StandardPostOrderTree instanceof RequireOnceExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getArgument()
    }
  }

  /** A print expression. */
  private class PrintExprTree extends StandardPostOrderTree instanceof PrintExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getArgument()
    }
  }

  /** A subscript expression (array access). */
  private class SubscriptExprTree extends StandardPostOrderTree instanceof SubscriptExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getObject()
      or
      i = 1 and result = super.getIndexExpr()
    }
  }

  /** A member access expression. */
  private class MemberAccessExprTree extends StandardPostOrderTree instanceof MemberAccessExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getObject()
    }
  }

  /** A nullsafe member access expression. */
  private class NullsafeMemberAccessExprTree extends StandardPostOrderTree instanceof NullsafeMemberAccessExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getObject()
    }
  }

  /** An array creation expression. */
  private class ArrayCreationExprTree extends StandardPostOrderTree instanceof ArrayCreationExpr {
    override ControlFlowTree getChildNode(int i) {
      result = super.getElement(i)
    }
  }

  /** An array element initializer. */
  private class ArrayElemInitTree extends StandardPostOrderTree instanceof ArrayElementInitializer {
    override ControlFlowTree getChildNode(int i) {
      result = super.getChild(i)
    }
  }

  /** A function call expression. */
  private class FunctionCallExprTree extends StandardPostOrderTree instanceof FunctionCallExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getFunction()
      or
      exists(int argIdx |
        result = super.getArgument(argIdx) and
        i = argIdx + 1
      )
    }
  }

  /** A method call expression. */
  private class MethodCallExprTree extends StandardPostOrderTree instanceof MethodCallExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getObject()
      or
      exists(int argIdx |
        result = super.getArgument(argIdx) and
        i = argIdx + 1
      )
    }
  }

  /** A nullsafe method call expression. */
  private class NullsafeMethodCallExprTree extends StandardPostOrderTree instanceof NullsafeMethodCallExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getObject()
      or
      exists(int argIdx |
        result = super.getArgument(argIdx) and
        i = argIdx + 1
      )
    }
  }

  /** A scoped (static) call expression. */
  private class ScopedCallExprTree extends StandardPostOrderTree instanceof ScopedCallExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getScope()
      or
      exists(int argIdx |
        result = super.getArgument(argIdx) and
        i = argIdx + 1
      )
    }
  }

  /** An object creation expression (new). */
  private class ObjectCreationExprTree extends StandardPostOrderTree instanceof ObjectCreationExpr {
    override ControlFlowTree getChildNode(int i) {
      result = super.getChild(i)
    }
  }

  // --------------------------------------------------------------------------
  // Leaf nodes - tokens and simple literals
  // --------------------------------------------------------------------------

  /** A variable name (leaf). */
  private class VariableNameTree extends LeafTree instanceof VariableName { }

  /** A name token (leaf). */
  private class NameTree extends LeafTree instanceof Name {
    NameTree() {
      // Exclude Name nodes that are part of other constructs handled elsewhere
      not this = any(FunctionDef fd).getName() and
      not this = any(MethodDecl md).getName() and
      not this = any(ClassDecl cd).getName() and
      not this = any(InterfaceDecl id).getName() and
      not this = any(TraitDecl td).getName() and
      not this = any(EnumDecl ed).getName()
    }
  }

  /** A qualified name (leaf). */
  private class QualifiedNameTree extends LeafTree instanceof QualifiedName { }

  /** An integer literal (leaf). */
  private class IntLiteralTree extends LeafTree instanceof IntegerLiteral { }

  /** A float literal (leaf). */
  private class FloatLiteralTree extends LeafTree instanceof FloatLiteral { }

  /** A string literal (leaf). */
  private class StringLiteralTree extends LeafTree instanceof StringLiteral { }

  /** A boolean literal (leaf). */
  private class BoolLiteralTree extends LeafTree instanceof BooleanLiteral { }

  /** A null literal (leaf). */
  private class NullLiteralTree extends LeafTree instanceof NullLiteral { }

  /** An encapsed (interpolated) string. */
  private class EncapsedStringTree extends StandardPostOrderTree instanceof EncapsedString {
    override ControlFlowTree getChildNode(int i) {
      result = super.getElement(i)
    }
  }

  /** A yield expression. */
  private class YieldExprTree extends StandardPostOrderTree instanceof YieldExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getChild()
    }
  }

  /** A match expression (leaf for now - simplified). */
  private class MatchExprTree extends LeafTree instanceof MatchExpr { }

  /** A dynamic variable name. */
  private class DynamicVarNameTree extends StandardPostOrderTree instanceof DynamicVariableNameExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getNameExpr()
    }
  }

  /** A variadic unpacking expression. */
  private class VariadicUnpackTree extends StandardPostOrderTree instanceof VariadicUnpackingExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getExpr()
    }
  }

  /** A scoped property access expression. */
  private class ScopedPropAccessTree extends StandardPostOrderTree instanceof ScopedPropertyAccessExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getScope()
    }
  }

  /** A class constant access expression. */
  private class ClassConstAccessTree extends StandardPostOrderTree instanceof ClassConstantAccessExpr {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getScope()
    }
  }

  /** A shell command expression (backtick). */
  private class ShellCommandTree extends StandardPostOrderTree instanceof ShellCommandExpr {
    override ControlFlowTree getChildNode(int i) {
      result = super.getElement(i)
    }
  }

  /** An exit/die statement. */
  private class ExitStatementTree extends ControlFlowTree instanceof Php::ExitStatement {
    override predicate propagatesAbnormal(AstNode child) { none() }

    override predicate first(AstNode first) {
      first(this.(Php::ExitStatement).getChild().(ControlFlowTree), first)
      or
      not exists(this.(Php::ExitStatement).getChild()) and first = this
    }

    override predicate last(AstNode last, Completion c) {
      last = this and c instanceof ExitCompletion
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.(Php::ExitStatement).getChild().(ControlFlowTree), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  /** A heredoc string (leaf). */
  private class HeredocTree extends LeafTree instanceof Heredoc { }

  // --------------------------------------------------------------------------
  // Declarations - these are leaves in the CFG (their bodies are separate scopes)
  // --------------------------------------------------------------------------

  /** A function definition is a leaf in the surrounding scope's CFG. */
  private class FunctionDefTree extends LeafTree instanceof FunctionDef { }

  /** A class declaration is a leaf in the surrounding scope's CFG. */
  private class ClassDeclTree extends LeafTree instanceof ClassDecl { }

  /** An interface declaration is a leaf. */
  private class InterfaceDeclTree extends LeafTree instanceof InterfaceDecl { }

  /** A trait declaration is a leaf. */
  private class TraitDeclTree extends LeafTree instanceof TraitDecl { }

  /** An enum declaration is a leaf. */
  private class EnumDeclTree extends LeafTree instanceof EnumDecl { }

  /** An anonymous function is a leaf in the enclosing scope. */
  private class AnonymousFunctionTree extends LeafTree instanceof AnonymousFunction { }

  /** An arrow function is a leaf in the enclosing scope. */
  private class ArrowFunctionTree extends LeafTree instanceof ArrowFunction { }

  // --------------------------------------------------------------------------
  // Other declarations and statements that are leaves
  // --------------------------------------------------------------------------

  /** A namespace definition. */
  private class NamespaceDefTree extends StandardPreOrderTree instanceof NamespaceDefinition {
    override ControlFlowTree getChildNode(int i) {
      i = 0 and result = super.getBody()
    }
  }

  /** A namespace use declaration (leaf). */
  private class NamespaceUseTree extends LeafTree instanceof NamespaceUseDeclaration { }

  /** A declare statement (leaf). */
  private class DeclareStmtTree extends LeafTree instanceof DeclareStmt { }

  /** A goto statement. */
  private class GotoStmtTree extends LeafTree instanceof GotoStmt { }

  /** A label statement. */
  private class LabelStmtTree extends LeafTree instanceof LabelStmt { }

  // --------------------------------------------------------------------------
  // Class member declarations (leaves in the class body CFG)
  // --------------------------------------------------------------------------

  /** A method declaration is a leaf node in the class body. */
  private class MethodDeclTree extends LeafTree instanceof MethodDecl { }

  /** A property declaration. */
  private class PropertyDeclTree extends LeafTree instanceof PropertyDecl { }

  /** A constant declaration. */
  private class ConstDeclTree extends LeafTree instanceof ConstDecl { }

  /** An arguments list (used internally by calls). */
  private class ArgumentsTree extends StandardPostOrderTree instanceof Arguments {
    override ControlFlowTree getChildNode(int i) {
      result = super.getArgument(i)
    }
  }

  /** Formal parameters list (leaf). */
  private class FormalParametersTree extends LeafTree instanceof FormalParameters { }

  /** A parameter (leaf). */
  private class ParameterTree extends LeafTree instanceof Parameter { }

  /** A type node (leaf). */
  private class TypeNodeTree extends LeafTree instanceof TypeNode { }

  /** A base clause (extends, leaf). */
  private class BaseClauseTree extends LeafTree instanceof BaseClause { }

  /** A class interface clause (implements, leaf). */
  private class ClassInterfaceClauseTree extends LeafTree instanceof ClassInterfaceClause { }

  /** A declaration list (class body). */
  private class DeclarationListTree extends StandardPreOrderTree instanceof DeclarationList {
    override ControlFlowTree getChildNode(int i) {
      result = super.getMember(i)
    }
  }

  /** A property element (leaf). */
  private class PropertyElementTree extends LeafTree instanceof PropertyElement { }

  /** A const element (leaf). */
  private class ConstElementTree extends LeafTree instanceof ConstElement { }

  /** A catch clause variable (leaf). */
  private class CatchClauseVarTree extends LeafTree {
    CatchClauseVarTree() {
      this = any(CatchClause cc).getVariable()
    }
  }
}
