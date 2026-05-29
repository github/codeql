private import rust
private import codeql.namebinding.LocalNameBinding
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.internal.PathResolution as PathResolution
private import codeql.rust.elements.internal.generated.ParentChild as ParentChild
private import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
private import codeql.rust.elements.internal.PathImpl::Impl as PathImpl
private import codeql.rust.elements.internal.FormatTemplateVariableAccessImpl::Impl as FormatTemplateVariableAccessImpl

module Impl {
  private Pat getAPatAncestor(Pat p) {
    (p instanceof IdentPat or p instanceof OrPat) and
    exists(Pat p0 | result = p0.getParentPat() |
      p0 = p
      or
      p0 = getAPatAncestor(p) and
      not p0 instanceof OrPat
    )
  }

  /** Gets the immediately enclosing `|` pattern of `p`, if any */
  private OrPat getEnclosingOrPat(Pat p) { result = getAPatAncestor(p) }

  /** Gets the outermost enclosing `|` pattern parent of `p`, if any. */
  private OrPat getOutermostEnclosingOrPat(IdentPat p) {
    result = getEnclosingOrPat+(p) and
    not exists(getEnclosingOrPat(result))
  }

  /**
   * Holds if `name` declares a variable named `text` at `definingNode`.
   * Normally, `definingNode = name`, except in cases like
   *
   * ```rust
   * match either {
   *     Either::Left(x) | Either::Right(x) => println!(x),
   * }
   * ```
   *
   * where `definingNode` is the entire `Either::Left(x) | Either::Right(x)`
   * pattern.
   */
  cached
  predicate variableDecl(AstNode definingNode, Name name, string text) {
    CachedStage::ref() and
    exists(SelfParam sp |
      name = sp.getName() and
      definingNode = name and
      text = name.getText() and
      // exclude self parameters from functions without a body as these are
      // trait method declarations without implementations
      not exists(Function f | not f.hasBody() and f.getSelfParam() = sp)
    )
    or
    exists(IdentPat pat |
      name = pat.getName() and
      (
        definingNode = getOutermostEnclosingOrPat(pat)
        or
        not exists(getOutermostEnclosingOrPat(pat)) and definingNode = name
      ) and
      text = name.getText() and
      not PathResolution::identPatIsResolvable(pat) and
      // exclude parameters from functions without a body as these are trait method declarations
      // without implementations
      not exists(Function f | not f.hasBody() and f.getAParam().getPat() = pat) and
      // exclude parameters from function pointer types (e.g. `x` in `fn(x: i32) -> i32`)
      not exists(FnPtrTypeRepr fp | fp.getParamList().getAParam().getPat() = pat)
    )
  }

  /**
   * `let` chains like
   *
   * ```rust
   * if let x1 = ... && let x2 = ... && ... && let xn = ...  { ... }
   * ```
   *
   * are parsed left-associatively, so the AST for the condition looks like
   *
   * ```rust
   * ((let x1 = ... && let x2 = ...) && ...) && let xn = ...
   * ```
   *
   * This, however, does not work with scoping and shadowing, so we instead treat
   * `let` chains as if there is just a single root `&&` node with `n` children,
   * skipping all intermediate `&&` nodes.
   */
  private module LetChains {
    predicate isLetChainAncestor(LogicalAndExpr lae) {
      lae.getAnOperand() instanceof LetExpr
      or
      isLetChainAncestor(lae.getLhs())
    }

    private predicate isLetChainRoot(LogicalAndExpr root) {
      isLetChainAncestor(root) and
      not root = any(LogicalAndExpr lae).getLhs()
    }

    private predicate leftMostChildOfLetChainRoot(LogicalAndExpr left, LogicalAndExpr root) {
      isLetChainRoot(root) and
      left = root.getLhs*() and
      not left.getLhs() instanceof LogicalAndExpr
    }

    private AstNode getLetChainChild(LogicalAndExpr sub, LogicalAndExpr root, int i) {
      leftMostChildOfLetChainRoot(sub, root) and
      i = 1 and
      result = sub.getRhs()
      or
      exists(LogicalAndExpr mid |
        exists(getLetChainChild(mid, root, i - 1)) and
        sub.getLhs() = mid and
        result = sub.getRhs()
      )
    }

