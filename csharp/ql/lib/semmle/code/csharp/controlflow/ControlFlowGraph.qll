/**
 * Provides classes representing the control flow graph within callables.
 */

import csharp
private import codeql.controlflow.ControlFlowGraph
private import codeql.controlflow.SuccessorType
private import semmle.code.csharp.commons.Compilation
private import semmle.code.csharp.controlflow.internal.NonReturning as NonReturning
private import semmle.code.csharp.controlflow.internal.Completion as Completion

private module Cfg0 = Make0<Location, Ast>;

private module Cfg1 = Make1<Input>;

private module Cfg2 = Make2<Input>;

private import Cfg0
private import Cfg1
private import Cfg2
import Public

/** Provides an implementation of the AST signature for C#. */
private module Ast implements AstSig<Location> {
  private import csharp as CS

  class AstNode = ControlFlowElementOrCallable;

  private predicate expandedAssignmentParent(Expr p) {
    exists(AssignExpr ae | any(AssignOperation ao).getExpandedAssignment() = ae |
      p = ae or p = ae.getRightOperand()
    )
  }

  private AstNode getExprChild0(Expr e, int i) {
    not e instanceof NameOfExpr and
    not e instanceof QualifiableExpr and
    not e instanceof Assignment and
    not e instanceof AnonymousFunctionExpr and
    result = e.getChild(i)
    or
    e = any(ExtensionMethodCall emc | result = emc.getArgument(i))
    or
    e =
      any(QualifiableExpr qe |
        not qe instanceof ExtensionMethodCall and
        result = qe.getChild(i)
      )
    or
    e =
      any(Assignment a |
        // The left-hand side of an assignment is evaluated before the right-hand side
        i = 0 and result = a.getLValue()
        or
        i = 1 and result = a.getRValue()
      )
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
    result = getExprChild0(n, index) and not expandedAssignmentParent(n)
  }

  private AstNode getParent(AstNode n) { n = getChild(result, _) }

  Callable getEnclosingCallable(AstNode node) {
    result = node.(ControlFlowElement).getEnclosingCallable() or
    result.(ObjectInitMethod).initializes(getParent*(node)) or
    Initializers::staticMemberInitializer(result, getParent*(node))
  }

  class Callable = CS::Callable;

  AstNode callableGetBody(Callable c) {
    result = c.getBody() or
    result = c.(Constructor).getObjectInitializerCall() or
    result = c.(Constructor).getInitializer() or
    c.(ObjectInitMethod).initializes(result) or
    Initializers::staticMemberInitializer(c, result)
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

  final private class FinalNullCoalescingExpr = CS::NullCoalescingExpr;

  // class NullCoalescingExpr = CS::NullCoalescingExpr;
  class NullCoalescingExpr extends FinalNullCoalescingExpr {
    NullCoalescingExpr() { not expandedAssignmentParent(this) }
  }

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

/**
 * A compilation.
 *
 * Unlike the standard `Compilation` class, this class also supports buildless
 * extraction.
 */
private newtype CompilationExt =
  TCompilation(Compilation c) { not extractionIsStandalone() } or
  TBuildless() { extractionIsStandalone() }

/** Gets the compilation that source file `f` belongs to. */
private CompilationExt getCompilation(File f) {
  exists(Compilation c |
    f = c.getAFileCompiled() and
    result = TCompilation(c)
  )
  or
  result = TBuildless()
}

private module Initializers {
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
      rank[i + 1](Expr init, Location l |
        staticMemberInitializer(staticCtor, init) and
        l = init.getLocation()
      |
        init order by l.getStartLine(), l.getStartColumn(), l.getFile().getAbsolutePath()
      )
  }

  /**
   * Gets the `i`th member initializer expression for object initializer method `obinit`
   * in compilation `comp`.
   */
  AssignExpr initializedInstanceMemberOrder(ObjectInitMethod obinit, CompilationExt comp, int i) {
    obinit.initializes(result) and
    result =
      rank[i + 1](AssignExpr ae0, Location l |
        obinit.initializes(ae0) and
        l = ae0.getLocation() and
        getCompilation(l.getFile()) = comp
      |
        ae0 order by l.getStartLine(), l.getStartColumn(), l.getFile().getAbsolutePath()
      )
  }

  /**
   * Gets the last member initializer expression for object initializer method `obinit`
   * in compilation `comp`.
   */
  AssignExpr lastInitializer(ObjectInitMethod obinit, CompilationExt comp) {
    exists(int i |
      result = initializedInstanceMemberOrder(obinit, comp, i) and
      not exists(initializedInstanceMemberOrder(obinit, comp, i + 1))
    )
  }
}

private module Input implements InputSig1, InputSig2 {
  predicate cfgCachedStageRef() { CfgCachedStage::ref() }

