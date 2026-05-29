/**
 * Provides a library for resolving local names based on syntactic scopes, including
 * handling of shadowing sibling declarations.
 */
overlay[local?]
module;

private import codeql.util.DenseRank
private import codeql.util.Location

/** Provides the input to `LocalNameBinding`. */
signature module LocalNameBindingInputSig<LocationSig Location> {
  /**
   * Reverse references to the cached predicates that reference
   * `CachedStage::ref()`.
   */
  default predicate cacheRevRef() { none() }

  /** An AST node. */
  class AstNode {
    /** Gets a textual representation of this element. */
    string toString();

    /** Gets the location of this element. */
    Location getLocation();
  }

  /**
   * Gets the child of AST node `n` at the specified index.
   *
   * The order of the children is only relevant for determining nearest preceding
   * shadowing sibling declarations.
   */
  AstNode getChild(AstNode n, int index);

  /**
   * A conditional where any local declarations in the condition are in scope
   * in the then-branch but not the else-branch.
   *
   * Example:
   *
   * ```rust
   * if let Some(x) = opt {
   *   // x is in scope here
   * } else {
   *   // x is not in scope here
   * }
   * ```
   *
   * If a local declaration inside the condition is a shadowing sibling declaration
   * (see below), then it should use the declaration itself as scope, otherwise it
   * should use the condition as scope.
   */
  class Conditional extends AstNode {
    /** Gets the condition of this conditional. */
    AstNode getCondition();

    /** Gets the then-branch of this conditional. */
    AstNode getThen();

    /** Gets the else-branch of this conditional. */
    AstNode getElse();
  }

  /**
   * A declaration where all local declarations in the left-hand side are in
   * scope _after_ the declaration, and where any sibling declarations with
   * the same name and syntactic scope preceding it are shadowed.
   *
   * Example:
   *
   * ```rust
   * fn f() {
   *   let x = 1;
   *   // this declaration of `x` shadows the previous one (in the syntactic scope
   *   // being the body of `f`), but the `x` in the right-hand side still refers
   *   // to the first declaration
   *   let x = x + 1;
   *   // this access of `x` refers to the second declaration
   *   println!("{}", x);
   * }
   * ```
   */
  class SiblingShadowingDecl extends AstNode {
    /** Gets the left-hand side of this declaration. */
    AstNode getLhs();

    /**
     * Gets the right-hand side of this declaration.
     *
     * Any local declared in the left-hand side of this declaration is _not_ in scope
     * in the right-hand side.
     */
    AstNode getRhs();

    /**
     * Gets the else-branch of this declaration, if any.
     *
     * Any local declared in the left-hand side of this declaration is _not_ in scope
     * in the else-branch.
     */
    AstNode getElse();
  }

  /**
   * Holds if a local declaration named `name` exists at `definingNode` inside
   * the syntactic scope `scope`.
   *
   * Note that declarations with a `definingNode` in the left-hand side of a
   * shadowing sibling declaration `decl` should use `scope = decl`.
   */
  predicate declInScope(AstNode definingNode, string name, AstNode scope);

  /**
   * Holds if a local declaration named `name` is implicitly in scope in the given `scope`.
   */
  default predicate implicitDeclInScope(string name, AstNode scope) { none() }

  /**
   * Holds if `scope` is a top scope, meaning that names may not be looked up
   * in ancestor scopes.
   */
  default predicate isTopScope(AstNode scope) { none() }

  /**
   * Holds if `n` is a node that may access a local named `name`.
   */
  predicate accessCand(AstNode n, string name);

  /**
   * Holds if the access candidate `n` should begin its lookup in `scope` instead
   * of its immediately enclosing scope.
   *
   * For example, the `this` variable in an instance field initializer might need
   * to be resolved relative to a constructor body.
   *
   * If `scope` declares a local with the name of `n`, then `scope` is guaranteed
   * to be the scope that `n` ultimately resolves to. This can thus be used to take
   * full control of scope resolution for specific types of references.
   */
  default predicate lookupStartsAt(AstNode n, AstNode scope) { none() }
}

/**
 * Provides logic for resolving local names based on syntactic scopes, including
 * handling of shadowing sibling declarations.
 */
