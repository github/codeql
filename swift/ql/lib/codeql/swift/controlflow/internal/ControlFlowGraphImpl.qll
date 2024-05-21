/**
 * Provides auxiliary classes and predicates used to construct the basic successor
 * relation on control flow elements.
 *
 * The implementation is centered around the concept of a _completion_, which
 * models how the execution of a statement or expression terminates.
 * Completions are represented as an algebraic data type `Completion` defined in
 * `Completion.qll`.
 *
 * The CFG is built by structural recursion over the AST. To achieve this the
 * CFG edges related to a given AST node, `n`, are divided into three categories:
 *
 *   1. The in-going edge that points to the first CFG node to execute when
 *      `n` is going to be executed.
 *   2. The out-going edges for control flow leaving `n` that are going to some
 *      other node in the surrounding context of `n`.
 *   3. The edges that have both of their end-points entirely within the AST
 *      node and its children.
 *
 * The edges in (1) and (2) are inherently non-local and are therefore
 * initially calculated as half-edges, that is, the single node, `k`, of the
 * edge contained within `n`, by the predicates `k = first(n)` and `k = last(n, _)`,
 * respectively. The edges in (3) can then be enumerated directly by the predicate
 * `succ` by calling `first` and `last` recursively on the children of `n` and
 * connecting the end-points. This yields the entire CFG, since all edges are in
 * (3) for _some_ AST node.
 *
 * The second parameter of `last` is the completion, which is necessary to distinguish
 * the out-going edges from `n`. Note that the completion changes as the calculation of
 * `last` proceeds outward through the AST; for example, a `BreakCompletion` is
 * caught up by its surrounding loop and turned into a `NormalCompletion`.
 */

private import swift
private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.generated.Synth
private import Completion
private import Scope
import ControlFlowGraphImplSpecific::CfgImpl
private import ControlFlowElements
private import AstControlFlowTrees

module CfgScope {
  abstract class Range_ extends AstNode {
    abstract predicate entry(ControlFlowElement first);

    abstract predicate exit(ControlFlowElement last, Completion c);
  }

  private class BodyStmtCallableScope extends Range_ instanceof Function {
    Decls::FuncDeclTree tree;

    BodyStmtCallableScope() { tree.getAst() = this }

    final override predicate entry(ControlFlowElement first) { first(tree, first) }

    final override predicate exit(ControlFlowElement last, Completion c) { last(tree, last, c) }
  }

  private class KeyPathScope extends Range_ instanceof KeyPathExpr {
    KeyPathControlFlowTree tree;

    KeyPathScope() { tree.getAst() = this }

    final override predicate entry(ControlFlowElement first) { first(tree, first) }

    final override predicate exit(ControlFlowElement last, Completion c) { last(tree, last, c) }
  }

  private class ClosureExprScope extends Range_ instanceof ClosureExpr {
    Exprs::ClosureExprTree tree;

    ClosureExprScope() {
      isNormalAutoClosureOrExplicitClosure(this) and
      tree.getAst() = this
    }

    final override predicate entry(ControlFlowElement first) { first(tree, first) }

    final override predicate exit(ControlFlowElement last, Completion c) { last(tree, last, c) }
  }

  private class KeyPathControlFlowTree extends StandardPostOrderTree instanceof KeyPathElement {
    override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = super.getAst().getComponent(i)
    }

    KeyPathExpr getAst() { result = super.getAst() }
  }
}

/** Holds if `first` is first executed when entering `scope`. */
pragma[nomagic]
predicate succEntry(CfgScope::Range_ scope, ControlFlowElement first) { scope.entry(first) }

/** Holds if `last` with completion `c` can exit `scope`. */
pragma[nomagic]
predicate succExit(CfgScope::Range_ scope, ControlFlowElement last, Completion c) {
  scope.exit(last, c)
}

private class KeyPathComponentTree extends AstStandardPostOrderTree {
  override KeyPathComponent ast;

  final override ControlFlowElement getChildNode(int i) {
    result.asAstNode() = ast.getSubscriptArgument(i).getExpr().getFullyConverted()
  }
}

/**
 * Control-flow for statements.
 */
module Stmts {
  class BraceStmtTree extends AstControlFlowTree {
    override BraceStmt ast;

    override predicate propagatesAbnormal(ControlFlowElement node) { none() }

    override predicate first(ControlFlowElement first) {
      this.firstInner(first)
      or
      not exists(ast.getFirstElement()) and first.asAstNode() = ast
    }

    override predicate last(ControlFlowElement last, Completion c) {
      this.lastInner(last, c)
      or
      not exists(ast.getFirstElement()) and
      last.asAstNode() = ast and
      c instanceof SimpleCompletion
    }

    predicate firstInner(ControlFlowElement first) {
      astFirst(ast.getFirstElement().getFullyUnresolved(), first)
    }

    /** Gets the body of the i'th `defer` statement. */
    private BraceStmt getDeferStmtBody(int i) {
      result =
        rank[i](DeferStmt defer, int index |
          defer = ast.getElement(index)
        |
          defer.getBody() order by index
        )
    }

    /**
     * Gets the body of the first `defer` statement to be executed once all
     * statements in this block has been evaluated.
     */
    private BraceStmt getFirstDeferStmtBody() {
      exists(int i |
        result = this.getDeferStmtBody(i) and
        not exists(this.getDeferStmtBody(i + 1))
      )
    }

    /** Gets the body of the last `defer` statement to be executed. */
    private BraceStmt getLastDeferStmtBody() {
      exists(int i |
        result = this.getDeferStmtBody(i) and
        not exists(this.getDeferStmtBody(i - 1))
      )
    }

    /** Gets the index of the i'th `defer` statement. */
    int getDeferIndex(int i) {
      exists(DeferStmt defer |
        this.getDeferStmtBody(i) = defer.getBody() and
        ast.getElement(result) = defer
      )
    }

    /**
     * Gets the first `defer` statement to be executed if `i` is the
     * index of the last statement in this block that was executed.
     */
    bindingset[i]
    private BraceStmt getDeferStmtBodyAfterStmt(int i) {
      exists(int j |
        // The result is the j'th statement (where the index is less than or equal to i)
        result = this.getDeferStmtBody(j) and
        this.getDeferIndex(j) <= i and
        // and the next defer statement is _after_ the i'th statement.
        not this.getDeferIndex(j + 1) <= i
      )
    }

    predicate lastInner(ControlFlowElement last, Completion c) {
      // Normal exit and no defer statements
      astLast(ast.getLastElement().getFullyUnresolved(), last, c) and
      not exists(this.getFirstDeferStmtBody()) and
      c instanceof NormalCompletion
      or
      // Normal exit from the last defer statement to be executed
      astLast(this.getLastDeferStmtBody().getFullyUnresolved(), last, c) and
      c instanceof NormalCompletion
      or
      // Abnormal exit without any defer statements
      not c instanceof NormalCompletion and
      astLast(ast.getAnElement().getFullyUnresolved(), last, c) and
      not exists(this.getFirstDeferStmtBody())
    }

