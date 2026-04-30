/**
 * Provides classes representing the control flow graph within callables.
 */
overlay[local?]
module;

import java
private import codeql.controlflow.ControlFlowGraph
private import codeql.controlflow.SuccessorType
private import controlflow.internal.Preconditions

private module Cfg0 = Make0<Location, Ast>;

private module Cfg1 = Make1<Input>;

private module Cfg2 = Make2<Input>;

private import Cfg0
private import Cfg1
private import Cfg2
import Public

/** Provides an implementation of the AST signature for Java. */
private module Ast implements AstSig<Location> {
  private import java as J

  class AstNode = ExprParent;

  private predicate skipControlFlow(AstNode e) {
    e.(Expr).getParent*() instanceof Annotation or
    e instanceof TypeAccess or
    e instanceof ArrayTypeAccess or
    e instanceof UnionTypeAccess or
    e instanceof IntersectionTypeAccess or
    e instanceof WildcardTypeAccess or
    // Switch cases of the form `case e1 -> e2;` skip the ExprStmt and treat
    // the right-hand side as an expression. See `SwitchCase.getRuleExpression()`.
    any(SwitchCase sc).getRuleExpression() = e.(J::ExprStmt).getExpr()
  }

  AstNode getChild(AstNode n, int index) {
    not skipControlFlow(result) and
    not skipControlFlow(n) and
    result.(Expr).isNthChildOf(n, index)
    or
    result.(Stmt).isNthChildOf(n, index)
    or
    result = n.(SwitchCase).getRuleExpression() and index = -1
  }

  Callable getEnclosingCallable(AstNode node) {
    result = node.(Expr).getEnclosingCallable() or
    result = node.(Stmt).getEnclosingCallable()
  }

  class Callable = J::Callable;

  AstNode callableGetBody(Callable c) { result = c.getBody() }

  // TODO: Implement in order to include parameters in the CFG
  class Parameter extends AstNode {
    Parameter() { none() }

    Expr getDefaultValue() { none() }
  }

  Parameter callableGetParameter(Callable c, int i) { result = c.getParameter(i) }

  class Stmt = J::Stmt;

  class Expr = J::Expr;

  class BlockStmt = J::BlockStmt;

  class ExprStmt extends J::ExprStmt {
    ExprStmt() { not skipControlFlow(this) }
  }

  class IfStmt = J::IfStmt;

  class LoopStmt = J::LoopStmt;

  class WhileStmt = J::WhileStmt;

  class DoStmt = J::DoStmt;

  class ForStmt = J::ForStmt;

  final private class FinalEnhancedForStmt = J::EnhancedForStmt;

  class ForeachStmt extends FinalEnhancedForStmt {
    Expr getVariable() { result = super.getVariable() }

    Expr getCollection() { result = super.getExpr() }
  }

  class BreakStmt extends Stmt {
    BreakStmt() { this instanceof J::BreakStmt or this instanceof YieldStmt }
  }

  class ContinueStmt = J::ContinueStmt;

  class GotoStmt extends Stmt {
    GotoStmt() { none() }
  }

  class ReturnStmt = J::ReturnStmt;

  class Throw = J::ThrowStmt;

  final private class FinalTryStmt = J::TryStmt;

  class TryStmt extends FinalTryStmt {
    Stmt getBody() { result = super.getBlock() }

    CatchClause getCatch(int index) { result = super.getCatchClause(index) }

    Stmt getFinally() { result = super.getFinally() }
  }

  AstNode getTryInit(TryStmt try, int index) { result = try.getResource(index) }

  final private class FinalCatchClause = J::CatchClause;

  class CatchClause extends FinalCatchClause {
    AstNode getVariable() { result = super.getVariable() }

    Expr getCondition() { none() }

    Stmt getBody() { result = super.getBlock() }
  }

  class Switch extends AstNode {
    Switch() {
      this instanceof SwitchStmt or
      this instanceof SwitchExpr
    }

    Expr getExpr() {
      result = this.(SwitchStmt).getExpr() or
      result = this.(SwitchExpr).getExpr()
    }

    Case getCase(int index) {
      result = this.(SwitchStmt).getCase(index) or
      result = this.(SwitchExpr).getCase(index)
    }

    Stmt getStmt(int index) {
      result = this.(SwitchStmt).getStmt(index) or
      result = this.(SwitchExpr).getStmt(index)
    }
  }

  class Case extends AstNode instanceof J::SwitchCase {
    /** Gets a pattern being matched by this case. */
    AstNode getAPattern() {
      result = this.(PatternCase).getAPattern() or
      result = this.(ConstCase).getValue(_)
    }

