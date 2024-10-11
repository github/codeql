private import rust
private import codeql.rust.elements.internal.generated.ParentChild
private import codeql.rust.elements.internal.PathExprImpl::Impl as PathExprImpl
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
  private predicate variableDecl(AstNode definingNode, IdentPat p, string name) {
    (
      definingNode = getOutermostEnclosingOrPat(p)
      or
      not exists(getOutermostEnclosingOrPat(p)) and
      definingNode = p.getName()
    ) and
    name = p.getName().getText() and
    // exclude for now anything starting with an uppercase character, which may be a reference to
    // an enum constant (e.g. `None`). This excludes static and constant variables (UPPERCASE),
    // which we don't appear to recognize yet anyway. This also assumes programmers follow the
    // naming guidelines, which they generally do, but they're not enforced.
    not name.charAt(0).isUppercase()
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

    /**
     * Gets the pattern that declares this variable.
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

    /** Gets the initial value of this variable, if any. */
    Expr getInitializer() {
      exists(LetStmt let |
        this.getPat() = let.getPat() and
        result = let.getInitializer()
      )
    }

    /** Holds if this variable is captured. */
    predicate isCaptured() { this.getAnAccess().isCapture() }
  }

  /** A path expression that may access a local variable. */
  private class VariableAccessCand extends PathExpr {
    string name_;

    VariableAccessCand() {
      exists(Path p, PathSegment ps |
        p = this.getPath() and
        not p.hasQualifier() and
        ps = p.getPart() and
        not ps.hasGenericArgList() and
        not ps.hasParamList() and
        not ps.hasPathType() and
        not ps.hasReturnTypeSyntax() and
        name_ = ps.getNameRef().getText()
      )
    }

    string getName() { result = name_ }
  }

  private AstNode getAnAncestorInVariableScope(AstNode n) {
    (
      n instanceof Pat or
      n instanceof VariableAccessCand or
      n instanceof LetStmt or
      n instanceof VariableScope
    ) and
    exists(AstNode n0 | result = getImmediateParent(n0) |
      n0 = n
      or
      n0 = getAnAncestorInVariableScope(n) and
      not n0 instanceof VariableScope
    )
  }

  /** Gets the immediately enclosing variable scope of `n`. */
  private VariableScope getEnclosingScope(AstNode n) { result = getAnAncestorInVariableScope(n) }

  private Pat getAVariablePatAncestor(Variable v) {
    exists(AstNode definingNode, string name |
      v = MkVariable(definingNode, name) and
      variableDecl(definingNode, result, name)
    )
    or
    exists(Pat mid |
      mid = getAVariablePatAncestor(v) and
      result = getImmediatePatParent(mid)
    )
  }

  /**
   * Holds if `v` is named `name` and is declared inside variable scope
   * `scope`, and `v` is bound starting from `(line, column)`.
   */
  private predicate variableDeclInScope(
    Variable v, VariableScope scope, string name, int line, int column
  ) {
    name = v.getName() and
    exists(Pat pat | pat = getAVariablePatAncestor(v) |
      scope =
        any(MatchArmScope arm |
          arm.getPat() = pat and
          arm.getLocation().hasLocationInfo(_, line, column, _, _)
        )
      or
      exists(Function f |
        f.getParamList().getAParam().getPat() = pat and
        scope = f.getBody() and
        scope.getLocation().hasLocationInfo(_, line, column, _, _)
      )
      or
      exists(LetStmt let |
        let.getPat() = pat and
        scope = getEnclosingScope(let) and
        // for `let` statements, variables are bound _after_ the statement, i.e.
        // not in the RHS
        let.getLocation().hasLocationInfo(_, _, _, line, column)
      )
      or
      exists(IfExpr ie, LetExpr let |
        let.getPat() = pat and
        ie.getCondition() = let and
        scope = ie.getThen() and
        scope.getLocation().hasLocationInfo(_, line, column, _, _)
      )
      or
      exists(ForExpr fe |
        fe.getPat() = pat and
        scope = fe.getLoopBody() and
        scope.getLocation().hasLocationInfo(_, line, column, _, _)
      )
      or
      exists(ClosureExpr ce |
        ce.getParamList().getAParam().getPat() = pat and
        scope = ce.getBody() and
        scope.getLocation().hasLocationInfo(_, line, column, _, _)
      )
      or
      exists(WhileExpr we, LetExpr let |
        let.getPat() = pat and
        we.getCondition() = let and
        scope = we.getLoopBody() and
        scope.getLocation().hasLocationInfo(_, line, column, _, _)
      )
    )
  }

  /**
   * Holds if `cand` may access a variable named `name` at
   * `(startline, startcolumn, endline, endcolumn)` in the variable scope
   * `scope`.
   *
   * `nestLevel` is the number of nested scopes that need to be traversed
   * to reach `scope` from `cand`.
   */
  private predicate variableAccessCandInScope(
    VariableAccessCand cand, VariableScope scope, string name, int nestLevel, int startline,
    int startcolumn, int endline, int endcolumn
  ) {
    name = cand.getName() and
    scope = [cand.(VariableScope), getEnclosingScope(cand)] and
    cand.getLocation().hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
    nestLevel = 0
    or
    exists(VariableScope inner |
      variableAccessCandInScope(cand, inner, name, nestLevel - 1, _, _, _, _) and
      scope = getEnclosingScope(inner) and
      // Use the location of the inner scope as the location of the access, instead of the
      // actual access location. This allows us to collapse multiple accesses in inner
      // scopes to a single entity
      inner.getLocation().hasLocationInfo(_, startline, startcolumn, endline, endcolumn)
    )
  }

  private newtype TVariableOrAccessCand =
    TVariableOrAccessCandVariable(Variable v) or
    TVariableOrAccessCandVariableAccessCand(VariableAccessCand va)

  /**
   * A variable declaration or variable access candidate.
   *
   * In order to determine whether a candidate is an actual variable access,
   * we rank declarations and candidates by their position in source code.
   *
   * The ranking must take variable names into account, but also variable scopes;
   * below a comment `rank(scope, name, i)` means that the declaration/access on
   * the given line has rank `i` amongst all declarations/accesses inside variable
   * scope `scope`, for variable name `name`:
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
   * Variable declarations are only ranked in the scope that they bind into, while
   * accesses candidates propagate outwards through scopes, as they may access
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
  private class VariableOrAccessCand extends TVariableOrAccessCand {
    Variable asVariable() { this = TVariableOrAccessCandVariable(result) }

    VariableAccessCand asVariableAccessCand() {
      this = TVariableOrAccessCandVariableAccessCand(result)
    }

    string toString() {
      result = this.asVariable().toString() or result = this.asVariableAccessCand().toString()
    }

    Location getLocation() {
      result = this.asVariable().getLocation() or result = this.asVariableAccessCand().getLocation()
    }

    pragma[nomagic]
    predicate rankBy(
      string name, VariableScope scope, int startline, int startcolumn, int endline, int endcolumn
    ) {
      variableDeclInScope(this.asVariable(), scope, name, startline, startcolumn) and
      endline = -1 and
      endcolumn = -1
      or
      variableAccessCandInScope(this.asVariableAccessCand(), scope, name, _, startline, startcolumn,
        endline, endcolumn)
    }
  }

  private module DenseRankInput implements DenseRankInputSig3 {
    class C1 = VariableScope;

    class C2 = string;

    class Ranked = VariableOrAccessCand;

    int getRank(VariableScope scope, string name, VariableOrAccessCand v) {
      v =
        rank[result](VariableOrAccessCand v0, int startline, int startcolumn, int endline,
          int endcolumn |
          v0.rankBy(name, scope, startline, startcolumn, endline, endcolumn)
        |
          v0 order by startline, startcolumn, endline, endcolumn
        )
    }
  }

  /**
   * Gets the rank of `v` amongst all other declarations or access candidates
   * to a variable named `name` in the variable scope `scope`.
   */
  private int rankVariableOrAccess(VariableScope scope, string name, VariableOrAccessCand v) {
    result = DenseRank3<DenseRankInput>::denseRank(scope, name, v) - 1
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
  private predicate variableReachesRank(VariableScope scope, string name, Variable v, int rnk) {
    rnk = rankVariableOrAccess(scope, name, TVariableOrAccessCandVariable(v))
    or
    variableReachesRank(scope, name, v, rnk - 1) and
    rnk = rankVariableOrAccess(scope, name, TVariableOrAccessCandVariableAccessCand(_))
  }

  private predicate variableReachesCand(
    VariableScope scope, string name, Variable v, VariableAccessCand cand, int nestLevel
  ) {
    exists(int rnk |
      variableReachesRank(scope, name, v, rnk) and
      rnk = rankVariableOrAccess(scope, name, TVariableOrAccessCandVariableAccessCand(cand)) and
      variableAccessCandInScope(cand, scope, name, nestLevel, _, _, _, _)
    )
  }

  private import codeql.rust.controlflow.internal.Scope

  /** A variable access. */
  class VariableAccess extends PathExprImpl::PathExpr instanceof VariableAccessCand {
    private string name;
    private Variable v;

    VariableAccess() { variableAccess(name, v, this) }

    /** Gets the variable being accessed. */
    Variable getVariable() { result = v }

    /** Holds if this access is a capture. */
    predicate isCapture() { scopeOfAst(this) != scopeOfAst(v.getPat()) }

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
      not mid.(PrefixExpr).getOperatorName() = "*"
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

  cached
  private module Cached {
    cached
    newtype TVariable =
      MkVariable(AstNode definingNode, string name) { variableDecl(definingNode, _, name) }

    cached
    predicate variableAccess(string name, Variable v, VariableAccessCand cand) {
      v =
        min(Variable v0, int nestLevel |
          variableReachesCand(_, name, v0, cand, nestLevel)
        |
          v0 order by nestLevel
        )
    }
  }

  private import Cached
}
