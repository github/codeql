import csharp
import codeql.controlflow.ControlFlowGraph

module Initializers {
  private import semmle.code.csharp.ExprOrStmtParent as ExprOrStmtParent

  /**
   * The `expr_parent_top_level_adjusted()` relation restricted to exclude relations
   * between properties and their getters' expression bodies in properties such as
   * `int P => 0`.
   *
   * This is in order to only associate the expression body with one CFG scope, namely
   * the getter (and not the declaration itself).
   */
  private predicate expr_parent_top_level_adjusted2(
    Expr child, int i, @top_level_exprorstmt_parent parent
  ) {
    ExprOrStmtParent::expr_parent_top_level_adjusted(child, i, parent) and
    not exists(Getter g |
      g.getDeclaration() = parent and
      i = 0
    )
  }

  /**
   * Holds if `init` is a static member initializer and `staticCtor` is the
   * static constructor in the same declaring type. Hence, `staticCtor` can be
   * considered to execute `init` prior to the execution of its body.
   */
  predicate staticMemberInitializer(Constructor staticCtor, Expr init) {
    exists(Assignable a |
      a.(Modifiable).isStatic() and
      expr_parent_top_level_adjusted2(init, _, a) and
      a.getDeclaringType() = staticCtor.getDeclaringType() and
      staticCtor.isStatic()
    )
  }

  /**
   * Gets the `i`th static member initializer expression for static constructor `staticCtor`.
   */
  Expr initializedStaticMemberOrder(Constructor staticCtor, int i) {
    result =
      rank[i + 1](Expr init, Location l, string filepath, int startline, int startcolumn |
        staticMemberInitializer(staticCtor, init) and
        l = init.getLocation() and
        l.hasLocationInfo(filepath, startline, startcolumn, _, _)
      |
        init order by startline, startcolumn, filepath
      )
  }

  /**
   * Gets the `i`th member initializer expression for object initializer method `obinit`.
   */
  AssignExpr initializedInstanceMemberOrder(ObjectInitMethod obinit, int i) {
    result =
      rank[i + 1](AssignExpr ae0, Location l, string filepath, int startline, int startcolumn |
        obinit.initializes(ae0) and
        l = ae0.getLocation() and
        l.hasLocationInfo(filepath, startline, startcolumn, _, _)
      |
        ae0 order by startline, startcolumn, filepath
      )
  }
}

/**
 * Provides an implementation of the AST signature for C#.
 */
module Ast implements AstSig<Location> {
  private import csharp as CS

  class AstNode = ControlFlowElementOrCallable;

  additional predicate skipControlFlow(AstNode e) {
    e instanceof TypeAccess and
    not e instanceof TypeAccessPatternExpr
    or
    not e.getFile().fromSource()
  }

  private AstNode getExprChild0(Expr e, int i) {
    not e instanceof NameOfExpr and
    not e instanceof AnonymousFunctionExpr and
    not skipControlFlow(result) and
    result = e.getChild(i)
  }

  private AstNode getStmtChild0(Stmt s, int i) {
    not s instanceof FixedStmt and
    not s instanceof UsingBlockStmt and
    result = s.getChild(i)
    or
    s =
      any(FixedStmt fs |
        result = fs.getVariableDeclExpr(i)
        or
        result = fs.getBody() and
        i = max(int j | exists(fs.getVariableDeclExpr(j))) + 1
      )
    or
    s =
      any(UsingBlockStmt us |
        result = us.getExpr() and
        i = 0
        or
        result = us.getVariableDeclExpr(i)
        or
        result = us.getBody() and
        i = max([1, count(us.getVariableDeclExpr(_))])
      )
  }

  AstNode getChild(AstNode n, int index) {
    result = getStmtChild0(n, index)
    or
    result = getExprChild0(n, index)
  }

  private AstNode getParent(AstNode n) { n = getChild(result, _) }

  Callable getEnclosingCallable(AstNode node) {
    result = node.(ControlFlowElement).getEnclosingCallable()
    or
    result.(ObjectInitMethod).initializes(getParent*(node))
    or
    Initializers::staticMemberInitializer(result, getParent*(node))
    or
    result = node.(Parameter).getCallable()
    or
    not skipControlFlow(node) and
    getParent*(node) = any(Parameter p | result = p.getCallable()).getDefaultValue()
  }