    /** Gets the guard expression of this case, if any. */
    Expr getGuard() { result = this.(PatternCase).getGuard() }

    /**
     * Gets the body of this case, if any.
     *
     * A case can either have a body as a single child AST node given by this
     * predicate, or it can have an implicit body given by the sequence of
     * statements between this case and the next case.
     */
    AstNode getBody() {
      result = this.(J::SwitchCase).getRuleExpression()
      or
      result = this.(J::SwitchCase).getRuleStatement()
    }
  }

  class DefaultCase extends Case instanceof J::DefaultCase { }

  class ConditionalExpr = J::ConditionalExpr;

  class BinaryExpr = J::BinaryExpr;

  class LogicalAndExpr = AndLogicalExpr;

  class LogicalOrExpr = OrLogicalExpr;

  class NullCoalescingExpr extends BinaryExpr {
    NullCoalescingExpr() { none() }
  }

  class UnaryExpr = J::UnaryExpr;

  class LogicalNotExpr = LogNotExpr;

  class Assignment = J::Assignment;

  class AssignExpr = J::AssignExpr;

  class CompoundAssignment = J::AssignOp;

  class AssignLogicalAndExpr extends CompoundAssignment {
    AssignLogicalAndExpr() { none() }
  }

  class AssignLogicalOrExpr extends CompoundAssignment {
    AssignLogicalOrExpr() { none() }
  }

  class AssignNullCoalescingExpr extends CompoundAssignment {
    AssignNullCoalescingExpr() { none() }
  }

  final private class FinalBooleanLiteral = J::BooleanLiteral;

  class BooleanLiteral extends FinalBooleanLiteral {
    boolean getValue() { result = this.getBooleanValue() }
  }

  final private class FinalInstanceOfExpr = J::InstanceOfExpr;

  class PatternMatchExpr extends FinalInstanceOfExpr {
    PatternMatchExpr() { this.isPattern() }

    AstNode getPattern() { result = super.getPattern() }
  }
}

private module Exceptions {
  private predicate methodMayThrow(Method m) {
    exists(Stmt stmt |
      stmt instanceof ThrowStmt and
      not stmt.(ThrowStmt).getParent() = any(Method m0).getBody()
      or
      uncheckedExceptionFromMethod(any(MethodCall call | call.getEnclosingStmt() = stmt))
    |
      stmt.getEnclosingCallable() = m and
      not exists(TryStmt try |
        exists(try.getACatchClause()) and try.getBlock() = stmt.getEnclosingStmt*()
      )
    )
  }

  /**
   * Holds if an unchecked exception may occur in a precondition check or guard wrapper.
   */
  private predicate uncheckedExceptionFromMethod(MethodCall call) {
    (methodCallChecksArgument(call) or methodCallUnconditionallyThrows(call))
    or
    methodMayThrow(call.getMethod().getSourceDeclaration())
  }

  /**
   * Holds if an unchecked exception from `c` may transfer control to a finally
   * block inside which `c` is nested.
   */
  private predicate uncheckedExceptionFromFinally(Call c) {
    exists(TryStmt try |
      c.getEnclosingStmt().getEnclosingStmt+() = try.getBlock() or
      c.(Expr).getParent*() = try.getAResource()
    |
      exists(try.getFinally())
    )
  }

  /**
   * A throwable that's a (reflexive, transitive) supertype of an unchecked
   * exception. Besides the unchecked exceptions themselves, this includes
   * `java.lang.Throwable` and `java.lang.Exception`.
   */
  private class UncheckedThrowableSuperType extends RefType {
    UncheckedThrowableSuperType() {
      this instanceof TypeThrowable or
      this instanceof TypeException or
      this instanceof UncheckedThrowableType
    }
  }

  /**
   * Holds if an unchecked exception from `n` may be caught by an enclosing
   * catch clause.
   */
  private predicate uncheckedExceptionFromCatch(Ast::AstNode n) {
    exists(TryStmt try, UncheckedThrowableSuperType caught |
      n.(Stmt).getEnclosingStmt+() = try.getBlock() or
      n.(Expr).getEnclosingStmt().getEnclosingStmt+() = try.getBlock() or
      n.(Expr).getParent*() = try.getAResource()
    |
      try.getACatchClause().getACaughtType() = caught and
      (
        caught instanceof TypeClassCastException and n instanceof CastExpr
        or
        caught instanceof TypeNullPointerException and n instanceof NotNullExpr
        or
        n instanceof Call
      )
    )
  }

