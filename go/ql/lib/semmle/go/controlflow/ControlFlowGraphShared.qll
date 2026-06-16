/**
 * Provides the shared CFG library instantiation for Go.
 *
 * Everything is wrapped in `GoCfg` to avoid name conflicts with the existing
 * CFG implementation during the transition.
 */
overlay[local]
module;

private import codeql.controlflow.ControlFlowGraph as CfgLib
private import codeql.controlflow.SuccessorType
private import codeql.util.Void

/** Contains the shared CFG library instantiation for Go. */
module GoCfg {
  private import go as Go

  private module Cfg0 = CfgLib::Make0<Go::Location, Ast>;

  private module Cfg1 = Cfg0::Make1<Input>;

  private module Cfg2 = Cfg1::Make2<Input>;

  private import Cfg0
  private import Cfg1
  private import Cfg2
  import Public

  class CfgScope = Ast::Callable;

  /** Holds if `e` has an implicit field selection at `index` for `implicitField`. */
  predicate implicitFieldSelection(Go::AstNode e, int index, Go::Field implicitField) {
    Input::implicitFieldSelection(e, index, implicitField)
  }

  /** Provides an implementation of the AST signature for Go. */
  private module Ast implements CfgLib::AstSig<Go::Location> {
    class AstNode = Go::AstNode;

    private predicate skipCfg(AstNode e) {
      e instanceof Go::TypeExpr and not e instanceof Go::FuncTypeExpr
      or
      e = any(Go::FieldDecl f).getTag()
      or
      e instanceof Go::KeyValueExpr and not e = any(Go::CompositeLit lit).getAnElement()
      or
      e = any(Go::SelectorExpr sel).getSelector()
      or
      e = any(Go::StructLit sl).getKey(_)
      or
      e instanceof Go::Ident and not e instanceof Go::ReferenceExpr
      or
      e instanceof Go::SelectorExpr and not e instanceof Go::ReferenceExpr
      or
      e instanceof Go::ReferenceExpr and
      not e.(Go::ReferenceExpr).isRvalue() and
      not e instanceof Go::SelectorExpr and
      not e = any(Go::SelectorExpr sel).getBase() and
      not e instanceof Go::IndexExpr and
      not e = any(Go::IndexExpr idx).getBase() and
      not e = any(Go::IndexExpr idx).getIndex()
      or
      e instanceof Go::CommentGroup
      or
      e instanceof Go::Comment
      or
      e = any(Go::ImportSpec is).getPathExpr()
      or
      e.getParent*() = any(Go::ArrayTypeExpr ate).getLength()
    }

    AstNode getChild(AstNode n, int index) {
      not n instanceof Go::FuncDef and
      not skipCfg(n) and
      not skipCfg(result) and
      result = n.getChild(index)
    }

    class Callable extends AstNode {
      Callable() {
        exists(this.(Go::FuncDef).getBody())
        or
        exists(this.(Go::File).getADecl())
      }
    }

    AstNode callableGetBody(Callable c) {
      result = c.(Go::FuncDef).getBody()
      or
      result = c.(Go::File)
    }

    class Parameter extends AstNode {
      Parameter() { none() }

      AstNode getPattern() { none() }

      Expr getDefaultValue() { none() }
    }

    Parameter callableGetParameter(Callable c, int index) { none() }

    Callable getEnclosingCallable(AstNode node) {
      result = node.getEnclosingFunction()
      or
      not exists(node.getEnclosingFunction()) and
      result = node.getFile()
    }

    class Stmt = Go::Stmt;

    class Expr = Go::Expr;

    class BlockStmt extends Go::BlockStmt {
      BlockStmt() {
        not this = any(Go::SwitchStmt sw).getBody() and
        not this = any(Go::SelectStmt sel).getBody()
      }

      override Stmt getStmt(int n) { result = Go::BlockStmt.super.getStmt(n) }

      Stmt getLastStmt() {
        exists(int last | result = this.getStmt(last) and not exists(this.getStmt(last + 1)))
      }
    }

    class ExprStmt = Go::ExprStmt;

    class IfStmt extends Stmt {
      IfStmt() { this instanceof Go::IfStmt }

      Expr getCondition() { result = this.(Go::IfStmt).getCond() }

      Stmt getThen() { result = this.(Go::IfStmt).getThen() }

      Stmt getElse() { result = this.(Go::IfStmt).getElse() }
    }

    AstNode getIfInit(IfStmt ifstmt) { result = ifstmt.(Go::IfStmt).getInit() }

    class LoopStmt extends Stmt {
      LoopStmt() { this instanceof Go::LoopStmt }

      Stmt getBody() { result = this.(Go::LoopStmt).getBody() }
    }

    class WhileStmt extends LoopStmt {
      WhileStmt() { none() }

      Expr getCondition() { none() }
    }

    class DoStmt extends LoopStmt {
      DoStmt() { none() }

      Expr getCondition() { none() }
    }

    class UntilStmt extends LoopStmt {
      UntilStmt() { none() }

      Expr getCondition() { none() }
    }

    class ForStmt extends LoopStmt {
      ForStmt() { this instanceof Go::ForStmt }

      AstNode getInit(int index) { index = 0 and result = this.(Go::ForStmt).getInit() }

      Expr getCondition() { result = this.(Go::ForStmt).getCond() }

      AstNode getUpdate(int index) { index = 0 and result = this.(Go::ForStmt).getPost() }
    }

    class ForeachStmt extends LoopStmt {
      ForeachStmt() { none() }

      Expr getVariable() { none() }

      Expr getCollection() { none() }
    }

    class BreakStmt = Go::BreakStmt;

    class ContinueStmt = Go::ContinueStmt;

    class GotoStmt = Go::GotoStmt;

    class ReturnStmt extends Go::ReturnStmt {
      override Expr getExpr() { result = Go::ReturnStmt.super.getExpr() }
    }

    class Throw extends AstNode {
      Throw() { none() }

      Expr getExpr() { none() }
    }

    class TryStmt extends Stmt {
      TryStmt() { none() }

      AstNode getBody(int index) { none() }

      CatchClause getCatch(int index) { none() }

      Stmt getFinally() { none() }
    }

    class CatchClause extends AstNode {
      CatchClause() { none() }

      AstNode getVariable() { none() }

      Expr getCondition() { none() }

      Stmt getBody() { none() }
    }

    class Switch extends AstNode {
      Switch() { none() }

      Expr getExpr() { none() }

      Case getCase(int index) { none() }

      Stmt getStmt(int index) { none() }
    }

    class Case extends AstNode {
      Case() { none() }

      AstNode getPattern(int index) { none() }

      Expr getGuard() { none() }

      AstNode getBody() { none() }
    }

    class DefaultCase extends Case {
      DefaultCase() { none() }
    }

    class ConditionalExpr extends Expr {
      ConditionalExpr() { none() }

      Expr getCondition() { none() }

      Expr getThen() { none() }

      Expr getElse() { none() }
    }

    class BinaryExpr = Go::BinaryExpr;

    class LogicalAndExpr = Go::LandExpr;

    class LogicalOrExpr = Go::LorExpr;

    class NullCoalescingExpr extends BinaryExpr {
      NullCoalescingExpr() { none() }
    }

    class UnaryExpr = Go::UnaryExpr;

    class LogicalNotExpr = Go::NotExpr;

    class BooleanLiteral extends Expr {
      boolean val;

      BooleanLiteral() {
        this.(Go::Ident).getName() = "true" and val = true
        or
        this.(Go::Ident).getName() = "false" and val = false
      }

      boolean getValue() { result = val }
    }

    class Assignment extends BinaryExpr {
      Assignment() { none() }
    }

    class AssignExpr extends Assignment {
      AssignExpr() { none() }
    }

    class CompoundAssignment extends Assignment {
      CompoundAssignment() { none() }
    }

    class AssignLogicalAndExpr extends CompoundAssignment {
      AssignLogicalAndExpr() { none() }
    }

    class AssignLogicalOrExpr extends CompoundAssignment {
      AssignLogicalOrExpr() { none() }
    }

