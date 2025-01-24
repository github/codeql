private import rust
private import codeql.rust.controlflow.ControlFlowGraph
private import codeql.rust.elements.internal.generated.ParentChild
private import codeql.rust.elements.internal.PathExprBaseImpl::Impl as PathExprBaseImpl
private import codeql.rust.elements.internal.FormatTemplateVariableAccessImpl::Impl as FormatTemplateVariableAccessImpl
private import codeql.util.DenseRank

module Impl {
  /**
   * A variable scope. Either a block `{ ... }`, the guard/rhs
   * of a match arm, or the body of a closure.
   */
  abstract class VariableScope extends AstNode { }

  class BlockExprScope extends VariableScope, BlockExpr { }

  abstract class MatchArmScope extends VariableScope {
    MatchArm arm;

    bindingset[arm]
    MatchArmScope() { exists(arm) }

    Pat getPat() { result = arm.getPat() }
  }

  class MatchArmExprScope extends MatchArmScope {
    MatchArmExprScope() { this = arm.getExpr() }
  }

  class MatchArmGuardScope extends MatchArmScope {
    MatchArmGuardScope() { this = arm.getGuard() }
  }

  class ClosureBodyScope extends VariableScope {
    ClosureBodyScope() { this = any(ClosureExpr ce).getBody() }
  }

  private Pat getImmediatePatParent(AstNode n) {
    result = getImmediateParent(n)
    or
    result.(RecordPat).getRecordPatFieldList().getAField().getPat() = n
  }