  /**
   * Holds if a catch clause of `try` catches checked exceptions of type
   * `caught`, and that `call` is contained within the try block.
   */
  private predicate checkedExceptionFromCatchCandidate(TryStmt try, RefType caught, Call call) {
    (
      call.getEnclosingStmt().getEnclosingStmt+() = try.getBlock() or
      call.(Expr).getParent*() = try.getAResource()
    ) and
    try.getACatchClause().getACaughtType() = caught and
    not caught instanceof UncheckedThrowableSuperType
  }

  /**
   * Holds if a catch clause of `try` catches checked exceptions of type
   * `caught`, and that there is a call within the try block that declares that
   * it may throw `caught` or a subtype thereof.
   */
  private predicate declaredCheckedExceptionFromCatchCandidate(TryStmt try, RefType caught) {
    exists(Call call |
      checkedExceptionFromCatchCandidate(try, caught, call) and
      call.getCallee().getAThrownExceptionType().getASourceSupertype*() = caught
    )
  }

  /**
   * Holds if `call` is contained within a try block that has a catch clause
   * that catches a checked exception, but there is no call within the try
   * block that declares that it may throw that exception, and no throw
   * statement either. In this case, it is likely that the throws declaration
   * for some reason was not extracted, so we conseratively assume that `call`
   * may throw such an exception.
   */
  private predicate checkedExceptionFromCatchCandidate(Call call) {
    exists(TryStmt try, RefType caught |
      checkedExceptionFromCatchCandidate(try, caught, call) and
      not declaredCheckedExceptionFromCatchCandidate(try, caught) and
      not exists(ThrowStmt throwstmt |
        throwstmt.getEnclosingStmt+() = try.getBlock() and
        throwstmt.getThrownExceptionType().getASourceSupertype*() = caught
      )
    )
  }

  /**
   * Holds if `n` is expected to possibly throw an exception. This can either
   * be due to a declared (likely checked) exception on a call target
   * or due to an enclosing try/catch/finally.
   */
  predicate mayThrow(Ast::AstNode n) {
    exists(n.(Call).getCallee().getAThrownExceptionType())
    or
    checkedExceptionFromCatchCandidate(n)
    or
    uncheckedExceptionFromMethod(n)
    or
    uncheckedExceptionFromFinally(n)
    or
    uncheckedExceptionFromCatch(n)
  }
}

private module NonReturningCalls {
  /**
   * A virtual method with a unique implementation. That is, the method does not
   * participate in overriding and there are no call targets that could dispatch
   * to both this and another method.
   */
  private class EffectivelyNonVirtualMethod extends SrcMethod {
    EffectivelyNonVirtualMethod() {
      exists(this.getBody()) and
      this.isVirtual() and
      not this = any(Method m).getASourceOverriddenMethod() and
      not this.overrides(_) and
      // guard against implicit overrides of default methods
      not this.getAPossibleImplementationOfSrcMethod() != this and
      // guard against interface implementations in inheriting subclasses
      not exists(SrcMethod m |
        1 < strictcount(m.getAPossibleImplementationOfSrcMethod()) and
        this = m.getAPossibleImplementationOfSrcMethod()
      ) and
      // UnsupportedOperationException could indicate that this is meant to be overridden
      not exists(ClassInstanceExpr ex |
        this.getBody().getLastStmt().(ThrowStmt).getExpr() = ex and
        ex.getConstructedType().hasQualifiedName("java.lang", "UnsupportedOperationException")
      ) and
      // an unused parameter could indicate that this is meant to be overridden
      forall(Parameter p | p = this.getAParameter() | exists(p.getAnAccess()))
    }

    /** Gets a `MethodCall` that calls this method. */
    MethodCall getAnAccess() { result.getMethod().getAPossibleImplementation() = this }
  }

  /** Holds if a call to `m` indicates that `m` is expected to return. */
  private predicate expectedReturn(EffectivelyNonVirtualMethod m) {
    exists(Stmt s, BlockStmt b |
      m.getAnAccess().getEnclosingStmt() = s and
      b.getAStmt() = s and
      not b.getLastStmt() = s
    )
  }

  /**
   * Gets a non-overridable method that always throws an exception or calls `exit`.
   */
  private Method nonReturningMethod() {
    result instanceof MethodExit
    or
    not result.isOverridable() and
    exists(BlockStmt body |
      body = result.getBody() and
      not exists(ReturnStmt ret | ret.getEnclosingCallable() = result)
    |
      not result.getReturnType() instanceof VoidType or
      body.getLastStmt() = nonReturningStmt()
    )
  }