    class AssignNullCoalescingExpr extends CompoundAssignment {
      AssignNullCoalescingExpr() { none() }
    }

    class PatternMatchExpr extends Expr {
      PatternMatchExpr() { none() }

      Expr getExpr() { none() }

      AstNode getPattern() { none() }
    }
  }

  /** The Input module implementing InputSig1 and InputSig2 for Go. */
  private module Input implements Cfg0::InputSig1, Cfg1::InputSig2 {
    predicate cfgCachedStageRef() { CfgCachedStage::ref() }

    class CallableContext = Void;

    private newtype TLabel =
      TGoLabel(string l) { exists(Go::LabeledStmt ls | l = ls.getLabel()) } or
      TFallthrough()

    class Label extends TLabel {
      string toString() {
        exists(string l | this = TGoLabel(l) and result = l)
        or
        this = TFallthrough() and result = "fallthrough"
      }
    }

    private Label getLabelOfStmt(Go::Stmt s) {
      exists(Go::LabeledStmt l | s = l.getStmt() |
        result = TGoLabel(l.getLabel()) or result = getLabelOfStmt(l)
      )
    }

    predicate hasLabel(Ast::AstNode n, Label l) {
      l = getLabelOfStmt(n)
      or
      l = TGoLabel(n.(Go::BreakStmt).getLabel())
      or
      l = TGoLabel(n.(Go::ContinueStmt).getLabel())
      or
      l = TFallthrough() and n instanceof Go::FallthroughStmt
    }

    predicate inConditionalContext(Ast::AstNode n, ConditionKind kind) {
      kind.isBoolean() and
      (
        n = any(Go::ForStmt fs).getCond()
        or
        exists(Go::ExpressionSwitchStmt ess |
          not exists(ess.getExpr()) and n = ess.getACase().(Go::CaseClause).getExpr(_)
        )
      )
    }

    predicate preOrderExpr(Ast::Expr e) { none() }

    predicate propagatesValue(Ast::AstNode child, Ast::AstNode parent) {
      child = parent.(Go::ParenExpr).getExpr()
    }

    predicate postOrInOrder(Ast::AstNode n) {
      n instanceof Go::ReferenceExpr
      or
      n instanceof Go::BasicLit
      or
      n instanceof Go::FuncLit
      or
      n instanceof Go::CallExpr and
      not n = any(Go::DeferStmt defer).getCall() and
      not n = any(Go::GoStmt go_).getCall()
      or
      n instanceof Go::BinaryExpr and not n instanceof Go::LogicalBinaryExpr
      or
      n instanceof Go::UnaryExpr and not n instanceof Go::NotExpr
      or
      n instanceof Go::ConversionExpr
      or
      n instanceof Go::TypeAssertExpr
      or
      n instanceof Go::IndexExpr
      or
      n instanceof Go::SliceExpr
      or
      n instanceof Go::CompositeLit
      or
      n instanceof Go::ReturnStmt
      or
      n instanceof Go::DeferStmt
      or
      n instanceof Go::GoStmt
      or
      n instanceof Go::SelectStmt
      or
      n instanceof Go::SendStmt
      or
      n instanceof Go::IncDecStmt
      or
      n instanceof Go::FuncDecl
      or
      n instanceof Go::SelectorExpr and
      n.(Go::SelectorExpr).getBase() instanceof Go::ValueExpr
    }

    predicate additionalNode(Ast::AstNode n, string tag, NormalSuccessor t) {
      t instanceof DirectSuccessor and
      (
        // Assignment write nodes: one per LHS
        exists(int i |
          (
            notBlankIdent(n.(Go::Assignment).getLhs(i))
            or
            notBlankIdent(n.(Go::ValueSpec).getNameExpr(i))
            or
            notBlankIdent(n.(Go::RangeStmt).getKey()) and i = 0
            or
            notBlankIdent(n.(Go::RangeStmt).getValue()) and i = 1
          ) and
          tag = "assign:" + i.toString()
        )
        or
        // Compound assignment implicit RHS
        n instanceof Go::CompoundAssignStmt and tag = "compound-rhs"
        or
        // Tuple extraction nodes
        exists(int i |
          extractNodeCondition(n, i) and
          tag = "extract:" + i.toString()
        )
        or
        // Zero initialization (on the ValueSpec)
        exists(int i, Go::ValueSpec spec |
          n = spec and
          not exists(spec.getAnInit()) and
          exists(spec.getNameExpr(i)) and
          tag = "zero-init:" + i.toString()
        )
        or
        // Increment/decrement implicit operations
        n instanceof Go::IncDecStmt and tag = "implicit-one"
        or
        n instanceof Go::IncDecStmt and tag = "incdec-rhs"
        or
        // Result write nodes in return statements
        exists(int i, Go::ReturnStmt ret |
          n = ret and
          exists(ret.getEnclosingFunction().getResultVar(i)) and
          exists(ret.getAnExpr()) and
          tag = "result-write:" + i.toString()
        )
        or
        // Result read nodes (on the function body)
        exists(int i, Go::FuncDef fd |
          n = fd.getBody() and
          exists(fd.getBody()) and
          exists(fd.getResultVar(i)) and
          tag = "result-read:" + i.toString()
        )
        or
        // Parameter init + argument nodes (on the function body)
        exists(int i, Go::FuncDef fd |
          n = fd.getBody() and
          exists(fd.getBody()) and
          exists(fd.getParameter(i)) and
          (tag = "param-init:" + i.toString() or tag = "arg:" + i.toString())
        )
        or
        // Result variable init (on the function body)
        exists(int i, Go::FuncDef fd |
          n = fd.getBody() and
          exists(fd.getBody()) and
          exists(fd.getResultVar(i)) and
          tag = "result-init:" + i.toString()
        )
        or
        // Result variable zero init (on the function body)
        exists(int i, Go::FuncDef fd |
          n = fd.getBody() and
          exists(fd.getBody()) and
          exists(fd.getResultVar(i)) and
          exists(fd.getResultVar(i).(Go::ResultVariable).getFunction().getBody()) and
          tag = "result-zero-init:" + i.toString()
        )
        or
        // Next node for range statements
        n instanceof Go::RangeStmt and tag = "next"
        or
        // Send node
        n instanceof Go::SendStmt and
        not n = any(Go::CommClause cc).getComm() and
        tag = "send"
        or
        // Implicit deref
        implicitDerefCondition(n) and tag = "implicit-deref"
        or
        // Implicit slice bounds
        n instanceof Go::SliceExpr and
        not exists(n.(Go::SliceExpr).getLow()) and
        tag = "implicit-low"
        or
        n instanceof Go::SliceExpr and
        not exists(n.(Go::SliceExpr).getHigh()) and
        tag = "implicit-high"
        or
        n instanceof Go::SliceExpr and
        not exists(n.(Go::SliceExpr).getMax()) and
        tag = "implicit-max"
        or
        // Implicit true in tagless switch
        n instanceof Go::ExpressionSwitchStmt and
        not exists(n.(Go::ExpressionSwitchStmt).getExpr()) and
        tag = "implicit-true"
        or
        // Case check nodes
        exists(int i |
          exists(n.(Go::CaseClause).getExpr(i)) and
          tag = "case-check:" + i.toString()
        )
        or
        // Type switch implicit variable
        exists(Go::TypeSwitchStmt ts, Go::DefineStmt ds |
          ds = ts.getAssign() and
          n.(Go::CaseClause) = ts.getACase() and
          exists(n.(Go::CaseClause).getImplicitlyDeclaredVariable()) and
          tag = "type-switch-var"
        )
        or
        // Literal element initialization
        n = any(Go::CompositeLit lit).getAnElement() and
        tag = "lit-init"
        or
        // Implicit literal element index
        exists(Go::CompositeLit lit |
          not lit instanceof Go::StructLit and
          n = lit.getAnElement() and
          not n instanceof Go::KeyValueExpr and
          tag = "lit-index"
        )
        or
        // Implicit field selection for promoted fields
        exists(int i, Go::Field implicitField |
          implicitFieldSelection(n, i, implicitField) and
          tag = "implicit-field:" + i.toString()
        )
        or
        // Deferred-call invocation node, placed at function exit by `deferExitStep`
        n = any(Go::DeferStmt s).getCall() and tag = "defer-invoke"
      )
    }