    override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // left-to-right evaluation of statements
      exists(int i |
        astLast(ast.getElement(i).getFullyUnresolved(), pred, c) and
        astFirst(ast.getElement(i + 1).getFullyUnresolved(), succ) and
        c instanceof NormalCompletion
      )
      or
      // Flow from last elements to the first defer statement to be executed
      c instanceof NormalCompletion and
      astLast(ast.getLastElement().getFullyUnresolved(), pred, c) and
      astFirst(this.getFirstDeferStmtBody().getFullyUnresolved(), succ)
      or
      // Flow from a defer statement to the next defer to be executed
      c instanceof NormalCompletion and
      exists(int i |
        astLast(this.getDeferStmtBody(i), pred, c) and
        astFirst(this.getDeferStmtBody(i - 1), succ)
      )
      or
      // Abnormal exit from an element to the first defer statement to be executed.
      not c instanceof NormalCompletion and
      exists(int i |
        astLast(ast.getElement(i).getFullyUnresolved(), pred, c) and
        astFirst(this.getDeferStmtBodyAfterStmt(i), succ)
      )
    }
  }

  private class ReturnStmtTree extends AstStandardPostOrderTree {
    override ReturnStmt ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getResult().getFullyConverted() and i = 0
    }
  }

  private class DiscardStmtTree extends AstStandardPostOrderTree {
    override DiscardStmt ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and result.asAstNode() = ast.getSubExpr().getFullyUnresolved()
    }
  }

  private class YieldStmtTree extends AstStandardPostOrderTree {
    override YieldStmt ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getResult(i).getFullyConverted()
    }
  }

  private class ThenStmtTree extends AstStandardPostOrderTree {
    override ThenStmt ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and
      result.asAstNode() = ast.getResult()
    }
  }

  private class FailTree extends AstLeafTree {
    override FailStmt ast;
  }

  private class StmtConditionTree extends AstPreOrderTree {
    override StmtCondition ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getAnElement().getInitializer().getFullyConverted()
      or
      child.asAstNode() = ast.getAnElement().getPattern().getFullyUnresolved()
      or
      child.asAstNode() = ast.getAnElement().getBoolean().getFullyConverted()
      or
      child.asAstNode() = ast.getAnElement().getAvailability().getFullyUnresolved()
    }

    predicate firstElement(int i, ControlFlowElement first) {
      // If there is an initializer in the first element, evaluate that first
      astFirst(ast.getElement(i).getInitializer().getFullyConverted(), first)
      or
      // Otherwise, the first element is...
      not exists(ast.getElement(i).getInitializer()) and
      (
        // ... a boolean condition.
        astFirst(ast.getElement(i).getBoolean().getFullyConverted(), first)
        or
        // ... or an availability check.
        astFirst(ast.getElement(i).getAvailability().getFullyUnresolved(), first)
      )
    }

    predicate succElement(int i, ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Evaluate the pattern after the initializer
      astLast(ast.getElement(i).getInitializer().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      astFirst(ast.getElement(i).getPattern().getFullyUnresolved(), succ)
      or
      (
        // After evaluating the pattern
        astLast(ast.getElement(i).getPattern().getFullyUnresolved(), pred, c)
        or
        // ... or the boolean ...
        astLast(ast.getElement(i).getBoolean().getFullyConverted(), pred, c)
        or
        // ... or the availability check ...
        astLast(ast.getElement(i).getAvailability().getFullyUnresolved(), pred, c)
      ) and
      // We evaluate the next element
      c instanceof NormalCompletion and
      this.firstElement(i + 1, succ)
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Stop if a boolean check failed
      astLast(ast.getAnElement().getBoolean().getFullyConverted(), last, c) and
      c instanceof FalseCompletion
      or
      // Stop is a pattern match failed
      astLast(ast.getAnElement().getPattern().getFullyUnresolved(), last, c) and
      not c.(MatchingCompletion).isMatch()
      or
      // Stop if an availability check failed
      astLast(ast.getAnElement().getAvailability().getFullyUnresolved(), last, c) and
      c instanceof FalseCompletion
      or
      // Stop if we successfully evaluated all the conditionals
      (
        astLast(ast.getLastElement().getBoolean().getFullyConverted(), last, c)
        or
        astLast(ast.getLastElement().getPattern().getFullyUnresolved(), last, c)
        or
        astLast(ast.getLastElement().getAvailability().getFullyUnresolved(), last, c)
      ) and
      c instanceof NormalCompletion
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: Flow from this ast node to the first condition
      pred.asAstNode() = ast and
      c instanceof SimpleCompletion and
      this.firstElement(0, succ)
      or
      // Left-to-right evaluation of elements
      this.succElement(_, pred, succ, c)
    }
  }

  private class IfStmtTree extends AstPreOrderTree {
    override IfStmt ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getCondition().getFullyUnresolved() or
      child.asAstNode() = ast.getThen() or
      child.asAstNode() = ast.getElse()
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Condition exits with a false completion and there is no `else` branch
      astLast(ast.getCondition().getFullyUnresolved(), last, c) and
      c instanceof FalseOrNonMatchCompletion and
      not exists(ast.getElse())
      or
      // Then/Else branch exits with any completion
      astLast(ast.getBranch(_), last, c)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: flow from statement itself to first element of condition
      pred.asAstNode() = ast and
      astFirst(ast.getCondition().getFullyUnresolved(), succ) and
      c instanceof SimpleCompletion
      or
      astLast(ast.getCondition().getFullyUnresolved(), pred, c) and
      (
        // Flow from last element of condition to first element of then branch
        c instanceof TrueOrMatchCompletion and
        astFirst(ast.getThen(), succ)
        or
        // Flow from last element of condition to first element of else branch
        c instanceof FalseOrNonMatchCompletion and
        astFirst(ast.getElse(), succ)
      )
    }
  }

  private class GuardTree extends AstPreOrderTree {
    override GuardStmt ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getCondition().getFullyUnresolved() or
      child.asAstNode() = ast.getBody()
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Normal exit after evaluating the body
      astLast(ast.getBody(), last, c) and
      c instanceof NormalCompletion
      or
      // Exit when a condition is true
      astLast(ast.getCondition().getFullyUnresolved(), last, c) and
      c instanceof TrueOrMatchCompletion
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: flow from statement itself to first element of condition
      pred.asAstNode() = ast and
      astFirst(ast.getCondition().getFullyUnresolved(), succ) and
      c instanceof SimpleCompletion
      or
      // Flow to the body when the condition is false
      astLast(ast.getCondition().getFullyUnresolved(), pred, c) and
      c instanceof FalseOrNonMatchCompletion and
      astFirst(ast.getBody(), succ)
    }
  }

  /**
   * Control-flow for loops.
   */
  module Loops {
    class ConditionalLoop = Synth::TWhileStmt or Synth::TRepeatWhileStmt;

    class LoopStmt = Synth::TForEachStmt or ConditionalLoop;

    abstract class LoopTree extends AstPreOrderTree {
      LoopTree() { ast instanceof ConditionalLoop }

      abstract ControlFlowElement getCondition();

      abstract ControlFlowElement getBody();

      final override predicate propagatesAbnormal(ControlFlowElement child) {
        child = this.getCondition()
      }

      final override predicate last(ControlFlowElement last, Completion c) {
        // Condition exits with a false completion
        last(this.getCondition(), last, c) and
        c instanceof FalseOrNonMatchCompletion
        or
        // Body exits with a break completion
        exists(BreakCompletion break |
          last(this.getBody(), last, break) and
          // Propagate the break upwards if we need to break out of multiple loops.
          if break.getTarget() = ast then c instanceof SimpleCompletion else c = break
        )
        or
        // Body exits with a completion that does not continue the loop
        last(this.getBody(), last, c) and
        not c instanceof BreakCompletion and
        not c.continuesLoop(ast)
      }

      override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
        last(this.getCondition(), pred, c) and
        c instanceof TrueOrMatchCompletion and
        first(this.getBody(), succ)
        or
        last(this.getBody(), pred, c) and
        first(this.getCondition(), succ) and
        c.continuesLoop(ast)
      }
    }

    private class WhileTree extends LoopTree {
      override WhileStmt ast;

      final override ControlFlowElement getCondition() {
        result.asAstNode() = ast.getCondition().getFullyUnresolved()
      }

      final override ControlFlowElement getBody() { result.asAstNode() = ast.getBody() }

      final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
        LoopTree.super.succ(pred, succ, c)
        or
        pred.asAstNode() = ast and
        first(this.getCondition(), succ) and
        c instanceof SimpleCompletion
      }
    }

    private class RepeatWhileTree extends LoopTree {
      override RepeatWhileStmt ast;

      final override ControlFlowElement getCondition() {
        result.asAstNode() = ast.getCondition().getFullyConverted()
      }

      final override ControlFlowElement getBody() { result.asAstNode() = ast.getBody() }

      final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
        LoopTree.super.succ(pred, succ, c)
        or
        // Pre-order: Flow from the element to the body.
        pred.asAstNode() = ast and
        first(this.getBody(), succ) and
        c instanceof SimpleCompletion
      }
    }

    private class ForEachTree extends AstControlFlowTree {
      override ForEachStmt ast;

      final override predicate propagatesAbnormal(ControlFlowElement child) {
        child.asAstNode() = ast.getIteratorVar()
        or
        child.asAstNode() = ast.getNextCall()
        or
        child.asAstNode() = ast.getPattern().getFullyUnresolved()
      }

      final override predicate first(ControlFlowElement first) {
        // Unlike most other statements, `foreach` statements are not modeled in
        // pre-order, because we use the `foreach` node itself to represent the
        // emptiness test that determines whether to execute the loop body
        astFirst(ast.getIteratorVar(), first)
      }

      final override predicate last(ControlFlowElement last, Completion c) {
        // Emptiness test exits with no more elements
        last.asAstNode() = ast and
        c.(EmptinessCompletion).isEmpty()
        or
        // Body exits with a break completion
        exists(BreakCompletion break |
          astLast(ast.getBody(), last, break) and
          // Propagate the break upwards if we need to break out of multiple loops.
          if break.getTarget() = ast then c instanceof SimpleCompletion else c = break
        )
        or
        // Body exits abnormally
        astLast(ast.getBody(), last, c) and
        not c instanceof NormalCompletion and
        not c instanceof ContinueCompletion and
        not c instanceof BreakCompletion
      }

      override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
        // Flow from last element of iterator expression to first element of iterator call
        astLast(ast.getIteratorVar(), pred, c) and
        c instanceof NormalCompletion and
        astFirst(ast.getNextCall().getFullyConverted(), succ)
        or
        // Flow from iterator call to emptiness test
        astLast(ast.getNextCall().getFullyConverted(), pred, c) and
        c instanceof NormalCompletion and
        succ.asAstNode() = ast
        or
        // Flow from emptiness test to first element of variable declaration/loop body
        pred.asAstNode() = ast and
        c = any(EmptinessCompletion ec | not ec.isEmpty()) and
        astFirst(ast.getPattern().getFullyUnresolved(), succ)
        or
        // Flow from last element of variable declaration ...
        astLast(ast.getPattern().getFullyUnresolved(), pred, c) and
        c instanceof NormalCompletion and
        (
          // ... to first element of loop body if no 'where' clause exists,
          astFirst(ast.getBody(), succ) and
          not exists(ast.getWhere())
          or
          // ... or to the 'where' clause.
          astFirst(ast.getWhere().getFullyConverted(), succ)
        )
        or
        // Flow from the where 'clause' ...
        astLast(ast.getWhere().getFullyConverted(), pred, c) and
        (
          // to the loop body if the condition is true,
          c instanceof TrueCompletion and
          astFirst(ast.getBody(), succ)
          or
          // or to the getNextCall if the condition is false.
          c instanceof FalseCompletion and
          astFirst(ast.getNextCall().getFullyConverted(), succ)
        )
        or
        // Flow from last element of loop body back to getNextCall
        astLast(ast.getBody(), pred, c) and
        c.continuesLoop(ast) and
        astFirst(ast.getNextCall().getFullyConverted(), succ)
      }
    }
  }

  private class BreakTree extends AstLeafTree {
    override BreakStmt ast;
  }

  private class ContinueTree extends AstLeafTree {
    override ContinueStmt ast;
  }

  private class SwitchTree extends AstPreOrderTree {
    override SwitchStmt ast;

    override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getExpr().getFullyConverted()
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Switch expression exits normally and there are no cases
      not exists(ast.getACase()) and
      astLast(ast.getExpr().getFullyConverted(), last, c) and
      c instanceof NormalCompletion
      or
      // A statement exits
      astLast(ast.getACase().getBody(), last, c)
      // Note: There's no need for an exit with a non-match as
      // Swift's switch statements are always exhaustive.
    }

    override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Flow from last element of switch expression to first element of first case
      c instanceof NormalCompletion and
      astLast(ast.getExpr().getFullyConverted(), pred, c) and
      astFirst(ast.getFirstCase(), succ)
      or
      // Flow from last element of case pattern to next case
      exists(CaseStmt case, int i | case = ast.getCase(i) |
        astLast(case.getLastLabel(), pred, c) and
        c.(MatchingCompletion).isNonMatch() and
        astFirst(ast.getCase(i + 1), succ)
      )
      or
      // Flow from a case statement that ends in a fallthrough
      // statement to the next statement
      astLast(ast.getACase().getBody(), pred, c) and
      astFirst(c.(FallthroughCompletion).getDestination().getBody(), succ)
      or
      // Pre-order: flow from statement itself to first switch expression
      pred.asAstNode() = ast and
      astFirst(ast.getExpr().getFullyConverted(), succ) and
      c instanceof SimpleCompletion
    }
  }

  private class CaseLabelItemTree extends AstPreOrderTree {
    override CaseLabelItem ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getGuard().getFullyConverted()
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // If the last node is the pattern ...
      astLast(ast.getPattern().getFullyUnresolved(), last, c) and
      (
        // then it's because we failed to match it
        c.(MatchingCompletion).isNonMatch()
        or
        // Or because, there is no guard (in which case we can also finish the evaluation
        // here on a successful match).
        c.(MatchingCompletion).isMatch() and
        not ast.hasGuard()
      )
      or
      // Or it can be the guard if a guard exists
      exists(BooleanCompletion booleanComp |
        astLast(ast.getGuard().getFullyUnresolved(), last, booleanComp)
      |
        booleanComp.getValue() = c.(MatchingCompletion).getValue()
      )
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: Flow from this to the pattern
      pred.asAstNode() = ast and
      astFirst(ast.getPattern().getFullyUnresolved(), succ) and
      c instanceof SimpleCompletion
      or
      // Flow from a matching pattern to the guard, if any
      astLast(ast.getPattern().getFullyUnresolved(), pred, c) and
      c instanceof MatchingCompletion and
      succ.asAstNode() = ast.getGuard().getFullyConverted()
    }
  }

  private class CaseTree extends AstPreOrderTree {
    override CaseStmt ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getALabel()
      or
      child.asAstNode() = ast.getBody()
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      // Case pattern exits with a non-match
      astLast(ast.getLastLabel().getFullyUnresolved(), last, c) and
      not c.(MatchingCompletion).isMatch()
      or
      // Case body exits with any completion
      astLast(ast.getBody(), last, c)
    }

    override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: Flow from the case statement itself to the first label
      pred.asAstNode() = ast and
      astFirst(ast.getFirstLabel().getFullyUnresolved(), succ) and
      c instanceof SimpleCompletion
      or
      // Left-to-right evaluation of labels until we find a match
      exists(int i |
        astLast(ast.getLabel(i).getFullyUnresolved(), pred, c) and
        astFirst(ast.getLabel(i + 1).getFullyUnresolved(), succ) and
        c.(MatchingCompletion).isNonMatch()
      )
      or
      // Flow from last element of pattern to first element of body
      astLast(ast.getALabel().getFullyUnresolved(), pred, c) and
      astFirst(ast.getBody(), succ) and
      c.(MatchingCompletion).isMatch()
    }
  }

  private class FallThroughTree extends AstLeafTree {
    override FallthroughStmt ast;
  }

  private class DeferTree extends AstLeafTree {
    override DeferStmt ast;
  }

  private class ThrowExprTree extends AstPostOrderTree {
    override ThrowStmt ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getSubExpr().getFullyConverted()
    }

    final override predicate first(ControlFlowElement first) {
      astFirst(ast.getSubExpr().getFullyConverted(), first)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Post-order: flow from thrown expression to the throw statement.
      astLast(ast.getSubExpr().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      succ.asAstNode() = ast
    }
  }

  abstract class DoOrDoCatchTree extends AstPreOrderTree {
    DoOrDoCatchTree() {
      ast instanceof DoStmt
      or
      ast instanceof DoCatchStmt
    }

    abstract ControlFlowElement getBody();

    override predicate last(ControlFlowElement last, Completion c) {
      // The last element of the body is always a candidate for the last element of the statement.
      // Note that this is refined in `DoCatchTree` to only be the last statement if the body
      // doesn't end with a throw completion.
      last(this.getBody(), last, c)
    }

    override predicate propagatesAbnormal(ControlFlowElement child) { none() }

    override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: flow from statement itself to first element of body
      pred.asAstNode() = ast and
      first(this.getBody(), succ) and
      c instanceof SimpleCompletion
    }
  }

  class DoCatchTree extends DoOrDoCatchTree {
    override DoCatchStmt ast;

    final override ControlFlowTree getBody() { result.asAstNode() = ast.getBody() }

    override predicate last(ControlFlowElement last, Completion c) {
      DoOrDoCatchTree.super.last(last, c) and
      not c instanceof ThrowCompletion
      or
      // Any catch can be the last element to be evaluated.
      astLast(ast.getACatch().getBody(), last, c)
      or
      // We failed to match on any of the clauses.
      // TODO: This can actually only happen if the enclosing function is marked with 'throws'.
      //       So we could make this more precise.
      astLast(ast.getLastCatch(), last, c) and
      c = any(MatchingCompletion mc | not mc.isMatch())
    }

    override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      DoOrDoCatchTree.super.succ(pred, succ, c)
      or
      // Flow from the body to the first catch when an exception occurs
      last(this.getBody(), pred, c) and
      c instanceof ThrowCompletion and
      astFirst(ast.getFirstCatch(), succ)
      or
      exists(int i |
        // Flow from one `catch` clause to the next
        astLast(ast.getCatch(i), pred, c) and
        astFirst(ast.getCatch(i + 1), succ) and
        c = any(MatchingCompletion mc | not mc.isMatch())
      )
    }
  }

  class DoTree extends DoOrDoCatchTree {
    override DoStmt ast;

    final override ControlFlowElement getBody() { result.asAstNode() = ast.getBody() }

    final override predicate propagatesAbnormal(ControlFlowElement child) { child = this.getBody() }
  }
}