  class Callable extends CS::Callable {
    Callable() { this.isUnboundDeclaration() }
  }

  AstNode callableGetBody(Callable c) {
    not skipControlFlow(result) and
    result = c.getBody()
  }

  final private class ParameterFinal = CS::Parameter;

  class Parameter extends ParameterFinal {
    Expr getDefaultValue() {
      // Avoid combinatorial explosions for callables with multiple bodies
      result = unique( | | super.getDefaultValue())
    }
  }

  Parameter callableGetParameter(Callable c, int i) {
    not skipControlFlow(result) and
    result = c.getParameter(i)
  }

  class Stmt = CS::Stmt;

  class Expr = CS::Expr;

  class BlockStmt = CS::BlockStmt;

  class ExprStmt = CS::ExprStmt;

  class IfStmt = CS::IfStmt;

  class LoopStmt = CS::LoopStmt;

  class WhileStmt = CS::WhileStmt;

  class DoStmt = CS::DoStmt;

  final private class FinalForStmt = CS::ForStmt;

  class ForStmt extends FinalForStmt {
    Expr getInit(int index) { result = this.getInitializer(index) }
  }

  final private class FinalForeachStmt = CS::ForeachStmt;

  class ForeachStmt extends FinalForeachStmt {
    Expr getVariable() {
      result = this.getVariableDeclExpr() or result = this.getVariableDeclTuple()
    }

    Expr getCollection() { result = this.getIterableExpr() }
  }

  class BreakStmt = CS::BreakStmt;

  class ContinueStmt = CS::ContinueStmt;

  class GotoStmt = CS::GotoStmt;

  class ReturnStmt = CS::ReturnStmt;

  class Throw = CS::ThrowElement;

  final private class FinalTryStmt = CS::TryStmt;

  class TryStmt extends FinalTryStmt {
    Stmt getBody() { result = this.getBlock() }

    CatchClause getCatch(int index) { result = this.getCatchClause(index) }

    Stmt getFinally() { result = super.getFinally() }
  }

  final private class FinalCatchClause = CS::CatchClause;

  class CatchClause extends FinalCatchClause {
    AstNode getVariable() { result = this.(CS::SpecificCatchClause).getVariableDeclExpr() }

    Expr getCondition() { result = this.getFilterClause() }

    Stmt getBody() { result = this.getBlock() }
  }

  final private class FinalSwitch = CS::Switch;

  class Switch extends FinalSwitch {
    Case getCase(int index) { result = super.getCase(index) }

    Stmt getStmt(int index) { result = this.(CS::SwitchStmt).getStmt(index) }
  }

  final private class FinalCase = CS::Case;

  class Case extends FinalCase {
    AstNode getAPattern() { result = this.getPattern() }

    Expr getGuard() { result = this.getCondition() }

    AstNode getBody() { result = super.getBody() }
  }

  class DefaultCase extends Case instanceof CS::DefaultCase { }

  class ConditionalExpr = CS::ConditionalExpr;

  class BinaryExpr = CS::BinaryOperation;

  class LogicalAndExpr = CS::LogicalAndExpr;

  class LogicalOrExpr = CS::LogicalOrExpr;

  class NullCoalescingExpr = CS::NullCoalescingExpr;

  class UnaryExpr = CS::UnaryOperation;

  class LogicalNotExpr = CS::LogicalNotExpr;

  class Assignment = CS::Assignment;

  class AssignExpr = CS::AssignExpr;

  class CompoundAssignment = CS::AssignOperation;

  class AssignLogicalAndExpr extends CompoundAssignment {
    AssignLogicalAndExpr() { none() }
  }

  class AssignLogicalOrExpr extends CompoundAssignment {
    AssignLogicalOrExpr() { none() }
  }

  class AssignNullCoalescingExpr = CS::AssignCoalesceExpr;

  final private class FinalBoolLiteral = CS::BoolLiteral;

  class BooleanLiteral extends FinalBoolLiteral {
    boolean getValue() { result = this.getBoolValue() }
  }

  final private class FinalIsExpr = CS::IsExpr;

  class PatternMatchExpr extends FinalIsExpr {
    AstNode getPattern() { result = super.getPattern() }
  }
}
