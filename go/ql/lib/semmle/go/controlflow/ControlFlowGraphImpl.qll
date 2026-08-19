/**
 * Provides the shared CFG library instantiation for Go.
 */
overlay[local]
module;

private import codeql.controlflow.ControlFlowGraph as CfgLib
private import codeql.controlflow.SuccessorType
private import codeql.util.Void

/** Contains the shared CFG library instantiation for Go. */
module CfgImpl {
  private import go as Go

  private module Cfg0 = CfgLib::Make0<Go::Location, Ast>;

  private module Cfg1 = Cfg0::Make1<Input1>;

  private module EarlyCfg2 = Cfg1::Make2<EarlyInput2>;

  private module Cfg2 = Cfg1::Make2<FinalInput2>;

  private import Cfg0
  private import Cfg1
  private import Cfg2
  import Public

  class CfgScope = Ast::Callable;

  /** Holds if `e` has an implicit field selection at `index` for `implicitField`. */
  predicate implicitFieldSelection(Go::AstNode e, int index, Go::Field implicitField) {
    Input1::implicitFieldSelection(e, index, implicitField)
  }

  /**
   * Holds if `root` is a constant root: a constant expression (with any
   * enclosing parentheses stripped) whose parent expression is not itself
   * constant. The strict sub-expressions of a constant root are folded at
   * compile time and are not evaluated at run time, so they get no evaluation
   * node; the constant root itself is evaluated as a single leaf value.
   */
  private predicate constantRoot(Go::Expr root) {
    exists(Go::Expr c |
      c.isConst() and
      not c.getParent().(Go::Expr).isConst() and
      root = c.stripParens()
    )
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
      or
      // The shared switch model wires control flow directly from the switch to
      // its case clauses (in control-flow order) and between cases, so the
      // enclosing block must not introduce its own nodes or default
      // left-to-right sequencing of the case clauses.
      e = any(Go::SwitchStmt sw).getBody()
      or
      // The test statement of a type switch (`y := x.(type)` or the bare
      // `x.(type)` expression statement) is transparent: the shared switch
      // model evaluates the underlying type-assertion expression directly as
      // the switch expression (see `Switch.getExpr`), so the wrapping
      // statement must not introduce its own assignment or expression nodes.
      e = any(Go::TypeSwitchStmt ts).getTest()
      or
      // The strict sub-expressions of a constant expression are not evaluated
      // at run time, so they must not get their own evaluation nodes.
      constantRoot(e.(Go::Expr).getParent+())
    }

    AstNode getChild(AstNode n, int index) {
      (
        not n instanceof Go::FuncDef and
        not skipCfg(n) and
        result = n.getChild(index)
        or
        // The body block of a switch (expression or type) is transparent (see
        // `skipCfg`), so it is not itself a child and contributes no children.
        // Expose the case clauses directly as children of the switch instead,
        // so that the AST child chain stays connected for abrupt-completion
        // propagation (e.g. a panicking call in a case body reaching the
        // enclosing function's exceptional exit).
        result = n.(Go::SwitchStmt).getBody().getChild(index)
        or
        // The type-switch test statement is transparent (see `skipCfg`), so
        // expose the underlying type-assertion expression directly as a child
        // of the type switch, keeping the AST child chain connected.
        result = n.(Go::TypeSwitchStmt).getExpr() and index = 1
      ) and
      not skipCfg(result)
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
      Parameter() { this = any(Go::Parameter p).getDeclaration() }

      AstNode getPattern() { result = this }

      Expr getDefaultValue() { none() }
    }

