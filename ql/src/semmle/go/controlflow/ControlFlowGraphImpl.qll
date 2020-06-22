/**
 * INTERNAL: Analyses should use module `ControlFlowGraph` instead.
 *
 * Provides predicates for building intra-procedural CFGs.
 */

import go

/** A block statement that is not the body of a `switch` or `select` statement. */
class PlainBlock extends BlockStmt {
  PlainBlock() {
    not this = any(SwitchStmt sw).getBody() and not this = any(SelectStmt sel).getBody()
  }
}

private predicate notBlankIdent(Expr e) { not e instanceof BlankIdent }

private predicate pureLvalue(ReferenceExpr e) { not e.isRvalue() }

private predicate isCondRoot(Expr e) {
  e = any(LogicalBinaryExpr lbe).getLeftOperand()
  or
  e = any(ForStmt fs).getCond()
  or
  e = any(IfStmt is).getCond()
  or
  e = any(ExpressionSwitchStmt ess | not exists(ess.getExpr())).getACase().getAnExpr()
}

private predicate isCond(Expr e) {
  isCondRoot(e) or
  e = any(LogicalBinaryExpr lbe | isCond(lbe)).getRightOperand() or
  e = any(ParenExpr par | isCond(par)).getExpr()
}

/**
 * A node in the intra-procedural control-flow graph of a Go function or file.
 *
 * There are two kinds of control-flow nodes:
 *
 *   1. Instructions: these are nodes that correspond to expressions and statements
 *      that compute a value or perform an operation (as opposed to providing syntactic
 *      structure or type information).
 *   2. Synthetic nodes:
 *      - Entry and exit nodes for each Go function and file that mark the beginning and the end,
 *        respectively, of the execution of the function and the loading of the file;
 *      - Skip nodes that are semantic no-ops, but make CFG construction easier.
 */
newtype TControlFlowNode =
  /**
   * A control-flow node that represents the evaluation of an expression.
   */
  MkExprNode(Expr e) { CFG::hasSemantics(e) } or
  /**
   * A control-flow node that represents the initialization of an element of a composite literal.
   */
  MkLiteralElementInitNode(Expr e) { e = any(CompositeLit lit).getAnElement() } or
  /**
   * A control-flow node that represents the implicit index of an element in a slice or array literal.
   */
  MkImplicitLiteralElementIndex(Expr e) {
    exists(CompositeLit lit | not lit instanceof StructLit |
      e = lit.getAnElement() and
      not e instanceof KeyValueExpr
    )
  } or
  /**
   * A control-flow node that represents a (single) assignment.
   *
   * Assignments with multiple left-hand sides are split up into multiple assignment nodes,
   * one for each left-hand side. Assignments to `_` are not represented in the control-flow graph.
   */
  MkAssignNode(AstNode assgn, int i) {
    // the `i`th assignment in a (possibly multi-)assignment
    notBlankIdent(assgn.(Assignment).getLhs(i))
    or
    // the `i`th name declared in a (possibly multi-)declaration specifier
    notBlankIdent(assgn.(ValueSpec).getNameExpr(i))
    or
    // the assignment to the "key" variable in a `range` statement
    notBlankIdent(assgn.(RangeStmt).getKey()) and i = 0
    or
    // the assignment to the "value" variable in a `range` statement
    notBlankIdent(assgn.(RangeStmt).getValue()) and i = 1
  } or
  /**
   * A control-flow node that represents the implicit right-hand side of a compound assignment.
   *
   * For example, the compound assignment `x += 1` has an implicit right-hand side `x + 1`.
   */
  MkCompoundAssignRhsNode(CompoundAssignStmt assgn) or
  /**
   * A control-flow node that represents the `i`th component of a tuple expression `base`.
   */
  MkExtractNode(AstNode s, int i) {
    // in an assignment `x, y, z = tuple`
    exists(Assignment assgn |
      s = assgn and
      exists(assgn.getRhs()) and
      assgn.getNumLhs() > 1 and
      exists(assgn.getLhs(i))
    )
    or
    // in a declaration `var x, y, z = tuple`
    exists(ValueSpec spec |
      s = spec and
      exists(spec.getInit()) and
      spec.getNumName() > 1 and
      exists(spec.getNameExpr(i))
    )
    or
    // in a `range` statement
    exists(RangeStmt rs | s = rs |
      exists(rs.getKey()) and i = 0
      or
      exists(rs.getValue()) and i = 1
    )
    or
    // in a return statement `return f()` where `f` has multiple return values
    exists(ReturnStmt ret, SignatureType rettp |
      s = ret and
      // the return statement has a single expression
      exists(ret.getExpr()) and
      // but the enclosing function has multiple results
      rettp = ret.getEnclosingFunction().getType() and
      rettp.getNumResult() > 1 and
      exists(rettp.getResultType(i))
    )
    or
    // in a call `f(g())` where `g` has multiple return values
    exists(CallExpr outer, CallExpr inner | s = outer |
      inner = outer.getArgument(0).stripParens() and
      outer.getNumArgument() = 1 and
      exists(inner.getType().(TupleType).getComponentType(i))
    )
  } or
  /**
   * A control-flow node that represents the zero value to which a variable without an initializer
   * expression is initialized.
   */
  MkZeroInitNode(ValueEntity v) {
    exists(ValueSpec spec, int i |
      not exists(spec.getAnInit()) and
      spec.getNameExpr(i) = v.getDeclaration()
    )
    or
    exists(v.(ResultVariable).getFunction().getBody())
  } or
  /**
   * A control-flow node that represents a function declaration.
   */
  MkFuncDeclNode(FuncDecl fd) or
  /**
   * A control-flow node that represents a `defer` statement.
   */
  MkDeferNode(DeferStmt def) or
  /**
   * A control-flow node that represents a `go` statement.
   */
  MkGoNode(GoStmt go) or
  /**
   * A control-flow node that represents the fact that `e` is known to evaluate to
   * `outcome`.
   */
  MkConditionGuardNode(Expr e, Boolean outcome) { isCondRoot(e) } or
  /**
   * A control-flow node that represents an increment or decrement statement.
   */
  MkIncDecNode(IncDecStmt ids) or
  /**
   * A control-flow node that represents the implicit right-hand side of an increment or decrement statement.
   */
  MkIncDecRhs(IncDecStmt ids) or
  /**
   * A control-flow node that represents the implicit operand 1 of an increment or decrement statement.
   */
  MkImplicitOne(IncDecStmt ids) or
  /**
   * A control-flow node that represents a return from a function.
   */
  MkReturnNode(ReturnStmt ret) or
  /**
   * A control-flow node that represents the implicit write to a named result variable in a return statement.
   */
  MkResultWriteNode(ResultVariable var, int i, ReturnStmt ret) {
    ret.getEnclosingFunction().getResultVar(i) = var and
    exists(ret.getAnExpr())
  } or
  /**
   * A control-flow node that represents the implicit read of a named result variable upon returning from
   * a function (after any deferred calls have been executed).
   */
  MkResultReadNode(ResultVariable var) or
  /**
   * A control-flow node that represents a no-op.
   *
   * These control-flow nodes correspond to Go statements that have no runtime semantics other than potentially
   * influencing control flow: the branching statements `continue`, `break`, `fallthrough` and `goto`; empty
   * blocks; empty statements; and import and type declarations.
   */
  MkSkipNode(AstNode skip) {
    skip instanceof BranchStmt
    or
    skip instanceof EmptyStmt
    or
    skip.(PlainBlock).getNumStmt() = 0
    or
    skip instanceof ImportDecl
    or
    skip instanceof TypeDecl
    or
    pureLvalue(skip)
    or
    skip.(CaseClause).getNumStmt() = 0
    or
    skip.(CommClause).getNumStmt() = 0
  } or
  /**
   * A control-flow node that represents a `select` operation.
   */
  MkSelectNode(SelectStmt sel) or
  /**
   * A control-flow node that represents a `send` operation.
   */
  MkSendNode(SendStmt send) or
  /**
   * A control-flow node that represents the initialization of a parameter to its corresponding argument.
   */
  MkParameterInit(Parameter parm) { exists(parm.getFunction().getBody()) } or
  /**
   * A control-flow node that represents the argument corresponding to a parameter.
   */
  MkArgumentNode(Parameter parm) { exists(parm.getFunction().getBody()) } or
  /**
   * A control-flow node that represents the initialization of a result variable to its zero value.
   */
  MkResultInit(ResultVariable rv) { exists(rv.getFunction().getBody()) } or
  /**
   * A control-flow node that represents the operation of retrieving the next (key, value) pair in a
   * `range` statement, if any.
   */
  MkNextNode(RangeStmt rs) or
  /**
   * A control-flow node that represents the implicit `true` expression in `switch { ... }`.
   */
  MkImplicitTrue(ExpressionSwitchStmt stmt) { not exists(stmt.getExpr()) } or
  /**
   * A control-flow node that represents the implicit comparison or type check performed by
   * the `i`th expression of a case clause `cc`.
   */
  MkCaseCheckNode(CaseClause cc, int i) { exists(cc.getExpr(i)) } or
  /**
   * A control-flow node that represents the implicit lower bound of a slice expression.
   */
  MkImplicitLowerSliceBound(SliceExpr sl) { not exists(sl.getLow()) } or
  /**
   * A control-flow node that represents the implicit upper bound of a simple slice expression.
   */
  MkImplicitUpperSliceBound(SliceExpr sl) { not exists(sl.getHigh()) } or
  /**
   * A control-flow node that represents the implicit max bound of a simple slice expression.
   */
  MkImplicitMaxSliceBound(SliceExpr sl) { not exists(sl.getMax()) } or
  /**
   * A control-flow node that represents the implicit dereference of the base in a field/method
   * access, element access, or slice expression.
   */
  MkImplicitDeref(Expr e) {
    e.getType().getUnderlyingType() instanceof PointerType and
    (
      exists(SelectorExpr sel | e = sel.getBase() |
        // field accesses through a pointer always implicitly dereference
        sel = any(Field f).getAReference()
        or
        // method accesses only dereference if the receiver is _not_ a pointer
        exists(Method m, Type tp |
          sel = m.getAReference() and
          tp = m.getReceiver().getType().getUnderlyingType() and
          not tp instanceof PointerType
        )
      )
      or
      e = any(IndexExpr ie).getBase()
      or
      e = any(SliceExpr se).getBase()
    )
  } or
  /**
   * A control-flow node that represents the start of the execution of a function or file.
   */
  MkEntryNode(ControlFlow::Root root) or
  /**
   * A control-flow node that represents the end of the execution of a function or file.
   */
  MkExitNode(ControlFlow::Root root)

