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
private import Completion
private import Scope
import ControlFlowGraphImplShared

module CfgScope {
  abstract class Range_ extends AstNode {
    abstract predicate entry(AstNode first);

    abstract predicate exit(AstNode last, Completion c);
  }

  private class BodyStmtCallableScope extends Range_ instanceof AbstractFunctionDecl {
    final override predicate entry(AstNode first) {
      super.getBody().(Stmts::BraceStmtTree).firstInner(first)
    }

    final override predicate exit(AstNode last, Completion c) {
      super.getBody().(Stmts::BraceStmtTree).last(last, c)
    }
  }
}

/** Holds if `first` is first executed when entering `scope`. */
pragma[nomagic]
predicate succEntry(CfgScope::Range_ scope, AstNode first) { scope.entry(first) }

/** Holds if `last` with completion `c` can exit `scope`. */
pragma[nomagic]
predicate succExit(CfgScope::Range_ scope, AstNode last, Completion c) { scope.exit(last, c) }

/**
 * Control-flow for statements.
 */
module Stmts {
  class BraceStmtTree extends ControlFlowTree instanceof BraceStmt {
    override predicate propagatesAbnormal(AstNode node) { none() }

    override predicate first(AstNode first) {
      this.firstInner(first)
      or
      not exists(super.getFirstElement()) and first = this
    }

    override predicate last(AstNode last, Completion c) {
      this.lastInner(last, c)
      or
      not exists(super.getFirstElement()) and last = this and c instanceof SimpleCompletion
    }

    predicate firstInner(AstNode first) { first(super.getFirstElement(), first) }

