/**
 * Provides classes representing the control flow graph within callables.
 */

import csharp
private import codeql.controlflow.ControlFlowGraph
private import codeql.controlflow.SuccessorType
private import semmle.code.csharp.commons.Compilation
private import semmle.code.csharp.controlflow.internal.NonReturning as NonReturning

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
    result = node.(ControlFlowElement).getEnclosingCallable() or
    result.(ObjectInitMethod).initializes(getParent*(node)) or
    Initializers::staticMemberInitializer(result, getParent*(node))
  }

  class Callable = CS::Callable;

  AstNode callableGetBody(Callable c) {
    not skipControlFlow(result) and
    result = c.getBody()
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

/**
 * A compilation.
 *
 * Unlike the standard `Compilation` class, this class also supports buildless
 * extraction.
 */
private newtype TCompilationExt =
  TCompilation(Compilation c) { not extractionIsStandalone() } or
  TBuildless() { extractionIsStandalone() }

private class CompilationExt extends TCompilationExt {
  string toString() {
    exists(Compilation c |
      this = TCompilation(c) and
      result = c.toString()
    )
    or
    this = TBuildless() and result = "buildless compilation"
  }
}

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

private module Exceptions {
  private import semmle.code.csharp.commons.Assertions

  private class Overflowable extends UnaryOperation {
    Overflowable() {
      not this instanceof UnaryBitwiseOperation and
      this.getType() instanceof IntegralType
    }
  }

  /** Holds if `cfe` is a control flow element that may throw an exception. */
  predicate mayThrowException(ControlFlowElement cfe) {
    cfe.(TriedControlFlowElement).mayThrowException()
    or
    cfe instanceof Assertion
  }

  /** A control flow element that is inside a `try` block. */
  private class TriedControlFlowElement extends ControlFlowElement {
    TriedControlFlowElement() {
      this = any(TryStmt try).getATriedElement() and
      not this instanceof NonReturning::NonReturningCall
    }

    /**
     * Holds if this element may potentially throw an exception.
     */
    predicate mayThrowException() {
      this instanceof Overflowable
      or
      this.(CastExpr).getType() instanceof IntegralType
      or
      invalidCastCandidate(this)
      or
      this instanceof Call
      or
      this =
        any(MemberAccess ma |
          not ma.isConditional() and
          ma.getQualifier() = any(Expr e | not e instanceof TypeAccess)
        )
      or
      this instanceof DelegateCreation
      or
      this instanceof ArrayCreation
      or
      this =
        any(AddOperation ae |
          ae.getType() instanceof StringType
          or
          ae.getType() instanceof IntegralType
        )
      or
      this = any(SubOperation se | se.getType() instanceof IntegralType)
      or
      this = any(MulOperation me | me.getType() instanceof IntegralType)
      or
      this = any(DivOperation de | not de.getDenominator().getValue().toFloat() != 0)
      or
      this instanceof RemOperation
      or
      this instanceof DynamicExpr
    }
  }

  pragma[nomagic]
  private ValueOrRefType getACastExprBaseType(CastExpr ce) {
    result = ce.getType().(ValueOrRefType).getABaseType()
    or
    result = getACastExprBaseType(ce).getABaseType()
  }

  pragma[nomagic]
  private predicate invalidCastCandidate(CastExpr ce) {
    ce.getExpr().getType() = getACastExprBaseType(ce)
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

  class CallableBodyPartContext = CompilationExt;

  pragma[nomagic]
  Ast::AstNode callableGetBodyPart(Callable c, CallableBodyPartContext ctx, int index) {
    not Ast::skipControlFlow(result) and
    ctx = getCompilation(result.getFile()) and
    (
      result = Initializers::initializedInstanceMemberOrder(c, index)
      or
      result = Initializers::initializedStaticMemberOrder(c, index)
      or
      exists(Constructor ctor, int i, int staticMembers |
        c = ctor and
        staticMembers = count(Expr init | Initializers::staticMemberInitializer(ctor, init)) and
        index = staticMembers + i + 1
      |
        i = 0 and result = ctor.getObjectInitializerCall()
        or
        i = 1 and result = ctor.getInitializer()
        or
        i = 2 and result = ctor.getBody()
      )
    )
  }

  private Expr getQualifier(QualifiableExpr qe) {
    result = qe.getQualifier() or
    result = qe.(ExtensionMethodCall).getArgument(0)
  }

  predicate inConditionalContext(Ast::AstNode n, ConditionKind kind) {
    kind.isNullness() and
    exists(QualifiableExpr qe | qe.isConditional() | n = getQualifier(qe))
  }

  predicate postOrInOrder(Ast::AstNode n) { n instanceof YieldStmt or n instanceof Call }

  predicate beginAbruptCompletion(
    Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
  ) {
    // `yield break` behaves like a return statement
    ast instanceof YieldBreakStmt and
    n.isIn(ast) and
    c.asSimpleAbruptCompletion() instanceof ReturnSuccessor and
    always = true
    or
    Exceptions::mayThrowException(ast) and
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

  predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
    exists(QualifiableExpr qe | qe.isConditional() |
      n1.isBefore(qe) and n2.isBefore(getQualifier(qe))
      or
      exists(NullnessSuccessor t | n1.isAfterValue(getQualifier(qe), t) |
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
            def.getTargetAccess() = qe and
            n2.isAfterValue(def.getExpr(), t)
          )
          or
          not qe instanceof AssignableWrite and
          n2.isAfterValue(qe, t)
        ) else (
          n2.isBefore(Ast::getChild(qe, 0))
          or
          n2.isIn(qe) and not exists(Ast::getChild(qe, 0))
        )
      )
      or
      exists(int i | i >= 0 and n1.isAfter(Ast::getChild(qe, i)) |
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