/** A representation of the target of a write. */
newtype TWriteTarget =
  /** A write target that is represented explicitly in the AST. */
  MkLhs(TControlFlowNode write, Expr lhs) {
    exists(AstNode assgn, int i | write = MkAssignNode(assgn, i) |
      lhs = assgn.(Assignment).getLhs(i).stripParens()
      or
      lhs = assgn.(ValueSpec).getNameExpr(i)
      or
      exists(RangeStmt rs | rs = assgn |
        i = 0 and lhs = rs.getKey().stripParens()
        or
        i = 1 and lhs = rs.getValue().stripParens()
      )
    )
    or
    exists(IncDecStmt ids | write = MkIncDecNode(ids) | lhs = ids.getOperand().stripParens())
    or
    exists(Parameter parm | write = MkParameterInit(parm) | lhs = parm.getDeclaration())
    or
    exists(ResultVariable res | write = MkResultInit(res) | lhs = res.getDeclaration())
  } or
  /** A write target for an element in a compound literal, viewed as a field write. */
  MkLiteralElementTarget(MkLiteralElementInitNode elt) or
  /** A write target for a returned expression, viewed as a write to the corresponding result variable. */
  MkResultWriteTarget(MkResultWriteNode w)

/**
 * A control-flow node that represents a no-op.
 *
 * These control-flow nodes correspond to Go statements that have no runtime semantics other than
 * potentially influencing control flow: the branching statements `continue`, `break`,
 * `fallthrough` and `goto`; empty blocks; empty statements; and import and type declarations.
 */
class SkipNode extends ControlFlow::Node, MkSkipNode {
  AstNode skip;

  SkipNode() { this = MkSkipNode(skip) }

  override ControlFlow::Root getRoot() { result.isRootOf(skip) }

  override string toString() { result = "skip" }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    skip.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * A control-flow node that represents the start of the execution of a function or file.
 */
class EntryNode extends ControlFlow::Node, MkEntryNode {
  ControlFlow::Root root;

  EntryNode() { this = MkEntryNode(root) }

  override ControlFlow::Root getRoot() { result = root }

  override string toString() { result = "entry" }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    root.hasLocationInfo(filepath, startline, startcolumn, _, _) and
    endline = startline and
    endcolumn = startcolumn
  }
}

/**
 * A control-flow node that represents the end of the execution of a function or file.
 */
class ExitNode extends ControlFlow::Node, MkExitNode {
  ControlFlow::Root root;

  ExitNode() { this = MkExitNode(root) }

  override ControlFlow::Root getRoot() { result = root }

  override string toString() { result = "exit" }

  override predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    root.hasLocationInfo(filepath, _, _, endline, endcolumn) and
    endline = startline and
    endcolumn = startcolumn
  }
}

/**
 * Provides classes and predicates for computing the control-flow graph.
 */
cached
module CFG {
  /**
   * The target of a branch statement, which is either the label of a labeled statement or
   * the special target `""` referring to the innermost enclosing loop or `switch`.
   */
  private class BranchTarget extends string {
    BranchTarget() { this = any(LabeledStmt ls).getLabel() or this = "" }
  }

  private module BranchTarget {
    /** Holds if this is the target of branch statement `stmt` or the label of compound statement `stmt`. */
    BranchTarget of(Stmt stmt) {
      exists(BranchStmt bs | bs = stmt |
        result = bs.getLabel()
        or
        not exists(bs.getLabel()) and result = ""
      )
      or
      exists(LabeledStmt ls | stmt = ls.getStmt() | result = ls.getLabel())
      or
      (stmt instanceof LoopStmt or stmt instanceof SwitchStmt or stmt instanceof SelectStmt) and
      result = ""
    }
  }

