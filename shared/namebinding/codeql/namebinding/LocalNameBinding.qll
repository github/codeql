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
   * A conditional with a condition, a then-branch, and an optional else-branch.
   *
   * Unless `isUnscopedConditional` holds, local declarations in the condition
   * are in scope in the then-branch but not the else-branch.
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
   * Holds if local declarations in a branch of `cond` are in scope in the
   * remainder of the branch _and_ following the conditional itself.
   *
   * Example:
   *
   * ```swift
   * #if DEBUG
   *     let x = def1
   *     // x is in scope here and refers to `def1`
   * #else
   *     let x = def2
   *     // x is in scope here and refers to `def2`
   * #endif
   * // x is in scope here and refers to either `def1` or `def2`
   * ```
   */
  default predicate isUnscopedConditional(Conditional cond) { none() }

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

  /**
   * Holds if the set of names available in `scope` is not known ahead of time,
   * and thus any lookup chain that goes through `scope` may need to be reconciled at a later stage.
   */
  default predicate uncertainScope(AstNode scope) { none() }
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
      or
      uncertainScope(this)
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
    not exists(Conditional cond |
      not isUnscopedConditional(cond) and
      result = [cond.getElse(), cond.getThen()]
    )
    or
    exists(Conditional cond |
      not isUnscopedConditional(cond) and
      (
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
    )
  }

  private module DenseRankInput implements DenseRankInputSig1 {
    class C = AstNode;

    class Ranked = AstNode;

    int getRank(C parent, Ranked child) {
      child = getChildAdj(parent, result) and
      // Only rank children when necessary, i.e., when there are sibling
      // shadowing declarations or unscoped conditionals among the children.
      (
        getChildAdj(parent, _) instanceof SiblingShadowingDecl
        or
        isUnscopedConditional(getChildAdj(parent, _))
      )
    }
  }

  private predicate getRankedChild = DenseRank1<DenseRankInput>::denseRank/2;

  /** Holds if `decl` is a possible final declaration introduced by `node`. */
  private predicate lastDeclAfter(AstNode node, SiblingShadowingDecl decl) {
    node = decl
    or
    node = any(Conditional cond | isUnscopedConditional(cond) and lastDeclInBranch(cond, decl))
  }

  private predicate lastDeclInBranch(Conditional cond, SiblingShadowingDecl decl) {
    exists(AstNode branch | branch = [cond.getThen(), cond.getElse()] |
      // An `#elseif` is itself a conditional rather than a block of statements.
      isUnscopedConditional(branch) and lastDeclAfter(branch, decl)
      or
      not isUnscopedConditional(branch) and
      lastDeclInPrefix(branch, max(int i | exists(getRankedChild(branch, i))), decl)
    )
  }

  /**
   * Holds if the unscoped conditional `cond` might not introduce any shadowing
   * declarations. We need this property to determine whether declarations prior
   * to the conditional are still in scope following the conditional.
   *
   * For instance, in
   * ```swift
   * let x = 1
   * #if DEBUG
   *     let x = 2
   * #else
   *     let x = 3
   * #endif
   * print(x) // prints 2 or 3
   * ```
   * the initial declaration of `x` is certain to not be shadowed after the
   * conditional.
   *
   * If the conditional instead had no else branch or had one of the branches
   * not declared any shadowing declarations, then the initial declaration of
   * `x` might not have been shadowed after the conditional.
   */
  private predicate unscopedConditionalPreservesIncoming(Conditional cond) {
    isUnscopedConditional(cond) and
    (
      not exists(cond.getElse())
      or
      branchPreservesIncoming([cond.getThen(), cond.getElse()])
    )
  }

  private predicate branchPreservesIncoming(AstNode branch) {
    unscopedConditionalPreservesIncoming(branch)
    or
    not isUnscopedConditional(branch) and
    (
      // If the children are not ranked, then they do not contain any sibling
      // shadowing declarations.
      not exists(getRankedChild(branch, _))
      or
      prefixPreservesIncoming(branch, max(int i | exists(getRankedChild(branch, i))))
    )
  }

  /**
   * Holds if `node` might not introduce any shadowing declaration.
   *
   * For example, the following satisfies the predicate since the declaration
   * might be removed at compile time.
   * ```swift
   * #if DEBUG
   *     let value = 1
   * #endif
   *  ```
   */
  private predicate preservesIncoming(AstNode node) {
    // A shadowing declaration always introduces a shadowing declaration.
    not node instanceof SiblingShadowingDecl and
    not isUnscopedConditional(node)
    or
    unscopedConditionalPreservesIncoming(node)
  }

  /** Summarizes the first `i` ranked children without entering ordinary nested scopes. */
  private predicate lastDeclInPrefix(AstNode parent, int i, SiblingShadowingDecl decl) {
    exists(AstNode child | child = getRankedChild(parent, i) |
      lastDeclAfter(child, decl)
      or
      preservesIncoming(child) and lastDeclInPrefix(parent, i - 1, decl)
    )
  }

  /**
   * Holds if the first `i` children might not introduce any shadowing
   * declarations.
   */
  private predicate prefixPreservesIncoming(AstNode parent, int i) {
    i = 0 and exists(getRankedChild(parent, _))
    or
    prefixPreservesIncoming(parent, i - 1) and
    preservesIncoming(getRankedChild(parent, i))
  }

  /**
   * Holds if, instead of its parent, `n` should be considered a child of a
   * shadowing sibling declaration `decl` when resolving accesses.
   *
   * Each alternative through preceding unscoped conditionals contributes its own
   * nearest shadowing declaration.
   *
   * Note that `decl` may itself also have to be nested under another shadowing
   * sibling declaration.
   */
  private predicate shouldBeShadowingDeclChild(SiblingShadowingDecl decl, AstNode n) {
    exists(AstNode parent, int i |
      n = getRankedChild(parent, i) and
      lastDeclInPrefix(parent, i - 1, decl)
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
    not exists(SiblingShadowingDecl decl | n = [decl.getRhs(), decl.getElse()]) and
    n = getChildAdj(result, _) and
    (
      not exists(int i | n = getRankedChild(result, i))
      or
      exists(int i |
        n = getRankedChild(result, i) and
        prefixPreservesIncoming(result, i - 1)
      )
    )
    or
    shouldBeShadowingDeclChild(result, n)
    or
    exists(SiblingShadowingDecl decl |
      result = getParentForScoping(decl) and
      n = [decl.getRhs(), decl.getElse()]
    )
  }

  /** Holds if `node` should be included in the debug tree. */
  private signature predicate relevantNodeSig(AstNode node);

  module DebugScopeGraph<relevantNodeSig/1 relevantNode> {
    private string getANodeAnnotation(AstNode node) {
      result =
        "[scope=" +
          strictconcat(string name |
            declInScope(_, name, node) or implicitDeclInScope(name, node)
          |
            name, ","
          ) + "]"
    }

    query predicate nodes(AstNode node, string key, string value) {
      relevantNode(node) and
      key = "semmle.label" and
      value = node.toString() + concat(getANodeAnnotation(node))
    }

    query predicate edges(AstNode node1, AstNode node2) {
      relevantNode(node2) and node2 = getParentForScoping(node1)
    }
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

  private predicate declInScope(string name, AstNode scope) {
    declInScope(_, name, scope) or
    implicitDeclInScope(name, scope)
  }

  signature predicate accessCandSig(AstNode n, string name);

  /**
   * Allows resolution of access candidates.
   *
   * This is instantiated once by the local name binding library itself in order to populate `LocalAccess`.
   * It can be instantiated further by the client, to resolve additional lookups at a later evaluation stage.
   */
  module ResolveAccesses<accessCandSig/2 accessCandInput> {
    private predicate accessCandInLookupScope(AstNode n, string name, Scope lookup) {
      accessCandInput(n, name) and
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
        not declInScope(name, mid) and
        not isTopScope(mid) and
        scope = getEnclosingScope(mid)
      )
    }

    pragma[nomagic]
    private predicate resolveInScope(string name, Scope lookup, Local l) {
      exists(Scope scope | lookupInScope(name, lookup, scope) |
        l = TExplicitLocal(_, name, scope) or
        l = TImplicitLocal(name, scope)
      )
    }

    /** Holds if `access` resolves to `l`. */
    predicate access(AstNode access, Local l) {
      exists(Scope lookup, string name |
        accessCandInLookupScope(access, name, lookup) and
        resolveInScope(name, lookup, l)
      )
    }

    /**
     * Holds if `name`, when resolved from `lookup`, may resolve to one of the uncertain members of `scope`.
     */
    pragma[nomagic]
    private predicate lookupInUncertainScope(string name, Scope lookup, Scope scope) {
      lookupInScope(name, lookup, scope) and
      uncertainScope(scope) and
      not declInScope(name, scope)
    }

    /**
     * Gets an uncertain scope in which the `accessCand` pair may resolve.
     */
    AstNode getAnUncertainScope(AstNode access, string name) {
      exists(Scope lookup |
        accessCandInLookupScope(access, name, lookup) and
        lookupInUncertainScope(name, lookup, result)
      )
    }
  }

  private module DefaultAccesses = ResolveAccesses<accessCand/2>;

  /** Holds if `access` resolves to `l`. */
  cached
  private predicate access(AstNode access, Local l) {
    CachedStage::ref() and
    DefaultAccesses::access(access, l)
  }

  predicate getAnUncertainScope = DefaultAccesses::getAnUncertainScope/2;

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

    /** Holds if this variable has the given name and scope. */
    pragma[nomagic]
    predicate hasNameAndScope(string name_, AstNode scope_) { name = name_ and scope = scope_ }
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