    AstNode getLetChainChild(LogicalAndExpr lae, int i) {
      exists(LogicalAndExpr left |
        leftMostChildOfLetChainRoot(left, lae) and
        i = 0 and
        result = left.getLhs()
      )
      or
      result = getLetChainChild(_, lae, i)
    }
  }

  private import LetChains

  private module Input implements LocalNameBindingInputSig<Location> {
    private import rust as Rust

    predicate cacheRevRef() {
      (variableDecl(_, _, _) implies any())
      or
      (exists(VariableReadAccess a) implies any())
      or
      (exists(VariableWriteAccess a) implies any())
      or
      (exists(any(Variable v).getParameter()) implies any())
    }

    class AstNode = Rust::AstNode;

    AstNode getChild(AstNode parent, int index) {
      result = ParentChild::getImmediateChild(parent, index) and
      not isLetChainAncestor(parent)
      or
      result = getLetChainChild(parent, index)
      or
      exists(Format f |
        f = result.(FormatTemplateVariableAccess).getArgument().getParent() and
        parent = f.getParent() and
        index = f.getIndex()
      )
    }

    abstract class Conditional extends AstNode {
      abstract AstNode getCondition();

      abstract AstNode getThen();

      abstract AstNode getElse();
    }

    private class IfExprConditional extends Conditional instanceof IfExpr {
      override AstNode getCondition() { result = IfExpr.super.getCondition() }

      override AstNode getThen() { result = IfExpr.super.getThen() }

      override AstNode getElse() { result = IfExpr.super.getElse() }
    }

    private class WhileExprConditional extends Conditional instanceof WhileExpr {
      override AstNode getCondition() { result = WhileExpr.super.getCondition() }

      override AstNode getThen() { result = WhileExpr.super.getLoopBody() }

      override AstNode getElse() { none() }
    }

    private class MatchGuardConditional extends Conditional instanceof MatchGuard {
      override AstNode getCondition() { result = MatchGuard.super.getCondition() }

      override AstNode getThen() {
        exists(MatchArm arm | this = arm.getGuard() and result = arm.getExpr())
      }

      override AstNode getElse() { none() }
    }

    abstract class SiblingShadowingDecl extends AstNode {
      abstract AstNode getLhs();

      abstract AstNode getRhs();

      abstract AstNode getElse();
    }

    private class LetStmtSiblingShadowingDecl extends SiblingShadowingDecl instanceof LetStmt {
      override AstNode getLhs() { result = LetStmt.super.getPat() }

      override AstNode getRhs() { result = LetStmt.super.getInitializer() }

      override AstNode getElse() { result = LetStmt.super.getLetElse() }
    }

    private class LetExprSiblingShadowingDecl extends SiblingShadowingDecl instanceof LetExpr {
      override AstNode getLhs() { result = LetExpr.super.getPat() }

      override AstNode getRhs() { result = LetExpr.super.getScrutinee() }

      override AstNode getElse() { none() }
    }

    predicate declInScope(AstNode definingNode, string name, AstNode scope) {
      // local variable
      exists(Name n | variableDecl(definingNode, n, name) |
        scope = any(SelfParam self | n = self.getName()).getCallable()
        or
        exists(Pat pat, Pat pat0 |
          pat = getAPatAncestor*(pat0) and
          (pat0 = definingNode or pat0.(IdentPat).getName() = n)
        |
          scope = any(MatchArm arm | pat = arm.getPat())
          or
          scope = any(Input::SiblingShadowingDecl let | pat = let.getLhs())
          or
          scope = any(ForExpr fe | pat = fe.getPat()).getLoopBody()
          or
          scope = any(Param p | pat = p.getPat()).getCallable()
        )
      )
      or
      // local function; behave as if they are defined at the beginning of the scope
      definingNode = scope.(BlockExpr).getStmtList().getAStatement() and
      name = definingNode.(Function).getName().getText()
    }

    predicate accessCand(AstNode n, string name) {
      name = n.(PathExpr).getPath().(PathImpl::IdentPath).getName()
      or
      name = n.(FormatTemplateVariableAccess).getName()
    }
  }

  private import LocalNameBinding<Location, Input>

  /** A variable. */
  class Variable extends Local {
    Variable() { variableDecl(this.getDefiningNode(), _, _) }