  private newtype TCompletion =
    /** A completion indicating that an expression or statement was evaluated successfully. */
    Done() or
    /**
     * A completion indicating that an expression was successfully evaluated to Boolean value `b`.
     *
     * Note that many Boolean expressions are modelled as having completion `Done()` instead.
     * Completion `Bool` is only used in contexts where the Boolean value can be determined.
     */
    Bool(boolean b) { b = true or b = false } or
    /**
     * A completion indicating that execution of a (compound) statement ended with a `break`
     * statement targeting the given label.
     */
    Break(BranchTarget lbl) or
    /**
     * A completion indicating that execution of a (compound) statement ended with a `continue`
     * statement targeting the given label.
     */
    Continue(BranchTarget lbl) or
    /**
     * A completion indicating that execution of a (compound) statement ended with a `fallthrough`
     * statement.
     */
    Fallthrough() or
    /**
     * A completion indicating that execution of a (compound) statement ended with a `return`
     * statement.
     */
    Return() or
    /**
     * A completion indicating that execution of a statement or expression may have ended with
     * a panic being raised.
     */
    Panic()

  private Completion normalCompletion() { result.isNormal() }

  private class Completion extends TCompletion {
    predicate isNormal() { this = Done() or this = Bool(_) }

    Boolean getOutcome() { this = Done() or this = Bool(result) }

    string toString() {
      this = Done() and result = "normal"
      or
      exists(boolean b | this = Bool(b) | result = b.toString())
      or
      exists(BranchTarget lbl |
        this = Break(lbl) and result = "break " + lbl
        or
        this = Continue(lbl) and result = "continue " + lbl
      )
      or
      this = Fallthrough() and result = "fallthrough"
      or
      this = Return() and result = "return"
      or
      this = Panic() and result = "panic"
    }
  }

  /**
   * Holds if `e` is an expression that has runtime semantics and hence should be represented in the
   * control-flow graph.
   */
  cached
  predicate hasSemantics(Expr e) {
    // exclude expressions that do not denote a value
    not e instanceof TypeExpr and
    not e = any(FieldDecl f).getTag() and
    not e instanceof KeyValueExpr and
    not e = any(SelectorExpr sel).getSelector() and
    not e = any(StructLit sl).getKey(_) and
    not (e instanceof Ident and not e instanceof ReferenceExpr) and
    not (e instanceof SelectorExpr and not e instanceof ReferenceExpr) and
    not pureLvalue(e) and
    not isStructural(e) and
    // exclude expressions that are not evaluated at runtime
    not e = any(ImportSpec is).getPathExpr() and
    not e.getParent*() = any(ArrayTypeExpr ate).getLength() and
    // sub-expressions of constant expressions are not evaluated (even if they don't look constant
    // themselves)
    not constRoot(e.getParent+())
  }

  /**
   * Holds if `e` is an expression that purely serves grouping or control-flow purposes.
   *
   * Examples include parenthesized expressions and short-circuiting Boolean expressions used in
   * a loop or `if` condition.
   */
  private predicate isStructural(Expr e) {
    e instanceof LogicalBinaryExpr and
    isCond(e)
    or
    e instanceof ParenExpr
  }

  /**
   * Gets a constant root, that is, an expression that is constant but whose parent expression is not.
   *
   * As an exception to the latter, for a grouping expression such as `(c)` where `c` is constant
   * we still consider it to be a constant root, even though its parent expression is also constant.
   */
  private predicate constRoot(Expr root) {
    exists(Expr c |
      c.isConst() and
      not c.getParent().(Expr).isConst() and
      root = stripStructural(c)
    )
  }

  /**
   * Strips off any structural components from `e`.
   */
  private Expr stripStructural(Expr e) {
    if isStructural(e) then result = stripStructural(e.getAChildExpr()) else result = e
  }

  private class ControlFlowTree extends AstNode {
    predicate firstNode(ControlFlow::Node first) { none() }

    predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      // propagate abnormal completion from children
      lastNode(this.getAChild(), last, cmpl) and
      not cmpl.isNormal()
    }

    predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      exists(int i |
        lastNode(getChildTreeRanked(i), pred, normalCompletion()) and
        firstNode(getChildTreeRanked(i + 1), succ)
      )
    }

    final ControlFlowTree getChildTreeRanked(int i) {
      exists(int j |
        result = getChildTree(j) and
        j = rank[i + 1](int k | exists(getChildTree(k)))
      )
    }

    ControlFlowTree getFirstChildTree() { result = getChildTreeRanked(0) }

    ControlFlowTree getLastChildTree() {
      result = max(ControlFlowTree ch, int j | ch = getChildTree(j) | ch order by j)
    }

    ControlFlowTree getChildTree(int i) { none() }
  }

  private class AtomicTree extends ControlFlowTree {
    ControlFlow::Node nd;
    Completion cmpl;

    AtomicTree() {
      exists(Expr e |
        e = this.(Expr) and
        e.isConst() and
        nd = mkExprOrSkipNode(this)
      |
        if e.isPlatformIndependentConstant() and exists(e.getBoolValue())
        then cmpl = Bool(e.getBoolValue())
        else cmpl = Done()
      )
      or
      this instanceof Ident and
      not this.(Expr).isConst() and
      nd = mkExprOrSkipNode(this) and
      cmpl = Done()
      or
      this instanceof BreakStmt and
      nd = MkSkipNode(this) and
      cmpl = Break(BranchTarget::of(this))
      or
      this instanceof ContinueStmt and
      nd = MkSkipNode(this) and
      cmpl = Continue(BranchTarget::of(this))
      or
      this instanceof Decl and
      nd = MkSkipNode(this) and
      cmpl = Done()
      or
      this instanceof EmptyStmt and
      nd = MkSkipNode(this) and
      cmpl = Done()
      or
      this instanceof FallthroughStmt and
      nd = MkSkipNode(this) and
      cmpl = Fallthrough()
      or
      this instanceof FuncLit and
      nd = MkExprNode(this) and
      cmpl = Done()
      or
      this instanceof PlainBlock and
      nd = MkSkipNode(this) and
      cmpl = Done()
      or
      this instanceof SelectorExpr and
      not this.(SelectorExpr).getBase() instanceof ValueExpr and
      nd = mkExprOrSkipNode(this) and
      cmpl = Done()
    }

    override predicate firstNode(ControlFlow::Node first) { first = nd }

    override predicate lastNode(ControlFlow::Node last, Completion c) { last = nd and c = cmpl }
  }

  abstract private class PostOrderTree extends ControlFlowTree {
    abstract ControlFlow::Node getNode();

    Completion getCompletion() { result = Done() }

    override predicate firstNode(ControlFlow::Node first) {
      firstNode(getFirstChildTree(), first)
      or
      not exists(getChildTree(_)) and
      first = getNode()
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      super.lastNode(last, cmpl)
      or
      last = getNode() and cmpl = getCompletion()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      super.succ(pred, succ)
      or
      lastNode(getLastChildTree(), pred, normalCompletion()) and
      succ = getNode()
    }
  }

  abstract private class PreOrderTree extends ControlFlowTree {
    abstract ControlFlow::Node getNode();

    override predicate firstNode(ControlFlow::Node first) { first = getNode() }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      super.lastNode(last, cmpl)
      or
      lastNode(getLastChildTree(), last, cmpl)
      or
      not exists(getChildTree(_)) and
      last = getNode() and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      super.succ(pred, succ)
      or
      pred = getNode() and
      firstNode(getFirstChildTree(), succ)
    }
  }

  private class WrapperTree extends ControlFlowTree {
    WrapperTree() {
      this instanceof ConstDecl or
      this instanceof DeclStmt or
      this instanceof ExprStmt or
      this instanceof KeyValueExpr or
      this instanceof LabeledStmt or
      this instanceof ParenExpr or
      this instanceof PlainBlock or
      this instanceof VarDecl
    }

    override predicate firstNode(ControlFlow::Node first) { firstNode(getFirstChildTree(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      super.lastNode(last, cmpl)
      or
      lastNode(getLastChildTree(), last, cmpl)
      or
      exists(LoopStmt ls | this = ls.getBody() |
        lastNode(this, last, Continue(BranchTarget::of(ls))) and
        cmpl = Done()
      )
    }

    override ControlFlowTree getChildTree(int i) {
      i = 0 and result = this.(DeclStmt).getDecl()
      or
      i = 0 and result = this.(ExprStmt).getExpr()
      or
      result = this.(GenDecl).getSpec(i)
      or
      exists(KeyValueExpr kv | kv = this |
        not kv.getLiteral() instanceof StructLit and
        i = 0 and
        result = kv.getKey()
        or
        i = 1 and result = kv.getValue()
      )
      or
      i = 0 and result = this.(LabeledStmt).getStmt()
      or
      i = 0 and result = this.(ParenExpr).getExpr()
      or
      result = this.(PlainBlock).getStmt(i)
    }
  }

  private class AssignmentTree extends ControlFlowTree {
    AssignmentTree() {
      this instanceof Assignment or
      this instanceof ValueSpec
    }

    Expr getLhs(int i) {
      result = this.(Assignment).getLhs(i) or
      result = this.(ValueSpec).getNameExpr(i)
    }

    int getNumLhs() {
      result = this.(Assignment).getNumLhs() or
      result = this.(ValueSpec).getNumName()
    }

    Expr getRhs(int i) {
      result = this.(Assignment).getRhs(i) or
      result = this.(ValueSpec).getInit(i)
    }

    int getNumRhs() {
      result = this.(Assignment).getNumRhs() or
      result = this.(ValueSpec).getNumInit()
    }

    predicate isExtractingAssign() { getNumRhs() = 1 and getNumLhs() > 1 }

    override predicate firstNode(ControlFlow::Node first) {
      not this instanceof RecvStmt and
      firstNode(getLhs(0), first)
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      exists(int nl, int nr | nl = getNumLhs() and nr = getNumRhs() |
        last = MkAssignNode(this, nl - 1)
        or
        not exists(MkAssignNode(this, nl - 1)) and
        (
          exists(ControlFlow::Node rhs | lastNode(getRhs(nr - 1), rhs, normalCompletion()) |
            if nl = nr then last = rhs else last = MkExtractNode(this, nl - 1)
          )
          or
          not exists(getRhs(nr - 1)) and
          lastNode(getLhs(nl - 1), last, normalCompletion())
        )
      ) and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      exists(int i | lastNode(getLhs(i), pred, normalCompletion()) |
        firstNode(getLhs(i + 1), succ)
        or
        not this instanceof RecvStmt and
        i = getNumLhs() - 1 and
        (
          firstNode(getRhs(0), succ)
          or
          not exists(getRhs(_)) and
          succ = epilogueNodeRanked(1)
        )
      )
      or
      exists(int i |
        lastNode(getRhs(i), pred, normalCompletion()) and
        firstNode(getRhs(i + 1), succ)
      )
      or
      exists(int i |
        pred = epilogueNodeRanked(i) and
        succ = epilogueNodeRanked(i + 1)
      )
    }

    ControlFlow::Node epilogueNodeRanked(int i) {
      exists(int j |
        result = epilogueNode(j) and
        j = rank[i + 1](int k | exists(epilogueNode(k)))
      )
    }

    private ControlFlow::Node epilogueNode(int i) {
      not this instanceof RecvStmt and
      i = -2 and
      (
        lastNode(getRhs(getNumRhs() - 1), result, normalCompletion())
        or
        not exists(getRhs(_)) and
        lastNode(getLhs(getNumLhs() - 1), result, normalCompletion())
      )
      or
      i = -1 and
      result = MkCompoundAssignRhsNode(this)
      or
      exists(int j |
        result = MkExtractNode(this, j) and
        i = 2 * j
        or
        result = MkZeroInitNode(any(ValueEntity v | getLhs(j) = v.getDeclaration())) and
        i = 2 * j
        or
        result = MkAssignNode(this, j) and
        i = 2 * j + 1
      )
    }
  }

  private class BinaryExprTree extends PostOrderTree, BinaryExpr {
    override ControlFlow::Node getNode() { result = MkExprNode(this) }

    override Completion getCompletion() {
      result = PostOrderTree.super.getCompletion()
      or
      // runtime panic due to division by zero or comparison of incomparable interface values
      (this instanceof DivExpr or this instanceof EqualityTestExpr) and
      not this.(Expr).isConst() and
      result = Panic()
    }

    override ControlFlowTree getChildTree(int i) {
      i = 0 and result = getLeftOperand()
      or
      i = 1 and result = getRightOperand()
    }
  }

  private class LogicalBinaryExprTree extends BinaryExprTree, LogicalBinaryExpr {
    boolean shortCircuit;

    LogicalBinaryExprTree() {
      this instanceof LandExpr and shortCircuit = false
      or
      this instanceof LorExpr and shortCircuit = true
    }

    private ControlFlow::Node getGuard(boolean outcome) {
      result = MkConditionGuardNode(getLeftOperand(), outcome)
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      lastNode(getAnOperand(), last, cmpl) and
      not cmpl.isNormal()
      or
      if isCond(this)
      then (
        last = getGuard(shortCircuit) and
        cmpl = Bool(shortCircuit)
        or
        lastNode(getRightOperand(), last, cmpl)
      ) else (
        last = MkExprNode(this) and
        cmpl = Done()
      )
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      exists(Completion lcmpl |
        lastNode(getLeftOperand(), pred, lcmpl) and
        succ = getGuard(lcmpl.getOutcome())
      )
      or
      pred = getGuard(shortCircuit.booleanNot()) and
      firstNode(getRightOperand(), succ)
      or
      not isCond(this) and
      (
        pred = getGuard(shortCircuit) and
        succ = MkExprNode(this)
        or
        exists(Completion rcmpl |
          lastNode(getRightOperand(), pred, rcmpl) and
          rcmpl.isNormal() and
          succ = MkExprNode(this)
        )
      )
    }
  }

  private class CallExprTree extends PostOrderTree, CallExpr {
    private predicate isSpecial() {
      this = any(DeferStmt defer).getCall() or
      this = any(GoStmt go).getCall()
    }

    override ControlFlow::Node getNode() {
      not isSpecial() and
      result = MkExprNode(this)
    }

    override Completion getCompletion() {
      not getTarget().mustPanic() and
      result = Done()
      or
      (not exists(getTarget()) or getTarget().mayPanic()) and
      result = Panic()
    }

    override ControlFlowTree getChildTree(int i) {
      i = 0 and result = getCalleeExpr()
      or
      result = getArgument(i - 1) and
      // calls to `make` and `new` can have type expressions as arguments
      not result instanceof TypeExpr
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      // interpose implicit argument destructuring nodes between last argument
      // and call itself; this is for cases like `f(g())` where `g` has multiple
      // results
      exists(ControlFlow::Node mid | PostOrderTree.super.succ(pred, mid) |
        if mid = getNode() then succ = getEpilogueNode(0) else succ = mid
      )
      or
      exists(int i |
        pred = getEpilogueNode(i) and
        succ = getEpilogueNode(i + 1)
      )
    }

    private ControlFlow::Node getEpilogueNode(int i) {
      result = MkExtractNode(this, i)
      or
      i = max(int j | exists(MkExtractNode(this, j))) + 1 and
      result = getNode()
      or
      not exists(MkExtractNode(this, _)) and
      i = 0 and
      result = getNode()
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      PostOrderTree.super.lastNode(last, cmpl)
      or
      isSpecial() and
      lastNode(getLastChildTree(), last, cmpl)
    }
  }

  private class CaseClauseTree extends ControlFlowTree, CaseClause {
    private ControlFlow::Node getExprStart(int i) {
      firstNode(getExpr(i), result)
      or
      getExpr(i) instanceof TypeExpr and
      result = MkCaseCheckNode(this, i)
    }

    ControlFlow::Node getExprEnd(int i, Boolean outcome) {
      exists(Expr e | e = getExpr(i) |
        result = MkConditionGuardNode(e, outcome)
        or
        not exists(MkConditionGuardNode(e, _)) and
        result = MkCaseCheckNode(this, i)
      )
    }

    private ControlFlow::Node getBodyStart() {
      firstNode(getStmt(0), result) or result = MkSkipNode(this)
    }

    override predicate firstNode(ControlFlow::Node first) {
      first = getExprStart(0)
      or
      not exists(getAnExpr()) and
      first = getBodyStart()
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      // TODO: shouldn't be here
      last = getExprEnd(getNumExpr() - 1, false) and
      cmpl = Bool(false)
      or
      last = MkSkipNode(this) and
      cmpl = Done()
      or
      lastNode(getStmt(getNumStmt() - 1), last, cmpl)
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      exists(int i |
        lastNode(getExpr(i), pred, normalCompletion()) and
        succ = MkCaseCheckNode(this, i)
        or
        // visit guard node if there is one
        pred = MkCaseCheckNode(this, i) and
        succ = getExprEnd(i, _) and
        succ != pred // this avoids self-loops if there isn't a guard node
        or
        pred = getExprEnd(i, false) and
        succ = getExprStart(i + 1)
        or
        pred = getExprEnd(i, true) and
        succ = getBodyStart()
      )
    }

    override ControlFlowTree getChildTree(int i) { result = getStmt(i) }
  }

  private class CommClauseTree extends ControlFlowTree, CommClause {
    override predicate firstNode(ControlFlow::Node first) { firstNode(getComm(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      last = MkSkipNode(this) and
      cmpl = Done()
      or
      lastNode(getStmt(getNumStmt() - 1), last, cmpl)
    }

    override ControlFlowTree getChildTree(int i) { result = getStmt(i) }
  }

  private class CompositeLiteralTree extends ControlFlowTree, CompositeLit {
    private ControlFlow::Node getElementInit(int i) {
      result = MkLiteralElementInitNode(getElement(i))
    }

    private ControlFlow::Node getElementStart(int i) {
      exists(Expr elt | elt = getElement(i) |
        result = MkImplicitLiteralElementIndex(elt)
        or
        (elt instanceof KeyValueExpr or this instanceof StructLit) and
        firstNode(getElement(i), result)
      )
    }

    override predicate firstNode(ControlFlow::Node first) { first = MkExprNode(this) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      last = getElementInit(getNumElement() - 1) and
      cmpl = Done()
      or
      not exists(getElement(_)) and
      last = MkExprNode(this) and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      firstNode(pred) and
      succ = getElementStart(0)
      or
      exists(int i |
        pred = MkImplicitLiteralElementIndex(getElement(i)) and
        firstNode(getElement(i), succ)
        or
        lastNode(getElement(i), pred, normalCompletion()) and
        succ = getElementInit(i)
        or
        pred = getElementInit(i) and
        succ = getElementStart(i + 1)
      )
    }
  }

  private class ConversionExprTree extends PostOrderTree, ConversionExpr {
    override ControlFlow::Node getNode() { result = MkExprNode(this) }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = getOperand() }
  }

  private class DeferStmtTree extends PostOrderTree, DeferStmt {
    override ControlFlow::Node getNode() { result = MkDeferNode(this) }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = getCall() }
  }

  private class FuncDeclTree extends PostOrderTree, FuncDecl {
    override ControlFlow::Node getNode() { result = MkFuncDeclNode(this) }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = getNameExpr() }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      // override to prevent panic propagation out of function declarations
      last = getNode() and cmpl = Done()
    }
  }

  private class GoStmtTree extends PostOrderTree, GoStmt {
    override ControlFlow::Node getNode() { result = MkGoNode(this) }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = getCall() }
  }

  private class IfStmtTree extends ControlFlowTree, IfStmt {
    private ControlFlow::Node getGuard(boolean outcome) {
      result = MkConditionGuardNode(getCond(), outcome)
    }

    override predicate firstNode(ControlFlow::Node first) {
      firstNode(getInit(), first)
      or
      not exists(getInit()) and
      firstNode(getCond(), first)
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      lastNode(getThen(), last, cmpl)
      or
      lastNode(getElse(), last, cmpl)
      or
      not exists(getElse()) and
      last = getGuard(false) and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      lastNode(getInit(), pred, normalCompletion()) and
      firstNode(getCond(), succ)
      or
      exists(Completion condCmpl |
        lastNode(getCond(), pred, condCmpl) and
        succ = MkConditionGuardNode(getCond(), condCmpl.getOutcome())
      )
      or
      pred = getGuard(true) and
      firstNode(getThen(), succ)
      or
      pred = getGuard(false) and
      firstNode(getElse(), succ)
    }
  }

  private class IndexExprTree extends ControlFlowTree, IndexExpr {
    override predicate firstNode(ControlFlow::Node first) { firstNode(getBase(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      // panic due to `nil` dereference
      last = MkImplicitDeref(this.getBase()) and
      cmpl = Panic()
      or
      last = mkExprOrSkipNode(this) and
      (cmpl = Done() or cmpl = Panic())
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      lastNode(getBase(), pred, normalCompletion()) and
      (
        succ = MkImplicitDeref(this.getBase())
        or
        not exists(MkImplicitDeref(this.getBase())) and
        firstNode(this.getIndex(), succ)
      )
      or
      pred = MkImplicitDeref(this.getBase()) and
      firstNode(this.getIndex(), succ)
      or
      lastNode(getIndex(), pred, normalCompletion()) and
      succ = mkExprOrSkipNode(this)
    }
  }

  private class LoopTree extends ControlFlowTree, LoopStmt {
    BranchTarget getLabel() { result = BranchTarget::of(this) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      exists(Completion inner | lastNode(getBody(), last, inner) and not inner.isNormal() |
        if inner = Break(getLabel())
        then cmpl = Done()
        else
          if inner = Continue(getLabel())
          then none()
          else cmpl = inner
      )
    }
  }

  private class FileTree extends ControlFlowTree, File {
    FileTree() { exists(getADecl()) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) { none() }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      pred = MkEntryNode(this) and
      firstNode(this.getDecl(0), succ)
      or
      exists(int i, Completion inner | lastNode(this.getDecl(i), pred, inner) |
        not inner.isNormal()
        or
        i = getNumDecl() - 1
      ) and
      succ = MkExitNode(this)
    }

    override ControlFlowTree getChildTree(int i) { result = getDecl(i) }
  }

  private class ForTree extends LoopTree, ForStmt {
    private ControlFlow::Node getGuard(boolean outcome) {
      result = MkConditionGuardNode(getCond(), outcome)
    }

    override predicate firstNode(ControlFlow::Node first) { firstNode(getFirstChildTree(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      LoopTree.super.lastNode(last, cmpl)
      or
      lastNode(getInit(), last, cmpl) and
      not cmpl.isNormal()
      or
      lastNode(getCond(), last, cmpl) and
      not cmpl.isNormal()
      or
      lastNode(getPost(), last, cmpl) and
      not cmpl.isNormal()
      or
      last = getGuard(false) and
      cmpl = Done()
    }

    override ControlFlowTree getChildTree(int i) {
      i = 0 and result = getInit()
      or
      i = 1 and result = getCond()
      or
      i = 2 and result = getBody()
      or
      i = 3 and result = getPost()
      or
      i = 4 and result = getCond()
      or
      i = 5 and result = getBody()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      exists(int i, ControlFlowTree predTree, Completion cmpl |
        predTree = getChildTreeRanked(i) and
        lastNode(predTree, pred, cmpl) and
        cmpl.isNormal()
      |
        if predTree = getCond()
        then succ = getGuard(cmpl.getOutcome())
        else firstNode(getChildTreeRanked(i + 1), succ)
      )
      or
      pred = getGuard(true) and
      firstNode(getBody(), succ)
    }
  }

  private class FuncDefTree extends ControlFlowTree, FuncDef {
    FuncDefTree() { exists(getBody()) }

    pragma[noinline]
    private MkEntryNode getEntry() { result = MkEntryNode(this) }

    private Parameter getParameterRanked(int i) {
      result = rank[i + 1](Parameter p, int j | p = getParameter(j) | p order by j)
    }

    private ControlFlow::Node getPrologueNode(int i) {
      i = -1 and result = getEntry()
      or
      exists(int numParm, int numRes |
        numParm = count(getParameter(_)) and
        numRes = count(getResultVar(_))
      |
        exists(int j, Parameter p | p = getParameterRanked(j) |
          i = 2 * j and result = MkArgumentNode(p)
          or
          i = 2 * j + 1 and result = MkParameterInit(p)
        )
        or
        exists(int j, ResultVariable v | v = getResultVar(j) |
          i = 2 * numParm + 2 * j and
          result = MkZeroInitNode(v)
          or
          i = 2 * numParm + 2 * j + 1 and
          result = MkResultInit(v)
        )
        or
        i = 2 * numParm + 2 * numRes and
        firstNode(getBody(), result)
      )
    }

    private ControlFlow::Node getEpilogueNode(int i) {
      result = MkResultReadNode(getResultVar(i))
      or
      i = count(getAResultVar()) and
      result = MkExitNode(this)
    }

    pragma[noinline]
    private predicate firstDefer(ControlFlow::Node nd) {
      exists(DeferStmt defer |
        nd = MkExprNode(defer.getCall()) and
        // `defer` can be the first `defer` statement executed
        // there is always a predecessor node because the `defer`'s call is always
        // evaluated before the defer statement itself
        MkDeferNode(defer) = succ(notDeferSucc*(getEntry()))
      )
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) { none() }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      exists(int i |
        pred = getPrologueNode(i) and
        succ = getPrologueNode(i + 1)
      )
      or
      exists(GotoStmt goto, LabeledStmt ls |
        pred = MkSkipNode(goto) and
        this = goto.getEnclosingFunction() and
        this = ls.getEnclosingFunction() and
        goto.getLabel() = ls.getLabel() and
        firstNode(ls, succ)
      )
      or
      exists(Completion cmpl |
        lastNode(this.getBody(), pred, cmpl) and
        // last node of function body can be reached without going through a `defer` statement
        pred = notDeferSucc*(getEntry())
      |
        // panic goes directly to exit, non-panic reads result variables first
        if cmpl = Panic() then succ = MkExitNode(this) else succ = getEpilogueNode(0)
      )
      or
      lastNode(this.getBody(), pred, _) and
      exists(DeferStmt defer | defer = this.getADeferStmt() |
        succ = MkExprNode(defer.getCall()) and
        // the last `DeferStmt` executed before pred is this `defer`
        pred = notDeferSucc*(MkDeferNode(defer))
      )
      or
      exists(DeferStmt predDefer, DeferStmt succDefer |
        predDefer = this.getADeferStmt() and
        succDefer = this.getADeferStmt()
      |
        // reversed because `defer`s are executed in LIFO order
        MkDeferNode(predDefer) = nextDefer(MkDeferNode(succDefer)) and
        pred = MkExprNode(predDefer.getCall()) and
        succ = MkExprNode(succDefer.getCall())
      )
      or
      firstDefer(pred) and
      (
        // conservatively assume that we might either panic (and hence skip the result reads)
        // or not
        succ = MkExitNode(this)
        or
        succ = getEpilogueNode(0)
      )
      or
      exists(int i |
        pred = getEpilogueNode(i) and
        succ = getEpilogueNode(i + 1)
      )
    }
  }

  private class GotoTree extends ControlFlowTree, GotoStmt {
    override predicate firstNode(ControlFlow::Node first) { first = MkSkipNode(this) }
  }

  private class IncDecTree extends ControlFlowTree, IncDecStmt {
    override predicate firstNode(ControlFlow::Node first) { firstNode(getOperand(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      last = MkIncDecNode(this) and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      lastNode(getOperand(), pred, normalCompletion()) and
      succ = MkImplicitOne(this)
      or
      pred = MkImplicitOne(this) and
      succ = MkIncDecRhs(this)
      or
      pred = MkIncDecRhs(this) and
      succ = MkIncDecNode(this)
    }
  }

  private class RangeTree extends LoopTree, RangeStmt {
    override predicate firstNode(ControlFlow::Node first) { firstNode(getDomain(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      LoopTree.super.lastNode(last, cmpl)
      or
      last = MkNextNode(this) and
      cmpl = Done()
      or
      lastNode(getKey(), last, cmpl) and
      not cmpl.isNormal()
      or
      lastNode(getValue(), last, cmpl) and
      not cmpl.isNormal()
      or
      lastNode(getDomain(), last, cmpl) and
      not cmpl.isNormal()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      lastNode(getDomain(), pred, normalCompletion()) and
      succ = MkNextNode(this)
      or
      pred = MkNextNode(this) and
      (
        firstNode(getKey(), succ)
        or
        not exists(getKey()) and
        firstNode(getBody(), succ)
      )
      or
      lastNode(getKey(), pred, normalCompletion()) and
      (
        firstNode(getValue(), succ)
        or
        not exists(getValue()) and
        succ = MkExtractNode(this, 0)
      )
      or
      lastNode(getValue(), pred, normalCompletion()) and
      succ = MkExtractNode(this, 0)
      or
      pred = MkExtractNode(this, 0) and
      (
        if exists(getValue())
        then succ = MkExtractNode(this, 1)
        else
          if exists(MkAssignNode(this, 0))
          then succ = MkAssignNode(this, 0)
          else
            if exists(MkAssignNode(this, 1))
            then succ = MkAssignNode(this, 1)
            else firstNode(getBody(), succ)
      )
      or
      pred = MkExtractNode(this, 1) and
      (
        if exists(MkAssignNode(this, 0))
        then succ = MkAssignNode(this, 0)
        else
          if exists(MkAssignNode(this, 1))
          then succ = MkAssignNode(this, 1)
          else firstNode(getBody(), succ)
      )
      or
      pred = MkAssignNode(this, 0) and
      (
        if exists(MkAssignNode(this, 1))
        then succ = MkAssignNode(this, 1)
        else firstNode(getBody(), succ)
      )
      or
      pred = MkAssignNode(this, 1) and
      firstNode(getBody(), succ)
      or
      exists(Completion inner |
        lastNode(getBody(), pred, inner) and
        (inner.isNormal() or inner = Continue(BranchTarget::of(this))) and
        succ = MkNextNode(this)
      )
    }
  }

  private class RecvStmtTree extends ControlFlowTree, RecvStmt {
    override predicate firstNode(ControlFlow::Node first) {
      firstNode(getExpr().getOperand(), first)
    }
  }

  private class ReturnStmtTree extends PostOrderTree, ReturnStmt {
    override ControlFlow::Node getNode() { result = MkReturnNode(this) }

    override Completion getCompletion() { result = Return() }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      exists(int i |
        lastNode(getExpr(i), pred, normalCompletion()) and
        succ = complete(i)
        or
        pred = MkExtractNode(this, i) and
        succ = after(i)
        or
        pred = MkResultWriteNode(_, i, this) and
        succ = next(i)
      )
    }

    private ControlFlow::Node complete(int i) {
      result = MkExtractNode(this, i)
      or
      not exists(MkExtractNode(this, _)) and
      result = after(i)
    }

    private ControlFlow::Node after(int i) {
      result = MkResultWriteNode(_, i, this)
      or
      not exists(MkResultWriteNode(_, i, this)) and
      result = next(i)
    }

    private ControlFlow::Node next(int i) {
      firstNode(getExpr(i + 1), result)
      or
      exists(MkExtractNode(this, _)) and
      result = complete(i + 1)
      or
      i + 1 = getEnclosingFunction().getType().getNumResult() and
      result = getNode()
    }

    override ControlFlowTree getChildTree(int i) { result = getExpr(i) }
  }

  private class SelectStmtTree extends ControlFlowTree, SelectStmt {
    private BranchTarget getLabel() { result = BranchTarget::of(this) }

    override predicate firstNode(ControlFlow::Node first) {
      firstNode(getNonDefaultCommClause(0), first)
      or
      getNumNonDefaultCommClause() = 0 and
      first = MkSelectNode(this)
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      exists(Completion inner | lastNode(getACommClause(), last, inner) |
        if inner = Break(getLabel()) then cmpl = Done() else cmpl = inner
      )
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      exists(CommClause cc, int i, Stmt comm |
        cc = getNonDefaultCommClause(i) and
        comm = cc.getComm() and
        (
          comm instanceof RecvStmt and
          lastNode(comm.(RecvStmt).getExpr().getOperand(), pred, normalCompletion())
          or
          comm instanceof SendStmt and
          lastNode(comm.(SendStmt).getValue(), pred, normalCompletion())
        )
      |
        firstNode(getNonDefaultCommClause(i + 1), succ)
        or
        i = getNumNonDefaultCommClause() - 1 and
        succ = MkSelectNode(this)
      )
      or
      pred = MkSelectNode(this) and
      exists(CommClause cc, Stmt comm | cc = getNonDefaultCommClause(_) and comm = cc.getComm() |
        comm instanceof RecvStmt and
        succ = MkExprNode(comm.(RecvStmt).getExpr())
        or
        comm instanceof SendStmt and
        succ = MkSendNode(comm)
      )
      or
      pred = MkSelectNode(this) and
      exists(CommClause cc | cc = getDefaultCommClause() |
        firstNode(cc.getStmt(0), succ)
        or
        succ = MkSkipNode(cc)
      )
      or
      exists(CommClause cc, RecvStmt recv | cc = getCommClause(_) and recv = cc.getComm() |
        pred = MkExprNode(recv.getExpr()) and
        (
          firstNode(recv.getLhs(0), succ)
          or
          not exists(recv.getLhs(0)) and
          (firstNode(cc.getStmt(0), succ) or succ = MkSkipNode(cc))
        )
        or
        lastNode(recv.getLhs(0), pred, normalCompletion()) and
        not exists(recv.getLhs(1)) and
        (
          succ = MkAssignNode(recv, 0)
          or
          not exists(MkAssignNode(recv, 0)) and
          (firstNode(cc.getStmt(0), succ) or succ = MkSkipNode(cc))
        )
        or
        lastNode(recv.getLhs(1), pred, normalCompletion()) and
        succ = MkExtractNode(recv, 0)
        or
        (
          pred = MkAssignNode(recv, 0) and
          not exists(MkExtractNode(recv, 1))
          or
          pred = MkExtractNode(recv, 1) and
          not exists(MkAssignNode(recv, 1))
          or
          pred = MkAssignNode(recv, 1)
        ) and
        (firstNode(cc.getStmt(0), succ) or succ = MkSkipNode(cc))
      )
      or
      exists(CommClause cc, SendStmt ss |
        cc = getCommClause(_) and
        ss = cc.getComm() and
        pred = MkSendNode(ss)
      |
        firstNode(cc.getStmt(0), succ)
        or
        succ = MkSkipNode(cc)
      )
    }
  }

  private class SelectorExprTree extends ControlFlowTree, SelectorExpr {
    SelectorExprTree() { getBase() instanceof ValueExpr }

    override predicate firstNode(ControlFlow::Node first) { firstNode(getBase(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      // panic due to `nil` dereference
      last = MkImplicitDeref(this.getBase()) and
      cmpl = Panic()
      or
      last = mkExprOrSkipNode(this) and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      lastNode(getBase(), pred, normalCompletion()) and
      (
        succ = MkImplicitDeref(this.getBase())
        or
        not exists(MkImplicitDeref(this.getBase())) and
        succ = mkExprOrSkipNode(this)
      )
      or
      pred = MkImplicitDeref(this.getBase()) and
      succ = mkExprOrSkipNode(this)
    }
  }

  private class SendStmtTree extends ControlFlowTree, SendStmt {
    override predicate firstNode(ControlFlow::Node first) { firstNode(getChannel(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      last = MkSendNode(this) and
      (cmpl = Done() or cmpl = Panic())
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      not this = any(CommClause cc).getComm() and
      lastNode(getValue(), pred, normalCompletion()) and
      succ = MkSendNode(this)
    }

    override ControlFlowTree getChildTree(int i) {
      i = 0 and result = getChannel()
      or
      i = 1 and result = getValue()
    }
  }

  private class SliceExprTree extends ControlFlowTree, SliceExpr {
    override predicate firstNode(ControlFlow::Node first) { firstNode(getBase(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      // panic due to `nil` dereference
      last = MkImplicitDeref(getBase()) and
      cmpl = Panic()
      or
      last = MkExprNode(this) and
      (cmpl = Done() or cmpl = Panic())
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      lastNode(getBase(), pred, normalCompletion()) and
      (
        succ = MkImplicitDeref(getBase())
        or
        not exists(MkImplicitDeref(getBase())) and
        (firstNode(getLow(), succ) or succ = MkImplicitLowerSliceBound(this))
      )
      or
      pred = MkImplicitDeref(getBase()) and
      (firstNode(getLow(), succ) or succ = MkImplicitLowerSliceBound(this))
      or
      (lastNode(getLow(), pred, normalCompletion()) or pred = MkImplicitLowerSliceBound(this)) and
      (firstNode(getHigh(), succ) or succ = MkImplicitUpperSliceBound(this))
      or
      (lastNode(getHigh(), pred, normalCompletion()) or pred = MkImplicitUpperSliceBound(this)) and
      (firstNode(getMax(), succ) or succ = MkImplicitMaxSliceBound(this))
      or
      (lastNode(getMax(), pred, normalCompletion()) or pred = MkImplicitMaxSliceBound(this)) and
      succ = MkExprNode(this)
    }
  }

  private class StarExprTree extends PostOrderTree, StarExpr {
    override ControlFlow::Node getNode() { result = mkExprOrSkipNode(this) }

    override Completion getCompletion() { result = Done() or result = Panic() }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = getBase() }
  }

  private class SwitchTree extends ControlFlowTree, SwitchStmt {
    override predicate firstNode(ControlFlow::Node first) {
      firstNode(getInit(), first)
      or
      not exists(getInit()) and
      (
        firstNode(this.(ExpressionSwitchStmt).getExpr(), first)
        or
        first = MkImplicitTrue(this)
        or
        firstNode(this.(TypeSwitchStmt).getTest(), first)
      )
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      lastNode(getInit(), last, cmpl) and
      not cmpl.isNormal()
      or
      (
        lastNode(this.(ExpressionSwitchStmt).getExpr(), last, cmpl)
        or
        last = MkImplicitTrue(this) and
        cmpl = Bool(true)
        or
        lastNode(this.(TypeSwitchStmt).getTest(), last, cmpl)
      ) and
      (
        not cmpl.isNormal()
        or
        not exists(this.getDefault())
      )
      or
      exists(CaseClause cc, int i, Completion inner |
        cc = this.getCase(i) and lastNode(cc, last, inner)
      |
        not exists(this.getDefault()) and
        i = this.getNumCase() - 1 and
        last = cc.(CaseClauseTree).getExprEnd(cc.getNumExpr() - 1, false) and
        inner.isNormal() and
        cmpl = inner
        or
        not last = cc.(CaseClauseTree).getExprEnd(_, _) and
        inner.isNormal() and
        cmpl = inner
        or
        if inner = Break(BranchTarget::of(this))
        then cmpl = Done()
        else (
          not inner.isNormal() and inner != Fallthrough() and cmpl = inner
        )
      )
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      lastNode(getInit(), pred, normalCompletion()) and
      (
        firstNode(this.(ExpressionSwitchStmt).getExpr(), succ) or
        succ = MkImplicitTrue(this) or
        firstNode(this.(TypeSwitchStmt).getTest(), succ)
      )
      or
      (
        lastNode(this.(ExpressionSwitchStmt).getExpr(), pred, normalCompletion()) or
        pred = MkImplicitTrue(this) or
        lastNode(this.(TypeSwitchStmt).getTest(), pred, normalCompletion())
      ) and
      (
        firstNode(getNonDefaultCase(0), succ)
        or
        not exists(getANonDefaultCase()) and
        firstNode(getDefault(), succ)
      )
      or
      exists(CaseClause cc, int i |
        cc = getNonDefaultCase(i) and
        lastNode(cc, pred, normalCompletion()) and
        pred = cc.(CaseClauseTree).getExprEnd(_, false)
      |
        firstNode(getNonDefaultCase(i + 1), succ)
        or
        i = getNumNonDefaultCase() - 1 and
        firstNode(getDefault(), succ)
      )
      or
      exists(CaseClause cc, int i, CaseClause next |
        cc = getCase(i) and
        lastNode(cc, pred, Fallthrough()) and
        next = getCase(i + 1)
      |
        firstNode(next.getStmt(0), succ)
        or
        succ = MkSkipNode(next)
      )
    }
  }

  private class TypeAssertTree extends PostOrderTree, TypeAssertExpr {
    override ControlFlow::Node getNode() { result = MkExprNode(this) }

    override Completion getCompletion() {
      result = Done()
      or
      // panic due to type mismatch, but not if the assertion appears in an assignment or
      // initialization with two variables or a type-switch
      not exists(Assignment assgn | assgn.getNumLhs() = 2 and this = assgn.getRhs().stripParens()) and
      not exists(ValueSpec vs | vs.getNumName() = 2 and this = vs.getInit().stripParens()) and
      not exists(TypeSwitchStmt ts | this = ts.getExpr()) and
      result = Panic()
    }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = getExpr() }
  }

  private class UnaryExprTree extends ControlFlowTree, UnaryExpr {
    override predicate firstNode(ControlFlow::Node first) { firstNode(getOperand(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      last = MkExprNode(this) and
      (
        cmpl = Done()
        or
        this instanceof DerefExpr and cmpl = Panic()
      )
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      not this = any(RecvStmt recv).getExpr() and
      lastNode(getOperand(), pred, normalCompletion()) and
      succ = MkExprNode(this)
    }
  }

  private ControlFlow::Node mkExprOrSkipNode(Expr e) {
    result = MkExprNode(e) or
    result = MkSkipNode(e)
  }

  /** Holds if evaluation of `root` may start at `first`. */
  cached
  predicate firstNode(ControlFlowTree root, ControlFlow::Node first) { root.firstNode(first) }

  /** Holds if evaluation of `root` may complete normally after `last`. */
  cached
  predicate lastNode(ControlFlowTree root, ControlFlow::Node last) {
    lastNode(root, last, normalCompletion())
  }

  private predicate lastNode(ControlFlowTree root, ControlFlow::Node last, Completion cmpl) {
    root.lastNode(last, cmpl)
  }

  /** Gets a successor of `nd` that is not a `defer` node */
  private ControlFlow::Node notDeferSucc(ControlFlow::Node nd) {
    not result = MkDeferNode(_) and
    result = succ(nd)
  }

  /** Gets `defer` statements that can be the first defer statement after `nd` in the CFG */
  private ControlFlow::Node nextDefer(ControlFlow::Node nd) {
    nd = MkDeferNode(_) and
    result = MkDeferNode(_) and
    (
      result = succ(nd)
      or
      result = succ(notDeferSucc+(nd))
    )
  }

  /** Gets a successor of `nd`, that is, a node that is executed after `nd`. */
  cached
  ControlFlow::Node succ(ControlFlow::Node nd) { any(ControlFlowTree tree).succ(nd, result) }
}