    /** Gets the body of the i'th `defer` statement. */
    private BraceStmt getDeferStmtBody(int i) {
      result =
        rank[i](DeferStmt defer, int index |
          defer = super.getElement(index)
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
        super.getElement(result) = defer
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

    predicate lastInner(AstNode last, Completion c) {
      // Normal exit and no defer statements
      last(super.getLastElement(), last, c) and
      not exists(this.getFirstDeferStmtBody()) and
      c instanceof NormalCompletion
      or
      // Normal exit from the last defer statement to be executed
      last(this.getLastDeferStmtBody(), last, c) and
      c instanceof NormalCompletion
      or
      // Abnormal exit without any defer statements
      not c instanceof NormalCompletion and
      last(super.getAnElement(), last, c) and
      not exists(this.getFirstDeferStmtBody())
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // left-to-right evaluation of statements
      exists(int i |
        last(super.getElement(i), pred, c) and
        first(super.getElement(i + 1), succ) and
        c instanceof NormalCompletion
      )
      or
      // Flow from last elements to the first defer statement to be executed
      c instanceof NormalCompletion and
      last(super.getLastElement(), pred, c) and
      first(this.getFirstDeferStmtBody(), succ)
      or
      // Flow from a defer statement to the next defer to be executed
      c instanceof NormalCompletion and
      exists(int i |
        last(this.getDeferStmtBody(i), pred, c) and
        first(this.getDeferStmtBody(i - 1), succ)
      )
      or
      // Abnormal exit from an element to the first defer statement to be executed.
      not c instanceof NormalCompletion and
      exists(int i |
        last(super.getElement(i), pred, c) and
        first(this.getDeferStmtBodyAfterStmt(i), succ)
      )
    }
  }

  private class ReturnStmtTree extends StandardPostOrderTree, ReturnStmt {
    final override ControlFlowTree getChildElement(int i) {
      result = this.getResult().getFullyConverted() and i = 0
    }
  }

  private class FailTree extends LeafTree instanceof FailStmt { }

  private class StmtConditionTree extends PostOrderTree instanceof StmtCondition {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getAnElement().getUnderlyingCondition()
    }

    final override predicate first(AstNode first) {
      first(super.getFirstElement().getUnderlyingCondition().getFullyUnresolved(), first)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Left-to-right evaluation of elements
      exists(int i |
        last(super.getElement(i).getUnderlyingCondition().getFullyUnresolved(), pred, c) and
        c instanceof NormalCompletion and
        first(super.getElement(i + 1).getUnderlyingCondition().getFullyUnresolved(), succ)
      )
      or
      // Post-order: flow from thrown expression to the throw statement.
      last(super.getLastElement().getUnderlyingCondition().getFullyUnresolved(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class IfStmtTree extends PreOrderTree instanceof IfStmt {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getCondition().getFullyUnresolved() or
      child = super.getThen() or
      child = super.getElse()
    }

    final override predicate last(AstNode last, Completion c) {
      // Condition exits with a false completion and there is no `else` branch
      last(super.getCondition().getFullyUnresolved(), last, c) and
      c instanceof FalseCompletion and
      not exists(super.getElse())
      or
      // Then/Else branch exits with any completion
      last(super.getBranch(_), last, c)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Pre-order: flow from statement itself to first element of condition
      pred = this and
      first(super.getCondition().getFullyUnresolved(), succ) and
      c instanceof SimpleCompletion
      or
      last(super.getCondition().getFullyUnresolved(), pred, c) and
      (
        // Flow from last element of condition to first element of then branch
        c instanceof TrueCompletion and first(super.getThen(), succ)
        or
        // Flow from last element of condition to first element of else branch
        c instanceof FalseCompletion and first(super.getElse(), succ)
      )
    }
  }

  private class GuardTree extends PreOrderTree instanceof GuardStmt {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getCondition().getFullyUnresolved() or
      child = super.getBody()
    }

    final override predicate last(AstNode last, Completion c) {
      // Normal exit after evaluating the body
      last(super.getBody(), last, c) and
      c instanceof NormalCompletion
      or
      // Exit when a condition is true
      last(super.getCondition().getFullyUnresolved(), last, c) and
      c instanceof TrueCompletion
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Pre-order: flow from statement itself to first element of condition
      pred = this and
      first(super.getCondition().getFullyUnresolved(), succ) and
      c instanceof SimpleCompletion
      or
      // Flow to the body when the condition is false
      last(super.getCondition().getFullyUnresolved(), pred, c) and
      c instanceof FalseCompletion and
      first(super.getBody(), succ)
    }
  }

  /**
   * Control-flow for loops.
   */
  module Loops {
    class ConditionalLoop = @while_stmt or @repeat_while_stmt;

    class LoopStmt = @for_each_stmt or ConditionalLoop;

    abstract class LoopTree extends PreOrderTree instanceof ConditionalLoop {
      abstract AstNode getCondition();

      abstract AstNode getBody();

      final override predicate propagatesAbnormal(AstNode child) { child = this.getCondition() }

      final override predicate last(AstNode last, Completion c) {
        // Condition exits with a false completion
        last(this.getCondition(), last, c) and
        c instanceof FalseCompletion
        or
        // Body exits with a break completion
        exists(BreakCompletion break |
          last(this.getBody(), last, break) and
          // Propagate the break upwards if we need to break out of multiple loops.
          if break.getTarget() = this then c instanceof SimpleCompletion else c = break
        )
        or
        // Body exits with a completion that does not continue the loop
        last(this.getBody(), last, c) and
        not c instanceof BreakCompletion and
        not c.continuesLoop(this)
      }

      override predicate succ(AstNode pred, AstNode succ, Completion c) {
        last(this.getCondition(), pred, c) and
        c instanceof TrueCompletion and
        first(this.getBody(), succ)
        or
        last(this.getBody(), pred, c) and
        first(this.getCondition(), succ) and
        c.continuesLoop(this)
      }
    }

    private class WhileTree extends LoopTree instanceof WhileStmt {
      final override AstNode getCondition() {
        result = WhileStmt.super.getCondition().getFullyUnresolved()
      }

      final override AstNode getBody() { result = WhileStmt.super.getBody() }

      final override predicate succ(AstNode pred, AstNode succ, Completion c) {
        LoopTree.super.succ(pred, succ, c)
        or
        pred = this and
        first(this.getCondition(), succ) and
        c instanceof SimpleCompletion
      }
    }

    private class RepeatWhileTree extends LoopTree instanceof RepeatWhileStmt {
      final override AstNode getCondition() {
        result = RepeatWhileStmt.super.getCondition().getFullyConverted()
      }

      final override AstNode getBody() { result = RepeatWhileStmt.super.getBody() }

      final override predicate succ(AstNode pred, AstNode succ, Completion c) {
        LoopTree.super.succ(pred, succ, c)
        or
        // Pre-order: Flow from the element to the body.
        pred = this and
        first(this.getBody(), succ) and
        c instanceof SimpleCompletion
      }
    }

    private class ForEachTree extends ControlFlowTree instanceof ForEachStmt {
      final override predicate propagatesAbnormal(AstNode child) {
        child = super.getSequence().getFullyConverted()
        or
        child = super.getPattern().getFullyUnresolved()
      }

      final override predicate first(AstNode first) {
        // Unlike most other statements, `foreach` statements are not modelled in
        // pre-order, because we use the `foreach` node itself to represent the
        // emptiness test that determines whether to execute the loop body
        first(super.getSequence().getFullyConverted(), first)
      }

      final override predicate last(AstNode last, Completion c) {
        // Emptiness test exits with no more elements
        last = this and
        c.(EmptinessCompletion).isEmpty()
        or
        // Body exits with a break completion
        exists(BreakCompletion break |
          last(super.getBody(), last, break) and
          // Propagate the break upwards if we need to break out of multiple loops.
          if break.getTarget() = this then c instanceof SimpleCompletion else c = break
        )
        or
        // Body exits abnormally
        last(super.getBody(), last, c) and
        not c instanceof NormalCompletion and
        not c instanceof ContinueCompletion and
        not c instanceof BreakCompletion
      }

      override predicate succ(AstNode pred, AstNode succ, Completion c) {
        // Flow from last element of iterator expression to emptiness test
        last(super.getSequence().getFullyConverted(), pred, c) and
        c instanceof NormalCompletion and
        succ = this
        or
        // Flow from emptiness test to first element of variable declaration/loop body
        pred = this and
        c = any(EmptinessCompletion ec | not ec.isEmpty()) and
        first(super.getPattern().getFullyUnresolved(), succ)
        or
        // Flow from last element of variable declaration ...
        last(super.getPattern().getFullyUnresolved(), pred, c) and
        c instanceof SimpleCompletion and
        (
          // ... to first element of loop body if no 'where' clause exists,
          first(super.getBody(), succ) and
          not exists(super.getWhere())
          or
          // ... or to the 'where' clause.
          first(super.getWhere().getFullyConverted(), succ)
        )
        or
        // Flow from the where 'clause' ...
        last(super.getWhere().getFullyConverted(), pred, c) and
        (
          // to the loop body if the condition is true,
          c instanceof TrueCompletion and
          first(super.getBody(), succ)
          or
          // or to the emptiness test if the condition is false.
          c instanceof FalseCompletion and
          succ = this
        )
        or
        // Flow from last element of loop body back to emptiness test.
        last(super.getBody(), pred, c) and
        c.continuesLoop(this) and
        succ = this
      }
    }
  }

  private class BreakTree extends LeafTree instanceof BreakStmt { }

  private class ContinueTree extends LeafTree instanceof ContinueStmt { }

  private class SwitchTree extends PreOrderTree instanceof SwitchStmt {
    override predicate propagatesAbnormal(AstNode child) {
      child = super.getExpr().getFullyConverted()
    }

    final override predicate last(AstNode last, Completion c) {
      // Switch expression exits normally and there are no cases
      not exists(super.getACase()) and
      last(super.getExpr().getFullyConverted(), last, c) and
      c instanceof NormalCompletion
      or
      // A statement exits (TODO: with a `break` completion?)
      last(super.getACase().getBody(), last, c) and
      c instanceof NormalCompletion
      // Note: There's no need for an exit with a non-match as
      // Swift's switch statements are always exhaustive.
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Flow from last element of switch expression to first element of first case
      c instanceof NormalCompletion and
      last(super.getExpr().getFullyConverted(), pred, c) and
      first(super.getFirstCase(), succ)
      or
      // Flow from last element of case pattern to next case
      exists(CaseStmt case, int i | case = super.getCase(i) |
        last(case.getLastLabel(), pred, c) and
        c.(MatchingCompletion).isNonMatch() and
        first(super.getCase(i + 1), succ)
      )
      or
      // Flow from a case statement that ends in a fallthrough
      // statement to the next statement
      last(super.getACase().getBody(), pred, c) and
      first(c.(FallthroughCompletion).getDestination().getBody(), succ)
      or
      // Pre-order: flow from statement itself to first switch expression
      pred = this and
      first(super.getExpr().getFullyConverted(), succ) and
      c instanceof SimpleCompletion
    }
  }

  private class CaseLabelItemTree extends PreOrderTree instanceof CaseLabelItem {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getGuard().getFullyConverted()
    }

    final override predicate last(AstNode last, Completion c) {
      // If the last node is the pattern ...
      last(super.getPattern().getFullyUnresolved(), last, c) and
      (
        // then it's because we failed to match it
        c.(MatchingCompletion).isNonMatch()
        or
        // Or because, there is no guard (in which case we can also finish the evaluation
        // here on a succesful match).
        c.(MatchingCompletion).isMatch() and
        not super.hasGuard()
      )
      or
      // Or it can be the guard if a guard exists
      exists(BooleanCompletion booleanComp |
        last(super.getGuard().getFullyUnresolved(), last, booleanComp)
      |
        booleanComp.getValue() = c.(MatchingCompletion).getValue()
      )
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Pre-order: Flow from this to the pattern
      pred = this and
      first(super.getPattern().getFullyUnresolved(), succ) and
      c instanceof SimpleCompletion
      or
      // Flow from a matching pattern to the guard, if any
      last(super.getPattern().getFullyUnresolved(), pred, c) and
      c instanceof MatchingCompletion and
      succ = super.getGuard().getFullyConverted()
    }
  }

  private class CaseTree extends PreOrderTree instanceof CaseStmt {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getALabel()
      or
      child = super.getBody()
    }

    final override predicate last(AstNode last, Completion c) {
      // Case pattern exits with a non-match
      last(super.getLastLabel().getFullyUnresolved(), last, c) and
      not c.(MatchingCompletion).isMatch()
      or
      // Case body exits with any completion
      last(super.getBody(), last, c)
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Pre-order: Flow from the case statement itself to the first label
      pred = this and
      first(super.getFirstLabel().getFullyUnresolved(), succ) and
      c instanceof SimpleCompletion
      or
      // Left-to-right evaluation of labels until we find a match
      exists(int i |
        last(super.getLabel(i).getFullyUnresolved(), pred, c) and
        first(super.getLabel(i + 1).getFullyUnresolved(), succ) and
        c.(MatchingCompletion).isNonMatch()
      )
      or
      // Flow from last element of pattern to first element of body
      last(super.getALabel().getFullyUnresolved(), pred, c) and
      first(super.getBody(), succ) and
      c.(MatchingCompletion).isMatch()
    }
  }