    Parameter callableGetParameter(Callable c, int index) {
      result = c.(Go::FuncDef).getParameter(index).getDeclaration()
    }

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
        not this = any(Go::FuncDef fd).getBody() and
        not this = any(Go::SwitchStmt sw).getBody() and
        not this = any(Go::SelectStmt sel).getBody()
      }

      Stmt getLastStmt() {
        exists(int last | result = this.getStmt(last) and not exists(this.getStmt(last + 1)))
      }
    }

    class ExprStmt extends Stmt instanceof Go::ExprStmt {
      // The `x.(type)` test statement of a type switch is transparent (see
      // `skipCfg`): the shared switch model evaluates the underlying
      // type-assertion expression directly as the switch expression. It must
      // therefore not be treated as an ordinary expression statement, whose
      // value would otherwise be propagated from the expression to the
      // statement (creating a spurious flow into the transparent wrapper).
      ExprStmt() { not this = any(Go::TypeSwitchStmt ts).getTest() }

      Expr getExpr() { result = Go::ExprStmt.super.getExpr() }
    }

    class IfStmt = Go::IfStmt;

    AstNode getIfInit(IfStmt ifstmt) { result = ifstmt.(Go::IfStmt).getInit() }

    class LoopStmt = Go::LoopStmt;

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

    class ForStmt extends LoopStmt instanceof Go::ForStmt {
      AstNode getInit(int index) { index = 0 and result = this.(Go::ForStmt).getInit() }

      Expr getCondition() { result = this.(Go::ForStmt).getCond() }

      AstNode getUpdate(int index) { index = 0 and result = this.(Go::ForStmt).getPost() }
    }

    class ForeachStmt extends LoopStmt instanceof Go::RangeStmt {
      Expr getVariable() { result = this.(Go::RangeStmt).getPattern() }

      Expr getCollection() { result = this.(Go::RangeStmt).getDomain() }
    }

    class BreakStmt = Go::BreakStmt;

    class ContinueStmt = Go::ContinueStmt;

    class GotoStmt = Go::GotoStmt;

    class ReturnStmt = Go::ReturnStmt;

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

      AstNode getPattern() { none() }

      AstNode getVariable() { none() }

      Expr getCondition() { none() }

      Stmt getBody() { none() }
    }

    class Switch extends AstNode instanceof Go::SwitchStmt {
      Expr getExpr() { result = this.(Go::SwitchStmt).getExpr() }

      Case getCase(int index) { result = this.(Go::SwitchStmt).getCase(index) }

      Stmt getStmt(int index) {
        // Go nests each case clause's body statements under the clause rather
        // than in a flat list, so we expose a flattened view in which every
        // case clause is immediately followed by its own body statements. This
        // lets the shared library compute the body of a case as the statements
        // between it and the next clause.
        result =
          rank[index + 1](Go::Stmt s, int caseIdx, int inner |
            switchFlatItem(this, s, caseIdx, inner)
          |
            s order by caseIdx, inner
          )
      }
    }

    class Case extends AstNode {
      Case() { this = any(Go::SwitchStmt sw).getACase() }

      AstNode getPattern(int index) { result = this.(Go::CaseClause).getExpr(index) }

      Expr getGuard() { none() }

      AstNode getBody() { none() }
    }

    class DefaultCase extends Case {
      DefaultCase() { not exists(this.(Go::CaseClause).getAnExpr()) }
    }

    AstNode getSwitchInit(Switch switch) { result = switch.(Go::SwitchStmt).getInit() }

    predicate fallsThrough(Case c) {
      // Go has no implicit fall-through between case clauses; an explicit
      // `fallthrough` statement is required.
      c.(Go::CaseClause).getStmt(max(int i | exists(c.(Go::CaseClause).getStmt(i)))) instanceof
        Go::FallthroughStmt
    }

    /**
     * Holds if `s` is the flattened body element at position (`caseIdx`,
     * `inner`) of switch `sw`: either the `caseIdx`-th case clause itself (with
     * `inner` = -1) or its `inner`-th body statement.
     */
    private predicate switchFlatItem(Go::SwitchStmt sw, Go::Stmt s, int caseIdx, int inner) {
      s = sw.getCase(caseIdx) and inner = -1
      or
      s = sw.getCase(caseIdx).getStmt(inner)
    }

    class ConditionalExpr extends Expr {
      ConditionalExpr() { none() }

      Expr getCondition() { none() }

      Expr getThen() { none() }

      Expr getElse() { none() }
    }

    class BinaryExpr = Go::BinaryExpr;

    // Constant short-circuiting operators are folded at compile time and their
    // operands are not evaluated at run time, so they are not treated as
    // logical operators here (which would give their operands their own
    // evaluation nodes via `getLeftOperand`/`getRightOperand`/`getOperand`,
    // bypassing `skipCfg`). Instead they are handled as constant-root leaf
    // value nodes (see `postOrInOrder`).
    class LogicalAndExpr extends Go::LandExpr {
      LogicalAndExpr() { not this.isConst() }
    }

    class LogicalOrExpr extends Go::LorExpr {
      LogicalOrExpr() { not this.isConst() }
    }

    class NullCoalescingExpr extends BinaryExpr {
      NullCoalescingExpr() { none() }
    }

    class UnaryExpr = Go::UnaryExpr;

    class LogicalNotExpr extends Go::NotExpr {
      LogicalNotExpr() { not this.isConst() }
    }

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

  /** Predicates shared by the two stages of Go CFG construction. */
  private module Input1 implements Cfg0::InputSig1 {
    predicate cfgCachedStageRef() { CfgCachedStage::ref() }

    class CallableContext = Void;

    class Label extends string {
      Label() { this = any(Go::LabeledStmt ls).getLabel() }

      string toString() { result = this }
    }

    predicate hasLabel(Ast::AstNode n, Label l) {
      // A statement carries the label of every `LabeledStmt` that wraps it.
      // This is recursive because Go allows stacked labels (`L1: L2: stmt`),
      // which the extractor represents as nested `LabeledStmt`s, so a single
      // statement may have several labels.
      exists(Go::LabeledStmt ls | n = ls.getStmt() | l = ls.getLabel() or hasLabel(ls, l))
      or
      // The `LabeledStmt` wrapper itself also carries its label. Blocks contain
      // the wrapper (not the inner statement) as a direct child, so the shared
      // library's block-level `goto` target resolution -- which looks for a
      // labelled statement that is a direct child of a block -- matches on the
      // wrapper.
      l = n.(Go::LabeledStmt).getLabel()
      or
      l = n.(Go::BreakStmt).getLabel()
      or
      l = n.(Go::ContinueStmt).getLabel()
      or
      // A `goto` statement carries its target label, so that the shared
      // library's `beginAbruptCompletion` produces a *labelled* goto completion
      // (matching the target label) rather than an unlabelled one.
      l = n.(Go::GotoStmt).getLabel()
    }

    predicate preOrderExpr(Ast::Expr e) {
      // The call of a `defer` statement is not invoked at the statement
      // itself; its callee expression and arguments are evaluated in place,
      // but the call is only invoked later, at function exit (modeled by the
      // `defer-invoke` node and `additionalSuccessor`). Marking it as
      // pre-order means no in-order "invocation" node (and hence no inline
      // exceptional-exit edge) is created at the `defer` statement.
      e = any(Go::DeferStmt s).getCall()
      or
      // Parenthesized expressions are value-transparent (via `propagatesValue`)
      // and should not get an in-order evaluation node. Marking them as
      // pre-order prevents the shared library from auto-computing
      // `postOrInOrder` for them (which would create an unreachable In node).
      e instanceof Go::ParenExpr
    }

    predicate propagatesValue(Ast::AstNode child, Ast::AstNode parent) {
      child = parent.(Go::ParenExpr).getExpr()
    }

    predicate postOrInOrder(Ast::AstNode n) {
      // Leaf value expressions: these have no CFG children, so the shared
      // library's default (which only makes expressions *with* children
      // post-order) would otherwise treat them as simple leaf nodes with no
      // in-order value node.
      n instanceof Go::ReferenceExpr
      or
      n instanceof Go::BasicLit
      or
      n instanceof Go::FuncLit
      or
      // An empty composite literal (e.g. `T{}`) has no CFG children, so it too
      // needs an explicit in-order (allocation) node.
      n instanceof Go::CompositeLit
      or
      // A constant expression is folded at compile time and its sub-expressions
      // are not evaluated (they are pruned by `skipCfg`), so the constant root
      // has no CFG children. It therefore needs an explicit in-order node to
      // remain a single value-producing leaf (e.g. `unsafe.Sizeof(test())`,
      // `1 << 10`, or `!d` for constant `d`).
      constantRoot(n)
      or
      // Statements/declarations that compute a value or perform an operation and
      // are not among the statements the shared library makes post-order by
      // default.
      n instanceof Go::DeferStmt
      or
      n instanceof Go::GoStmt
      or
      n instanceof Go::CompoundAssignStmt
      or
      n instanceof Go::IncDecStmt
      or
      n instanceof Go::SelectStmt
      or
      n instanceof Go::SendStmt
      or
      n instanceof Go::FuncDecl
    }

    predicate additionalNode(Ast::AstNode n, string tag, NormalSuccessor t) {
      t instanceof DirectSuccessor and
      (
        // Assignment write nodes: one per LHS
        exists(int i |
          (
            notBlankIdent(n.(Go::Assignment).getLhs(i)) and
            // A compound assignment (`x += y`) performs its write at its
            // post-order operation node rather than emitting a separate
            // `assign:i` write node (see
            // `IR::EvalCompoundAssignRhsInstruction`).
            not n instanceof Go::CompoundAssignStmt and
            // The `y := x.(type)` test statement of a type switch is transparent
            // (see `skipCfg`): the per-case implicit variables are written at the
            // case match nodes (see `IR::TypeSwitchImplicitVariableInstruction`),
            // so the guard itself emits no assignment write node.
            not n = any(Go::TypeSwitchStmt ts).getAssign() and
            // A tuple-destructuring assignment (`x, y = f()`) folds its per-target
            // write into the `extract` node (see `IR::ExtractWriteInstruction`).
            not extractNodeCondition(n, i)
            or
            // A `ValueSpec` without an initializer is written by its `zero-init`
            // node directly (see `IR::EvalImplicitInitInstruction`), and a
            // tuple-destructuring declaration (`var x, y = f()`) is written by its
            // `extract` node; only specs with a per-name initializer emit
            // `assign:i`.
            notBlankIdent(n.(Go::ValueSpec).getNameExpr(i)) and
            exists(n.(Go::ValueSpec).getAnInit()) and
            not extractNodeCondition(n, i)
          ) and
          tag = "assign:" + i.toString()
        )
        or
        // Get the next key-value pair produced by a `range` statement.
        n instanceof Go::RangeElementExpr and tag = "next"
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
        // Result-variable zero-initialization (on the function body). This single
        // node computes the zero value and writes it to the result variable (see
        // `IR::EvalImplicitInitInstruction`); it is the same kind of node as the
        // `zero-init` of an uninitialised local variable.
        exists(int i, Go::FuncDef fd |
          n = fd.getBody() and
          exists(fd.getBody()) and
          exists(fd.getResultVar(i)) and
          tag = "zero-init:" + i.toString()
        )
        or
        // Implicit deref
        implicitDerefCondition(n) and tag = "implicit-deref"
        or
        // Literal element initialization
        n = any(Go::CompositeLit lit).getAnElement() and
        tag = "lit-init"
        or
        // Implicit field selection for promoted fields
        exists(int i, Go::Field implicitField |
          implicitFieldSelection(n, i, implicitField) and
          tag = "implicit-field:" + i.toString()
        )
        or
        // Deferred-call invocation node, placed at function exit by `additionalSuccessor`
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
      exists(Go::RangeElementExpr p | s = p |
        exists(p.getKey()) and i = 0
        or
        exists(p.getValue()) and i = 1
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

    additional predicate beginAbruptCompletion(
      Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
    ) {
      ast instanceof Go::CallExpr and
      (
        not exists(ast.(Go::CallExpr).getTarget()) or
        ast.(Go::CallExpr).getTarget().mayPanic()
      ) and
      (n.isIn(ast) or n.isAdditional(ast, "defer-invoke")) and
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
      (n.isIn(ast) or n.isAdditional(ast, "defer-invoke")) and
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
    }

    additional predicate endAbruptCompletion(
      Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c
    ) {
      exists(Go::LabeledStmt lbl |
        ast = lbl.getStmt() and
        n.isAfter(lbl) and
        c.getSuccessorType() instanceof BreakSuccessor and
        c.hasLabel(lbl.getLabel())
      )
      or
      // A `break` in a communication clause body terminates the enclosing
      // `select` statement, continuing after it. This mirrors the shared
      // library's handling of `break` in a `switch` case body, but `select` is
      // modeled language-specifically (it is not a `Switch`), so the break
      // must be caught here. The break completion bubbles up the AST until it
      // reaches a top-level statement of the comm clause body, at which point
      // flow resumes after the `select`. An unlabeled `break` targets the
      // innermost enclosing construct; a labeled `break` only targets this
      // `select` if it (or a `LabeledStmt` wrapping it) carries that label.
      exists(Go::SelectStmt sel, Go::CommClause cc |
        cc = sel.getACommClause() and
        ast = cc.getStmt(_) and
        n.isAfter(sel) and
        c.getSuccessorType() instanceof BreakSuccessor
      |
        not c.hasLabel(_)
        or
        exists(Label l | c.hasLabel(l) and hasLabel(sel, l))
      )
      or
      exists(Go::FuncDef fd |
        ast = fd.getBody() and
        not funcHasDefer(fd) and
        c.getSuccessorType() instanceof ReturnSuccessor and
        // If the function has result variables, route the return completion
        // through the result-read epilogue before reaching the function exit.
        exists(fd.getResultVar(0)) and
        n.isAdditional(fd.getBody(), "result-read:0")
      )
      or
      // Function bodies are excluded from `Ast::BlockStmt`, so handle goto
      // targets among their top-level statements here.
      exists(Go::FuncDef fd, Go::Stmt target, Label l |
        ast = fd.getBody() and
        target = fd.getBody().getAStmt() and
        not target instanceof Go::GotoStmt and
        hasLabel(target, l) and
        n.isBefore(target) and
        c.getSuccessorType() instanceof GotoSuccessor and
        c.hasLabel(l)
      )
    }

    additional predicate overridesAbruptCompletionEdge(
      PreControlFlowNode source, PreControlFlowNode target, AbruptCompletion completion
    ) {
      completion.getSuccessorType() instanceof ReturnSuccessor and
      target instanceof NormalExitNodeImpl and
      exists(PreControlFlowNode replacement | additionalSuccessor(source, replacement, _))
      or
      completion.getSuccessorType() instanceof ExceptionSuccessor and
      target instanceof ExceptionalExitNodeImpl and
      exists(PreControlFlowNode nextDefer |
        additionalSuccessor(source, nextDefer, _) and deferInvoke(nextDefer, _)
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
     */
    private predicate deferRegistration(PreControlFlowNode n, Go::DeferStmt s) { n.isIn(s) }

    /**
     * Holds if `n` is the deferred-invocation node for `defer` statement `s`,
     * which models the deferred call running at function exit.
     */
    private predicate deferInvoke(PreControlFlowNode n, Go::DeferStmt s) {
      n.isAdditional(s.getCall(), "defer-invoke")
    }

    /** Holds if invoking deferred call `s` may return normally. */
    private predicate deferInvocationMayReturnNormally(Go::DeferStmt s) {
      not exists(Go::Function target | target = s.getCall().getTarget() |
        target.mustPanic() or target.mustNotReturnNormally()
      )
    }

    /** Holds if invoking deferred call `s` terminates without panic unwinding. */
    private predicate deferInvocationStopsUnwinding(Go::DeferStmt s) {
      exists(Go::Function target | target = s.getCall().getTarget() |
        target.mustNotReturnNormally() and not target.mustPanic()
      )
    }

    /**
     * Gets a defer-free successor of `n` that is not a `defer` registration
     * node. Walking this relation from a node stops at the next registration
     * node, which is how the reachability gate for deferred calls is computed.
     *
     * This is computed over the early CFG, before deferred-invocation edges are
     * added to the final CFG.
     */
    private PreControlFlowNode succBeforeNextDeferRegistration(PreControlFlowNode n) {
      earlySuccessor(n) = result and
      not deferRegistration(result, _)
    }

    /** Gets a successor of `n` in the early CFG, before deferred invocations are added. */
    private PreControlFlowNode earlySuccessor(PreControlFlowNode n) {
      exists(EarlyCfg2::ControlFlowNode early | early = n and result = early.getASuccessor())
    }

    /** Gets a node reachable from `start` over `succBeforeNextDeferRegistration`, reflexively. */
    private PreControlFlowNode reachableBeforeNextDeferRegistration(PreControlFlowNode start) {
      result = start
      or
      result = succBeforeNextDeferRegistration(reachableBeforeNextDeferRegistration(start))
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
    private predicate firstRegisteredDefer(Go::DeferStmt s, Go::FuncDef fd) {
      s.getEnclosingFunction() = fd and
      exists(PreControlFlowNode reg, PreControlFlowNode m |
        deferRegistration(reg, s) and
        m = reachableBeforeNextDeferRegistration(funcEntry(fd)) and
        earlySuccessor(m) = reg
      )
    }

    /**
     * Holds if the registration node of `laterRegistered` is the next registration
     * node reachable from the registration node of `earlierRegistered`. The later
     * registration therefore runs immediately before the earlier one (deferred calls
     * run in last-in-first-out order).
     */
    private predicate nextRegisteredDefer(
      Go::DeferStmt laterRegistered, Go::DeferStmt earlierRegistered
    ) {
      exists(
        PreControlFlowNode laterRegistration, PreControlFlowNode earlierRegistration,
        PreControlFlowNode m
      |
        deferRegistration(laterRegistration, laterRegistered) and
        deferRegistration(earlierRegistration, earlierRegistered) and
        m = reachableBeforeNextDeferRegistration(earlierRegistration) and
        earlySuccessor(m) = laterRegistration
      )
    }

    /**
     * Holds if `n` is a normal-exit predecessor of `fd`: a `return` statement
     * node, or the normal fall-through from the body's last statement.
     */
    private predicate normalExitPred(PreControlFlowNode n, Go::FuncDef fd) {
      exists(Go::ReturnStmt ret | ret.getEnclosingFunction() = fd and n.isIn(ret))
      or
      n.isAfter(getLastRankedChild(fd.getBody()))
    }

    /**
     * Holds if `n` is an exceptional-exit predecessor of `fd`: the in-order
     * node of an operation that may panic. In Go, deferred functions run on
     * panic, so these nodes must also enter the deferred-call chain. Other
     * nonreturning calls, such as `os.Exit`, do not run deferred functions.
     */
    private predicate exceptionalExitPred(PreControlFlowNode n, Go::FuncDef fd) {
      exists(Ast::AstNode ast, AbruptCompletion c |
        ast.getEnclosingFunction() = fd and
        n.isIn(ast) and
        beginAbruptCompletion(ast, n, c, false) and
        c.getSuccessorType() instanceof ExceptionSuccessor and
        not exists(Go::CallExpr call |
          ast = call and
          call.getTarget().mustNotReturnNormally() and
          not call.getTarget().mustPanic()
        )
      )
    }

    /**
     * Holds if, after running its deferred calls, `fd` should continue at
     * `target` on a normal exit. For functions with result variables this is
     * the start of the result-read epilogue; otherwise it is the function
     * body's `After` node.
     */
    private predicate deferChainExitTarget(Go::FuncDef fd, PreControlFlowNode target) {
      exists(fd.getResultVar(0)) and target.isAdditional(fd.getBody(), "result-read:0")
      or
      not exists(fd.getResultVar(_)) and target.isAfter(fd.getBody())
    }

    additional predicate additionalSuccessor(
      PreControlFlowNode n1, PreControlFlowNode n2, SuccessorType successorType
    ) {
      exists(Go::FuncDef fd | funcHasDefer(fd) |
        successorType instanceof DirectSuccessor and
        (
          // an exit predecessor with no active defer flows straight to the exit target
          normalExitPred(n1, fd) and
          n1 = reachableBeforeNextDeferRegistration(funcEntry(fd)) and
          deferChainExitTarget(fd, n2)
          or
          // an exit predecessor flows to the invocation of the last-registered active defer
          exists(Go::DeferStmt d, PreControlFlowNode reg |
            deferRegistration(reg, d) and
            d.getEnclosingFunction() = fd and
            normalExitPred(n1, fd) and
            n1 = reachableBeforeNextDeferRegistration(reg) and
            deferInvoke(n2, d)
          )
          or
          // deferred invocations chain in last-in-first-out order
          exists(Go::DeferStmt laterRegistered, Go::DeferStmt earlierRegistered |
            laterRegistered.getEnclosingFunction() = fd and
            nextRegisteredDefer(laterRegistered, earlierRegistered) and
            not deferInvocationStopsUnwinding(laterRegistered) and
            deferInvoke(n1, laterRegistered) and
            deferInvoke(n2, earlierRegistered)
          )
          or
          // the invocation of the first-registered (last to run) defer flows to the exit target
          exists(Go::DeferStmt firstD |
            firstRegisteredDefer(firstD, fd) and
            deferInvocationMayReturnNormally(firstD) and
            deferInvoke(n1, firstD) and
            deferChainExitTarget(fd, n2)
          )
        )
        or
        // a possible panic with active defers flows to the last-registered active defer
        successorType instanceof ExceptionSuccessor and
        exists(Go::DeferStmt d, PreControlFlowNode reg |
          deferRegistration(reg, d) and
          d.getEnclosingFunction() = fd and
          exceptionalExitPred(n1, fd) and
          n1 = reachableBeforeNextDeferRegistration(reg) and
          deferInvoke(n2, d)
        )
      )
    }

    additional predicate overridesDefaultControlFlow(Ast::AstNode ast) {
      exists(Go::SelectStmt sel, Go::RecvStmt recv |
        recv = sel.getACommClause().getComm() and
        (ast = recv or ast = recv.getExpr())
      )
      or
      exists(Go::SelectStmt sel, Go::SendStmt send |
        send = sel.getACommClause().getComm() and ast = send
      )
    }

    additional predicate preservesDefaultControlFlow(Ast::AstNode ast) {
      ast = any(Go::FuncDef fd | hasFuncDefPrologue(fd)).getBody()
      or
      exists(getFirstEpilogueTag(ast))
    }

    additional predicate overridesDefaultControlFlowStep(
      Ast::AstNode ast, PreControlFlowNode source, PreControlFlowNode target
    ) {
      ast = any(Go::FuncDef fd | hasFuncDefPrologue(fd)).getBody() and source.isBefore(ast)
      or
      ast = any(Go::FuncDef fd | funcHasDefer(fd)).getBody() and
      source.isAfter(getLastRankedChild(ast)) and
      target.isAfter(ast)
      or
      exists(getFirstEpilogueTag(ast)) and
      (
        source.isAfter(getLastRankedChild(ast))
        or
        not exists(getRankedChild(ast, _)) and source.isBefore(ast)
      ) and
      (target.isIn(ast) or target.isAfter(ast))
    }

    additional predicate step(PreControlFlowNode n1, PreControlFlowNode n2) {
      rangeStmtStep(n1, n2) or
      selectStmtStep(n1, n2) or
      assignmentStep(n1, n2) or
      returnStep(n1, n2) or
      callExprStep(n1, n2) or
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
      result = rank[rnk](Ast::AstNode c, int ix | c = Ast::getChild(parent, ix) | c order by ix)
    }

    /** Gets the last non-skipped child of `parent`, or fails if none. */
    private Ast::AstNode getLastRankedChild(Ast::AstNode parent) {
      exists(int i |
        result = getRankedChild(parent, i) and
        not exists(getRankedChild(parent, i + 1))
      )
    }

    /** Routes between consecutive epilogue nodes of `parent`. */
    private predicate epilogueSequenceStep(
      Ast::AstNode parent, PreControlFlowNode n1, PreControlFlowNode n2
    ) {
      exists(string tag1, string tag2 |
        epilogueTagSucc(parent, tag1, tag2) and
        n1.isAdditional(parent, tag1) and
        n2.isAdditional(parent, tag2)
      )
    }

    /** Routes into and between the epilogue nodes of `parent`. */
    private predicate epilogueStep(Ast::AstNode parent, PreControlFlowNode n1, PreControlFlowNode n2) {
      n1.isAfter(getLastRankedChild(parent)) and
      n2.isAdditional(parent, getFirstEpilogueTag(parent))
      or
      not exists(getRankedChild(parent, _)) and
      n1.isBefore(parent) and
      n2.isAdditional(parent, getFirstEpilogueTag(parent))
      or
      epilogueSequenceStep(parent, n1, n2)
    }

    /**
     * Assignment flow: routes through LHS/RHS children, then through
     * additional nodes for extract, zero-init, and assign operations.
     */
    private predicate assignmentStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Ast::AstNode assgn |
        assgn instanceof Go::Assignment and
        not assgn instanceof Go::RecvStmt and
        // The `y := x.(type)` test statement of a type switch is transparent
        // (see `skipCfg`); the shared switch model evaluates the underlying
        // type-assertion expression directly, so this statement has no
        // assignment flow of its own.
        not assgn = any(Go::TypeSwitchStmt ts).getAssign()
        or
        assgn instanceof Go::ValueSpec
      |
        epilogueStep(assgn, n1, n2)
        or
        n1.isAdditional(assgn, getLastEpilogueTag(assgn)) and
        n2.isAfter(assgn)
      )
    }

    /** Gets a tuple-extraction epilogue tag and its order. */
    private string getExtractionEpilogueTag(Ast::AstNode node, int ord) {
      exists(int i |
        extractNodeCondition(node, i) and
        result = "extract:" + i.toString() and
        ord = 2 * i
      )
    }

    /** Gets an assignment epilogue tag and its order. */
    private string getAssignmentEpilogueTag(Ast::AstNode assgn, int ord) {
      exists(int j |
        (
          exists(Go::ValueSpec spec |
            assgn = spec and
            not exists(spec.getAnInit()) and
            exists(spec.getNameExpr(j)) and
            result = "zero-init:" + j.toString() and
            ord = 2 * j
          )
          or
          (
            notBlankIdent(assgn.(Go::Assignment).getLhs(j)) and
            // Compound assignments perform their write at their post-order
            // operation node, so they emit no separate `assign:j` node.
            not assgn instanceof Go::CompoundAssignStmt and
            // Tuple-destructuring targets are written by their `extract` node.
            not extractNodeCondition(assgn, j)
            or
            // A `ValueSpec` without an initializer is written by its `zero-init`
            // node directly, and a tuple-destructuring declaration by its
            // `extract` node, so only specs with a per-name initializer emit
            // `assign:j`.
            notBlankIdent(assgn.(Go::ValueSpec).getNameExpr(j)) and
            exists(assgn.(Go::ValueSpec).getAnInit()) and
            not extractNodeCondition(assgn, j)
          ) and
          result = "assign:" + j.toString() and
          ord = 2 * j + 1
        )
      )
    }

    /** Gets a result-write epilogue tag and its order. */
    private string getResultWriteEpilogueTag(Ast::AstNode node, int ord) {
      exists(int i, Go::ReturnStmt ret, Go::ResultVariable rv |
        node = ret and
        ret.getEnclosingFunction().getResultVar(i) = rv and
        exists(ret.getAnExpr()) and
        result = "result-write:" + i.toString() and
        ord = 2 * i + 1
      )
    }

    /** Gets an epilogue tag and its order. */
    private string getEpilogueTag(Ast::AstNode node, int ord) {
      result = getExtractionEpilogueTag(node, ord)
      or
      result = getAssignmentEpilogueTag(node, ord)
      or
      result = getResultWriteEpilogueTag(node, ord)
    }

    private string getRankedEpilogueTag(Ast::AstNode node, int rnk) {
      result = rank[rnk](string tag, int ord | tag = getEpilogueTag(node, ord) | tag order by ord)
    }

    private string getFirstEpilogueTag(Ast::AstNode node) { result = getRankedEpilogueTag(node, 1) }

    private string getLastEpilogueTag(Ast::AstNode node) {
      exists(int i |
        result = getRankedEpilogueTag(node, i) and
        not exists(getRankedEpilogueTag(node, i + 1))
      )
    }

    private predicate epilogueTagSucc(Ast::AstNode node, string tag1, string tag2) {
      exists(int i |
        tag1 = getRankedEpilogueTag(node, i) and
        tag2 = getRankedEpilogueTag(node, i + 1)
      )
    }

    /**
     * Return statement: evaluate expressions, extract tuples, write results,
     * then the return node.
     */
    private predicate returnStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::ReturnStmt ret |
        epilogueStep(ret, n1, n2)
        or
        n1.isAdditional(ret, getLastEpilogueTag(ret)) and
        n2.isIn(ret)
      )
    }

    /**
     * Call with spread arguments, e.g. `f(g())` where the inner call `g`
     * returns multiple results that are passed as the arguments of the outer
     * call `f`: evaluate the function expression and argument call, extract
     * each tuple element of the argument's result, then invoke the outer call.
     *
     * The tuple-extraction nodes are additional nodes (see
     * `extractNodeCondition`); without wiring them into the control flow they
     * would be unreachable and pruned, breaking data flow through `f(g())`.
     */
    private predicate callExprStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::CallExpr call |
        // Restrict to ordinary invoked calls; the calls of `defer`/`go`
        // statements do not use this tuple-extraction override.
        not call = any(Go::DeferStmt s).getCall() and
        not call = any(Go::GoStmt s).getCall() and
        extractNodeCondition(call, _)
      |
        epilogueStep(call, n1, n2)
        or
        n1.isAdditional(call, getLastEpilogueTag(call)) and n2.isIn(call)
        or
        n1.isIn(call) and
        n2.isAfter(call) and
        not beginAbruptCompletion(call, n1, _, true)
      )
    }

    /**
     * Index expression: base -> implicit-deref? -> index -> In(indexExpr)
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
     * Gets the bound expression of slice `se` at position `r` (`0` = low,
     * `1` = high, `2` = max), if it is present.
     */
    private Go::Expr sliceBoundExpr(Go::SliceExpr se, int r) {
      r = 0 and result = se.getLow()
      or
      r = 1 and result = se.getHigh()
      or
      r = 2 and result = se.getMax()
    }

    /**
     * Holds if, having finished evaluating the slice component at position `p`
     * (`-1` = base, `0` = low, `1` = high, `2` = max), `n2` is the control-flow
     * node to execute next: the next present bound in `low, high, max` order, or
     * the slice evaluation node `In(se)` if no further bound is present.
     *
     * Implicit (omitted) bounds have no control-flow node of their own, so
     * control simply skips over them.
     */
    bindingset[p]
    private predicate sliceNext(Go::SliceExpr se, int p, PreControlFlowNode n2) {
      exists(int q | q = min(int r | r > p and exists(sliceBoundExpr(se, r)) | r) |
        n2.isBefore(sliceBoundExpr(se, q))
      )
      or
      not exists(int r | r > p and exists(sliceBoundExpr(se, r))) and
      n2.isIn(se)
    }

    /**
     * Slice expression: base -> implicit-deref? -> low? -> high? -> max? -> In(sliceExpr).
     *
     * Missing (implicit) bounds have no control-flow node of their own; the
     * implicit lower bound of `0` is modeled as a constant on the
     * `SliceInstruction` rather than as a separate node.
     */
    private predicate sliceExprStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::SliceExpr se |
        n1.isBefore(se) and n2.isBefore(se.getBase())
        or
        n1.isAfter(se.getBase()) and
        (
          if implicitDerefCondition(se.getBase())
          then n2.isAdditional(se.getBase(), "implicit-deref")
          else sliceNext(se, -1, n2)
        )
        or
        n1.isAdditional(se.getBase(), "implicit-deref") and sliceNext(se, -1, n2)
        or
        n1.isAfter(se.getLow()) and sliceNext(se, 0, n2)
        or
        n1.isAfter(se.getHigh()) and sliceNext(se, 1, n2)
        or
        n1.isAfter(se.getMax()) and sliceNext(se, 2, n2)
        or
        n1.isIn(se) and n2.isAfter(se)
      )
    }

    /**
     * Selector expression with value base: base -> implicit-deref? ->
     * implicit-field-selections -> In(selector)
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
          n1.isAfter(sel.getBase()) and
          implicitDerefCondition(sel.getBase()) and
          n2.isAdditional(sel.getBase(), "implicit-deref")
          or
          n1.isAdditional(sel.getBase(), "implicit-deref") and
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
          exists(int i |
            i > 1 and
            implicitFieldSelection(sel, i, _) and
            implicitFieldSelection(sel, i - 1, _) and
            n1.isAdditional(sel, "implicit-field:" + i.toString()) and
            n2.isAdditional(sel, "implicit-field:" + (i - 1).toString())
          )
          or
          implicitFieldSelection(sel, 1, _) and
          n1.isAdditional(sel, "implicit-field:1") and
          n2.isIn(sel)
          or
          n1.isIn(sel) and n2.isAfter(sel)
        )
      )
    }

    /**
     * Composite literal: In(lit) -> element-init chain -> After(lit)
     * CompositeLit evaluates the literal (allocation) first (pre-order),
     * then initializes elements.
     */
    private predicate compositeLitStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::CompositeLit lit |
        n1.isBefore(lit) and n2.isIn(lit)
        or
        n1.isIn(lit) and
        (
          n2.isBefore(lit.getElement(0))
          or
          not exists(lit.getElement(_)) and n2.isAfter(lit)
        )
        or
        // Positional array/slice elements have an implicit index that is
        // modeled on the `lit-init` instruction itself (see
        // `IR::InitLiteralElementInstruction`) rather than as a separate node.
        exists(int i |
          n1.isAfter(lit.getElement(i)) and
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
     * Send statement (outside select): channel -> value -> In(send)
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

    private predicate rangeStmtStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::RangeElementExpr p |
        // The shared `ForeachStmt` model owns the loop skeleton (testing the
        // domain for emptiness, the `[LoopHeader]` join/branch point, and the
        // loop exit) and routes control flow into `Before(p)` and out of
        // `After(p)`, where `p` is the synthesized "range element" loop
        // variable. Here we get the next key-value pair and destructure it into
        // the key/value variables using the shared extract/assign epilogue
        // machinery.
        n1.isBefore(p) and n2.isAdditional(p, "next")
        or
        n1.isAdditional(p, "next") and
        (
          exists(getFirstEpilogueTag(p)) and
          n2.isAdditional(p, getFirstEpilogueTag(p))
          or
          not exists(getFirstEpilogueTag(p)) and n2.isAfter(p)
        )
        or
        epilogueSequenceStep(p, n1, n2)
        or
        n1.isAdditional(p, getLastEpilogueTag(p)) and n2.isAfter(p)
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

    /**
     * Holds if there is a control-flow step from `n1` to `n2` for the
     * communication operation of a comm clause of `sel` that has been selected.
     *
     * The channel operands (and, for a send, the value) of every clause are
     * evaluated up front in the prep phase (see `selectCommPrepStart` and
     * friends), and the `select` then non-deterministically dispatches to one
     * clause via `In(sel) -> Before(cc)`. The communication node itself
     * (`In(recv.getExpr())` for a receive, `In(send)` for a send) is therefore
     * only reached through that dispatch, never by ordinary left-to-right
     * evaluation of the clause.
     *
     * Default sequencing for the communication statements is suppressed by
     * `overridesDefaultControlFlow` above, so the communication can only be
     * reached through the select dispatch.
     */
    private predicate selectedCommStep(
      Go::SelectStmt sel, PreControlFlowNode n1, PreControlFlowNode n2
    ) {
      exists(Go::SendStmt send | send = sel.getACommClause().getComm() |
        // The send communication happens at `In(send)`; flow then continues to
        // the clause body via `selectStmtStep`.
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
          n1.isAfter(recv.getLhs(last)) and
          n2.isAdditional(recv, getFirstEpilogueTag(recv))
        )
        or
        exists(int last | exists(recv.getLhs(last)) and not exists(recv.getLhs(last + 1)) |
          not exists(getFirstEpilogueTag(recv)) and
          n1.isAfter(recv.getLhs(last)) and
          commClauseBodyStart(sel, cc, n2)
        )
        or
        epilogueSequenceStep(recv, n1, n2)
        or
        n1.isAdditional(recv, getLastEpilogueTag(recv)) and
        commClauseBodyStart(sel, cc, n2)
      )
    }

    private predicate selectStmtStep(PreControlFlowNode n1, PreControlFlowNode n2) {
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

    private predicate hasFuncDefPrologue(Go::FuncDef fd) { exists(fd.getResultVar(_)) }

    private predicate funcDefBodyStart(Go::FuncDef fd, PreControlFlowNode n) {
      n.isBefore(getRankedChild(fd.getBody(), 1))
      or
      not exists(getRankedChild(fd.getBody(), _)) and
      n.isAdditional(fd.getBody(), "result-read:0")
    }

    /**
     * Function body flow for named result variables: `Before(body)` ->
     * `zero-init:0` -> ... -> first statement -> ... -> `result-read:0` -> ...
     * -> `After(body)`. Parameters precede `Before(body)` through the shared
     * callable flow. Return and defer handling route into the result-read
     * sequence separately; this predicate sequences its nodes and routes
     * defer-free fall-through into it.
     */
    private predicate funcDefStep(PreControlFlowNode n1, PreControlFlowNode n2) {
      exists(Go::FuncDef fd | exists(fd.getBody()) |
        n1.isBefore(fd.getBody()) and
        exists(fd.getResultVar(0)) and
        n2.isAdditional(fd.getBody(), "zero-init:0")
        or
        exists(int j | exists(fd.getResultVar(j)) |
          n1.isAdditional(fd.getBody(), "zero-init:" + j.toString()) and
          (
            exists(fd.getResultVar(j + 1)) and
            n2.isAdditional(fd.getBody(), "zero-init:" + (j + 1).toString())
            or
            not exists(fd.getResultVar(j + 1)) and
            funcDefBodyStart(fd, n2)
          )
        )
        or
        exists(int j | exists(fd.getResultVar(j + 1)) |
          n1.isAdditional(fd.getBody(), "result-read:" + j.toString()) and
          n2.isAdditional(fd.getBody(), "result-read:" + (j + 1).toString())
        )
        or
        not funcHasDefer(fd) and
        exists(fd.getResultVar(0)) and
        n1.isAfter(getLastRankedChild(fd.getBody())) and
        n2.isAdditional(fd.getBody(), "result-read:0")
        or
        exists(int j |
          exists(fd.getResultVar(j)) and
          not exists(fd.getResultVar(j + 1)) and
          n1.isAdditional(fd.getBody(), "result-read:" + j.toString()) and
          n2.isAfter(fd.getBody())
        )
      )
    }
  }

  /** Builds the CFG used to determine which `defer` statements have been registered. */
  private module EarlyInput2 implements Cfg1::InputSig2 {
    predicate beginAbruptCompletion(
      Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
    ) {
      Input1::beginAbruptCompletion(ast, n, c, always)
    }

    predicate endAbruptCompletion(Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c) {
      Input1::endAbruptCompletion(ast, n, c)
      or
      exists(Go::FuncDef fd |
        ast = fd.getBody() and
        c.getSuccessorType() instanceof ReturnSuccessor and
        exists(fd.getResultVar(0)) and
        n.isAdditional(fd.getBody(), "result-read:0")
      )
    }

    predicate overridesDefaultControlFlow(Ast::AstNode ast) {
      Input1::overridesDefaultControlFlow(ast)
    }

    predicate preservesDefaultControlFlow(Ast::AstNode ast) {
      Input1::preservesDefaultControlFlow(ast)
    }

    predicate overridesDefaultControlFlowStep(
      Ast::AstNode ast, PreControlFlowNode source, PreControlFlowNode target
    ) {
      Input1::overridesDefaultControlFlowStep(ast, source, target)
    }

    predicate step(PreControlFlowNode n1, PreControlFlowNode n2) { Input1::step(n1, n2) }
  }

  /** Builds the final Go CFG, including deferred invocations. */
  private module FinalInput2 implements Cfg1::InputSig2 {
    predicate beginAbruptCompletion(
      Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c, boolean always
    ) {
      Input1::beginAbruptCompletion(ast, n, c, always)
    }

    predicate endAbruptCompletion(Ast::AstNode ast, PreControlFlowNode n, AbruptCompletion c) {
      Input1::endAbruptCompletion(ast, n, c)
    }

    predicate overridesAbruptCompletionEdge(
      PreControlFlowNode source, PreControlFlowNode target, AbruptCompletion completion
    ) {
      Input1::overridesAbruptCompletionEdge(source, target, completion)
    }

    predicate additionalSuccessor(
      PreControlFlowNode n1, PreControlFlowNode n2, SuccessorType successorType
    ) {
      Input1::additionalSuccessor(n1, n2, successorType)
    }

    predicate overridesDefaultControlFlow(Ast::AstNode ast) {
      Input1::overridesDefaultControlFlow(ast)
    }

    predicate preservesDefaultControlFlow(Ast::AstNode ast) {
      Input1::preservesDefaultControlFlow(ast)
    }

    predicate overridesDefaultControlFlowStep(
      Ast::AstNode ast, PreControlFlowNode source, PreControlFlowNode target
    ) {
      Input1::overridesDefaultControlFlowStep(ast, source, target)
    }

    predicate step(PreControlFlowNode n1, PreControlFlowNode n2) { Input1::step(n1, n2) }
  }
}
