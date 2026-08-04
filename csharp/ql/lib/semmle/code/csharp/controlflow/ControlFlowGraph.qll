/**
 * Provides classes representing the control flow graph within callables.
 */

import csharp
private import internal.ControlFlowGraph
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
bindingset[e]
pragma[inline_late]
private CompilationExt getCompilation(Element e) {
  exists(Compilation c |
    e.getALocation().getFile() = c.getAFileCompiled() and
    result = TCompilation(c)
  )
  or
  result = TBuildless()
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

  class CallableContext = CompilationExt;

  pragma[nomagic]
  Ast::AstNode callableGetBodyPart(Ast::Callable c, CallableContext ctx, int index) {
    not Ast::skipControlFlow(result) and
    ctx = getCompilation(result) and
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
      or
      not c instanceof Constructor and
      result = c.getBody() and
      index = 0
    )
  }

  pragma[nomagic]
  Ast::Parameter callableGetParameter(Ast::Callable c, CallableContext ctx, int index) {
    result = Ast::callableGetParameter(c, index) and
    ctx = getCompilation(result)
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