  private class FallThroughTree extends LeafTree instanceof FallthroughStmt { }

  private class DeferTree extends LeafTree instanceof DeferStmt { }

  private class ThrowExprTree extends PostOrderTree instanceof ThrowStmt {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getSubExpr().getFullyConverted()
    }

    final override predicate first(AstNode first) {
      first(super.getSubExpr().getFullyConverted(), first)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Post-order: flow from thrown expression to the throw statement.
      last(super.getSubExpr().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  class DoOrDoCatchStmt = @do_stmt or @do_catch_stmt;

  abstract class DoOrDoCatchTree extends PreOrderTree instanceof DoOrDoCatchStmt {
    abstract AstNode getBody();

    override predicate last(AstNode last, Completion c) {
      // The last element of the body is always a candidate for the last element of the statement.
      // Note that this is refined in `DoCatchTree` to only be the last statement if the body
      // doesn't end with a throw completion.
      last(this.getBody(), last, c)
    }

    override predicate propagatesAbnormal(AstNode child) { none() }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Pre-order: flow from statement itself to first element of body
      pred = this and
      first(this.getBody(), succ) and
      c instanceof SimpleCompletion
    }
  }

  class DoCatchTree extends DoOrDoCatchTree instanceof DoCatchStmt {
    final override AstNode getBody() { result = DoCatchStmt.super.getBody() }

    override predicate last(AstNode last, Completion c) {
      DoOrDoCatchTree.super.last(last, c) and
      not c instanceof ThrowCompletion
      or
      // Any catch can be the last element to be evaluated.
      last(super.getACatch(), last, c)
      or
      // We failed to match on any of the clauses.
      // TODO: This can actually only happen if the enclosing function is marked with 'throws'.
      //       So we could make this more precise.
      last(super.getLastCatch(), last, c) and
      c = any(MatchingCompletion mc | not mc.isMatch())
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      DoOrDoCatchTree.super.succ(pred, succ, c)
      or
      // Flow from the body to the first catch when an exception occurs
      last(this.getBody(), pred, c) and
      c instanceof ThrowCompletion and
      first(super.getFirstCatch(), succ)
      or
      exists(int i |
        // Flow from one `catch` clause to the next
        last(super.getCatch(i), pred, c) and
        first(super.getCatch(i + 1), succ) and
        c = any(MatchingCompletion mc | not mc.isMatch())
      )
    }
  }

  class DoTree extends DoOrDoCatchTree instanceof DoStmt {
    final override AstNode getBody() { result = DoStmt.super.getBody() }

    final override predicate propagatesAbnormal(AstNode child) { child = this.getBody() }
  }
}

/** A class that exists to allow control-flow through incorrectly extracted AST nodes. */
private class UnknownAstTree extends LeafTree instanceof UnknownElement { }

/**
 * Control-flow for patterns (which appear in `switch` statements
 * and `catch` statements).
 */
module Patterns {
  private class TypedTree extends StandardPostOrderTree instanceof TypedPattern {
    final override ControlFlowTree getChildElement(int i) {
      i = 0 and
      result = super.getSubPattern().getFullyUnresolved()
    }
  }