/** A class that exists to allow control-flow through incorrectly extracted AST nodes. */
private class UnknownAstTree extends AstLeafTree {
  UnknownAstTree() { ast.isUnknown() }
}

/**
 * Control-flow for patterns (which appear in `switch` statements
 * and `catch` statements).
 */
module Patterns {
  private class TypedTree extends AstStandardPostOrderTree {
    override TypedPattern ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and
      result.asAstNode() = ast.getSubPattern().getFullyUnresolved()
    }
  }

  private class TupleTree extends AstPreOrderTree {
    override TuplePattern ast;

    final override predicate propagatesAbnormal(ControlFlowElement n) {
      n.asAstNode() = ast.getAnElement().getFullyUnresolved()
    }

    final override predicate last(ControlFlowElement n, Completion c) {
      // A subpattern failed to match
      astLast(ast.getAnElement().getFullyUnresolved(), n, c) and
      not c.(MatchingCompletion).isMatch()
      or
      // We finished matching on all subpatterns
      astLast(ast.getLastElement().getFullyUnresolved(), n, c) and
      c instanceof NormalCompletion
    }

    override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: Flow from this to the first subpattern
      pred.asAstNode() = ast and
      astFirst(ast.getFirstElement().getFullyUnresolved(), succ) and
      c instanceof SimpleCompletion
      or
      // Flow from an element that matched to the next element
      exists(int i |
        astLast(ast.getElement(i).getFullyUnresolved(), pred, c) and
        c.(MatchingCompletion).isMatch() and
        astFirst(ast.getElement(i + 1).getFullyUnresolved(), succ)
      )
    }
  }

  private class ParenTree extends AstStandardPreOrderTree {
    override ParenPattern ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and
      result.asAstNode() = ast.getResolveStep()
    }
  }

  private class NamedTree extends AstLeafTree {
    override NamedPattern ast;
  }

  private class BoolTree extends AstLeafTree {
    override BoolPattern ast;
  }

  private class AnyTree extends AstLeafTree {
    override AnyPattern ast;
  }

  private class IsTree extends AstStandardPostOrderTree {
    override IsPattern ast;

    final override ControlFlowElement getChildNode(int i) {
      // Note: `getSubPattern` only has a result if the `is` pattern is of the form `pattern as type`.
      i = 0 and
      result.asAstNode() = ast.getSubPattern().getFullyUnresolved()
    }
  }

  private class EnumElementTree extends AstPreOrderTree {
    override EnumElementPattern ast;

    final override predicate propagatesAbnormal(ControlFlowElement n) {
      n.asAstNode() = ast.getSubPattern().getFullyUnresolved()
    }

    final override predicate last(ControlFlowElement n, Completion c) {
      // We finished the subpattern check
      astLast(ast.getSubPattern().getFullyUnresolved(), n, c) and
      c instanceof NormalCompletion
      or
      // Or we got to the enum element check which failed
      n.asAstNode() = ast and
      c.(MatchingCompletion).isNonMatch()
      or
      // No sub pattern: We can either succeed or fail this match depending on the enum element check.
      n.asAstNode() = ast and
      not exists(ast.getSubPattern()) and
      c instanceof MatchingCompletion
    }

    override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: Flow from the enumeration check to the subpattern
      pred.asAstNode() = ast and
      astFirst(ast.getSubPattern().getFullyUnresolved(), succ) and
      c.(MatchingCompletion).isMatch()
    }
  }

  private class BindingTree extends AstStandardPostOrderTree {
    override BindingPattern ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and
      result.asAstNode() = ast.getResolveStep()
    }
  }

  private class ExprTree extends AstStandardPostOrderTree {
    override ExprPattern ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and
      result.asAstNode() = ast.getSubExpr().getFullyConverted()
    }
  }

  private class OptionalSomeTree extends AstPreOrderTree {
    override OptionalSomePattern ast;

    final override predicate propagatesAbnormal(ControlFlowElement n) {
      n.asAstNode() = ast.getSubPattern().getFullyUnresolved()
    }

    final override predicate last(ControlFlowElement n, Completion c) {
      // The subpattern check either failed or succeeded
      astLast(ast.getSubPattern().getFullyUnresolved(), n, c) and
      c instanceof NormalCompletion
      or
      // Or we got to the some/none check and it failed
      n.asAstNode() = ast and
      c.(MatchingCompletion).isNonMatch()
    }

    override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      // Pre-order: Flow from a matching some/none check to the subpattern
      pred.asAstNode() = ast and
      astFirst(ast.getSubPattern().getFullyUnresolved(), succ) and
      c.(MatchingCompletion).isMatch()
    }
  }
}