    /** Helper: condition for MkExtractNode */
    private predicate extractNodeCondition(Ast::AstNode s, int i) {
      exists(Go::Assignment assgn |
        s = assgn and
        exists(assgn.getRhs()) and
        assgn.getNumLhs() > 1 and
        exists(assgn.getLhs(i))
      )
      or
      exists(Go::ValueSpec spec |
        s = spec and
        exists(spec.getInit()) and
        spec.getNumName() > 1 and
        exists(spec.getNameExpr(i))
      )
      or
      exists(Go::RangeStmt rs | s = rs |
        exists(rs.getKey()) and i = 0
        or
        exists(rs.getValue()) and i = 1
      )
      or
      exists(Go::ReturnStmt ret, Go::SignatureType rettp |
        s = ret and
        exists(ret.getExpr()) and
        rettp = ret.getEnclosingFunction().getType() and
        rettp.getNumResult() > 1 and
        exists(rettp.getResultType(i))
      )
      or
      exists(Go::CallExpr outer, Go::CallExpr inner | s = outer |
        inner = outer.getArgument(0).stripParens() and
        outer.getNumArgument() = 1 and
        exists(inner.getType().(Go::TupleType).getComponentType(i))
      )
    }

    /** Helper: condition for implicit dereference */
    private predicate implicitDerefCondition(Ast::AstNode e) {
      e.(Go::Expr).getType().getUnderlyingType() instanceof Go::PointerType and
      (
        exists(Go::SelectorExpr sel | e = sel.getBase() |
          sel = any(Go::Field f).getAReference()
          or
          exists(Go::Method m, Go::Type tp |
            sel = m.getAReference() and
            tp = m.getReceiver().getType().getUnderlyingType() and
            not tp instanceof Go::PointerType
          )
        )
        or
        e = any(Go::IndexExpr ie).getBase()
        or
        e = any(Go::SliceExpr se).getBase()
      )
    }

    /** Helper: blank identifier check */
    private predicate notBlankIdent(Go::Expr e) { not e instanceof Go::BlankIdent }

    /** Helper: implicit field selection for promoted selectors */
    additional predicate implicitFieldSelection(Ast::AstNode e, int index, Go::Field implicitField) {
      exists(Go::StructType baseType, Go::PromotedField child, int implicitFieldDepth |
        baseType = e.(Go::PromotedSelector).getSelectedStructType() and
        (
          e.(Go::PromotedSelector).refersTo(child)
          or
          implicitFieldSelection(e, implicitFieldDepth + 1, child)
        )
      |
        child = baseType.getFieldOfEmbedded(implicitField, _, implicitFieldDepth + 1, _) and
        exists(Go::PromotedField explicitField, int explicitFieldDepth |
          e.(Go::PromotedSelector).refersTo(explicitField) and
          baseType.getFieldAtDepth(_, explicitFieldDepth) = explicitField
        |
          index = explicitFieldDepth - implicitFieldDepth
        )
      )
      or
      exists(
        Go::StructType baseType, Go::PromotedMethod method, int mDepth, int implicitFieldDepth
      |
        baseType = e.(Go::PromotedSelector).getSelectedStructType() and
        e.(Go::PromotedSelector).refersTo(method) and
        baseType.getMethodAtDepth(_, mDepth) = method and
        index = mDepth - implicitFieldDepth
      |
        method = baseType.getMethodOfEmbedded(implicitField, _, implicitFieldDepth + 1)
        or
        exists(Go::PromotedField child |
          child = baseType.getFieldOfEmbedded(implicitField, _, implicitFieldDepth + 1, _) and
          implicitFieldSelection(e, implicitFieldDepth + 1, child)
        )
      )
    }

    predicate beginAbruptCompletion(
      Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
    ) {
      ast instanceof Go::CallExpr and
      (
        not exists(ast.(Go::CallExpr).getTarget()) or
        ast.(Go::CallExpr).getTarget().mayPanic()
      ) and
      n.isIn(ast) and
      c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
      always = false
      or
      // Calls to functions that never return normally (e.g. `os.Exit`, `log.Fatal`,
      // `panic`) must suppress normal flow past the call site. We emit an `always`
      // exception completion so that the shared library's default In->After step
      // is suppressed.
      ast instanceof Go::CallExpr and
      exists(Go::Function target | target = ast.(Go::CallExpr).getTarget() |
        target.mustPanic() or target.mustNotReturnNormally()
      ) and
      n.isIn(ast) and
      c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
      always = true
      or
      ast instanceof Go::DivExpr and
      not ast.(Go::Expr).isConst() and
      n.isIn(ast) and
      c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
      always = false
      or
      ast instanceof Go::DerefExpr and
      n.isIn(ast) and
      c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
      always = false
      or
      ast instanceof Go::TypeAssertExpr and
      not exists(Go::Assignment assgn |
        assgn.getNumLhs() = 2 and ast = assgn.getRhs().stripParens()
      ) and
      not exists(Go::ValueSpec vs | vs.getNumName() = 2 and ast = vs.getInit().stripParens()) and
      not exists(Go::TypeSwitchStmt ts | ast = ts.getExpr()) and
      n.isIn(ast) and
      c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
      always = false
      or
      ast instanceof Go::IndexExpr and
      n.isIn(ast) and
      c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
      always = false
      or
      ast instanceof Go::ConversionExpr and
      ast.(Go::ConversionExpr).getType().(Go::PointerType).getBaseType() instanceof Go::ArrayType and
      n.isIn(ast) and
      c.asSimpleAbruptCompletion() instanceof ExceptionSuccessor and
      always = false
      or
      ast instanceof Go::FallthroughStmt and
      n.injects(ast) and
      c.getSuccessorType() instanceof BreakSuccessor and
      c.hasLabel(TFallthrough()) and
      always = true
      or
      ast instanceof Go::GotoStmt and
      n.injects(ast) and
      c.getSuccessorType() instanceof GotoSuccessor and
      c.hasLabel(TGoLabel(ast.(Go::GotoStmt).getLabel())) and
      always = true
    }

    predicate endAbruptCompletion(Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c) {
      exists(Go::LabeledStmt lbl |
        ast = lbl.getStmt() and
        n.isAfter(lbl) and
        c.getSuccessorType() instanceof BreakSuccessor and
        c.hasLabel(TGoLabel(lbl.getLabel()))
      )
      or
      exists(Go::FuncDef fd |
        ast = fd.getBody() and
        not funcHasDefer(fd) and
        c.getSuccessorType() instanceof ReturnSuccessor and
        (
          // If the function has result variables, route the return completion
          // through the result-read epilogue before reaching the function exit.
          exists(fd.getResultVar(0)) and n.isAdditional(fd.getBody(), "result-read:0")
          or
          not exists(fd.getResultVar(_)) and n.isAfter(fd.getBody())
        )
      )
      or
      exists(Go::LabeledStmt lbl, Go::FuncDef fd |
        ast = fd.getBody() and
        n.isBefore(lbl) and
        fd = lbl.getEnclosingFunction() and
        c.getSuccessorType() instanceof GotoSuccessor and
        c.hasLabel(TGoLabel(lbl.getLabel()))
      )
    }

    predicate overridesCallableEndAbruptCompletion(Ast::Callable c, AbruptCompletion completion) {
      // For functions with result variables, the library's default routing of a
      // `return` straight to the normal exit node is suppressed so that the
      // return is instead caught by `endAbruptCompletion` above and routed
      // through the result-read epilogue.
      //
      // For functions containing `defer` statements, the default routing is
      // likewise suppressed so that returns are routed through the deferred-call
      // epilogue (see `deferExitStep`) instead.
      (exists(c.(Go::FuncDef).getResultVar(0)) or funcHasDefer(c.(Go::FuncDef))) and
      completion.getSuccessorType() instanceof ReturnSuccessor
    }