  private class TupleTree extends PreOrderTree instanceof TuplePattern {
    final override predicate propagatesAbnormal(AstNode n) {
      n = super.getAnElement().getFullyUnresolved()
    }

    final override predicate last(AstNode n, Completion c) {
      // A subpattern failed to match
      last(super.getAnElement().getFullyUnresolved(), n, c) and
      not c.(MatchingCompletion).isMatch()
      or
      // We finished matching on all subpatterns
      last(super.getLastElement().getFullyUnresolved(), n, c) and
      c instanceof NormalCompletion
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Pre-order: Flow from this to the first subpattern
      pred = this and
      first(super.getFirstElement().getFullyUnresolved(), succ) and
      c instanceof SimpleCompletion
      or
      // Flow from an element that matched to the next element
      exists(int i |
        last(super.getElement(i).getFullyUnresolved(), pred, c) and
        c.(MatchingCompletion).isMatch() and
        first(super.getElement(i + 1).getFullyUnresolved(), succ)
      )
    }
  }

  private class ParenTree extends StandardPreOrderTree instanceof ParenPattern {
    final override ControlFlowTree getChildElement(int i) {
      i = 0 and
      result = ParenPattern.super.getResolveStep()
    }
  }

  private class NamedTree extends LeafTree instanceof NamedPattern { }