module Decls {
  private class VarDeclTree extends AstLeafTree {
    override VarDecl ast;
  }

  private class PatternBindingDeclTree extends AstStandardPostOrderTree {
    override PatternBindingDecl ast;

    final override ControlFlowElement getChildNode(int i) {
      exists(int j |
        i = 2 * j and
        result.asAstNode() = ast.getPattern(j).getFullyUnresolved()
      )
      or
      // synthesized pattern bindings for property wrappers may be sharing the init with the backed
      // variable declaration, so we need to skip those
      not exists(VarDecl decl |
        ast =
          [
            decl.getPropertyWrapperBackingVarBinding(),
            decl.getPropertyWrapperProjectionVarBinding()
          ]
      ) and
      exists(int j |
        i = 2 * j + 1 and
        result.asAstNode() = ast.getInit(j).getFullyConverted()
      )
    }
  }

  /**
   * The control-flow of a type declaration. This is necessary to skip past local type
   * declarations that occur inside bodies like in:
   * ```swift
   * func foo() -> Int {
   *   let x = 42
   *   class C {}
   *   return x
   * }
   * ```
   */
  private class TypeDeclTree extends AstLeafTree {
    override TypeDecl ast;
  }

  /**
   * The control-flow of a function declaration. This is necessary to skip past local function
   * declarations that occur inside bodies like in:
   * ```swift
   * func foo() -> Int {
   *   let x = 42
   *   func bar() { ... }
   *   return x
   * }
   * ```
   */
  private class FunctionTree extends AstLeafTree {
    override Function ast;
  }