  /**
   * Gets a virtual method that always throws an exception or calls `exit`.
   */
  private EffectivelyNonVirtualMethod likelyNonReturningMethod() {
    result.getReturnType() instanceof VoidType and
    not exists(ReturnStmt ret | ret.getEnclosingCallable() = result) and
    not expectedReturn(result) and
    forall(Parameter p | p = result.getAParameter() | exists(p.getAnAccess())) and
    result.getBody().getLastStmt() = nonReturningStmt()
  }

  /**
   * Gets a `MethodCall` that always throws an exception or calls `exit`.
   */
  MethodCall nonReturningMethodCall() {
    methodCallUnconditionallyThrows(result) or
    result.getMethod().getSourceDeclaration() = nonReturningMethod() or
    result = likelyNonReturningMethod().getAnAccess()
  }

  /**
   * Gets a statement that always throws an exception or calls `exit`.
   */
  private Stmt nonReturningStmt() {
    result instanceof ThrowStmt
    or
    result.(ExprStmt).getExpr() = nonReturningExpr()
    or
    result.(BlockStmt).getLastStmt() = nonReturningStmt()
    or
    exists(IfStmt ifstmt | ifstmt = result |
      ifstmt.getThen() = nonReturningStmt() and
      ifstmt.getElse() = nonReturningStmt()
    )
    or
    exists(TryStmt try | try = result |
      try.getBlock() = nonReturningStmt() and
      forall(CatchClause cc | cc = try.getACatchClause() | cc.getBlock() = nonReturningStmt())
    )
  }

  /**
   * Gets an expression that always throws an exception or calls `exit`.
   */
  private Expr nonReturningExpr() {
    result = nonReturningMethodCall()
    or
    result.(StmtExpr).getStmt() = nonReturningStmt()
    or
    exists(WhenExpr whenexpr | whenexpr = result |
      whenexpr.getBranch(_).isElseBranch() and
      forex(WhenBranch whenbranch | whenbranch = whenexpr.getBranch(_) |
        whenbranch.getRhs() = nonReturningStmt()
      )
    )
  }
}

private module Input implements InputSig1, InputSig2 {
  private import java as J
  private import codeql.util.Void

  predicate cfgCachedStageRef() { CfgCachedStage::ref() }

  /** Holds if this catch clause catches all exceptions. */
  predicate catchAll(Ast::CatchClause catch) {
    catch.getACaughtType() instanceof TypeThrowable
    or
    exists(TryStmt try, int last |
      catch.getACaughtType() instanceof TypeException and
      try.getCatchClause(last) = catch and
      not exists(try.getCatchClause(last + 1))
    )
  }

  /** Holds if this case matches all possible values. */
  predicate matchAll(Ast::Case c) {
    c instanceof DefaultCase
    or
    // Switch expressions and enhanced switch blocks (those that use pattern
    // cases or match null) must be exhaustive, so the last case matches all
    // remaining values.
    // See https://docs.oracle.com/javase/specs/jls/se21/html/jls-14.html#jls-14.11.2
    exists(Ast::Switch switch, int last |
      switch instanceof SwitchExpr or
      exists(switch.(SwitchStmt).getAPatternCase()) or
      switch.(SwitchStmt).hasNullCase()
    |
      switch.getCase(last) = c and
      not exists(switch.getCase(last + 1))
    )
    or
    c.(J::PatternCase).getAPattern().getType() instanceof TypeObject
  }

  private newtype TLabel =
    TJavaLabel(string l) { exists(LabeledStmt lbl | l = lbl.getLabel()) } or
    TYield()

  class Label extends TLabel {
    string toString() {
      exists(string l | this = TJavaLabel(l) and result = l)
      or
      this = TYield() and result = "yield"
    }
  }

  private Label getLabelOfLoop(Stmt s) {
    exists(LabeledStmt l | s = l.getStmt() |
      result = TJavaLabel(l.getLabel()) or
      result = getLabelOfLoop(l)
    )
  }

  predicate hasLabel(Ast::AstNode n, Label l) {
    l = getLabelOfLoop(n)
    or
    l = TJavaLabel(n.(BreakStmt).getLabel())
    or
    l = TJavaLabel(n.(ContinueStmt).getLabel())
    or
    l = TYield() and n instanceof YieldStmt
    or
    l = TYield() and n instanceof SwitchExpr
  }

  class CallableContext = Void;

  predicate inConditionalContext(Ast::AstNode n, ConditionKind kind) {
    kind.isBoolean() and
    (
      any(AssertStmt assertstmt).getExpr() = n or
      any(WhenBranch whenbranch).getCondition() = n
    )
  }

  predicate preOrderExpr(Expr e) { e instanceof WhenExpr }