  private class BoolTree extends LeafTree instanceof BoolPattern { }

  private class AnyTree extends LeafTree instanceof AnyPattern { }

  private class IsTree extends StandardPostOrderTree instanceof IsPattern {
    final override ControlFlowTree getChildElement(int i) {
      // Note: `getSubPattern` only has a result if the `is` pattern is of the form `pattern as type`.
      i = 0 and
      result = super.getSubPattern().getFullyUnresolved()
      or
      i = 1 and
      result = super.getCastTypeRepr()
    }
  }

  private class EnumElementTree extends PreOrderTree instanceof EnumElementPattern {
    final override predicate propagatesAbnormal(AstNode n) {
      n = super.getSubPattern().getFullyUnresolved()
    }

    final override predicate last(AstNode n, Completion c) {
      // We finished the subpattern check
      last(super.getSubPattern().getFullyUnresolved(), n, c) and
      c instanceof NormalCompletion
      or
      // Or we got to the enum element check which failed
      n = this and
      c.(MatchingCompletion).isNonMatch()
      or
      // No sub pattern: We can either succeed or fail this match depending on the enum element check.
      n = this and
      not exists(super.getSubPattern()) and
      c instanceof MatchingCompletion
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Pre-order: Flow from the enumeration check to the subpattern
      pred = this and
      first(super.getSubPattern().getFullyUnresolved(), succ) and
      c.(MatchingCompletion).isMatch()
    }
  }

  private class BindingTree extends PostOrderTree instanceof BindingPattern {
    final override predicate propagatesAbnormal(AstNode n) {
      n = super.getSubPattern().getFullyUnresolved()
    }