  private Pat getAPatAncestor(Pat p) {
    (p instanceof IdentPat or p instanceof OrPat) and
    exists(Pat p0 | result = getImmediatePatParent(p0) |
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
   * Holds if `p` declares a variable named `name` at `definingNode`. Normally,
   * `definingNode = p`, except in cases like
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
  private predicate variableDecl(AstNode definingNode, AstNode p, string name) {
    p =
      any(SelfParam sp |
        definingNode = sp.getName() and
        name = sp.getName().getText() and
        // exclude self parameters from functions without a body as these are
        // trait method declarations without implementations
        not exists(Function f | not f.hasBody() and f.getParamList().getSelfParam() = sp)
      )
    or
    p =
      any(IdentPat pat |
        (
          definingNode = getOutermostEnclosingOrPat(pat)
          or
          not exists(getOutermostEnclosingOrPat(pat)) and definingNode = pat.getName()
        ) and
        name = pat.getName().getText() and
        // exclude for now anything starting with an uppercase character, which may be a reference to
        // an enum constant (e.g. `None`). This excludes static and constant variables (UPPERCASE),
        // which we don't appear to recognize yet anyway. This also assumes programmers follow the
        // naming guidelines, which they generally do, but they're not enforced.
        not name.charAt(0).isUppercase() and
        // exclude parameters from functions without a body as these are trait method declarations
        // without implementations
        not exists(Function f | not f.hasBody() and f.getParamList().getAParam().getPat() = pat) and
        // exclude parameters from function pointer types (e.g. `x` in `fn(x: i32) -> i32`)
        not exists(FnPtrTypeRepr fp | fp.getParamList().getParam(_).getPat() = pat)
      )
  }

  /** A variable. */
  class Variable extends MkVariable {
    private AstNode definingNode;
    private string name;

    Variable() { this = MkVariable(definingNode, name) }

    /** Gets the name of this variable. */
    string getName() { result = name }

    /** Gets the location of this variable. */
    Location getLocation() { result = definingNode.getLocation() }

    /** Gets a textual representation of this variable. */
    string toString() { result = this.getName() }

    /** Gets an access to this variable. */
    VariableAccess getAnAccess() { result.getVariable() = this }

    /** Gets the `self` parameter that declares this variable, if one exists. */
    SelfParam getSelfParam() { variableDecl(definingNode, result, name) }

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
    IdentPat getPat() { variableDecl(definingNode, result, name) }

    /** Gets the enclosing CFG scope for this variable declaration. */
    CfgScope getEnclosingCfgScope() { result = definingNode.getEnclosingCfgScope() }

    /** Gets the `let` statement that introduces this variable, if any. */
    LetStmt getLetStmt() { this.getPat() = result.getPat() }

    /** Gets the initial value of this variable, if any. */
    Expr getInitializer() { result = this.getLetStmt().getInitializer() }

    /** Holds if this variable is captured. */
    predicate isCaptured() { this.getAnAccess().isCapture() }

    /** Gets the parameter that introduces this variable, if any. */
    ParamBase getParameter() {
      result = this.getSelfParam() or result.(Param).getPat() = getAVariablePatAncestor(this)
    }

    /** Hold is this variable is mutable. */
    predicate isMutable() { this.getPat().isMut() }

    /** Hold is this variable is immutable. */
    predicate isImmutable() { not this.isMutable() }
  }

  /**
   * A path expression that may access a local variable. These are paths that
   * only consist of a simple name (i.e., without generic arguments,
   * qualifiers, etc.).
   */
  private class VariableAccessCand extends PathExprBase {
    string name_;

    VariableAccessCand() {
      exists(Path p, PathSegment ps |
        p = this.(PathExpr).getPath() and
        not p.hasQualifier() and
        ps = p.getPart() and
        not ps.hasGenericArgList() and
        not ps.hasParenthesizedArgList() and
        not ps.hasPathType() and
        not ps.hasReturnTypeSyntax() and
        name_ = ps.getNameRef().getText()
      )
      or
      this.(FormatTemplateVariableAccess).getName() = name_
    }

    string toString() { result = name_ }

    string getName() { result = name_ }
  }

  private AstNode getAnAncestorInVariableScope(AstNode n) {
    (
      n instanceof Pat or
      n instanceof VariableAccessCand or
      n instanceof LetStmt or
      n instanceof VariableScope
    ) and
    exists(AstNode n0 |
      result = getImmediateParent(n0) or
      result = n0.(FormatTemplateVariableAccess).getArgument().getParent().getParent()
    |
      n0 = n
      or
      n0 = getAnAncestorInVariableScope(n) and
      not n0 instanceof VariableScope
    )
  }

  /** Gets the immediately enclosing variable scope of `n`. */
  private VariableScope getEnclosingScope(AstNode n) { result = getAnAncestorInVariableScope(n) }

  private Pat getAVariablePatAncestor(Variable v) {
    result = v.getPat()
    or
    exists(Pat mid |
      mid = getAVariablePatAncestor(v) and
      result = getImmediatePatParent(mid)
    )
  }

  /**
   * Holds if a parameter declares the variable `v` inside variable scope `scope`.
   */
  private predicate parameterDeclInScope(Variable v, VariableScope scope) {
    exists(Callable f |
      v.getParameter() = f.getParamList().getAParamBase() and
      scope = [f.(Function).getBody(), f.(ClosureExpr).getBody()]
    )
  }

  /** A subset of `Element`s for which we want to compute pre-order numbers. */
  private class RelevantElement extends Element {
    RelevantElement() {
      this instanceof VariableScope or
      this instanceof VariableAccessCand or
      this instanceof LetStmt or
      getImmediateChildAndAccessor(this, _, _) instanceof RelevantElement
    }

    pragma[nomagic]
    private RelevantElement getChild(int index) {
      result = getImmediateChildAndAccessor(this, index, _)
    }

    pragma[nomagic]
    private RelevantElement getImmediateChildMin(int index) {
      // A child may have multiple positions for different accessors,
      // so always use the first
      result = this.getChild(index) and
      index = min(int i | result = this.getChild(i) | i)
    }

    pragma[nomagic]
    RelevantElement getImmediateChild(int index) {
      result =
        rank[index + 1](Element res, int i | res = this.getImmediateChildMin(i) | res order by i)
    }

    pragma[nomagic]
    RelevantElement getImmediateLastChild() {
      exists(int last |
        result = this.getImmediateChild(last) and
        not exists(this.getImmediateChild(last + 1))
      )
    }
  }

  /**
   * Gets the pre-order numbering of `n`, where the immediately enclosing
   * variable scope of `n` is `scope`.
   */
  pragma[nomagic]
  private int getPreOrderNumbering(VariableScope scope, RelevantElement n) {
    n = scope and
    result = 0
    or
    exists(RelevantElement parent |
      not parent instanceof VariableScope
      or
      parent = scope
    |
      // first child of a previously numbered node
      result = getPreOrderNumbering(scope, parent) + 1 and
      n = parent.getImmediateChild(0)
      or
      // non-first child of a previously numbered node
      exists(RelevantElement child, int i |
        result = getLastPreOrderNumbering(scope, child) + 1 and
        child = parent.getImmediateChild(i) and
        n = parent.getImmediateChild(i + 1)
      )
    )
  }

  /**
   * Gets the pre-order numbering of the _last_ node nested under `n`, where the
   * immediately enclosing variable scope of `n` (and the last node) is `scope`.
   */
  pragma[nomagic]
  private int getLastPreOrderNumbering(VariableScope scope, RelevantElement n) {
    exists(RelevantElement leaf |
      result = getPreOrderNumbering(scope, leaf) and
      leaf != scope and
      (
        not exists(leaf.getImmediateChild(_))
        or
        leaf instanceof VariableScope
      )
    |
      n = leaf
      or
      n.getImmediateLastChild() = leaf and
      not n instanceof VariableScope
    )
    or
    exists(RelevantElement mid |
      mid = n.getImmediateLastChild() and
      result = getLastPreOrderNumbering(scope, mid) and
      not mid instanceof VariableScope and
      not n instanceof VariableScope
    )
  }

  /**
   * Holds if `v` is named `name` and is declared inside variable scope
   * `scope`. The pre-order numbering of the binding site of `v`, amongst
   * all nodes nester under `scope`, is `ord`.
   */
  private predicate variableDeclInScope(Variable v, VariableScope scope, string name, int ord) {
    name = v.getName() and
    (
      parameterDeclInScope(v, scope) and
      ord = getPreOrderNumbering(scope, scope)
      or
      exists(Pat pat | pat = getAVariablePatAncestor(v) |
        scope =
          any(MatchArmScope arm |
            arm.getPat() = pat and
            ord = getPreOrderNumbering(scope, arm)
          )
        or
        exists(LetStmt let |
          let.getPat() = pat and
          scope = getEnclosingScope(let) and
          // for `let` statements, variables are bound _after_ the statement, i.e.
          // not in the RHS
          ord = getLastPreOrderNumbering(scope, let) + 1
        )
        or
        exists(IfExpr ie, LetExpr let |
          let.getPat() = pat and
          ie.getCondition() = let and
          scope = ie.getThen() and
          ord = getPreOrderNumbering(scope, scope)
        )
        or
        exists(ForExpr fe |
          fe.getPat() = pat and
          scope = fe.getLoopBody() and
          ord = getPreOrderNumbering(scope, scope)
        )
        or
        exists(WhileExpr we, LetExpr let |
          let.getPat() = pat and
          we.getCondition() = let and
          scope = we.getLoopBody() and
          ord = getPreOrderNumbering(scope, scope)
        )
      )
    )
  }

  /**
   * Holds if `cand` may access a variable named `name` at pre-order number `ord`
   * in the variable scope `scope`.
   *
   * `nestLevel` is the number of nested scopes that need to be traversed
   * to reach `scope` from `cand`.
   */
  private predicate variableAccessCandInScope(
    VariableAccessCand cand, VariableScope scope, string name, int nestLevel, int ord
  ) {
    name = cand.getName() and
    scope = [cand.(VariableScope), getEnclosingScope(cand)] and
    ord = getPreOrderNumbering(scope, cand) and
    nestLevel = 0
    or
    exists(VariableScope inner |
      variableAccessCandInScope(cand, inner, name, nestLevel - 1, _) and
      scope = getEnclosingScope(inner) and
      // Use the pre-order number of the inner scope as the number of the access. This allows
      // us to collapse multiple accesses in inner scopes to a single entity
      ord = getPreOrderNumbering(scope, inner)
    )
  }

  private newtype TDefOrAccessCand =
    TDefOrAccessCandNestedFunction(Function f, BlockExprScope scope) {
      f = scope.getStmtList().getAStatement()
    } or
    TDefOrAccessCandVariable(Variable v) or
    TDefOrAccessCandVariableAccessCand(VariableAccessCand va)

  /**
   * A nested function declaration, variable declaration, or variable (or function)
   * access candidate.
   *
   * In order to determine whether a candidate is an actual variable/function access,
   * we rank declarations and candidates by their position in the AST.
   *
   * The ranking must take names into account, but also variable scopes; below a comment
   * `rank(scope, name, i)` means that the declaration/access on the given line has rank
   * `i` amongst all declarations/accesses inside variable scope `scope`, for name `name`:
   *
   * ```rust
   * fn f() {           // scope0
   *     let x = 0;     // rank(scope0, "x", 0)
   *     use(x);        // rank(scope0, "x", 1)
   *     let x =        // rank(scope0, "x", 3)
   *         x + 1;     // rank(scope0, "x", 2)
   *     let y =        // rank(scope0, "y", 0)
   *         x;         // rank(scope0, "x", 4)
   *
   *     {              // scope1
   *         use(x);    // rank(scope1, "x", 0), rank(scope0, "x", 4)
   *         use(y);    // rank(scope1, "y", 0), rank(scope0, "y", 1)
   *         let x = 2; // rank(scope1, "x", 1)
   *         use(x);    // rank(scope1, "x", 2), rank(scope0, "x", 4)
   *     }
   * }
   * ```
   *
   * Function/variable declarations are only ranked in the scope that they bind into,
   * while accesses candidates propagate outwards through scopes, as they may access
   * declarations from outer scopes.
   *
   * For an access candidate with ranks `{ rank(scope_i, name, rnk_i) | i in I }` and
   * declarations `d in D` with ranks `rnk(scope_d, name, rnk_d)`,  the target is
   * calculated as
   * ```
   * max_{i in I} (
   *   max_{d in D | scope_d = scope_i and rnk_d < rnk_i} (
   *     d
   *   )
   * )
   * ```
   *
   * i.e., its the nearest declaration before the access in the same (or outer) scope
   * as the access.
   */
  abstract private class DefOrAccessCand extends TDefOrAccessCand {
    abstract string toString();

    abstract Location getLocation();

    pragma[nomagic]
    abstract predicate rankBy(string name, VariableScope scope, int ord, int kind);
  }

  abstract private class NestedFunctionOrVariable extends DefOrAccessCand { }

  private class DefOrAccessCandNestedFunction extends NestedFunctionOrVariable,
    TDefOrAccessCandNestedFunction
  {
    private Function f;
    private BlockExprScope scope_;

    DefOrAccessCandNestedFunction() { this = TDefOrAccessCandNestedFunction(f, scope_) }

    override string toString() { result = f.toString() }

    override Location getLocation() { result = f.getLocation() }

    override predicate rankBy(string name, VariableScope scope, int ord, int kind) {
      // nested functions behave as if they are defined at the beginning of the scope
      name = f.getName().getText() and
      scope = scope_ and
      ord = 0 and
      kind = 0
    }
  }

  private class DefOrAccessCandVariable extends NestedFunctionOrVariable, TDefOrAccessCandVariable {
    private Variable v;

    DefOrAccessCandVariable() { this = TDefOrAccessCandVariable(v) }

    override string toString() { result = v.toString() }

    override Location getLocation() { result = v.getLocation() }

    override predicate rankBy(string name, VariableScope scope, int ord, int kind) {
      variableDeclInScope(v, scope, name, ord) and
      kind = 1
    }
  }

  private class DefOrAccessCandVariableAccessCand extends DefOrAccessCand,
    TDefOrAccessCandVariableAccessCand
  {
    private VariableAccessCand va;

    DefOrAccessCandVariableAccessCand() { this = TDefOrAccessCandVariableAccessCand(va) }

    override string toString() { result = va.toString() }

    override Location getLocation() { result = va.getLocation() }

    override predicate rankBy(string name, VariableScope scope, int ord, int kind) {
      variableAccessCandInScope(va, scope, name, _, ord) and
      kind = 2
    }
  }

  private module DenseRankInput implements DenseRankInputSig2 {
    class C1 = VariableScope;

    class C2 = string;

    class Ranked = DefOrAccessCand;

    int getRank(VariableScope scope, string name, DefOrAccessCand v) {
      v =
        rank[result](DefOrAccessCand v0, int ord, int kind |
          v0.rankBy(name, scope, ord, kind)
        |
          v0 order by ord, kind
        )
    }
  }

  /**
   * Gets the rank of `v` amongst all other declarations or access candidates
   * to a variable named `name` in the variable scope `scope`.
   */
  private int rankVariableOrAccess(VariableScope scope, string name, DefOrAccessCand v) {
    v = DenseRank2<DenseRankInput>::denseRank(scope, name, result + 1)
  }

  /**
   * Holds if `v` can reach rank `rnk` in the variable scope `scope`. This is needed to
   * take shadowing into account, for example in
   *
   * ```rust
   * let x = 0;  // rank 0
   * use(x);     // rank 1
   * let x = ""; // rank 2
   * use(x);     // rank 3
   * ```
   *
   * the declaration at rank 0 can only reach the access at rank 1, while the declaration
   * at rank 2 can only reach the access at rank 3.
   */
  private predicate variableReachesRank(
    VariableScope scope, string name, NestedFunctionOrVariable v, int rnk
  ) {
    rnk = rankVariableOrAccess(scope, name, v)
    or
    variableReachesRank(scope, name, v, rnk - 1) and
    rnk = rankVariableOrAccess(scope, name, TDefOrAccessCandVariableAccessCand(_))
  }

  private predicate variableReachesCand(
    VariableScope scope, string name, NestedFunctionOrVariable v, VariableAccessCand cand,
    int nestLevel
  ) {
    exists(int rnk |
      variableReachesRank(scope, name, v, rnk) and
      rnk = rankVariableOrAccess(scope, name, TDefOrAccessCandVariableAccessCand(cand)) and
      variableAccessCandInScope(cand, scope, name, nestLevel, _)
    )
  }

  pragma[nomagic]
  predicate access(string name, NestedFunctionOrVariable v, VariableAccessCand cand) {
    v =
      min(NestedFunctionOrVariable v0, int nestLevel |
        variableReachesCand(_, name, v0, cand, nestLevel)
      |
        v0 order by nestLevel
      )
  }

  /** A variable access. */
  class VariableAccess extends PathExprBaseImpl::PathExprBase {
    private string name;
    private Variable v;

    VariableAccess() { variableAccess(name, v, this) }

    /** Gets the variable being accessed. */
    Variable getVariable() { result = v }

    /** Holds if this access is a capture. */
    predicate isCapture() { this.getEnclosingCfgScope() != v.getEnclosingCfgScope() }

    override string toString() { result = name }

    override string getAPrimaryQlClass() { result = "VariableAccess" }
  }

  /** Holds if `e` occurs in the LHS of an assignment or compound assignment. */
  private predicate assignmentExprDescendant(Expr e) {
    e = any(AssignmentExpr ae).getLhs()
    or
    exists(Expr mid |
      assignmentExprDescendant(mid) and
      getImmediateParent(e) = mid and
      not mid.(PrefixExpr).getOperatorName() = "*" and
      not mid instanceof FieldExpr and
      not mid instanceof IndexExpr
    )
  }

  /** A variable write. */
  class VariableWriteAccess extends VariableAccess {
    VariableWriteAccess() { assignmentExprDescendant(this) }
  }

  /** A variable read. */
  class VariableReadAccess extends VariableAccess {
    VariableReadAccess() {
      not this instanceof VariableWriteAccess and
      not this = any(RefExpr re).getExpr() and
      not this = any(CompoundAssignmentExpr cae).getLhs()
    }
  }

  /** A nested function access. */
  class NestedFunctionAccess extends PathExprBaseImpl::PathExprBase {
    private Function f;

    NestedFunctionAccess() { nestedFunctionAccess(_, f, this) }

    /** Gets the function being accessed. */
    Function getFunction() { result = f }
  }

  cached
  private module Cached {
    cached
    newtype TVariable =
      MkVariable(AstNode definingNode, string name) { variableDecl(definingNode, _, name) }

    cached
    predicate variableAccess(string name, Variable v, VariableAccessCand cand) {
      access(name, TDefOrAccessCandVariable(v), cand)
    }

    cached
    predicate nestedFunctionAccess(string name, Function f, VariableAccessCand cand) {
      access(name, TDefOrAccessCandNestedFunction(f, _), cand)
    }
  }

  private import Cached
}