    /** Gets an access to this variable. */
    VariableAccess getAnAccess() { result.getVariable() = this }

    /** Gets the name of this variable. */
    string getText() { result = super.getName() }

    /**
     * Get the name of this variable.
     *
     * Normally, the name is unique, except when introduced in an or pattern.
     */
    Name getName() { variableDecl(this.getDefiningNode(), result, super.getName()) }

    /** Gets the block that encloses this variable, if any. */
    BlockExpr getEnclosingBlock() { result = this.getDefiningNode().getEnclosingBlock() }

    /** Gets the `self` parameter that declares this variable, if any. */
    SelfParam getSelfParam() { result.getName() = this.getName() }

    /**
     * Gets the pattern that declares this variable, if any.
     *
     * Normally, the pattern is unique, except when introduced in an or pattern:
     *
     * ```rust
     * match either {
     *    Either::Left(x) | Either::Right(x) => println!(x),
     * }
     * ```
     */
    IdentPat getPat() { result.getName() = this.getName() }

    /** Gets the enclosing CFG scope for this variable declaration. */
    CfgScope getEnclosingCfgScope() { result = this.getDefiningNode().getEnclosingCfgScope() }

    /**
     * Gets the `let` statement that introduces this variable, if any.
     *
     * This is restricted to simple `let` statements of the form `let x = ...;`.
     */
    LetStmt getLetStmt() { this.getPat() = result.getPat() }

    /**
     * Gets the `let` expression that introduces this variable, if any.
     *
     * This is restricted to simple `let` expressions of the form `let x = ...`.
     */
    LetExpr getLetExpr() { this.getPat() = result.getPat() }

    /** Gets the initial value of this variable, if any. */
    Expr getInitializer() {
      result = this.getLetStmt().getInitializer() or
      result = this.getLetExpr().getScrutinee()
    }

    /** Holds if this variable is captured. */
    predicate isCaptured() { this.getAnAccess().isCapture() }

    /** Gets the parameter that introduces this variable, if any. */
    cached
    ParamBase getParameter() {
      CachedStage::ref() and
      result = this.getSelfParam()
      or
      result.(Param).getPat() = getAPatAncestor*(this.getPat())
    }

    /** Holds if this variable is mutable. */
    predicate isMutable() { this.getPat().isMut() or this.getSelfParam().isMut() }

    /** Holds if this variable is immutable. */
    predicate isImmutable() { not this.isMutable() }
  }

  /** A variable access. */
  class VariableAccess extends LocalAccess {
    VariableAccess() { this.getLocal() instanceof Variable }

    /** Gets the variable being accessed. */
    Variable getVariable() { result = super.getLocal() }

    /** Holds if this access is a capture. */
    predicate isCapture() {
      this.getEnclosingCfgScope() != this.getVariable().getEnclosingCfgScope()
    }
  }

  /** Holds if `e` occurs in the LHS of an assignment operation. */
  predicate assignmentOperationDescendant(AssignmentOperation ao, Expr e) {
    e = ao.getLhs()
    or
    exists(Expr mid |
      assignmentOperationDescendant(ao, mid) and
      mid = e.getParentNode() and
      not mid instanceof DerefExpr and
      not mid instanceof FieldExpr and
      not mid instanceof IndexExpr
    )
  }

  /** A variable write. */
  class VariableWriteAccess extends VariableAccess {
    private AssignmentExpr ae;

    cached
    VariableWriteAccess() {
      CachedStage::ref() and
      assignmentOperationDescendant(ae, this)
    }

    /** Gets the assignment expression that has this write access in the left-hand side. */
    AssignmentExpr getAssignmentExpr() { result = ae }
  }

  /** A variable read. */
  class VariableReadAccess extends VariableAccess {
    cached
    VariableReadAccess() {
      CachedStage::ref() and
      not this instanceof VariableWriteAccess and
      not this = any(RefExpr re).getExpr() and
      not this = any(CompoundAssignmentExpr cae).getLhs()
    }
  }

  /** A nested function access. */
  class NestedFunctionAccess extends LocalAccess {
    private Function f;

    /** Gets the function being accessed. */
    Function getFunction() { result = super.getLocal().getDefiningNode() }
  }
}