module LocalNameBinding<LocationSig Location, LocalNameBindingInputSig<Location> Input> {
  private import Input

  final private class AstNodeFinal = AstNode;

  private class Scope extends AstNodeFinal {
    Scope() {
      declInScope(_, _, this)
      or
      implicitDeclInScope(_, this)
      or
      isTopScope(this)
    }
  }

  pragma[nomagic]
  private predicate conditionHasChildAt(Conditional conditional, AstNode condition, int index) {
    condition = conditional.getCondition() and
    (
      exists(getChild(condition, index))
      or
      // safeguard against empty conditions
      not exists(getChild(condition, _)) and index = 0
    )
  }

  /**
   * An adjusted version of `getChild` from the `Input` module where in conditionals like
   * `if cond body`, instead of letting `body` be a child of `if`, we make it the last
   * child of `cond`. This ensures that shadowing sibling declarations inside `cond` are
   * properly handled inside `body`.
   *
   * Example:
   *
   * ```rust
   * if let Some(x) = opt && let x = x + 1 {
   *   // the second declaration of `x` is in scope here
   * }
   * ```
   *
   * We also move any `else` branch _before_ the condition to ensure that shadowing sibling
   * declarations inside the condition are not in scope.
   */
  private AstNode getChildAdj(AstNode parent, int index) {
    result = getChild(parent, index) and
    not exists(Conditional cond | result = [cond.getElse(), cond.getThen()])
    or
    exists(Conditional cond |
      parent = cond and
      result = cond.getElse() and
      index = -1
      or
      exists(int last |
        result = cond.getThen() and
        last = max(int i | conditionHasChildAt(cond, parent, i)) and
        index = last + 1
      )
    )
  }

  private module DenseRankInput implements DenseRankInputSig1 {
    class C = AstNode;

    class Ranked = AstNode;

    int getRank(C parent, Ranked child) {
      child = getChildAdj(parent, result) and
      getChildAdj(parent, _) instanceof SiblingShadowingDecl
    }
  }

  private predicate getRankedChild = DenseRank1<DenseRankInput>::denseRank/2;

  /**
   * Holds if `n` is the `i`th child of `parent`, but should instead be considered
   * a child of a shadowing sibling declaration `decl` when resolving accesses.
   *
   * This is the case when `decl` is the nearest shadowing sibling declaration
   * preceding `n` amongst all the children of `parent`.
   *
   * Note that `decl` may itself also have to be nested under another shadowing
   * sibling declaration.
   */
  private predicate shouldBeShadowingDeclChild(
    AstNode parent, SiblingShadowingDecl decl, int i, AstNode n
  ) {
    n = getRankedChild(parent, i) and
    (
      decl = getRankedChild(parent, i - 1)
      or
      shouldBeShadowingDeclChild(parent, decl, i - 1,
        any(AstNode prev | not prev instanceof SiblingShadowingDecl))
    )
  }

  /**
   * Gets the AST parent of `n` with respect to determining enclosing scopes.
   *
   * For example, in
   *
   * ```rust
   * let x = 1;
   * let x = x + 1;
   * println!("{}", x);
   * ```
   *
   * we will have (eliding leaf nodes)
   *
   * ```text
   *        let x = 1;
   *         /      \
   *       x + 1   let x = x + 1
   *                     |
   *              println!("{}", x);
   * ```
   *
   * and in
   *
   * ```rust
   * if let Some(x) = opt && let x = x + 1 {
   *    println!("{}", x);
   * }
   * ```
   *
   * we will have (again eliding leaf nodes)
   *
   * ```text
   *                           if ...
   *                             |
   *                         ... && ...
   *                          /       \
   *            let Some(x) = opt     opt
   *                /        \
   *      let x = x + 1     x + 1
   *             |
   *     println!("{}", x);
   * ```
   */
  private AstNode getParentForScoping(AstNode n) {
    not shouldBeShadowingDeclChild(_, _, _, n) and
    not exists(SiblingShadowingDecl decl | n = [decl.getRhs(), decl.getElse()]) and
    n = getChildAdj(result, _)
    or
    shouldBeShadowingDeclChild(_, result, _, n)
    or
    exists(SiblingShadowingDecl decl |
      result = getParentForScoping(decl) and
      n = [decl.getRhs(), decl.getElse()]
    )
  }