  predicate postOrInOrder(Ast::AstNode n) {
    // expressions are already post-order, but we need the calls that are statements to be post-order as well
    n instanceof Call
    or
    n instanceof SynchronizedStmt
  }

  private string assertThrowNodeTag() { result = "[assert-throw]" }

  predicate additionalNode(Ast::AstNode n, string tag, NormalSuccessor t) {
    n instanceof AssertStmt and tag = assertThrowNodeTag() and t instanceof DirectSuccessor
  }

  /**
   * Holds if `ast` may result in an abrupt completion `c` originating at
   * `n`. The boolean `always`  indicates whether the abrupt completion
   * always occurs or whether `n` may also terminate normally.
   */
  predicate beginAbruptCompletion(
    Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
  ) {
    ast instanceof AssertStmt and
    n.isAdditional(ast, assertThrowNodeTag()) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = true
    or
    Exceptions::mayThrow(ast) and
    n.isIn(ast) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = false
    or
    ast = NonReturningCalls::nonReturningMethodCall() and
    n.isIn(ast) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = true
  }

  /**
   * Holds if an abrupt completion `c` from within `ast` is caught with
   * flow continuing at `n`.
   */
  predicate endAbruptCompletion(Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c) {
    exists(LabeledStmt lbl |
      ast = lbl.getStmt() and
      n.isAfter(lbl) and
      c.getSuccessorType() instanceof BreakSuccessor and
      c.hasLabel(TJavaLabel(lbl.getLabel()))
    )
  }

  /** Holds if there is a local non-abrupt step from `n1` to `n2`. */
  predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(AssertStmt assertstmt |
      n1.isBefore(assertstmt) and
      n2.isBefore(assertstmt.getExpr())
      or
      n1.isAfterValue(assertstmt.getExpr(), any(BooleanSuccessor s | s.getValue() = true)) and
      n2.isAfter(assertstmt)
      or
      n1.isAfterValue(assertstmt.getExpr(), any(BooleanSuccessor s | s.getValue() = false)) and
      (
        n2.isBefore(assertstmt.getMessage())
        or
        not exists(assertstmt.getMessage()) and
        n2.isAdditional(assertstmt, assertThrowNodeTag())
      )
      or
      n1.isAfter(assertstmt.getMessage()) and
      n2.isAdditional(assertstmt, assertThrowNodeTag())
    )
    or
    // Synchronized statements execute their expression _before_ synchronization, so the CFG reflects that.
    exists(SynchronizedStmt synch |
      n1.isBefore(synch) and
      n2.isBefore(synch.getExpr())
      or
      n1.isAfter(synch.getExpr()) and
      n2.isIn(synch)
      or
      n1.isIn(synch) and
      n2.isBefore(synch.getBlock())
      or
      n1.isAfter(synch.getBlock()) and
      n2.isAfter(synch)
    )
    or
    exists(WhenExpr whenexpr |
      n1.isBefore(whenexpr) and
      n2.isBefore(whenexpr.getBranch(0))
      or
      exists(int i, WhenBranch branch | branch = whenexpr.getBranch(i) |
        // The `.isAfter(branch)` nodes are not needed, so they're simply skipped.
        n1.isBefore(branch) and
        n2.isBefore(branch.getCondition())
        or
        n1.isAfterTrue(branch.getCondition()) and
        n2.isBefore(branch.getRhs())
        or
        n1.isAfterFalse(branch.getCondition()) and
        (
          n2.isBefore(whenexpr.getBranch(i + 1))
          or
          not exists(whenexpr.getBranch(i + 1)) and
          n2.isAfter(whenexpr)
        )
        or
        n1.isAfter(branch.getRhs()) and
        n2.isAfter(whenexpr)
      )
    )
  }
}

/** A control-flow node that branches based on a boolean condition. */
class ConditionNode extends ControlFlowNode {
  ConditionNode() { exists(this.getASuccessor(any(BooleanSuccessor t))) }

  /** Gets a true- or false-successor of the `ConditionNode`. */
  ControlFlowNode getABranchSuccessor(boolean branch) {
    result = this.getASuccessor(any(BooleanSuccessor t | t.getValue() = branch))
  }

  /** Gets a true-successor of the `ConditionNode`. */
  ControlFlowNode getATrueSuccessor() { result = this.getABranchSuccessor(true) }

  /** Gets a false-successor of the `ConditionNode`. */
  ControlFlowNode getAFalseSuccessor() { result = this.getABranchSuccessor(false) }

  /** Gets the condition of this `ConditionNode`. */
  ExprParent getCondition() { result = this.asExpr() or result = this.asStmt() }
}