  /** The control-flow of a function declaration body. */
  class FuncDeclTree extends StandardPreOrderTree, TFuncDeclElement {
    Function ast;

    FuncDeclTree() { this = TFuncDeclElement(ast) }

    Function getAst() { result = ast }

    final override ControlFlowElement getChildNode(int i) {
      i = -1 and
      result.asAstNode() = ast.getSelfParam()
      or
      result.asAstNode() = ast.getParam(i)
      or
      result.asAstNode() = ast.getBody() and
      i = ast.getNumberOfParams()
    }
  }

  /**
   * The control-flow of an #if block.
   * The active elements are already listed in the containing scope, so we can just flow through
   * this as a leaf.
   */
  class IfConfigDeclTree extends AstLeafTree {
    override IfConfigDecl ast;
  }
}

module Exprs {
  module AssignExprs {
    /**
     * The control-flow of a `DiscardAssignmentExpr`, which represents the
     * `_` leaf expression that may appear on the left-hand side of an `AssignExpr`.
     */
    private class DiscardAssignmentExprTree extends AstLeafTree {
      override DiscardAssignmentExpr ast;
    }

    /**
     * The control-flow of an assignment operation.
     *
     * There are two implementation of this base class:
     * - One where the left-hand side has direct-to-storage-access semantics
     * - One where the left-hand side has direct-to-implementation-access semantics
     */
    abstract private class AssignExprTree extends AstControlFlowTree {
      override AssignExpr ast;

      final override predicate first(ControlFlowElement first) {
        astFirst(ast.getDest().getFullyConverted(), first)
      }

      abstract predicate isSet(ControlFlowElement n);

      abstract predicate isLast(ControlFlowElement n, Completion c);

      final override predicate propagatesAbnormal(ControlFlowElement child) {
        child.asAstNode() = ast.getDest().getFullyConverted() or
        child.asAstNode() = ast.getSource().getFullyConverted()
      }

      predicate hasWillSetObserver() { isPropertyObserverElement(_, any(WillSetObserver obs), ast) }

      predicate hasDidSetObserver() { isPropertyObserverElement(_, any(DidSetObserver obs), ast) }

      final override predicate last(ControlFlowElement last, Completion c) {
        isPropertyObserverElement(last, any(DidSetObserver obs), ast) and
        completionIsValidFor(c, last)
        or
        not this.hasDidSetObserver() and
        this.isLast(last, c)
      }

      final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
        // Flow from the destination to the source
        astLast(ast.getDest().getFullyConverted(), pred, c) and
        c instanceof NormalCompletion and
        astFirst(ast.getSource().getFullyConverted(), succ)
        or
        // Flow from the source to the `willSet` observer, if any. Otherwise, flow to the set operation
        astLast(ast.getSource().getFullyConverted(), pred, c) and
        c instanceof NormalCompletion and
        (
          if this.hasWillSetObserver()
          then isPropertyObserverElement(succ, any(WillSetObserver obs), ast)
          else this.isSet(succ)
        )
        or
        // Flow from the set operation to the `didSet` observer, if any
        this.isSet(pred) and
        completionIsValidFor(c, pred) and
        isPropertyObserverElement(succ, any(DidSetObserver obs), ast)
      }
    }

    /**
     * The control-flow for assignments where the left-hand side has
     * direct-to-implementation-access semantics.
     */
    class PropertyAssignExpr extends AssignExprTree {
      Accessor accessor;

      PropertyAssignExpr() { isPropertySetterElement(_, accessor, ast) }

      final override predicate isLast(ControlFlowElement last, Completion c) {
        isPropertySetterElement(last, accessor, ast) and
        completionIsValidFor(c, last)
      }

      final override predicate isSet(ControlFlowElement node) {
        isPropertySetterElement(node, _, ast)
      }
    }

    /**
     * The control-flow for assignments where the left-hand side has
     * direct-to-storage-access semantics.
     */
    class DirectAssignExpr extends AssignExprTree {
      DirectAssignExpr() { not this instanceof PropertyAssignExpr }

      final override predicate isLast(ControlFlowElement last, Completion c) {
        last.asAstNode() = ast and
        completionIsValidFor(c, last)
      }

