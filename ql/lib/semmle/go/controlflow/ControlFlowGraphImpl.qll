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

/**
 * Holds if `e` is a branch condition, including the LHS of a short-circuiting binary operator.
 */
private predicate isCondRoot(Expr e) {
  e = any(LogicalBinaryExpr lbe).getLeftOperand()
  or
  e = any(ForStmt fs).getCond()
  or
  e = any(IfStmt is).getCond()
  or
  e = any(ExpressionSwitchStmt ess | not exists(ess.getExpr())).getACase().getAnExpr()
}

/**
 * Holds if `e` is a branch condition or part of a logical binary expression contributing to a
 * branch condition.
 *
 * For example, in `v := (x && y) || (z && w)`, `x` and `(x && y)` and `z` are branch conditions
 * (`isCondRoot` holds of them), whereas this predicate also holds of `y` (contributes to condition
 * `x && y`) but not of `w` (contributes to the value `v`, but not to any branch condition).
 *
 * In the context `if (x && y) || (z && w)` then the whole `(x && y) || (z && w)` is a branch condition
 * as well as `x` and `(x && y)` and `z` as previously, and this predicate holds of all their
 * subexpressions.
 */
private predicate isCond(Expr e) {
  isCondRoot(e) or
  e = any(LogicalBinaryExpr lbe | isCond(lbe)).getRightOperand() or
  e = any(ParenExpr par | isCond(par)).getExpr()
}

/**
 * Holds if `e` implicitly reads the embedded field `implicitField`.
 *
 * The `index` is the distance from the promoted field. For example, if `A` contains an embedded
 * field `B`, `B` contains an embedded field `C` and `C` contains the non-embedded field `x`.
 * Then `a.x` implicitly reads `C` with index 1 and `B` with index 2.
 */
private predicate implicitFieldSelectionForField(PromotedSelector e, int index, Field implicitField) {
  exists(StructType baseType, PromotedField child, int implicitFieldDepth |
    baseType = e.getSelectedStructType() and
    (
      e.refersTo(child)
      or
      implicitFieldSelectionForField(e, implicitFieldDepth + 1, child)
    )
  |
    child = baseType.getFieldOfEmbedded(implicitField, _, implicitFieldDepth + 1, _) and
    exists(PromotedField explicitField, int explicitFieldDepth |
      e.refersTo(explicitField) and baseType.getFieldAtDepth(_, explicitFieldDepth) = explicitField
    |
      index = explicitFieldDepth - implicitFieldDepth
    )
  )
}