    predicate callableExitStep(PreControlFlowNode n, Ast::Callable c, boolean normal) {
      // The last result-read node of the epilogue steps to the normal exit node.
      exists(Go::FuncDef fd, int j | fd = c |
        normal = true and
        exists(fd.getResultVar(j)) and
        not exists(fd.getResultVar(j + 1)) and
        n.isAdditional(fd.getBody(), "result-read:" + j.toString())
      )
    }

    /** Holds if `fd` contains at least one `defer` statement. */
    private predicate funcHasDefer(Go::FuncDef fd) {
      exists(Go::DeferStmt s | s.getEnclosingFunction() = fd)
    }

    /**
     * Holds if `n` is the registration node of `defer` statement `s` (the
     * post-order node of the statement, reached once its call's arguments have
     * been evaluated).
     *
     * This uses the reachability-free `isInOrderNode` rather than `n.isIn(s)`
     * because it is referenced under negation by `notDeferSucc`, and must
     * therefore not depend on `reachable`.
     */
    private predicate deferRegistration(PreControlFlowNode n, Go::DeferStmt s) {
      isInOrderNode(n, s)
    }

    /**
     * Holds if `n` is the deferred-invocation node for `defer` statement `s`,
     * which models the deferred call running at function exit.
     */
    private predicate deferInvoke(PreControlFlowNode n, Go::DeferStmt s) {
      n.isAdditional(s.getCall(), "defer-invoke")
    }

    /**
     * Gets a defer-free successor of `n` that is not a `defer` registration
     * node. Walking this relation from a node stops at the next registration
     * node, which is how the reachability gate for deferred calls is computed.
     *
     * This is typed over `PreControlFlowNode` and uses `succIgnoringDeferExit`
     * so that it does not depend on `reachable` (which would otherwise create a
     * non-monotonic cycle through `deferExitStep`).
     */
    private PreControlFlowNode notDeferSucc(PreControlFlowNode n) {
      succIgnoringDeferExit(n, result, _) and
      not deferRegistration(result, _)
    }

    /** Gets a node reachable from `start` over `notDeferSucc`, reflexively. */
    private PreControlFlowNode notDeferReach(PreControlFlowNode start) {
      result = start
      or
      result = notDeferSucc(notDeferReach(start))
    }

    /** Gets the entry node of `fd`. */
    private PreControlFlowNode funcEntry(Go::FuncDef fd) {
      result.(EntryNodeImpl).getEnclosingCallable() = fd
    }

    /**
     * Holds if `s` can be the first `defer` statement registered in `fd`, and
     * hence the last to run: its registration node is reachable from the entry
     * node without passing through another registration node.
     */
    private predicate firstDefer(Go::DeferStmt s, Go::FuncDef fd) {
      s.getEnclosingFunction() = fd and
      exists(PreControlFlowNode reg, PreControlFlowNode m |
        deferRegistration(reg, s) and
        m = notDeferReach(funcEntry(fd)) and
        succIgnoringDeferExit(m, reg, _)
      )
    }

    /**
     * Holds if the registration node of `predD` is the next registration node
     * reachable from the registration node of `succD`. Then `predD` is
     * registered immediately after `succD` and therefore runs immediately
     * before it (deferred calls run in last-in-first-out order).
     */
    private predicate nextDefer(Go::DeferStmt predD, Go::DeferStmt succD) {
      exists(PreControlFlowNode regPred, PreControlFlowNode regSucc, PreControlFlowNode m |
        deferRegistration(regPred, predD) and
        deferRegistration(regSucc, succD) and
        m = notDeferReach(regSucc) and
        succIgnoringDeferExit(m, regPred, _)
      )
    }

    /**
     * Holds if `n` is a normal-exit predecessor of `fd`: a `return` statement
     * node, or the fall-through node after the body.
     */
    private predicate normalExitPred(PreControlFlowNode n, Go::FuncDef fd) {
      exists(Go::ReturnStmt ret | ret.getEnclosingFunction() = fd and n.isIn(ret))
      or
      n.isAfter(fd.getBody())
    }

    /**
     * Holds if, after running its deferred calls, `fd` should continue at
     * `target` on a normal exit. For functions with result variables this is
     * the start of the result-read epilogue; otherwise it is the normal exit
     * node directly.
     */
    private predicate deferChainExitTarget(Go::FuncDef fd, PreControlFlowNode target) {
      exists(fd.getResultVar(0)) and target.isAdditional(fd.getBody(), "result-read:0")
      or
      not exists(fd.getResultVar(_)) and
      target.(NormalExitNodeImpl).getEnclosingCallable() = fd
    }