      final override predicate isSet(ControlFlowElement node) { node.asAstNode() = ast }
    }
  }

  /**
   * The control flow for an explicit closure or a normal autoclosure in its
   * role as a control flow scope.
   */
  class ClosureExprTree extends StandardPreOrderTree, TClosureElement {
    ClosureExpr expr;

    ClosureExprTree() { this = TClosureElement(expr) }

    ClosureExpr getAst() { result = expr }

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = expr.getParam(i)
      or
      result.asAstNode() = expr.getBody() and
      i = expr.getNumberOfParams()
    }
  }

  private class BindOptionalTree extends AstStandardPostOrderTree {
    override BindOptionalExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class CaptureListTree extends AstStandardPostOrderTree {
    override CaptureListExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getBindingDecl(i).getFullyUnresolved()
      or
      i = ast.getNumberOfBindingDecls() and
      result.asAstNode() = ast.getClosureBody().getFullyConverted()
    }
  }

  module Closures {
    class Closure = @auto_closure_expr or @closure_expr;

    // TODO: Traverse the expressions in the capture list once we extract it.
    private class ExplicitClosureTree extends AstLeafTree {
      override ExplicitClosureExpr ast;
    }

    /**
     * An autoclosure expression that is generated as part of a logical operation or nil coalescing expression.
     *
     * This is needed because the Swift AST for `b1 && b2` is really syntactic sugar a function call:
     * ```swift
     * logical_and(b1, () => { return b2 })
     * ```
     * So the `true` edge from `b1` cannot just go to `b2` since this is an implicit autoclosure.
     * To handle this dig into the autoclosure when it's an operand of a logical operator.
     */
    private class ShortCircuitingAutoClosureTree extends AstPreOrderTree {
      override AutoClosureExpr ast;

      ShortCircuitingAutoClosureTree() {
        ast = any(LogicalOperation op).getAnOperand() or
        ast = any(NilCoalescingExpr expr).getAnOperand()
      }

      override predicate last(ControlFlowElement last, Completion c) {
        exists(Completion completion | astLast(ast.getReturn(), last, completion) |
          if completion instanceof ReturnCompletion
          then c instanceof SimpleCompletion
          else c = completion
        )
      }

      override predicate propagatesAbnormal(ControlFlowElement child) {
        child.asAstNode() = ast.getReturn()
      }

      override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
        // Pre order: Flow from this to the uniquely wrapped expr
        pred.asAstNode() = ast and
        astFirst(ast.getReturn(), succ) and
        c instanceof SimpleCompletion
      }
    }

    /** An autoclosure expression that is _not_ part of a logical operation. */
    private class AutoClosureTree extends AstLeafTree {
      override AutoClosureExpr ast;

      AutoClosureTree() { not this instanceof ShortCircuitingAutoClosureTree }
    }
  }

  class KeyPathTree extends AstLeafTree {
    override KeyPathExpr ast;
  }

  class KeyPathApplicationTree extends AstStandardPostOrderTree {
    override KeyPathApplicationExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and result.asAstNode() = ast.getBase().getFullyConverted()
      or
      i = 1 and result.asAstNode() = ast.getKeyPath().getFullyConverted()
    }
  }

  private class SubscriptTree extends AstControlFlowTree {
    override SubscriptExpr ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getBase().getFullyConverted()
      or
      child.asAstNode() = ast.getAnArgument().getExpr().getFullyConverted()
    }

    final override predicate first(ControlFlowElement first) {
      astFirst(ast.getBase().getFullyConverted(), first)
    }

    final override predicate last(ControlFlowElement last, Completion c) {
      (
        // If we need to do a call to a getter/setter, in which case
        // the index expression is the last expression we compute before we call the property access.
        if ignoreAstElement(ast)
        then isPropertyGetterElement(last, _, ast)
        else
          // If the subscript has direct-to-storage semantics we transfer flow to th subscript
          // expression itself.
          last.asAstNode() = ast
      ) and
      completionIsValidFor(c, last)
    }

    override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      astLast(ast.getBase().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      astFirst(ast.getFirstArgument().getExpr().getFullyConverted(), succ)
      or
      exists(int i |
        astLast(ast.getArgument(i).getExpr().getFullyConverted(), pred, c) and
        c instanceof NormalCompletion and
        astFirst(ast.getArgument(i + 1).getExpr().getFullyConverted(), succ)
      )
      or
      astLast(ast.getLastArgument().getExpr().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      (
        if ignoreAstElement(ast)
        then isPropertyGetterElement(succ, _, ast)
        else succ.asAstNode() = ast
      )
    }
  }

  private class TupleTree extends AstStandardPostOrderTree {
    override TupleExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getElement(i).getFullyConverted()
    }
  }

  private class TupleElementTree extends AstStandardPostOrderTree {
    override TupleElementExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class RebindSelfInInitializerTree extends AstStandardPostOrderTree {
    override RebindSelfInInitializerExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class SuperRefTree extends AstLeafTree {
    override SuperRefExpr ast;
  }

  private class DotSyntaxBaseIgnoredTree extends AstStandardPostOrderTree {
    override DotSyntaxBaseIgnoredExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getQualifier().getFullyConverted() and i = 0
      or
      result.asAstNode() = ast.getSubExpr().getFullyConverted() and i = 1
    }
  }

  private class TypeTree extends AstLeafTree {
    override TypeExpr ast;
  }

  private class DynamicTypeTree extends AstStandardPostOrderTree {
    override DynamicTypeExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getBase().getFullyConverted() and i = 0
    }
  }

  private class LazyInitializationTree extends AstStandardPostOrderTree {
    override LazyInitializationExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class ObjCSelectorTree extends AstStandardPostOrderTree {
    override ObjCSelectorExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class OneWayTree extends AstStandardPostOrderTree {
    override OneWayExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class OptionalEvaluationTree extends AstStandardPostOrderTree {
    override OptionalEvaluationExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class NonInterpolatedLiteralExprTree extends AstLeafTree {
    override LiteralExpr ast;

    NonInterpolatedLiteralExprTree() {
      // This one needs special handling
      not ast instanceof InterpolatedStringLiteralExpr
    }
  }

  private class InterpolatedStringLiteralExprTree extends AstStandardPostOrderTree {
    override InterpolatedStringLiteralExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and
      result.asAstNode() = ast.getAppendingExpr().getFullyConverted()
    }
  }

  /** Control-flow for a `TapExpr`. See the QLDoc for `TapExpr` for the semantics of a `TapExpr`. */
  private class TapExprTree extends AstStandardPostOrderTree {
    override TapExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      // We first visit the expression that gives the local variable its initial value.
      i = 0 and
      result.asAstNode() = ast.getSubExpr().getFullyConverted()
      or
      // And then we visit the body that potentially mutates the local variable.
      i = 1 and
      result.asAstNode() = ast.getBody()
    }
  }

  /** Control-flow for a `SingleValueStmtExpr`. See the QLDoc for `SingleValueStmtExpr` for the semantics of a `SingleValueStmtExpr`. */
  private class SingleValueStmtExprTree extends AstStandardPostOrderTree {
    override SingleValueStmtExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and result.asAstNode() = ast.getStmt()
    }
  }

  /** Control-flow for Pack Expansion. See the QLDoc for `PackExpansionExpr` for details. */
  private class PackExpansionExprTree extends AstStandardPostOrderTree {
    override PackExpansionExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and result.asAstNode() = ast.getPatternExpr().getFullyConverted()
    }
  }

  /** Control-flow for Pack Expansion. See the QLDoc for `PackElementExpr` for details. */
  private class PackElementExprTree extends AstStandardPostOrderTree {
    override PackElementExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and result.asAstNode() = ast.getSubExpr().getFullyUnresolved()
    }
  }

  private class MaterializePackExprTree extends AstStandardPostOrderTree {
    override MaterializePackExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and result.asAstNode() = ast.getSubExpr().getFullyUnresolved()
    }
  }

  /** Control-flow for Move Semantics. See the QLDoc for `CopyExpr` for details. */
  private class CopyExprTree extends AstStandardPostOrderTree {
    override CopyExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and result.asAstNode() = ast.getSubExpr().getFullyUnresolved()
    }
  }

  /** Control-flow for Move Semantics. See the QLDoc for `ConsumeExpr` for details. */
  private class ConsumeExprTree extends AstStandardPostOrderTree {
    override ConsumeExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and result.asAstNode() = ast.getSubExpr().getFullyUnresolved()
    }
  }

  private class OpaqueValueExprTree extends AstLeafTree {
    override OpaqueValueExpr ast;
  }

  module DeclRefExprs {
    class DeclRefExprLValueTree extends AstLeafTree {
      override DeclRefExpr ast;

      DeclRefExprLValueTree() { isLValue(ast) }
    }

    class OtherInitializerRefTree extends AstLeafTree {
      override OtherInitializerRefExpr ast;
    }

    abstract class DeclRefExprRValueTree extends AstControlFlowTree {
      override DeclRefExpr ast;

      DeclRefExprRValueTree() { isRValue(ast) }

      override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
        none()
      }

      override predicate propagatesAbnormal(ControlFlowElement child) { none() }
    }

    private class PropertyDeclRefRValueTree extends DeclRefExprRValueTree {
      Accessor accessor;

      PropertyDeclRefRValueTree() { isPropertyGetterElement(_, accessor, ast) }

      final override predicate first(ControlFlowElement first) {
        isPropertyGetterElement(first, accessor, ast)
      }

      final override predicate last(ControlFlowElement last, Completion c) {
        isPropertyGetterElement(last, accessor, ast) and
        completionIsValidFor(c, last)
      }
    }

    private class DirectDeclRefRValueTree extends DeclRefExprRValueTree {
      DirectDeclRefRValueTree() { not this instanceof PropertyDeclRefRValueTree }

      final override predicate first(ControlFlowElement first) { first.asAstNode() = ast }

      final override predicate last(ControlFlowElement last, Completion c) {
        last.asAstNode() = ast and
        completionIsValidFor(c, last)
      }
    }
  }

  class MethodLookupExprTree extends AstStandardPreOrderTree {
    override MethodLookupExpr ast;

    override ControlFlowElement getChildNode(int i) {
      i = 0 and result.asAstNode() = ast.getBase().getFullyConverted()
    }
  }

  module MemberRefs {
    /**
     * The control-flow of a member reference expression.
     *
     * There are two implementation of this base class:
     * - One for lvalues
     * - One for rvalues
     */
    abstract private class MemberRefTreeBase extends AstControlFlowTree {
      override MemberRefExpr ast;

      final override predicate propagatesAbnormal(ControlFlowElement child) {
        child.asAstNode() = ast.getBase().getFullyConverted()
      }

      final override predicate first(ControlFlowElement first) {
        astFirst(ast.getBase().getFullyConverted(), first)
      }
    }

    /**
     * The lvalue implementation of `MemberRefTreeBase`
     */
    private class MemberRefLValueTree extends MemberRefTreeBase {
      MemberRefLValueTree() { isLValue(ast) }

      final override predicate last(ControlFlowElement last, Completion c) {
        last.asAstNode() = ast and
        completionIsValidFor(c, last)
      }

      override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
        astLast(ast.getBase().getFullyConverted(), pred, c) and
        c instanceof NormalCompletion and
        succ.asAstNode() = ast
      }
    }

    /**
     * The rvalue base implementation of `MemberRefTreeBase`.
     *
     * There are two implementations of this class:
     * - One for direct-storage semantics
     * - One for calls to getters
     */
    abstract private class MemberRefRValueTree extends MemberRefTreeBase {
      MemberRefRValueTree() { isRValue(ast) }
    }

    /**
     * Control-flow for rvalue member accesses with direct-to-storage semantics
     * or ordinary semantics without a getter.
     */
    private class DirectMemberRefRValue extends MemberRefRValueTree {
      DirectMemberRefRValue() { not this instanceof PropertyMemberRefRValue }

      final override predicate last(ControlFlowElement last, Completion c) {
        last.asAstNode() = ast and
        completionIsValidFor(c, last)
      }

      override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
        astLast(ast.getBase().getFullyConverted(), pred, c) and
        c instanceof NormalCompletion and
        succ.asAstNode() = ast
      }
    }

    /**
     * Control-flow for rvalue member accesses with direct-to-implementation semantics
     * or ordinary semantics that includes a getter.
     */
    private class PropertyMemberRefRValue extends MemberRefRValueTree {
      Accessor accessor;

      PropertyMemberRefRValue() { isPropertyGetterElement(_, accessor, ast) }

      final override predicate last(ControlFlowElement last, Completion c) {
        isPropertyGetterElement(last, accessor, ast) and
        completionIsValidFor(c, last)
      }

      override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
        astLast(ast.getBase().getFullyConverted(), pred, c) and
        c instanceof NormalCompletion and
        isPropertyGetterElement(succ, accessor, ast)
      }
    }
  }

  private class ApplyExprTree extends AstStandardPostOrderTree {
    override ApplyExpr ast;

    ApplyExprTree() {
      // This one is handled in `LogicalNotTree`.
      not ast instanceof UnaryLogicalOperation and
      // These are handled in `LogicalOrTree` and `LogicalAndTree`.
      not ast instanceof BinaryLogicalOperation and
      // This one is handled in `NilCoalescingTree`
      not ast instanceof NilCoalescingExpr
    }

    final override ControlFlowElement getChildNode(int i) {
      i = -1 and
      result.asAstNode() = ast.getFunction().getFullyConverted()
      or
      result.asAstNode() = ast.getArgument(i).getExpr().getFullyConverted()
    }
  }

  private class DefaultArgumentTree extends AstLeafTree {
    override DefaultArgumentExpr ast;
  }

  private class ForceValueTree extends AstStandardPostOrderTree {
    override ForceValueExpr ast;

    override ControlFlowElement getChildNode(int i) {
      i = 0 and
      result.asAstNode() = ast.getSubExpr().getFullyConverted()
    }
  }

  private class NilCoalescingTestTree extends LeafTree instanceof NilCoalescingElement {
    NilCoalescingExpr getAst() { result = super.getAst() }
  }

  private class NilCoalescingTree extends AstPostOrderTree {
    override NilCoalescingExpr ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getAnOperand().getFullyConverted()
    }

    final override predicate first(ControlFlowElement first) {
      astFirst(ast.getLeftOperand().getFullyConverted(), first)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      astLast(ast.getLeftOperand().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      succ.(NilCoalescingTestTree).getAst() = ast
      or
      pred.(NilCoalescingTestTree).getAst() = ast and
      exists(EmptinessCompletion ec | c = ec | ec.isEmpty()) and
      astFirst(ast.getRightOperand().getFullyConverted(), succ)
      or
      pred.(NilCoalescingTestTree).getAst() = ast and
      exists(EmptinessCompletion ec | c = ec | not ec.isEmpty()) and
      succ.asAstNode() = ast
      or
      astLast(ast.getRightOperand().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      succ.asAstNode() = ast
    }
  }

  private class LogicalAndTree extends AstPostOrderTree {
    override LogicalAndExpr ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getAnOperand().getFullyConverted()
    }

    final override predicate first(ControlFlowElement first) {
      astFirst(ast.getLeftOperand().getFullyConverted(), first)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      astLast(ast.getLeftOperand().getFullyConverted(), pred, c) and
      c instanceof TrueCompletion and
      astFirst(ast.getRightOperand().getFullyConverted(), succ)
      or
      astLast(ast.getLeftOperand().getFullyConverted(), pred, c) and
      c instanceof FalseCompletion and
      succ.asAstNode() = ast
      or
      astLast(ast.getRightOperand().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      succ.asAstNode() = ast
    }
  }

  private class LogicalNotTree extends AstPostOrderTree {
    override NotExpr ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getOperand().getFullyConverted()
    }

    final override predicate first(ControlFlowElement first) {
      astFirst(ast.getOperand().getFullyConverted(), first)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      succ.asAstNode() = ast and
      astLast(ast.getOperand().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion
    }
  }

  private class LogicalOrTree extends AstPostOrderTree {
    override LogicalOrExpr ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getAnOperand().getFullyConverted()
    }

    final override predicate first(ControlFlowElement first) {
      astFirst(ast.getLeftOperand().getFullyConverted(), first)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      astLast(ast.getLeftOperand().getFullyConverted(), pred, c) and
      c instanceof FalseCompletion and
      astFirst(ast.getRightOperand().getFullyConverted(), succ)
      or
      astLast(ast.getLeftOperand().getFullyConverted(), pred, c) and
      c instanceof TrueCompletion and
      succ.asAstNode() = ast
      or
      astLast(ast.getRightOperand().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      succ.asAstNode() = ast
    }
  }

  private class VarargExpansionTree extends AstStandardPostOrderTree {
    override VarargExpansionExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      i = 0 and
      result.asAstNode() = ast.getSubExpr().getFullyConverted()
    }
  }

  private class ArrayTree extends AstStandardPostOrderTree {
    override ArrayExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getElement(i).getFullyConverted()
    }
  }

  private class EnumIsCaseTree extends AstStandardPostOrderTree {
    override EnumIsCaseExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class IsTree extends AstStandardPostOrderTree {
    override IsExpr ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class IfTree extends AstPostOrderTree {
    override IfExpr ast;

    final override predicate propagatesAbnormal(ControlFlowElement child) {
      child.asAstNode() = ast.getCondition().getFullyConverted()
      or
      child.asAstNode() = ast.getBranch(_).getFullyConverted()
    }

    final override predicate first(ControlFlowElement first) {
      astFirst(ast.getCondition().getFullyConverted(), first)
    }

    final override predicate succ(ControlFlowElement pred, ControlFlowElement succ, Completion c) {
      astLast(ast.getCondition().getFullyConverted(), pred, c) and
      exists(boolean b |
        b = c.(BooleanCompletion).getValue() and
        astFirst(ast.getBranch(b).getFullyConverted(), succ)
      )
      or
      astLast(ast.getBranch(_).getFullyConverted(), pred, c) and
      succ.asAstNode() = ast and
      c instanceof NormalCompletion
    }
  }

  private class AnyTryTree extends AstStandardPostOrderTree {
    override AnyTryExpr ast;

    override ControlFlowElement getChildNode(int i) {
      i = 0 and
      result.asAstNode() = ast.getSubExpr().getFullyConverted()
    }
  }

  private class DictionaryLiteralTree extends AstStandardPostOrderTree {
    override DictionaryExpr ast;

    override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getElement(i).getFullyConverted()
    }
  }

  private class OpenExistentialTree extends AstStandardPostOrderTree {
    override OpenExistentialExpr ast;

    override ControlFlowElement getChildNode(int i) {
      i = 0 and
      result.asAstNode() = ast.getExistential().getFullyConverted()
      or
      i = 1 and
      result.asAstNode() = ast.getSubExpr().getFullyConverted()
    }
  }

  module Conversions {
    class ConversionOrIdentity =
      Synth::TIdentityExpr or Synth::TExplicitCastExpr or Synth::TImplicitConversionExpr or
          Synth::TInOutExpr;

    abstract class ConversionOrIdentityTree extends AstStandardPostOrderTree {
      ConversionOrIdentityTree() { ast instanceof ConversionOrIdentity }

      abstract predicate convertsFrom(Expr e);

      override ControlFlowElement getChildNode(int i) {
        i = 0 and
        this.convertsFrom(result.asAstNode())
      }
    }

    // This isn't actually a conversion, but it behaves like one.
    private class IdentityTree extends ConversionOrIdentityTree {
      override IdentityExpr ast;

      override predicate convertsFrom(Expr e) { ast.convertsFrom(e) }
    }

    private class ExplicitCastTree extends ConversionOrIdentityTree {
      override ExplicitCastExpr ast;

      override predicate convertsFrom(Expr e) { ast.convertsFrom(e) }
    }

    private class ImplicitConversionTree extends ConversionOrIdentityTree {
      override ImplicitConversionExpr ast;

      override predicate convertsFrom(Expr e) { ast.convertsFrom(e) }
    }

    private class InOutTree extends ConversionOrIdentityTree {
      override InOutExpr ast;

      override predicate convertsFrom(Expr e) { ast.convertsFrom(e) }
    }
  }
}