  predicate catchAll(Ast::CatchClause catch) { catch instanceof GeneralCatchClause }

  predicate matchAll(Ast::Case c) { c instanceof DefaultCase or c.(SwitchCaseExpr).matchesAll() }

  private newtype TLabel =
    TLblGoto(string label) { any(GotoLabelStmt goto).getLabel() = label } or
    TLblSwitchCase(string value) { any(GotoCaseStmt goto).getLabel() = value } or
    TLblSwitchDefault()

  class Label extends TLabel {
    string toString() {
      this = TLblGoto(result)
      or
      this = TLblSwitchCase(result)
      or
      this = TLblSwitchDefault() and result = "default"
    }
  }

  predicate hasLabel(Ast::AstNode n, Label l) {
    l = TLblGoto(n.(GotoLabelStmt).getLabel())
    or
    l = TLblSwitchCase(n.(GotoCaseStmt).getLabel())
    or
    l = TLblSwitchDefault() and n instanceof GotoDefaultStmt
    or
    l = TLblGoto(n.(LabelStmt).getLabel())
  }

  predicate inConditionalContext(Ast::AstNode n, ConditionKind kind) {
    kind.isNullness() and
    exists(QualifiableExpr qe | n = qe.getQualifier() and qe.isConditional())
  }

  predicate postOrInOrder(Ast::AstNode n) { n instanceof YieldBreakStmt or n instanceof Call }

  predicate beginAbruptCompletion(
    Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
  ) {
    // `yield break` behaves like a return statement
    ast instanceof YieldBreakStmt and
    n.isIn(ast) and
    c.asSimpleAbruptCompletion() instanceof ReturnSuccessor and
    always = true
    or
    Completion::mayThrowException(ast) and
    n.isIn(ast) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = false
    or
    ast instanceof NonReturning::NonReturningCall and
    n.isIn(ast) and
    c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
    always = true
  }

  predicate endAbruptCompletion(Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c) {
    exists(SwitchStmt switch, Label l, Ast::Case case |
      ast.(Stmt).getParent() = switch and
      c.getSuccessorType() instanceof GotoSuccessor and
      c.hasLabel(l) and
      n.isAfterValue(case, any(MatchingSuccessor t | t.getValue() = true))
    |
      exists(string value, ConstCase cc |
        l = TLblSwitchCase(value) and
        switch.getAConstCase() = cc and
        cc.getLabel() = value and
        cc = case
      )
      or
      l = TLblSwitchDefault() and switch.getDefaultCase() = case
    )
  }

  pragma[noinline]
  private MethodCall getObjectInitializerCall(Constructor ctor, CompilationExt comp) {
    result = ctor.getObjectInitializerCall() and
    comp = getCompilation(result.getFile())
  }

  pragma[noinline]
  private ConstructorInitializer getInitializer(Constructor ctor, CompilationExt comp) {
    result = ctor.getInitializer() and
    comp = getCompilation(result.getFile())
  }

  pragma[noinline]
  private Ast::AstNode getBody(Constructor ctor, CompilationExt comp) {
    result = ctor.getBody() and
    comp = getCompilation(result.getFile())
  }

  predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(Constructor ctor |
      n1.(EntryNodeImpl).getEnclosingCallable() = ctor and
      if Initializers::staticMemberInitializer(ctor, _)
      then n2.isBefore(Initializers::initializedStaticMemberOrder(ctor, 0))
      else
        if exists(ctor.getObjectInitializerCall())
        then n2.isBefore(ctor.getObjectInitializerCall())
        else
          if exists(ctor.getInitializer())
          then n2.isBefore(ctor.getInitializer())
          else n2.isBefore(ctor.getBody())
      or
      exists(int i | n1.isAfter(Initializers::initializedStaticMemberOrder(ctor, i)) |
        n2.isBefore(Initializers::initializedStaticMemberOrder(ctor, i + 1))
        or
        not exists(Initializers::initializedStaticMemberOrder(ctor, i + 1)) and
        n2.isBefore(ctor.getBody())
      )
      or
      exists(CompilationExt comp |
        n1.isAfter(getObjectInitializerCall(ctor, comp)) and
        if exists(getInitializer(ctor, comp))
        then n2.isBefore(getInitializer(ctor, comp))
        else
          // This is only relevant in the context of compilation errors, since
          // normally the existence of an object initializer call implies the
          // existence of an initializer.
          if exists(getBody(ctor, comp))
          then n2.isBefore(getBody(ctor, comp))
          else n2.(NormalExitNodeImpl).getEnclosingCallable() = ctor
        or
        n1.isAfter(getInitializer(ctor, comp)) and
        if exists(getBody(ctor, comp))
        then n2.isBefore(getBody(ctor, comp))
        else n2.(NormalExitNodeImpl).getEnclosingCallable() = ctor
      )
      or
      n1.isAfter(ctor.getBody()) and
      n2.(NormalExitNodeImpl).getEnclosingCallable() = ctor
    )
    or
    exists(ObjectInitMethod obinit |
      n1.(EntryNodeImpl).getEnclosingCallable() = obinit and
      n2.isBefore(Initializers::initializedInstanceMemberOrder(obinit, _, 0))
      or
      exists(CompilationExt comp, int i |
        // Flow from one member initializer to the next
        n1.isAfter(Initializers::initializedInstanceMemberOrder(obinit, comp, i)) and
        n2.isBefore(Initializers::initializedInstanceMemberOrder(obinit, comp, i + 1))
      )
      or
      n1.isAfter(Initializers::lastInitializer(obinit, _)) and
      n2.(NormalExitNodeImpl).getEnclosingCallable() = obinit
    )
    or
    exists(QualifiableExpr qe | qe.isConditional() |
      n1.isBefore(qe) and n2.isBefore(qe.getQualifier())
      or
      exists(NullnessSuccessor t | n1.isAfterValue(qe.getQualifier(), t) |
        if t.isNull()
        then (
          // if `q` is null in `q?.f = x` then the assignment is skipped. This
          // holds for both regular, compound, and null-coalescing assignments.
          // On the other hand, the CFG definition for the assignment can treat
          // the LHS the same regardless of whether it's a conditionally
          // qualified access or not, as it just connects to the "before" and
          // "after" nodes of the LHS, and the "after" node is skipped in this
          // case.
          exists(AssignableDefinition def |
            not def.getExpr() = any(AssignOperation ao).getExpandedAssignment() and
            def.getTargetAccess() = qe and
            n2.isAfterValue(def.getExpr(), t)
          )
          or
          not qe instanceof AssignableWrite and
          n2.isAfterValue(qe, t)
        ) else (
          n2.isBefore(Ast::getChild(qe, 1))
          or
          n2.isIn(qe) and not exists(Ast::getChild(qe, 1))
        )
      )
      or
      exists(int i | i >= 1 and n1.isAfter(Ast::getChild(qe, i)) |
        n2.isBefore(Ast::getChild(qe, i + 1))
        or
        not exists(Ast::getChild(qe, i + 1)) and n2.isIn(qe)
      )
      or
      n1.isIn(qe) and n2.isAfter(qe) and not beginAbruptCompletion(qe, n1, _, true)
    )
    or
    exists(ObjectCreation oc |
      n1.isBefore(oc) and n2.isBefore(oc.getArgument(0))
      or
      n1.isBefore(oc) and n2.isIn(oc) and not exists(oc.getAnArgument())
      or
      exists(int i | n1.isAfter(oc.getArgument(i)) |
        n2.isBefore(oc.getArgument(i + 1))
        or
        not exists(oc.getArgument(i + 1)) and n2.isIn(oc)
      )
      or
      n1.isIn(oc) and n2.isBefore(oc.getInitializer())
      or
      n1.isIn(oc) and n2.isAfter(oc) and not exists(oc.getInitializer())
      or
      n1.isAfter(oc.getInitializer()) and n2.isAfter(oc)
    )
  }
}

/** Provides different types of control flow nodes. */
module ControlFlowNodes {
  /**
   * A node for a control flow element, that is, an expression or a statement.
   *
   * Each control flow element maps to zero or one `ElementNode`s: zero when
   * the element is in unreachable (dead) code, and otherwise one.
   */
  class ElementNode extends ControlFlowNode {
    ElementNode() { exists(this.asExpr()) or exists(this.asStmt()) }
  }

  /** A control-flow node for an expression. */
  class ExprNode extends ElementNode {
    Expr e;

    ExprNode() { e = this.asExpr() }

    /** Gets the expression that this control-flow node belongs to. */
    Expr getExpr() { result = e }

    /** Gets the value of this expression node, if any. */
    string getValue() { result = e.getValue() }

    /** Gets the type of this expression node. */
    Type getType() { result = e.getType() }
  }
}