    final override predicate first(AstNode n) {
      first(super.getSubPattern().getFullyUnresolved(), n)
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getSubPattern().getFullyUnresolved(), pred, c) and
      c.(MatchingCompletion).isMatch() and
      succ = this
    }
  }

  private class ExprTree extends StandardPostOrderTree instanceof ExprPattern {
    final override ControlFlowTree getChildElement(int i) {
      i = 0 and
      result = super.getSubExpr().getFullyConverted()
    }
  }

  private class OptionalSomeTree extends PreOrderTree instanceof OptionalSomePattern {
    final override predicate propagatesAbnormal(AstNode n) {
      n = super.getSubPattern().getFullyUnresolved()
    }

    final override predicate last(AstNode n, Completion c) {
      // The subpattern check either failed or succeeded
      last(super.getSubPattern().getFullyUnresolved(), n, c) and
      c instanceof NormalCompletion
      or
      // Or we got to the some/none check and it failed
      n = this and
      not c.(MatchingCompletion).isMatch()
    }

    override predicate succ(AstNode pred, AstNode succ, Completion c) {
      // Pre-order: Flow from a matching some/none check to the subpattern
      pred = this and
      first(super.getSubPattern().getFullyUnresolved(), succ) and
      c.(MatchingCompletion).isMatch()
    }
  }
}

module Decls {
  private class VarDeclTree extends LeafTree instanceof VarDecl { }