module AvailabilityInfo {
  private class AvailabilityInfoTree extends AstStandardPostOrderTree {
    override AvailabilityInfo ast;

    final override ControlFlowElement getChildNode(int i) {
      result.asAstNode() = ast.getSpec(i).getFullyUnresolved()
    }
  }

  private class AvailabilitySpecTree extends AstLeafTree {
    override AvailabilitySpec ast;
  }
}

private Scope parent(Scope n) {
  result = n.getOuterScope() and
  not n instanceof CfgScope::Range_
}

/** Gets the CFG scope of node `n`. */
pragma[inline]
CfgScope getCfgScope(ControlFlowElement n) {
  exists(ControlFlowElement n0 |
    pragma[only_bind_into](n0) = n and
    pragma[only_bind_into](result) = getCfgScopeImpl(n0)
  )
}

cached
private module Cached {
  /** Gets the CFG scope of node `n`. */
  cached
  CfgScope getCfgScopeImpl(ControlFlowElement n) {
    forceCachingInSameStage() and
    result = parent*(scopeOf(n))
  }

  private CfgScope scopeOf(ControlFlowElement n) {
    result = scopeOfAst(n.asAstNode()) or
    result = scopeOfAst(n.(PropertyGetterElement).getRef()) or
    result = scopeOfAst(n.(PropertySetterElement).getAssignExpr()) or
    result = scopeOfAst(n.(PropertyObserverElement).getAssignExpr()) or
    result = n.(FuncDeclElement).getAst() or
    result = n.(KeyPathElement).getAst()
  }

  cached
  newtype TSuccessorType =
    TSuccessorSuccessor() or
    TBooleanSuccessor(boolean b) { b in [false, true] } or
    TBreakSuccessor() or
    TContinueSuccessor() or
    TReturnSuccessor() or
    TMatchingSuccessor(boolean match) { match in [false, true] } or
    TFallthroughSuccessor() or
    TEmptinessSuccessor(boolean isEmpty) { isEmpty in [false, true] } or
    TExceptionSuccessor()
}

import Cached