  /** Gets the immediately enclosing variable scope of `n`. */
  private Scope getEnclosingScope(AstNode n) {
    result = getParentForScoping(n)
    or
    exists(AstNode mid |
      result = getEnclosingScope(mid) and
      mid = getParentForScoping(n) and
      not mid instanceof Scope
    )
  }

  private predicate accessCandInLookupScope(AstNode n, string name, Scope lookup) {
    accessCand(n, name) and
    (
      lookupStartsAt(n, lookup)
      or
      not lookupStartsAt(n, _) and
      lookup = getEnclosingScope(n)
    )
  }

  pragma[nomagic]
  private predicate lookupInScope(string name, Scope lookup, Scope scope) {
    accessCandInLookupScope(_, name, lookup) and
    scope = lookup
    or
    exists(Scope mid |
      lookupInScope(name, lookup, mid) and
      not declInScope(_, name, mid) and
      not implicitDeclInScope(name, mid) and
      not isTopScope(mid) and
      scope = getEnclosingScope(mid)
    )
  }

  cached
  private newtype TLocal =
    TExplicitLocal(AstNode definingNode, string name, AstNode scope) {
      CachedStage::ref() and
      declInScope(definingNode, name, scope)
    } or
    TImplicitLocal(string name, AstNode scope) { implicitDeclInScope(name, scope) }

  /** A locally declared entity, for example a variable or a parameter. */
  abstract private class LocalImpl extends TLocal {
    /** Gets the AST node that defines this local entity, if any. */
    abstract AstNode getDefiningNode();

    /** Gets the AST node that defines the scope of this local entity. */
    abstract AstNode getScope();

    /** Gets the name of this local entity. */
    abstract string getName();

    /** Gets the location of this local entity. */
    abstract Location getLocation();

    /** Gets an access to this local entity. */
    LocalAccess getAnAccess() { result.getLocal() = this }

    /** Gets a textual representation of this local entity. */
    string toString() { result = this.getName() }
  }

  final class Local = LocalImpl;

  /** An explicitly locally declared entity, for example a variable or a parameter. */
  class ExplicitLocal extends LocalImpl, TExplicitLocal {
    private AstNode definingNode;
    private string name;
    private AstNode scope;

    ExplicitLocal() { this = TExplicitLocal(definingNode, name, scope) }

    override AstNode getDefiningNode() { result = definingNode }

    override AstNode getScope() { result = scope }

    override string getName() { result = name }

    override Location getLocation() { result = definingNode.getLocation() }
  }

  /** An implicitly locally declared entity, for example a `self` parameter. */
  class ImplicitLocal extends LocalImpl, TImplicitLocal {
    private string name;
    private AstNode scope;

    ImplicitLocal() { this = TImplicitLocal(name, scope) }

    override AstNode getDefiningNode() { none() }

    override AstNode getScope() { result = scope }

    override string getName() { result = name }

    override Location getLocation() { result = scope.getLocation() }
  }

  pragma[nomagic]
  private predicate resolveInScope(string name, Scope lookup, Local l) {
    exists(Scope scope | lookupInScope(name, lookup, scope) |
      l = TExplicitLocal(_, name, scope) or
      l = TImplicitLocal(name, scope)
    )
  }

  cached
  private predicate access(AstNode access, Local l) {
    CachedStage::ref() and
    exists(Scope lookup, string name |
      accessCandInLookupScope(access, name, lookup) and
      resolveInScope(name, lookup, l)
    )
  }

  /** A local access. */
  final class LocalAccess extends AstNodeFinal {
    private Local l;

    LocalAccess() { access(this, l) }

    /** Gets the local entity being accessed. */
    Local getLocal() { result = l }
  }

  /**
   * The cached stage of this module.
   *
   * Should not be exposed.
   */
  cached
  module CachedStage {
    /** Reference to the cached stage of this module. */
    cached
    predicate ref() { any() }

    /**
     * DO NOT USE!
     *
     * Reverse references to the cached predicates that reference `ref()`.
     */
    cached
    predicate revRef() {
      any()
      or
      cacheRevRef()
      or
      (exists(Local l) implies any())
      or
      (exists(LocalAccess a) implies any())
    }
  }
}