private predicate implicitFieldSelectionForMethod(PromotedSelector e, int index, Field implicitField) {
  exists(StructType baseType, PromotedMethod method, int mDepth, int implicitFieldDepth |
    baseType = e.getSelectedStructType() and
    e.refersTo(method) and
    baseType.getMethodAtDepth(_, mDepth) = method and
    index = mDepth - implicitFieldDepth
  |
    method = baseType.getMethodOfEmbedded(implicitField, _, implicitFieldDepth + 1)
    or
    exists(PromotedField child |
      child = baseType.getFieldOfEmbedded(implicitField, _, implicitFieldDepth + 1, _) and
      implicitFieldSelectionForMethod(e, implicitFieldDepth + 1, child)
    )
  )
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
cached
newtype TControlFlowNode =
  /**
   * A control-flow node that represents the evaluation of an expression.
   */
  MkExprNode(Expr e) { CFG::hasEvaluationNode(e) } or
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
   * A control-flow node that represents the `i`th component of a tuple expression `s`.
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
   * A control-flow node that represents the implicit selection of a field when
   * accessing a promoted field.
   *
   * If that field has a pointer type then this control-flow node also
   * represents an implicit dereference of it.
   */
  MkImplicitFieldSelection(PromotedSelector e, int i, Field implicitField) {
    implicitFieldSelectionForField(e, i, implicitField) or
    implicitFieldSelectionForMethod(e, i, implicitField)
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
     * Note that many Boolean expressions are modeled as having completion `Done()` instead.
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
   * Holds if `e` should have an evaluation node in the control-flow graph.
   *
   * Excluded expressions include those not evaluated at runtime (e.g. identifiers, type expressions)
   * and some logical expressions that are expressed as control-flow edges rather than having a specific
   * evaluation node.
   */
  cached
  predicate hasEvaluationNode(Expr e) {
    // exclude expressions that do not denote a value
    not e instanceof TypeExpr and
    not e = any(FieldDecl f).getTag() and
    not e instanceof KeyValueExpr and
    not e = any(SelectorExpr sel).getSelector() and
    not e = any(StructLit sl).getKey(_) and
    not (e instanceof Ident and not e instanceof ReferenceExpr) and
    not (e instanceof SelectorExpr and not e instanceof ReferenceExpr) and
    not pureLvalue(e) and
    // exclude parentheses, which are purely concrete syntax, and some logical binary expressions
    // whose evaluation is implied by control-flow edges without requiring an evaluation node.
    not isControlFlowStructural(e) and
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
   * Examples include parenthesized expressions and short-circuiting Boolean expressions used within
   * a branch condition (`if` or `for` condition, or as part of a larger boolean expression, e.g.
   * in `(x && y) || z`, the `&&` subexpression matches this predicate).
   */
  private predicate isControlFlowStructural(Expr e) {
    // Some logical binary operators do not need an evaluation node
    // (for example, in `if x && y`, we evaluate `x` and then branch straight to either `y` or the
    //  `else` block, so there is no control-flow step where `x && y` is specifically calculated)
    e instanceof LogicalBinaryExpr and
    isCond(e)
    or
    // Purely concrete-syntactic structural expression:
    e instanceof ParenExpr
  }

  /**
   * Gets a constant root, that is, an expression that is constant but whose parent expression is not.
   *
   * As an exception to the latter, for a control-flow structural expression such as `(c1)` or `c1 && c2`
   * where `cn` are constants we still consider the `cn`s to be a constant roots, even though their parent
   * expression is also constant.
   */
  private predicate constRoot(Expr root) {
    exists(Expr c |
      c.isConst() and
      not c.getParent().(Expr).isConst() and
      root = stripStructural(c)
    )
  }

  /**
   * Strips off any control-flow structural components from `e`.
   */
  private Expr stripStructural(Expr e) {
    if isControlFlowStructural(e) then result = stripStructural(e.getAChildExpr()) else result = e
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
        lastNode(this.getChildTreeRanked(i), pred, normalCompletion()) and
        firstNode(this.getChildTreeRanked(i + 1), succ)
      )
    }

    final ControlFlowTree getChildTreeRanked(int i) {
      exists(int j |
        result = this.getChildTree(j) and
        j = rank[i + 1](int k | exists(this.getChildTree(k)))
      )
    }

    ControlFlowTree getFirstChildTree() { result = this.getChildTreeRanked(0) }

    ControlFlowTree getLastChildTree() {
      result = max(ControlFlowTree ch, int j | ch = this.getChildTree(j) | ch order by j)
    }

    ControlFlowTree getChildTree(int i) { none() }
  }

  private class AtomicTree extends ControlFlowTree {
    ControlFlow::Node nd;
    Completion cmpl;

    AtomicTree() {
      exists(Expr e |
        e = this and
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
      firstNode(this.getFirstChildTree(), first)
      or
      not exists(this.getChildTree(_)) and
      first = this.getNode()
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      super.lastNode(last, cmpl)
      or
      last = this.getNode() and cmpl = this.getCompletion()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      super.succ(pred, succ)
      or
      lastNode(this.getLastChildTree(), pred, normalCompletion()) and
      succ = this.getNode()
    }
  }

  abstract private class PreOrderTree extends ControlFlowTree {
    abstract ControlFlow::Node getNode();

    override predicate firstNode(ControlFlow::Node first) { first = this.getNode() }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      super.lastNode(last, cmpl)
      or
      lastNode(this.getLastChildTree(), last, cmpl)
      or
      not exists(this.getChildTree(_)) and
      last = this.getNode() and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      super.succ(pred, succ)
      or
      pred = this.getNode() and
      firstNode(this.getFirstChildTree(), succ)
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

    override predicate firstNode(ControlFlow::Node first) {
      firstNode(this.getFirstChildTree(), first)
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      super.lastNode(last, cmpl)
      or
      lastNode(this.getLastChildTree(), last, cmpl)
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

    predicate isExtractingAssign() { this.getNumRhs() = 1 and this.getNumLhs() > 1 }

    override predicate firstNode(ControlFlow::Node first) {
      not this instanceof RecvStmt and
      firstNode(this.getLhs(0), first)
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      (
        last = max(int i | | this.epilogueNode(i) order by i)
        or
        not exists(this.epilogueNode(_)) and
        lastNode(this.getLastSubExprInEvalOrder(), last, normalCompletion())
      ) and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      exists(int i | lastNode(this.getLhs(i), pred, normalCompletion()) |
        firstNode(this.getLhs(i + 1), succ)
        or
        not this instanceof RecvStmt and
        i = this.getNumLhs() - 1 and
        (
          firstNode(this.getRhs(0), succ)
          or
          not exists(this.getRhs(_)) and
          succ = this.epilogueNodeRanked(0)
        )
      )
      or
      exists(int i |
        lastNode(this.getRhs(i), pred, normalCompletion()) and
        firstNode(this.getRhs(i + 1), succ)
      )
      or
      not this instanceof RecvStmt and
      lastNode(this.getRhs(this.getNumRhs() - 1), pred, normalCompletion()) and
      succ = this.epilogueNodeRanked(0)
      or
      exists(int i |
        pred = this.epilogueNodeRanked(i) and
        succ = this.epilogueNodeRanked(i + 1)
      )
    }

    ControlFlow::Node epilogueNodeRanked(int i) {
      exists(int j |
        result = this.epilogueNode(j) and
        j = rank[i + 1](int k | exists(this.epilogueNode(k)))
      )
    }

    private Expr getSubExprInEvalOrder(int evalOrder) {
      if evalOrder < this.getNumLhs()
      then result = this.getLhs(evalOrder)
      else result = this.getRhs(evalOrder - this.getNumLhs())
    }

    private Expr getLastSubExprInEvalOrder() {
      result = max(int i | | this.getSubExprInEvalOrder(i) order by i)
    }

    private ControlFlow::Node epilogueNode(int i) {
      i = -1 and
      result = MkCompoundAssignRhsNode(this)
      or
      exists(int j |
        result = MkExtractNode(this, j) and
        i = 2 * j
        or
        result = MkZeroInitNode(any(ValueEntity v | this.getLhs(j) = v.getDeclaration())) and
        i = 2 * j
        or
        result = MkAssignNode(this, j) and
        i = 2 * j + 1
      )
    }
  }

  private class BinaryExprTree extends PostOrderTree, BinaryExpr {
    override ControlFlow::Node getNode() { result = MkExprNode(this) }

    private predicate equalityTestMayPanic() {
      this instanceof EqualityTestExpr and
      exists(Type t |
        t = this.getAnOperand().getType().getUnderlyingType() and
        (
          t instanceof InterfaceType or // panic due to comparison of incomparable interface values
          t instanceof StructType or // may contain an interface-typed field
          t instanceof ArrayType // may be an array of interface values
        )
      )
    }

    override Completion getCompletion() {
      result = PostOrderTree.super.getCompletion()
      or
      // runtime panic due to division by zero or comparison of incomparable interface values
      (this instanceof DivExpr or this.equalityTestMayPanic()) and
      not this.(Expr).isConst() and
      result = Panic()
    }

    override ControlFlowTree getChildTree(int i) {
      i = 0 and result = this.getLeftOperand()
      or
      i = 1 and result = this.getRightOperand()
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
      result = MkConditionGuardNode(this.getLeftOperand(), outcome)
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      lastNode(this.getAnOperand(), last, cmpl) and
      not cmpl.isNormal()
      or
      if isCond(this)
      then (
        last = this.getGuard(shortCircuit) and
        cmpl = Bool(shortCircuit)
        or
        lastNode(this.getRightOperand(), last, cmpl)
      ) else (
        last = MkExprNode(this) and
        cmpl = Done()
      )
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      exists(Completion lcmpl |
        lastNode(this.getLeftOperand(), pred, lcmpl) and
        succ = this.getGuard(lcmpl.getOutcome())
      )
      or
      pred = this.getGuard(shortCircuit.booleanNot()) and
      firstNode(this.getRightOperand(), succ)
      or
      not isCond(this) and
      (
        pred = this.getGuard(shortCircuit) and
        succ = MkExprNode(this)
        or
        exists(Completion rcmpl |
          lastNode(this.getRightOperand(), pred, rcmpl) and
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
      not this.isSpecial() and
      result = MkExprNode(this)
    }

    override Completion getCompletion() {
      (not exists(this.getTarget()) or this.getTarget().mayReturnNormally()) and
      result = Done()
      or
      (not exists(this.getTarget()) or this.getTarget().mayPanic()) and
      result = Panic()
    }

    override ControlFlowTree getChildTree(int i) {
      i = 0 and result = this.getCalleeExpr()
      or
      result = this.getArgument(i - 1) and
      // calls to `make` and `new` can have type expressions as arguments
      not result instanceof TypeExpr
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      // interpose implicit argument destructuring nodes between last argument
      // and call itself; this is for cases like `f(g())` where `g` has multiple
      // results
      exists(ControlFlow::Node mid | PostOrderTree.super.succ(pred, mid) |
        if mid = this.getNode() then succ = this.getEpilogueNode(0) else succ = mid
      )
      or
      exists(int i |
        pred = this.getEpilogueNode(i) and
        succ = this.getEpilogueNode(i + 1)
      )
    }

    private ControlFlow::Node getEpilogueNode(int i) {
      result = MkExtractNode(this, i)
      or
      i = max(int j | exists(MkExtractNode(this, j))) + 1 and
      result = this.getNode()
      or
      not exists(MkExtractNode(this, _)) and
      i = 0 and
      result = this.getNode()
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      PostOrderTree.super.lastNode(last, cmpl)
      or
      this.isSpecial() and
      lastNode(this.getLastChildTree(), last, cmpl)
    }
  }

  private class CaseClauseTree extends ControlFlowTree, CaseClause {
    private ControlFlow::Node getExprStart(int i) {
      firstNode(this.getExpr(i), result)
      or
      this.getExpr(i) instanceof TypeExpr and
      result = MkCaseCheckNode(this, i)
    }

    ControlFlow::Node getExprEnd(int i, Boolean outcome) {
      exists(Expr e | e = this.getExpr(i) |
        result = MkConditionGuardNode(e, outcome)
        or
        not exists(MkConditionGuardNode(e, _)) and
        result = MkCaseCheckNode(this, i)
      )
    }

    private ControlFlow::Node getBodyStart() {
      firstNode(this.getStmt(0), result) or result = MkSkipNode(this)
    }

    override predicate firstNode(ControlFlow::Node first) {
      first = this.getExprStart(0)
      or
      not exists(this.getAnExpr()) and
      first = this.getBodyStart()
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      // TODO: shouldn't be here
      last = this.getExprEnd(this.getNumExpr() - 1, false) and
      cmpl = Bool(false)
      or
      last = MkSkipNode(this) and
      cmpl = Done()
      or
      lastNode(this.getStmt(this.getNumStmt() - 1), last, cmpl)
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      exists(int i |
        lastNode(this.getExpr(i), pred, normalCompletion()) and
        succ = MkCaseCheckNode(this, i)
        or
        // visit guard node if there is one
        pred = MkCaseCheckNode(this, i) and
        succ = this.getExprEnd(i, _) and
        succ != pred // this avoids self-loops if there isn't a guard node
        or
        pred = this.getExprEnd(i, false) and
        succ = this.getExprStart(i + 1)
        or
        this.isPassingEdge(i, pred, succ, _)
      )
    }

    predicate isPassingEdge(int i, ControlFlow::Node pred, ControlFlow::Node succ, Expr testExpr) {
      pred = this.getExprEnd(i, true) and
      succ = this.getBodyStart() and
      testExpr = this.getExpr(i)
    }

    override ControlFlowTree getChildTree(int i) { result = this.getStmt(i) }
  }

  private class CommClauseTree extends ControlFlowTree, CommClause {
    override predicate firstNode(ControlFlow::Node first) { firstNode(this.getComm(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      last = MkSkipNode(this) and
      cmpl = Done()
      or
      lastNode(this.getStmt(this.getNumStmt() - 1), last, cmpl)
    }

    override ControlFlowTree getChildTree(int i) { result = this.getStmt(i) }
  }

  private class CompositeLiteralTree extends ControlFlowTree, CompositeLit {
    private ControlFlow::Node getElementInit(int i) {
      result = MkLiteralElementInitNode(this.getElement(i))
    }

    private ControlFlow::Node getElementStart(int i) {
      exists(Expr elt | elt = this.getElement(i) |
        result = MkImplicitLiteralElementIndex(elt)
        or
        (elt instanceof KeyValueExpr or this instanceof StructLit) and
        firstNode(this.getElement(i), result)
      )
    }

    override predicate firstNode(ControlFlow::Node first) { first = MkExprNode(this) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      last = this.getElementInit(this.getNumElement() - 1) and
      cmpl = Done()
      or
      not exists(this.getElement(_)) and
      last = MkExprNode(this) and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      this.firstNode(pred) and
      succ = this.getElementStart(0)
      or
      exists(int i |
        pred = MkImplicitLiteralElementIndex(this.getElement(i)) and
        firstNode(this.getElement(i), succ)
        or
        lastNode(this.getElement(i), pred, normalCompletion()) and
        succ = this.getElementInit(i)
        or
        pred = this.getElementInit(i) and
        succ = this.getElementStart(i + 1)
      )
    }
  }

  private class ConversionExprTree extends PostOrderTree, ConversionExpr {
    override Completion getCompletion() {
      // conversions of a slice to an array pointer are the only kind that may panic
      this.getType().(PointerType).getBaseType() instanceof ArrayType and
      result = Panic()
      or
      result = Done()
    }

    override ControlFlow::Node getNode() { result = MkExprNode(this) }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = this.getOperand() }
  }

  private class DeferStmtTree extends PostOrderTree, DeferStmt {
    override ControlFlow::Node getNode() { result = MkDeferNode(this) }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = this.getCall() }
  }

  private class FuncDeclTree extends PostOrderTree, FuncDecl {
    override ControlFlow::Node getNode() { result = MkFuncDeclNode(this) }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = this.getNameExpr() }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      // override to prevent panic propagation out of function declarations
      last = this.getNode() and cmpl = Done()
    }
  }

  private class GoStmtTree extends PostOrderTree, GoStmt {
    override ControlFlow::Node getNode() { result = MkGoNode(this) }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = this.getCall() }
  }

  private class IfStmtTree extends ControlFlowTree, IfStmt {
    private ControlFlow::Node getGuard(boolean outcome) {
      result = MkConditionGuardNode(this.getCond(), outcome)
    }

    override predicate firstNode(ControlFlow::Node first) {
      firstNode(this.getInit(), first)
      or
      not exists(this.getInit()) and
      firstNode(this.getCond(), first)
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      lastNode(this.getThen(), last, cmpl)
      or
      lastNode(this.getElse(), last, cmpl)
      or
      not exists(this.getElse()) and
      last = this.getGuard(false) and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      lastNode(this.getInit(), pred, normalCompletion()) and
      firstNode(this.getCond(), succ)
      or
      exists(Completion condCmpl |
        lastNode(this.getCond(), pred, condCmpl) and
        succ = MkConditionGuardNode(this.getCond(), condCmpl.getOutcome())
      )
      or
      pred = this.getGuard(true) and
      firstNode(this.getThen(), succ)
      or
      pred = this.getGuard(false) and
      firstNode(this.getElse(), succ)
    }
  }

  private class IndexExprTree extends ControlFlowTree, IndexExpr {
    override predicate firstNode(ControlFlow::Node first) { firstNode(this.getBase(), first) }

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
      lastNode(this.getBase(), pred, normalCompletion()) and
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
      lastNode(this.getIndex(), pred, normalCompletion()) and
      succ = mkExprOrSkipNode(this)
    }
  }

  private class LoopTree extends ControlFlowTree, LoopStmt {
    BranchTarget getLabel() { result = BranchTarget::of(this) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      exists(Completion inner | lastNode(this.getBody(), last, inner) and not inner.isNormal() |
        if inner = Break(this.getLabel())
        then cmpl = Done()
        else
          if inner = Continue(this.getLabel())
          then none()
          else cmpl = inner
      )
    }
  }

  private class FileTree extends ControlFlowTree, File {
    FileTree() { exists(this.getADecl()) }

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
        i = this.getNumDecl() - 1
      ) and
      succ = MkExitNode(this)
    }

    override ControlFlowTree getChildTree(int i) { result = this.getDecl(i) }
  }

  private class ForTree extends LoopTree, ForStmt {
    private ControlFlow::Node getGuard(boolean outcome) {
      result = MkConditionGuardNode(this.getCond(), outcome)
    }

    override predicate firstNode(ControlFlow::Node first) {
      firstNode(this.getFirstChildTree(), first)
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      LoopTree.super.lastNode(last, cmpl)
      or
      lastNode(this.getInit(), last, cmpl) and
      not cmpl.isNormal()
      or
      lastNode(this.getCond(), last, cmpl) and
      not cmpl.isNormal()
      or
      lastNode(this.getPost(), last, cmpl) and
      not cmpl.isNormal()
      or
      last = this.getGuard(false) and
      cmpl = Done()
    }

    override ControlFlowTree getChildTree(int i) {
      i = 0 and result = this.getInit()
      or
      i = 1 and result = this.getCond()
      or
      i = 2 and result = this.getBody()
      or
      i = 3 and result = this.getPost()
      or
      i = 4 and result = this.getCond()
      or
      i = 5 and result = this.getBody()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      exists(int i, ControlFlowTree predTree, Completion cmpl |
        predTree = this.getChildTreeRanked(i) and
        lastNode(predTree, pred, cmpl) and
        cmpl.isNormal()
      |
        if predTree = this.getCond()
        then succ = this.getGuard(cmpl.getOutcome())
        else firstNode(this.getChildTreeRanked(i + 1), succ)
      )
      or
      pred = this.getGuard(true) and
      firstNode(this.getBody(), succ)
    }
  }

  private class FuncDefTree extends ControlFlowTree, FuncDef {
    FuncDefTree() { exists(this.getBody()) }

    pragma[noinline]
    private MkEntryNode getEntry() { result = MkEntryNode(this) }

    private Parameter getParameterRanked(int i) {
      result = rank[i + 1](Parameter p, int j | p = this.getParameter(j) | p order by j)
    }

    private ControlFlow::Node getPrologueNode(int i) {
      i = -1 and result = this.getEntry()
      or
      exists(int numParm, int numRes |
        numParm = count(this.getParameter(_)) and
        numRes = count(this.getResultVar(_))
      |
        exists(int j, Parameter p | p = this.getParameterRanked(j) |
          i = 2 * j and result = MkArgumentNode(p)
          or
          i = 2 * j + 1 and result = MkParameterInit(p)
        )
        or
        exists(int j, ResultVariable v | v = this.getResultVar(j) |
          i = 2 * numParm + 2 * j and
          result = MkZeroInitNode(v)
          or
          i = 2 * numParm + 2 * j + 1 and
          result = MkResultInit(v)
        )
        or
        i = 2 * numParm + 2 * numRes and
        firstNode(this.getBody(), result)
      )
    }

    private ControlFlow::Node getEpilogueNode(int i) {
      result = MkResultReadNode(this.getResultVar(i))
      or
      i = count(this.getAResultVar()) and
      result = MkExitNode(this)
    }

    pragma[noinline]
    private predicate firstDefer(ControlFlow::Node nd) {
      exists(DeferStmt defer |
        nd = MkExprNode(defer.getCall()) and
        // `defer` can be the first `defer` statement executed
        // there is always a predecessor node because the `defer`'s call is always
        // evaluated before the defer statement itself
        MkDeferNode(defer) = succ(notDeferSucc*(this.getEntry()))
      )
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) { none() }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      exists(int i |
        pred = this.getPrologueNode(i) and
        succ = this.getPrologueNode(i + 1)
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
        pred = notDeferSucc*(this.getEntry())
      |
        // panic goes directly to exit, non-panic reads result variables first
        if cmpl = Panic() then succ = MkExitNode(this) else succ = this.getEpilogueNode(0)
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
      this.firstDefer(pred) and
      (
        // conservatively assume that we might either panic (and hence skip the result reads)
        // or not
        succ = MkExitNode(this)
        or
        succ = this.getEpilogueNode(0)
      )
      or
      exists(int i |
        pred = this.getEpilogueNode(i) and
        succ = this.getEpilogueNode(i + 1)
      )
    }
  }

  private class GotoTree extends ControlFlowTree, GotoStmt {
    override predicate firstNode(ControlFlow::Node first) { first = MkSkipNode(this) }
  }

  private class IncDecTree extends ControlFlowTree, IncDecStmt {
    override predicate firstNode(ControlFlow::Node first) { firstNode(this.getOperand(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      last = MkIncDecNode(this) and
      cmpl = Done()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      lastNode(this.getOperand(), pred, normalCompletion()) and
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
    override predicate firstNode(ControlFlow::Node first) { firstNode(this.getDomain(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      LoopTree.super.lastNode(last, cmpl)
      or
      last = MkNextNode(this) and
      cmpl = Done()
      or
      lastNode(this.getKey(), last, cmpl) and
      not cmpl.isNormal()
      or
      lastNode(this.getValue(), last, cmpl) and
      not cmpl.isNormal()
      or
      lastNode(this.getDomain(), last, cmpl) and
      not cmpl.isNormal()
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      lastNode(this.getDomain(), pred, normalCompletion()) and
      succ = MkNextNode(this)
      or
      pred = MkNextNode(this) and
      (
        firstNode(this.getKey(), succ)
        or
        not exists(this.getKey()) and
        firstNode(this.getBody(), succ)
      )
      or
      lastNode(this.getKey(), pred, normalCompletion()) and
      (
        firstNode(this.getValue(), succ)
        or
        not exists(this.getValue()) and
        succ = MkExtractNode(this, 0)
      )
      or
      lastNode(this.getValue(), pred, normalCompletion()) and
      succ = MkExtractNode(this, 0)
      or
      pred = MkExtractNode(this, 0) and
      (
        if exists(this.getValue())
        then succ = MkExtractNode(this, 1)
        else
          if exists(MkAssignNode(this, 0))
          then succ = MkAssignNode(this, 0)
          else
            if exists(MkAssignNode(this, 1))
            then succ = MkAssignNode(this, 1)
            else firstNode(this.getBody(), succ)
      )
      or
      pred = MkExtractNode(this, 1) and
      (
        if exists(MkAssignNode(this, 0))
        then succ = MkAssignNode(this, 0)
        else
          if exists(MkAssignNode(this, 1))
          then succ = MkAssignNode(this, 1)
          else firstNode(this.getBody(), succ)
      )
      or
      pred = MkAssignNode(this, 0) and
      (
        if exists(MkAssignNode(this, 1))
        then succ = MkAssignNode(this, 1)
        else firstNode(this.getBody(), succ)
      )
      or
      pred = MkAssignNode(this, 1) and
      firstNode(this.getBody(), succ)
      or
      exists(Completion inner |
        lastNode(this.getBody(), pred, inner) and
        (inner.isNormal() or inner = Continue(BranchTarget::of(this))) and
        succ = MkNextNode(this)
      )
    }
  }

  private class RecvStmtTree extends ControlFlowTree, RecvStmt {
    override predicate firstNode(ControlFlow::Node first) {
      firstNode(this.getExpr().getOperand(), first)
    }
  }

  private class ReturnStmtTree extends PostOrderTree, ReturnStmt {
    override ControlFlow::Node getNode() { result = MkReturnNode(this) }

    override Completion getCompletion() { result = Return() }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      exists(int i |
        lastNode(this.getExpr(i), pred, normalCompletion()) and
        succ = this.complete(i)
        or
        pred = MkExtractNode(this, i) and
        succ = this.after(i)
        or
        pred = MkResultWriteNode(_, i, this) and
        succ = this.next(i)
      )
    }

    private ControlFlow::Node complete(int i) {
      result = MkExtractNode(this, i)
      or
      not exists(MkExtractNode(this, _)) and
      result = this.after(i)
    }

    private ControlFlow::Node after(int i) {
      result = MkResultWriteNode(_, i, this)
      or
      not exists(MkResultWriteNode(_, i, this)) and
      result = this.next(i)
    }

    private ControlFlow::Node next(int i) {
      firstNode(this.getExpr(i + 1), result)
      or
      exists(MkExtractNode(this, _)) and
      result = this.complete(i + 1)
      or
      i + 1 = this.getEnclosingFunction().getType().getNumResult() and
      result = this.getNode()
    }

    override ControlFlowTree getChildTree(int i) { result = this.getExpr(i) }
  }

  private class SelectStmtTree extends ControlFlowTree, SelectStmt {
    private BranchTarget getLabel() { result = BranchTarget::of(this) }

    override predicate firstNode(ControlFlow::Node first) {
      firstNode(this.getNonDefaultCommClause(0), first)
      or
      this.getNumNonDefaultCommClause() = 0 and
      first = MkSelectNode(this)
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      exists(Completion inner | lastNode(this.getACommClause(), last, inner) |
        if inner = Break(this.getLabel()) then cmpl = Done() else cmpl = inner
      )
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      exists(CommClause cc, int i, Stmt comm |
        cc = this.getNonDefaultCommClause(i) and
        comm = cc.getComm() and
        (
          comm instanceof RecvStmt and
          lastNode(comm.(RecvStmt).getExpr().getOperand(), pred, normalCompletion())
          or
          comm instanceof SendStmt and
          lastNode(comm.(SendStmt).getValue(), pred, normalCompletion())
        )
      |
        firstNode(this.getNonDefaultCommClause(i + 1), succ)
        or
        i = this.getNumNonDefaultCommClause() - 1 and
        succ = MkSelectNode(this)
      )
      or
      pred = MkSelectNode(this) and
      exists(CommClause cc, Stmt comm |
        cc = this.getNonDefaultCommClause(_) and comm = cc.getComm()
      |
        comm instanceof RecvStmt and
        succ = MkExprNode(comm.(RecvStmt).getExpr())
        or
        comm instanceof SendStmt and
        succ = MkSendNode(comm)
      )
      or
      pred = MkSelectNode(this) and
      exists(CommClause cc | cc = this.getDefaultCommClause() |
        firstNode(cc.getStmt(0), succ)
        or
        succ = MkSkipNode(cc)
      )
      or
      exists(CommClause cc, RecvStmt recv | cc = this.getCommClause(_) and recv = cc.getComm() |
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
        cc = this.getCommClause(_) and
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
    SelectorExprTree() { this.getBase() instanceof ValueExpr }

    override predicate firstNode(ControlFlow::Node first) { firstNode(this.getBase(), first) }

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
      exists(int i | pred = this.getStepWithRank(i) and succ = this.getStepWithRank(i + 1))
    }

    private ControlFlow::Node getStepOrdered(int i) {
      i = -2 and lastNode(this.getBase(), result, normalCompletion())
      or
      i = -1 and result = MkImplicitDeref(this.getBase())
      or
      exists(int maxIndex |
        maxIndex = max(int k | k = 0 or exists(MkImplicitFieldSelection(this, k, _)))
      |
        result = MkImplicitFieldSelection(this, maxIndex - i, _)
        or
        i = maxIndex and
        result = mkExprOrSkipNode(this)
      )
    }

    private ControlFlow::Node getStepWithRank(int i) {
      exists(int j |
        result = this.getStepOrdered(j) and
        j = rank[i + 1](int k | exists(this.getStepOrdered(k)))
      )
    }
  }

  private class SendStmtTree extends ControlFlowTree, SendStmt {
    override predicate firstNode(ControlFlow::Node first) { firstNode(this.getChannel(), first) }

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
      lastNode(this.getValue(), pred, normalCompletion()) and
      succ = MkSendNode(this)
    }

    override ControlFlowTree getChildTree(int i) {
      i = 0 and result = this.getChannel()
      or
      i = 1 and result = this.getValue()
    }
  }

  private class SliceExprTree extends ControlFlowTree, SliceExpr {
    override predicate firstNode(ControlFlow::Node first) { firstNode(this.getBase(), first) }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      ControlFlowTree.super.lastNode(last, cmpl)
      or
      // panic due to `nil` dereference
      last = MkImplicitDeref(this.getBase()) and
      cmpl = Panic()
      or
      last = MkExprNode(this) and
      (cmpl = Done() or cmpl = Panic())
    }

    override predicate succ(ControlFlow::Node pred, ControlFlow::Node succ) {
      ControlFlowTree.super.succ(pred, succ)
      or
      lastNode(this.getBase(), pred, normalCompletion()) and
      (
        succ = MkImplicitDeref(this.getBase())
        or
        not exists(MkImplicitDeref(this.getBase())) and
        (firstNode(this.getLow(), succ) or succ = MkImplicitLowerSliceBound(this))
      )
      or
      pred = MkImplicitDeref(this.getBase()) and
      (firstNode(this.getLow(), succ) or succ = MkImplicitLowerSliceBound(this))
      or
      (lastNode(this.getLow(), pred, normalCompletion()) or pred = MkImplicitLowerSliceBound(this)) and
      (firstNode(this.getHigh(), succ) or succ = MkImplicitUpperSliceBound(this))
      or
      (lastNode(this.getHigh(), pred, normalCompletion()) or pred = MkImplicitUpperSliceBound(this)) and
      (firstNode(this.getMax(), succ) or succ = MkImplicitMaxSliceBound(this))
      or
      (lastNode(this.getMax(), pred, normalCompletion()) or pred = MkImplicitMaxSliceBound(this)) and
      succ = MkExprNode(this)
    }
  }

  private class StarExprTree extends PostOrderTree, StarExpr {
    override ControlFlow::Node getNode() { result = mkExprOrSkipNode(this) }

    override Completion getCompletion() { result = Done() or result = Panic() }

    override ControlFlowTree getChildTree(int i) { i = 0 and result = this.getBase() }
  }

  private class SwitchTree extends ControlFlowTree, SwitchStmt {
    override predicate firstNode(ControlFlow::Node first) {
      firstNode(this.getInit(), first)
      or
      not exists(this.getInit()) and
      (
        firstNode(this.(ExpressionSwitchStmt).getExpr(), first)
        or
        first = MkImplicitTrue(this)
        or
        firstNode(this.(TypeSwitchStmt).getTest(), first)
      )
    }

    override predicate lastNode(ControlFlow::Node last, Completion cmpl) {
      lastNode(this.getInit(), last, cmpl) and
      not cmpl.isNormal()
      or
      (
        lastNode(this.(ExpressionSwitchStmt).getExpr(), last, cmpl)
        or
        lastNode(this.(TypeSwitchStmt).getTest(), last, cmpl)
      ) and
      (
        not cmpl.isNormal()
        or
        not exists(this.getDefault())
      )
      or
      last = MkImplicitTrue(this) and
      cmpl = Bool(true) and
      this.getNumCase() = 0
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
      lastNode(this.getInit(), pred, normalCompletion()) and
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
        firstNode(this.getNonDefaultCase(0), succ)
        or
        not exists(this.getANonDefaultCase()) and
        firstNode(this.getDefault(), succ)
      )
      or
      exists(CaseClause cc, int i |
        cc = this.getNonDefaultCase(i) and
        lastNode(cc, pred, normalCompletion()) and
        pred = cc.(CaseClauseTree).getExprEnd(_, false)
      |
        firstNode(this.getNonDefaultCase(i + 1), succ)
        or
        i = this.getNumNonDefaultCase() - 1 and
        firstNode(this.getDefault(), succ)
      )
      or
      exists(CaseClause cc, int i, CaseClause next |
        cc = this.getCase(i) and
        lastNode(cc, pred, Fallthrough()) and
        next = this.getCase(i + 1)
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

    override ControlFlowTree getChildTree(int i) { i = 0 and result = this.getExpr() }
  }

  private class UnaryExprTree extends ControlFlowTree, UnaryExpr {
    override predicate firstNode(ControlFlow::Node first) { firstNode(this.getOperand(), first) }

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
      lastNode(this.getOperand(), pred, normalCompletion()) and
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

  /**
   * Holds if the function `f` may return without panicking, exiting the process, or looping forever.
   *
   * This is defined conservatively, and so may also hold of a function that in fact
   * cannot return normally, but never fails to hold of a function that can return normally.
   */
  cached
  predicate mayReturnNormally(ControlFlowTree root) {
    exists(ControlFlow::Node last, Completion cmpl | lastNode(root, last, cmpl) and cmpl != Panic())
  }

  /**
   * Holds if `pred` is the node for the case `testExpr` in an expression
   * switch statement which is switching on `switchExpr`, and `succ` is the
   * node to be executed next if the case test succeeds.
   */
  cached
  predicate isSwitchCaseTestPassingEdge(
    ControlFlow::Node pred, ControlFlow::Node succ, Expr switchExpr, Expr testExpr
  ) {
    exists(ExpressionSwitchStmt ess | ess.getExpr() = switchExpr |
      ess.getACase().(CaseClauseTree).isPassingEdge(_, pred, succ, testExpr)
    )
  }

  /** Gets a successor of `nd`, that is, a node that is executed after `nd`. */
  cached
  ControlFlow::Node succ(ControlFlow::Node nd) { any(ControlFlowTree tree).succ(nd, result) }
}