    predicate deferExitStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::FuncDef fd | funcHasDefer(fd) |
        // (a) an exit predecessor with no active defer flows straight to the exit target
        normalExitPred(n1, fd) and
        n1 = notDeferReach(funcEntry(fd)) and
        deferChainExitTarget(fd, n2)
        or
        // (b) an exit predecessor flows to the invocation of the last-registered active defer
        exists(Go::DeferStmt d, PreControlFlowNode reg |
          deferRegistration(reg, d) and
          d.getEnclosingFunction() = fd and
          normalExitPred(n1, fd) and
          n1 = notDeferReach(reg) and
          deferInvoke(n2, d)
        )
        or
        // (c) deferred invocations chain in last-in-first-out order
        exists(Go::DeferStmt predD, Go::DeferStmt succD |
          predD.getEnclosingFunction() = fd and
          nextDefer(predD, succD) and
          deferInvoke(n1, predD) and
          deferInvoke(n2, succD)
        )
        or
        // (d) the invocation of the first-registered (last to run) defer flows to the exit target
        exists(Go::DeferStmt firstD |
          firstDefer(firstD, fd) and
          deferInvoke(n1, firstD) and
          deferChainExitTarget(fd, n2)
        )
      )
    }

    predicate overridesCallableBodyExit(Ast::Callable c) { funcHasDefer(c.(Go::FuncDef)) }

    predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
      rangeLoop(n1, n2) or
      switchStmt(n1, n2) or
      selectStmt(n1, n2) or
      deferStmt(n1, n2) or
      goStmtStep(n1, n2) or
      assignmentStep(n1, n2) or
      incDecStep(n1, n2) or
      returnStep(n1, n2) or
      indexExprStep(n1, n2) or
      sliceExprStep(n1, n2) or
      selectorExprStep(n1, n2) or
      compositeLitStep(n1, n2) or
      sendStmtStep(n1, n2) or
      funcDefStep(n1, n2)
    }

    /**
     * Gets the non-skipped child of `parent` at rank `rnk` (1-based).
     * This mimics the shared library's getRankedChild but for use in explicit steps.
     */
    private Ast::AstNode getRankedChild(Ast::AstNode parent, int rnk) {
      result = rank[rnk](Ast::AstNode c, int ix | c = getChild(parent, ix) | c order by ix)
    }

    private Ast::AstNode getChild(Ast::AstNode parent, int ix) {
      result = Ast::getChild(parent, ix)
    }

    /**
     * Routes from isBefore(parent) through all non-skipped children in order,
     * then to the first epilogue node (additionalNode or isIn/isAfter).
     * This is for constructs where we manually override default flow.
     */
    private predicate childSequenceStep(
      Ast::AstNode parent, PreControlFlowNode n1, PreControlFlowNode n2
    ) {
      // Before parent → Before first child
      n1.isBefore(parent) and n2.isBefore(getRankedChild(parent, 1))
      or
      // After child i → Before child i+1
      exists(int i |
        n1.isAfter(getRankedChild(parent, i)) and
        n2.isBefore(getRankedChild(parent, i + 1))
      )
    }

    /** Gets the last non-skipped child of `parent`, or fails if none. */
    private Ast::AstNode getLastRankedChild(Ast::AstNode parent) {
      exists(int i |
        result = getRankedChild(parent, i) and
        not exists(getRankedChild(parent, i + 1))
      )
    }

    /**
     * Assignment flow: routes through LHS/RHS children, then through
     * additional nodes for compound-rhs, extract, zero-init, and assign
     * operations.
     */
    private predicate assignmentStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Ast::AstNode assgn |
        (
          assgn instanceof Go::Assignment and not assgn instanceof Go::RecvStmt
          or
          assgn instanceof Go::ValueSpec
        )
      |
        // Route through children (LHS names, RHS expressions)
        childSequenceStep(assgn, n1, n2)
        or
        // After last child → first epilogue node
        exists(Ast::AstNode lastChild | lastChild = getLastRankedChild(assgn) |
          n1.isAfter(lastChild) and n2.isAdditional(assgn, getFirstEpilogueTag(assgn))
        )
        or
        // No children at all → before → first epilogue
        not exists(getRankedChild(assgn, _)) and
        n1.isBefore(assgn) and
        n2.isAdditional(assgn, getFirstEpilogueTag(assgn))
        or
        // Chain through epilogue nodes
        exists(string tag1, string tag2 |
          epilogueSucc(assgn, tag1, tag2) and
          n1.isAdditional(assgn, tag1) and
          n2.isAdditional(assgn, tag2)
        )
        or
        // Last epilogue → after the assignment
        n1.isAdditional(assgn, getLastEpilogueTag(assgn)) and
        n2.isAfter(assgn)
        or
        // No epilogue at all → after last child → after assignment
        not exists(getFirstEpilogueTag(assgn)) and
        n1.isAfter(getLastRankedChild(assgn)) and
        n2.isAfter(assgn)
      )
    }

    /**
     * Gets the ordered epilogue tags for an assignment node, following the
     * pattern: compound-rhs?, (extract:i, assign:i | zero-init:i, assign:i)*
     */
    private string getEpilogueTag(Ast::AstNode assgn, int ord) {
      // Compound RHS comes first
      assgn instanceof Go::CompoundAssignStmt and
      ord = -1 and
      result = "compound-rhs"
      or
      exists(int j |
        (
          extractNodeCondition(assgn, j) and result = "extract:" + j.toString() and ord = 2 * j
          or
          exists(Go::ValueSpec spec |
            assgn = spec and
            not exists(spec.getAnInit()) and
            exists(spec.getNameExpr(j)) and
            result = "zero-init:" + j.toString() and
            ord = 2 * j
          )
          or
          (
            notBlankIdent(assgn.(Go::Assignment).getLhs(j))
            or
            notBlankIdent(assgn.(Go::ValueSpec).getNameExpr(j))
            or
            notBlankIdent(assgn.(Go::RangeStmt).getKey()) and j = 0
            or
            notBlankIdent(assgn.(Go::RangeStmt).getValue()) and j = 1
          ) and
          result = "assign:" + j.toString() and
          ord = 2 * j + 1
        )
      )
    }

    private string getEpilogueTagRanked(Ast::AstNode assgn, int rnk) {
      result =
        rank[rnk](string tag, int ord |
          tag = getEpilogueTag(assgn, ord) and
          exists(tag)
        |
          tag order by ord
        )
    }

    private string getFirstEpilogueTag(Ast::AstNode assgn) {
      result = getEpilogueTagRanked(assgn, 1)
    }

    private string getLastEpilogueTag(Ast::AstNode assgn) {
      exists(int i |
        result = getEpilogueTagRanked(assgn, i) and
        not exists(getEpilogueTagRanked(assgn, i + 1))
      )
    }

    private predicate epilogueSucc(Ast::AstNode assgn, string tag1, string tag2) {
      exists(int i |
        tag1 = getEpilogueTagRanked(assgn, i) and
        tag2 = getEpilogueTagRanked(assgn, i + 1)
      )
    }

    /**
     * Increment/decrement: operand → implicit-one → incdec-rhs → In(stmt)
     * (IncDecStmt is in postOrInOrder, so In(stmt) is its evaluation point)
     */
    private predicate incDecStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::IncDecStmt s |
        // Before → Before operand
        n1.isBefore(s) and n2.isBefore(s.getOperand())
        or
        // After operand → implicit-one
        n1.isAfter(s.getOperand()) and n2.isAdditional(s, "implicit-one")
        or
        // implicit-one → incdec-rhs
        n1.isAdditional(s, "implicit-one") and n2.isAdditional(s, "incdec-rhs")
        or
        // incdec-rhs → In(stmt) (the assignment itself)
        n1.isAdditional(s, "incdec-rhs") and n2.isIn(s)
        or
        // In(stmt) → After(stmt)
        n1.isIn(s) and n2.isAfter(s)
      )
    }

    /**
     * Return statement: evaluate expressions, extract tuples, write results,
     * then the return node.
     */
    private predicate returnStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::ReturnStmt ret |
        // Route through expression children
        childSequenceStep(ret, n1, n2)
        or
        exists(Ast::AstNode lastChild | lastChild = getLastRankedChild(ret) |
          // After last expr → first return epilogue
          n1.isAfter(lastChild) and n2.isAdditional(ret, getFirstReturnEpilogueTag(ret))
        )
        or
        exists(Ast::AstNode lastChild | lastChild = getLastRankedChild(ret) |
          // After last expr → return node directly if there is no return epilogue
          not exists(getFirstReturnEpilogueTag(ret)) and
          n1.isAfter(lastChild) and
          n2.isIn(ret)
        )
        or
        // No expressions → before → return node directly
        not exists(getRankedChild(ret, _)) and
        n1.isBefore(ret) and
        n2.isIn(ret)
        or
        // Chain return epilogue nodes
        exists(string tag1, string tag2 |
          returnEpilogueSucc(ret, tag1, tag2) and
          n1.isAdditional(ret, tag1) and
          n2.isAdditional(ret, tag2)
        )
        or
        // Last return epilogue → return node
        n1.isAdditional(ret, getLastReturnEpilogueTag(ret)) and
        n2.isIn(ret)
      )
    }

    private string getReturnEpilogueTag(Go::ReturnStmt ret, int ord) {
      exists(int i |
        extractNodeCondition(ret, i) and result = "extract:" + i.toString() and ord = 2 * i
        or
        exists(Go::ResultVariable rv |
          ret.getEnclosingFunction().getResultVar(i) = rv and
          exists(ret.getAnExpr()) and
          result = "result-write:" + i.toString() and
          ord = 2 * i + 1
        )
      )
    }

    private string getReturnEpilogueTagRanked(Go::ReturnStmt ret, int rnk) {
      result =
        rank[rnk](string tag, int ord |
          tag = getReturnEpilogueTag(ret, ord) and
          exists(tag)
        |
          tag order by ord
        )
    }

    private string getFirstReturnEpilogueTag(Go::ReturnStmt ret) {
      result = getReturnEpilogueTagRanked(ret, 1)
    }

    private string getLastReturnEpilogueTag(Go::ReturnStmt ret) {
      exists(int i |
        result = getReturnEpilogueTagRanked(ret, i) and
        not exists(getReturnEpilogueTagRanked(ret, i + 1))
      )
    }

    private predicate returnEpilogueSucc(Go::ReturnStmt ret, string tag1, string tag2) {
      exists(int i |
        tag1 = getReturnEpilogueTagRanked(ret, i) and
        tag2 = getReturnEpilogueTagRanked(ret, i + 1)
      )
    }

    /**
     * Index expression: base → implicit-deref? → index → In(indexExpr)
     */
    private predicate indexExprStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::IndexExpr ie |
        implicitDerefCondition(ie.getBase()) and
        (
          n1.isBefore(ie) and n2.isBefore(ie.getBase())
          or
          n1.isAfter(ie.getBase()) and n2.isAdditional(ie.getBase(), "implicit-deref")
          or
          n1.isAdditional(ie.getBase(), "implicit-deref") and n2.isBefore(ie.getIndex())
          or
          n1.isAfter(ie.getIndex()) and n2.isIn(ie)
          or
          n1.isIn(ie) and n2.isAfter(ie)
        )
      )
    }

    /**
     * Slice expression: base → implicit-deref? → low/implicit-low →
     * high/implicit-high → max/implicit-max → In(sliceExpr)
     */
    private predicate sliceExprStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::SliceExpr se |
        (implicitDerefCondition(se.getBase()) or exists(se.getLow()) or not exists(se.getLow())) and
        (
          n1.isBefore(se) and n2.isBefore(se.getBase())
          or
          // After base → implicit deref or low/implicit-low
          n1.isAfter(se.getBase()) and
          (
            if implicitDerefCondition(se.getBase())
            then n2.isAdditional(se.getBase(), "implicit-deref")
            else
              if exists(se.getLow())
              then n2.isBefore(se.getLow())
              else n2.isAdditional(se, "implicit-low")
          )
          or
          n1.isAdditional(se.getBase(), "implicit-deref") and
          (
            if exists(se.getLow())
            then n2.isBefore(se.getLow())
            else n2.isAdditional(se, "implicit-low")
          )
          or
          (n1.isAfter(se.getLow()) or n1.isAdditional(se, "implicit-low")) and
          (
            if exists(se.getHigh())
            then n2.isBefore(se.getHigh())
            else n2.isAdditional(se, "implicit-high")
          )
          or
          (n1.isAfter(se.getHigh()) or n1.isAdditional(se, "implicit-high")) and
          (
            if exists(se.getMax())
            then n2.isBefore(se.getMax())
            else n2.isAdditional(se, "implicit-max")
          )
          or
          (n1.isAfter(se.getMax()) or n1.isAdditional(se, "implicit-max")) and
          n2.isIn(se)
          or
          n1.isIn(se) and n2.isAfter(se)
        )
      )
    }

    /**
     * Selector expression with value base: base → implicit-deref? →
     * implicit-field-selections → In(selector)
     */
    private predicate selectorExprStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::SelectorExpr sel |
        sel.getBase() instanceof Go::ValueExpr and
        (
          implicitDerefCondition(sel.getBase()) or
          exists(Go::Field f | sel = f.getAReference()) or
          implicitFieldSelection(sel, _, _)
        ) and
        (
          n1.isBefore(sel) and n2.isBefore(sel.getBase())
          or
          // After base (no implicit-deref) → first implicit-field or In(sel)
          n1.isAfter(sel.getBase()) and
          not implicitDerefCondition(sel.getBase()) and
          (
            // Has implicit field reads: go to outermost (highest index)
            exists(int maxIdx |
              maxIdx = max(int i | implicitFieldSelection(sel, i, _)) and
              n2.isAdditional(sel, "implicit-field:" + maxIdx.toString())
            )
            or
            // No implicit field reads: go directly to In(sel)
            not implicitFieldSelection(sel, _, _) and n2.isIn(sel)
          )
          or
          // After base (has implicit-deref) → implicit-deref node
          n1.isAfter(sel.getBase()) and
          implicitDerefCondition(sel.getBase()) and
          n2.isAdditional(sel.getBase(), "implicit-deref")
          or
          // After implicit-deref → first implicit-field or In(sel)
          n1.isAdditional(sel.getBase(), "implicit-deref") and
          (
            exists(int maxIdx |
              maxIdx = max(int i | implicitFieldSelection(sel, i, _)) and
              n2.isAdditional(sel, "implicit-field:" + maxIdx.toString())
            )
            or
            not implicitFieldSelection(sel, _, _) and n2.isIn(sel)
          )
          or
          // Between implicit field reads: descend from index i to i-1
          exists(int i |
            i > 1 and
            implicitFieldSelection(sel, i, _) and
            implicitFieldSelection(sel, i - 1, _) and
            n1.isAdditional(sel, "implicit-field:" + i.toString()) and
            n2.isAdditional(sel, "implicit-field:" + (i - 1).toString())
          )
          or
          // Last implicit field read (index 1) → In(sel)
          implicitFieldSelection(sel, 1, _) and
          n1.isAdditional(sel, "implicit-field:1") and
          n2.isIn(sel)
          or
          n1.isIn(sel) and n2.isAfter(sel)
        )
      )
    }

    /**
     * Composite literal: In(lit) → element-init chain → After(lit)
     * CompositeLit evaluates the literal (allocation) first (pre-order),
     * then initializes elements.
     */
    private predicate compositeLitStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::CompositeLit lit |
        // Before → In (the literal allocation)
        n1.isBefore(lit) and n2.isIn(lit)
        or
        // In → first element, or After if no elements
        n1.isIn(lit) and
        (
          n2.isBefore(lit.getElement(0))
          or
          not exists(lit.getElement(_)) and n2.isAfter(lit)
        )
        or
        // After element → optional lit-index → lit-init → next element or After
        exists(int i |
          n1.isAfter(lit.getElement(i)) and
          (
            n2.isAdditional(lit.getElement(i), "lit-index")
            or
            not exists(PreControlFlowNode idx | idx.isAdditional(lit.getElement(i), "lit-index")) and
            n2.isAdditional(lit.getElement(i), "lit-init")
          )
          or
          n1.isAdditional(lit.getElement(i), "lit-index") and
          n2.isAdditional(lit.getElement(i), "lit-init")
          or
          n1.isAdditional(lit.getElement(i), "lit-init") and
          (
            n2.isBefore(lit.getElement(i + 1))
            or
            not exists(lit.getElement(i + 1)) and n2.isAfter(lit)
          )
        )
      )
    }

    /**
     * Send statement (outside select): channel → value → In(send)
     */
    private predicate sendStmtStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::SendStmt s | not s = any(Go::CommClause cc).getComm() |
        n1.isBefore(s) and n2.isBefore(s.getChannel())
        or
        n1.isAfter(s.getChannel()) and n2.isBefore(s.getValue())
        or
        n1.isAfter(s.getValue()) and n2.isIn(s)
        or
        n1.isIn(s) and n2.isAfter(s)
      )
    }

    private predicate rangeLoop(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::RangeStmt s |
        // Use the shared library's auto-created `[LoopHeader]` additional node
        // (created for every `LoopStmt`) as the join/branch point of the range loop.
        n1.isBefore(s) and n2.isBefore(s.getDomain())
        or
        n1.isAfter(s.getDomain()) and n2.isAdditional(s, "[LoopHeader]")
        or
        n1.isAdditional(s, "[LoopHeader]") and n2.isAdditional(s, "next")
        or
        n1.isAdditional(s, "next") and
        (
          exists(getFirstEpilogueTag(s)) and n2.isAdditional(s, getFirstEpilogueTag(s))
          or
          not exists(getFirstEpilogueTag(s)) and n2.isBefore(s.getBody())
        )
        or
        exists(string tag1, string tag2 |
          epilogueSucc(s, tag1, tag2) and
          n1.isAdditional(s, tag1) and
          n2.isAdditional(s, tag2)
        )
        or
        n1.isAdditional(s, getLastEpilogueTag(s)) and n2.isBefore(s.getBody())
        or
        n1.isAfter(s.getBody()) and n2.isAdditional(s, "[LoopHeader]")
        or
        n1.isAdditional(s, "[LoopHeader]") and n2.isAfter(s)
      )
    }

    private predicate switchStmt(PreControlFlowNode n1, PreControlFlowNode n2) {
      exprSwitch(n1, n2) or typeSwitch(n1, n2) or caseClause(n1, n2)
    }

    private predicate switchCasesStartOrAfter(Go::SwitchStmt sw, PreControlFlowNode n) {
      n.isBefore(sw.getNonDefaultCase(0))
      or
      not exists(sw.getANonDefaultCase()) and n.isBefore(sw.getDefault())
      or
      not exists(sw.getACase()) and n.isAfter(sw)
    }

    private predicate exprSwitch(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::ExpressionSwitchStmt sw |
        n1.isBefore(sw) and
        (
          n2.isBefore(sw.getInit())
          or
          not exists(sw.getInit()) and
          (
            n2.isBefore(sw.getExpr())
            or
            not exists(sw.getExpr()) and switchCasesStartOrAfter(sw, n2)
          )
        )
        or
        n1.isAfter(sw.getInit()) and
        (
          n2.isBefore(sw.getExpr())
          or
          not exists(sw.getExpr()) and switchCasesStartOrAfter(sw, n2)
        )
        or
        n1.isAfter(sw.getExpr()) and switchCasesStartOrAfter(sw, n2)
      )
    }

    private predicate typeSwitch(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::TypeSwitchStmt sw |
        n1.isBefore(sw) and
        (
          n2.isBefore(sw.getInit())
          or
          not exists(sw.getInit()) and n2.isBefore(sw.getTest())
        )
        or
        n1.isAfter(sw.getInit()) and n2.isBefore(sw.getTest())
        or
        n1.isAfter(sw.getTest()) and switchCasesStartOrAfter(sw, n2)
      )
    }

    /**
     * Holds if `sw` is a tagless expression switch, in which case the case
     * expressions are themselves the boolean conditions being tested and are
     * therefore in a boolean conditional context.
     */
    private predicate isBooleanSwitch(Go::SwitchStmt sw) {
      sw instanceof Go::ExpressionSwitchStmt and
      not exists(sw.(Go::ExpressionSwitchStmt).getExpr())
    }

    /**
     * Holds if `n` is the control-flow node immediately after evaluating case
     * expression `caseExpr` of switch `sw` on the branch where `caseExpr`
     * matches.
     */
    private predicate afterCaseExprMatch(Go::SwitchStmt sw, Go::Expr caseExpr, PreControlFlowNode n) {
      caseExpr = sw.getACase().(Go::CaseClause).getAnExpr() and
      (
        isBooleanSwitch(sw) and n.isAfterTrue(caseExpr)
        or
        not isBooleanSwitch(sw) and n.isAfter(caseExpr)
      )
    }

    /**
     * Holds if `n` is the control-flow node immediately after evaluating case
     * expression `caseExpr` of switch `sw` on the branch where `caseExpr`
     * does not match.
     */
    private predicate afterCaseExprNoMatch(
      Go::SwitchStmt sw, Go::Expr caseExpr, PreControlFlowNode n
    ) {
      caseExpr = sw.getACase().(Go::CaseClause).getAnExpr() and
      (
        isBooleanSwitch(sw) and n.isAfterFalse(caseExpr)
        or
        not isBooleanSwitch(sw) and n.isAfter(caseExpr)
      )
    }

    /**
     * Holds if `cc` is a case clause of a type switch with an assignment that
     * implicitly declares a variable whose type narrows to the case type. In
     * this situation the CFG inserts a `type-switch-var` additional node
     * between the case test and the case body, on which the IR layer
     * materialises the implicit assignment to that variable.
     */
    private predicate hasTypeSwitchVar(Go::CaseClause cc) {
      exists(Go::TypeSwitchStmt ts |
        ts.getACase() = cc and
        exists(ts.getAssign()) and
        exists(cc.getImplicitlyDeclaredVariable())
      )
    }

    private predicate caseClause(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::SwitchStmt sw, Go::CaseClause cc, int i | cc = sw.getNonDefaultCase(i) |
        n1.isBefore(cc) and n2.isBefore(cc.getExpr(0))
        or
        // For a tagless expression switch the case expressions are themselves
        // booleans in a conditional context, so we only fall through to the
        // next case expression on the false branch.
        exists(int j |
          afterCaseExprNoMatch(sw, cc.getExpr(j), n1) and n2.isBefore(cc.getExpr(j + 1))
        )
        or
        exists(int last | last = max(int j | exists(cc.getExpr(j))) |
          afterCaseExprMatch(sw, cc.getExpr(last), n1) and
          (
            hasTypeSwitchVar(cc) and n2.isAdditional(cc, "type-switch-var")
            or
            not hasTypeSwitchVar(cc) and
            (
              n2.isBefore(cc.getStmt(0))
              or
              not exists(cc.getStmt(0)) and n2.isAfter(sw)
            )
          )
          or
          afterCaseExprNoMatch(sw, cc.getExpr(last), n1) and
          (
            n2.isBefore(sw.getNonDefaultCase(i + 1))
            or
            not exists(sw.getNonDefaultCase(i + 1)) and n2.isBefore(sw.getDefault())
            or
            not exists(sw.getNonDefaultCase(i + 1)) and
            not exists(sw.getDefault()) and
            n2.isAfter(sw)
          )
        )
      )
      or
      exists(Go::SwitchStmt sw, Go::CaseClause def | def = sw.getDefault() |
        n1.isBefore(def) and
        (
          hasTypeSwitchVar(def) and n2.isAdditional(def, "type-switch-var")
          or
          not hasTypeSwitchVar(def) and
          (
            n2.isBefore(def.getStmt(0))
            or
            not exists(def.getStmt(0)) and n2.isAfter(sw)
          )
        )
      )
      or
      exists(Go::SwitchStmt sw, Go::CaseClause cc |
        sw.getACase() = cc and
        hasTypeSwitchVar(cc) and
        n1.isAdditional(cc, "type-switch-var") and
        (
          n2.isBefore(cc.getStmt(0))
          or
          not exists(cc.getStmt(0)) and n2.isAfter(sw)
        )
      )
      or
      exists(Go::CaseClause cc |
        exists(int j | n1.isAfter(cc.getStmt(j)) and n2.isBefore(cc.getStmt(j + 1)))
        or
        exists(Go::SwitchStmt sw, int last |
          sw.getACase() = cc and
          last = max(int j | exists(cc.getStmt(j))) and
          n1.isAfter(cc.getStmt(last)) and
          n2.isAfter(sw)
        )
      )
    }

    private predicate commClauseBodyStart(
      Go::SelectStmt sel, Go::CommClause cc, PreControlFlowNode n
    ) {
      n.isBefore(cc.getStmt(0))
      or
      not exists(cc.getStmt(0)) and n.isAfter(sel)
    }

    private predicate selectCommPrepStart(Go::CommClause cc, PreControlFlowNode n) {
      exists(Go::RecvStmt recv | recv = cc.getComm() | n.isBefore(recv.getExpr().getOperand()))
      or
      exists(Go::SendStmt send | send = cc.getComm() | n.isBefore(send.getChannel()))
    }

    private predicate selectCommPrepEnd(Go::CommClause cc, PreControlFlowNode n) {
      exists(Go::RecvStmt recv | recv = cc.getComm() | n.isAfter(recv.getExpr().getOperand()))
      or
      exists(Go::SendStmt send | send = cc.getComm() | n.isAfter(send.getValue()))
    }

    private predicate selectCommPrepStep(
      Go::CommClause cc, PreControlFlowNode n1, PreControlFlowNode n2
    ) {
      exists(Go::SendStmt send | send = cc.getComm() |
        n1.isAfter(send.getChannel()) and n2.isBefore(send.getValue())
      )
    }

    private predicate selectedCommStep(
      Go::SelectStmt sel, PreControlFlowNode n1, PreControlFlowNode n2
    ) {
      exists(Go::RecvStmt recv | recv = sel.getACommClause().getComm() |
        n1.isBefore(recv) and n2.isIn(recv.getExpr())
        or
        n1.isBefore(recv.getExpr()) and n2.isBefore(recv.getExpr().getOperand())
      )
      or
      exists(Go::SendStmt send | send = sel.getACommClause().getComm() |
        n1.isBefore(send) and n2.isBefore(send.getChannel())
        or
        n1.isAfter(send.getChannel()) and n2.isBefore(send.getValue())
        or
        n1.isIn(send) and n2.isAfter(send)
      )
    }

    private predicate selectRecvStmtStep(
      Go::SelectStmt sel, Go::CommClause cc, Go::RecvStmt recv, PreControlFlowNode n1,
      PreControlFlowNode n2
    ) {
      cc = sel.getACommClause() and
      recv = cc.getComm() and
      (
        n1.isIn(recv.getExpr()) and
        (
          n2.isBefore(recv.getLhs(0))
          or
          not exists(recv.getLhs(0)) and commClauseBodyStart(sel, cc, n2)
        )
        or
        exists(int j | n1.isAfter(recv.getLhs(j)) and n2.isBefore(recv.getLhs(j + 1)))
        or
        exists(int last | exists(recv.getLhs(last)) and not exists(recv.getLhs(last + 1)) |
          n1.isAfter(recv.getLhs(last)) and n2.isAdditional(recv, getFirstEpilogueTag(recv))
        )
        or
        exists(int last | exists(recv.getLhs(last)) and not exists(recv.getLhs(last + 1)) |
          not exists(getFirstEpilogueTag(recv)) and
          n1.isAfter(recv.getLhs(last)) and
          commClauseBodyStart(sel, cc, n2)
        )
        or
        exists(string tag1, string tag2 |
          epilogueSucc(recv, tag1, tag2) and
          n1.isAdditional(recv, tag1) and
          n2.isAdditional(recv, tag2)
        )
        or
        n1.isAdditional(recv, getLastEpilogueTag(recv)) and commClauseBodyStart(sel, cc, n2)
      )
    }

    private predicate selectStmt(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::SelectStmt sel |
        selectedCommStep(sel, n1, n2)
        or
        n1.isBefore(sel) and
        (
          selectCommPrepStart(sel.getNonDefaultCommClause(0), n2)
          or
          not exists(sel.getNonDefaultCommClause(0)) and n2.isIn(sel)
        )
        or
        exists(Go::CommClause cc, int i | cc = sel.getNonDefaultCommClause(i) |
          selectCommPrepStep(cc, n1, n2)
          or
          selectCommPrepEnd(cc, n1) and
          (
            selectCommPrepStart(sel.getNonDefaultCommClause(i + 1), n2)
            or
            not exists(sel.getNonDefaultCommClause(i + 1)) and n2.isIn(sel)
          )
        )
        or
        n1.isIn(sel) and
        exists(Go::CommClause cc | sel.getACommClause() = cc | n2.isBefore(cc))
        or
        exists(Go::CommClause cc | sel.getACommClause() = cc |
          n1.isBefore(cc) and
          (
            n2.isIn(cc.getComm().(Go::RecvStmt).getExpr())
            or
            n2.isIn(cc.getComm().(Go::SendStmt))
            or
            not exists(cc.getComm()) and commClauseBodyStart(sel, cc, n2)
          )
          or
          exists(Go::RecvStmt recv | selectRecvStmtStep(sel, cc, recv, n1, n2))
          or
          n1.isAfter(cc.getComm().(Go::SendStmt)) and commClauseBodyStart(sel, cc, n2)
          or
          exists(int j | n1.isAfter(cc.getStmt(j)) and n2.isBefore(cc.getStmt(j + 1)))
          or
          exists(int last |
            last = max(int j | exists(cc.getStmt(j))) and
            n1.isAfter(cc.getStmt(last)) and
            n2.isAfter(sel)
          )
        )
      )
    }

    private predicate deferStmt(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::DeferStmt s |
        n1.isBefore(s) and n2.isBefore(s.getCall())
        or
        n1.isAfter(s.getCall()) and n2.isIn(s)
        or
        n1.isIn(s) and n2.isAfter(s)
      )
    }

    private predicate goStmtStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::GoStmt s |
        n1.isBefore(s) and n2.isBefore(s.getCall())
        or
        n1.isAfter(s.getCall()) and n2.isIn(s)
        or
        n1.isIn(s) and n2.isAfter(s)
      )
    }

    /**
     * Function definition prologue and epilogue:
     * - Prologue: Before(body) → arg:-1 → param-init:-1 → arg:0 → param-init:0 → ...
     *             when a receiver exists; otherwise it starts at arg:0. Then
     *             result-zero-init:0 → result-init:0 → ... → first statement
     * - Epilogue: return → result-read:0 → result-read:1 → ... → result-read:last
     *
     * The last result-read node goes to `NormalExit(fd)` via the shared
     * library's `callableExitStep` hook.
     */
    private predicate hasFuncDefPrologue(Go::FuncDef fd) {
      exists(fd.getParameter(_)) or exists(fd.getResultVar(_))
    }

    private predicate funcDefBodyStart(Go::FuncDef fd, PreControlFlowNode n) {
      n.isBefore(getRankedChild(fd.getBody(), 1))
      or
      not exists(getRankedChild(fd.getBody(), _)) and n.isAfter(fd.getBody())
    }

    private predicate funcDefBodyStep(Go::FuncDef fd, PreControlFlowNode n1, PreControlFlowNode n2) {
      not hasFuncDefPrologue(fd) and
      n1.isBefore(fd.getBody()) and
      funcDefBodyStart(fd, n2)
      or
      exists(int i |
        n1.isAfter(getRankedChild(fd.getBody(), i)) and
        n2.isBefore(getRankedChild(fd.getBody(), i + 1))
      )
      or
      exists(Ast::AstNode lastChild | lastChild = getLastRankedChild(fd.getBody()) |
        n1.isAfter(lastChild) and n2.isAfter(fd.getBody())
      )
    }

    private predicate funcDefStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::FuncDef fd | exists(fd.getBody()) |
        // Before(body) → first prologue node, or first body statement if no prologue
        n1.isBefore(fd.getBody()) and
        (
          // Has receiver: start with arg:-1
          exists(fd.getParameter(-1)) and n2.isAdditional(fd.getBody(), "arg:-1")
          or
          // Has ordinary parameters: start with arg:0
          not exists(fd.getParameter(-1)) and
          exists(fd.getParameter(0)) and
          n2.isAdditional(fd.getBody(), "arg:0")
          or
          // No parameters, has result vars: start with result-zero-init:0
          not exists(fd.getParameter(_)) and
          exists(fd.getResultVar(0)) and
          n2.isAdditional(fd.getBody(), "result-zero-init:0")
          or
          // No parameters and no result vars: go directly to Before(body)
          not exists(fd.getParameter(_)) and
          not exists(fd.getResultVar(_)) and
          funcDefBodyStart(fd, n2)
        )
        or
        // arg:i → param-init:i (for each parameter)
        exists(int i | exists(fd.getParameter(i)) |
          n1.isAdditional(fd.getBody(), "arg:" + i.toString()) and
          n2.isAdditional(fd.getBody(), "param-init:" + i.toString())
        )
        or
        // param-init:i → next: arg:(i+1), or result-zero-init:0, or Before(body)
        exists(int i | exists(fd.getParameter(i)) |
          n1.isAdditional(fd.getBody(), "param-init:" + i.toString()) and
          (
            // Next parameter exists
            exists(fd.getParameter(i + 1)) and
            n2.isAdditional(fd.getBody(), "arg:" + (i + 1).toString())
            or
            // No next parameter, has result vars: go to result-zero-init:0
            not exists(fd.getParameter(i + 1)) and
            exists(fd.getResultVar(0)) and
            n2.isAdditional(fd.getBody(), "result-zero-init:0")
            or
            // No next parameter and no result vars: go to Before(body)
            not exists(fd.getParameter(i + 1)) and
            not exists(fd.getResultVar(_)) and
            funcDefBodyStart(fd, n2)
          )
        )
        or
        // result-zero-init:j → result-init:j (for each result variable)
        exists(int j | exists(fd.getResultVar(j)) |
          n1.isAdditional(fd.getBody(), "result-zero-init:" + j.toString()) and
          n2.isAdditional(fd.getBody(), "result-init:" + j.toString())
        )
        or
        // result-init:j → next: result-zero-init:(j+1), or Before(body)
        exists(int j | exists(fd.getResultVar(j)) |
          n1.isAdditional(fd.getBody(), "result-init:" + j.toString()) and
          (
            // Next result var exists
            exists(fd.getResultVar(j + 1)) and
            n2.isAdditional(fd.getBody(), "result-zero-init:" + (j + 1).toString())
            or
            // No next result var: go to Before(body)
            not exists(fd.getResultVar(j + 1)) and
            funcDefBodyStart(fd, n2)
          )
        )
        or
        funcDefBodyStep(fd, n1, n2)
        or
        // result-read:j → result-read:(j+1); the last result-read node steps to
        // the normal exit node via the `callableExitStep` hook.
        exists(int j | exists(fd.getResultVar(j + 1)) |
          n1.isAdditional(fd.getBody(), "result-read:" + j.toString()) and
          n2.isAdditional(fd.getBody(), "result-read:" + (j + 1).toString())
        )
      )
    }
  }
}