  private class PatternBindingDeclTree extends StandardPostOrderTree instanceof PatternBindingDecl {
    final override ControlFlowTree getChildElement(int i) {
      exists(int j |
        i = 2 * j and
        result = super.getPattern(j).getFullyUnresolved()
      )
      or
      exists(int j |
        i = 2 * j + 1 and
        result = super.getInit(j).getFullyConverted()
      )
    }
  }
}

module Exprs {
  private class AssignExprTree extends StandardPostOrderTree instanceof AssignExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getDest().getFullyConverted() and i = 0
      or
      result = super.getSource().getFullyConverted() and i = 1
    }
  }

  private class BindOptionalTree extends StandardPostOrderTree instanceof BindOptionalExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class CaptureListTree extends StandardPostOrderTree instanceof CaptureListExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getBindingDecl(i).getFullyUnresolved()
      or
      i = super.getNumberOfBindingDecls() and
      result = super.getClosureBody().getFullyConverted()
    }
  }

  module Closures {
    class Closure = @auto_closure_expr or @closure_expr;

    // TODO: Traverse the expressions in the capture list once we extract it.
    private class ClosureTree extends LeafTree instanceof ClosureExpr { }

    /**
     * An autoclosure expression that is generated as part of a logical operation.
     *
     * This is needed because the Swift AST for `b1 && b2` is really syntactic sugar a function call:
     * ```swift
     * logical_and(b1, () => { return b2 })
     * ```
     * So the `true` edge from `b1` cannot just go to `b2` since this is an implicit autoclosure.
     * To handle this dig into the autoclosure when it's an operand of a logical operator.
     */
    private class LogicalAutoClosureTree extends PreOrderTree instanceof AutoClosureExpr {
      LogicalAutoClosureTree() { this = any(LogicalOperation op).getAnOperand() }

      override predicate last(AstNode last, Completion c) {
        exists(Completion completion | last(super.getReturn(), last, completion) |
          if completion instanceof ReturnCompletion
          then c instanceof SimpleCompletion
          else c = completion
        )
      }

      override predicate propagatesAbnormal(AstNode child) { child = super.getReturn() }

      override predicate succ(AstNode pred, AstNode succ, Completion c) {
        // Pre order: Flow from this to the uniquely wrapped expr
        pred = this and
        first(super.getReturn(), succ) and
        c instanceof SimpleCompletion
      }
    }

    /** An autoclosure expression that is _not_ part of a logical operation. */
    private class AutoClosureTree extends LeafTree instanceof AutoClosureExpr {
      AutoClosureTree() { not this instanceof LogicalAutoClosureTree }
    }
  }

  private class InOutTree extends StandardPostOrderTree instanceof InOutExpr {
    final override ControlFlowTree getChildElement(int i) {
      i = 0 and result = super.getSubExpr().getFullyConverted()
    }
  }

  private class SubScriptTree extends StandardPostOrderTree instanceof SubscriptExpr {
    final override ControlFlowTree getChildElement(int i) {
      i = 0 and result = super.getBaseExpr().getFullyConverted()
      or
      i = 1 and result = super.getAnArgument().getExpr().getFullyConverted()
    }
  }

  private class TupleTree extends StandardPostOrderTree instanceof TupleExpr {
    TupleTree() { not this.getAnElement() = any(LogicalOperation op).getAnOperand() }

    final override ControlFlowTree getChildElement(int i) {
      result = super.getElement(i).getFullyConverted()
    }
  }

  private class TupleElementTree extends StandardPostOrderTree instanceof TupleElementExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class RebindSelfInConstructorTree extends StandardPostOrderTree instanceof RebindSelfInConstructorExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class SuperRefTree extends LeafTree instanceof SuperRefExpr { }

  private class DotSyntaxBaseIgnoredTree extends StandardPostOrderTree instanceof DotSyntaxBaseIgnoredExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getQualifier().getFullyConverted() and i = 0
      or
      result = super.getSubExpr().getFullyConverted() and i = 1
    }
  }

  private class TypeTree extends LeafTree instanceof TypeExpr { }

  private class DynamicTypeTree extends StandardPostOrderTree instanceof DynamicTypeExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getBaseExpr().getFullyConverted() and i = 0
    }
  }

  private class LazyInitializerTree extends StandardPostOrderTree instanceof LazyInitializerExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class ObjCSelectorTree extends StandardPostOrderTree instanceof ObjCSelectorExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class OneWayTree extends StandardPostOrderTree instanceof OneWayExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class OptionalEvaluationTree extends StandardPostOrderTree instanceof OptionalEvaluationExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getSubExpr().getFullyConverted() and i = 0
    }
  }

  private class NonInterpolatedLiteralExprTree extends LeafTree instanceof LiteralExpr {
    NonInterpolatedLiteralExprTree() {
      // This one needs special handling
      not this instanceof InterpolatedStringLiteralExpr
    }
  }

  private class InterpolatedStringLiteralExprTree extends StandardPostOrderTree instanceof InterpolatedStringLiteralExpr {
    final override ControlFlowTree getChildElement(int i) {
      none() // TODO
    }
  }

  private class DeclRefExprTree extends LeafTree instanceof DeclRefExpr { }

  private class MemberRefTree extends StandardPostOrderTree instanceof MemberRefExpr {
    final override AstNode getChildElement(int i) {
      result = super.getBaseExpr().getFullyConverted() and i = 0
    }
  }

  private class ApplyExprTree extends StandardPostOrderTree instanceof ApplyExpr {
    ApplyExprTree() {
      // This one is handled in `LogicalNotTree`.
      not this instanceof UnaryLogicalOperation and
      // These are handled in `LogicalOrTree` and `LogicalAndTree`.
      not this instanceof BinaryLogicalOperation
    }

    final override ControlFlowTree getChildElement(int i) {
      i = -1 and
      result = super.getFunction().getFullyConverted()
      or
      result = super.getArgument(i).getExpr().getFullyConverted()
    }
  }

  private class DefaultArgumentTree extends LeafTree instanceof DefaultArgumentExpr { }

  private class ForceValueTree extends StandardPostOrderTree instanceof ForceValueExpr {
    override AstNode getChildElement(int i) {
      i = 0 and
      result = super.getSubExpr().getFullyConverted()
    }
  }

  private class LogicalAndTree extends PostOrderTree, LogicalAndExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getAnOperand().getFullyConverted()
    }

    final override predicate first(AstNode first) {
      first(this.getLeftOperand().getFullyConverted(), first)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getLeftOperand().getFullyConverted(), pred, c) and
      c instanceof TrueCompletion and
      first(this.getRightOperand().getFullyConverted(), succ)
      or
      last(this.getLeftOperand().getFullyConverted(), pred, c) and
      c instanceof FalseCompletion and
      succ = this
      or
      last(this.getRightOperand().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class LogicalNotTree extends PostOrderTree, NotExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getOperand().getFullyConverted()
    }

    final override predicate first(AstNode first) {
      first(this.getOperand().getFullyConverted(), first)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      succ = this and
      last(this.getOperand().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion
    }
  }

  private class LogicalOrTree extends PostOrderTree, LogicalOrExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child = this.getAnOperand().getFullyConverted()
    }

    final override predicate first(AstNode first) {
      first(this.getLeftOperand().getFullyConverted(), first)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(this.getLeftOperand().getFullyConverted(), pred, c) and
      c instanceof FalseCompletion and
      first(this.getRightOperand().getFullyConverted(), succ)
      or
      last(this.getLeftOperand().getFullyConverted(), pred, c) and
      c instanceof TrueCompletion and
      succ = this
      or
      last(this.getRightOperand().getFullyConverted(), pred, c) and
      c instanceof NormalCompletion and
      succ = this
    }
  }

  private class VarargExpansionTree extends StandardPostOrderTree instanceof VarargExpansionExpr {
    final override ControlFlowTree getChildElement(int i) {
      i = 0 and
      result = super.getSubExpr().getFullyConverted()
    }
  }

  private class ArrayTree extends StandardPostOrderTree instanceof ArrayExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getElement(i).getFullyConverted()
    }
  }

  private class EnumIsCaseTree extends StandardPostOrderTree instanceof EnumIsCaseExpr {
    final override ControlFlowTree getChildElement(int i) {
      result = super.getSubExpr().getFullyConverted() and i = 0
      or
      result = super.getTypeRepr().getFullyUnresolved() and i = 1
    }
  }

  private class IfTree extends PostOrderTree instanceof IfExpr {
    final override predicate propagatesAbnormal(AstNode child) {
      child = super.getCondition().getFullyConverted()
      or
      child = super.getBranch(_).getFullyConverted()
    }

    final override predicate first(AstNode first) {
      first(super.getCondition().getFullyConverted(), first)
    }

    final override predicate succ(AstNode pred, AstNode succ, Completion c) {
      last(super.getCondition().getFullyConverted(), pred, c) and
      exists(boolean b |
        b = c.(BooleanCompletion).getValue() and
        first(super.getBranch(b).getFullyConverted(), succ)
      )
      or
      last(super.getBranch(_).getFullyConverted(), pred, c) and
      succ = this and
      c instanceof NormalCompletion
    }
  }

  private class TryTree extends StandardPostOrderTree instanceof TryExpr {
    override ControlFlowTree getChildElement(int i) {
      i = 0 and
      result = super.getSubExpr().getFullyConverted()
    }
  }

  private class DictionaryLiteralTree extends StandardPostOrderTree instanceof DictionaryExpr {
    override ControlFlowTree getChildElement(int i) { result = super.getElement(i) }
  }

  module Conversions {
    class ConversionOrIdentity = @identity_expr or @explicit_cast_expr or @implicit_conversion_expr;

    abstract class ConversionOrIdentityTree extends StandardPostOrderTree instanceof ConversionOrIdentity {
      abstract predicate convertsFrom(Expr e);

      override ControlFlowTree getChildElement(int i) {
        i = 0 and
        this.convertsFrom(result)
      }
    }

    // This isn't actually a conversion, but it behaves like one.
    private class IdentityTree extends ConversionOrIdentityTree instanceof IdentityExpr {
      override predicate convertsFrom(Expr e) { IdentityExpr.super.convertsFrom(e) }
    }

    private class ExplicitCastTree extends ConversionOrIdentityTree instanceof ExplicitCastExpr {
      override predicate convertsFrom(Expr e) { ExplicitCastExpr.super.convertsFrom(e) }
    }

    private class ImplicitConversionTree extends ConversionOrIdentityTree instanceof ImplicitConversionExpr {
      override predicate convertsFrom(Expr e) { ImplicitConversionExpr.super.convertsFrom(e) }
    }
  }
}

private Scope parent(Scope n) {
  result = n.getOuterScope() and
  not n instanceof CfgScope::Range_
}

/** Gets the CFG scope of node `n`. */
pragma[inline]
CfgScope getCfgScope(AstNode n) {
  exists(AstNode n0 |
    pragma[only_bind_into](n0) = n and
    pragma[only_bind_into](result) = getCfgScopeImpl(n0)
  )
}

cached
private module Cached {
  /** Gets the CFG scope of node `n`. */
  cached
  CfgScope getCfgScopeImpl(AstNode n) {
    forceCachingInSameStage() and
    result = parent*(scopeOf(n))
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
