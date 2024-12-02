/**
 * Provides predicates for giving improved type bounds on expressions.
 *
 * An inferred bound on the runtime type of an expression can be either exact
 * or merely an upper bound. Bounds are only reported if they are likely to be
 * better than the static bound, which can happen either if an inferred exact
 * type has a subtype or if an inferred upper bound passed through at least one
 * explicit or implicit cast that lost type information.
 */

private import codeql.util.Location

/** Provides the input specification. */
signature module TypeFlowInput<LocationSig Location> {
  /**
   * A node for which type information is available. For example, expressions
   * and method declarations.
   */
  class TypeFlowNode {
    /** Gets a textual representation of this node. */
    string toString();

    /** Gets the type of this node. */
    Type getType();

    /** Gets the location of this node. */
    Location getLocation();
  }

  /**
   * Holds if data can flow from `n1` to `n2` in one step.
   *
   * For a given `n2`, this predicate must include all possible `n1` that can flow to `n2`.
   */
  predicate step(TypeFlowNode n1, TypeFlowNode n2);

  /** Holds if `n` represents a `null` value. */
  predicate isNullValue(TypeFlowNode n);

  /**
   * Holds if `n` should be excluded from the set of null values even if
   * the null analysis determines that `n` is always null.
   */
  default predicate isExcludedFromNullAnalysis(TypeFlowNode n) { none() }

  /** A type. */
  class Type {
    /** Gets a textual representation of this type. */
    string toString();

    /** Gets a direct super type of this type. */
    Type getASupertype();
  }

  /**
   * Gets the source declaration of this type, or `t` if `t` is already a
   * source declaration.
   */
  default Type getSourceDeclaration(Type t) { result = t }

  /**
   * Gets the erased version of this type. The erasure of a erasure of a
   * parameterized type is its generic counterpart, or `t` if `t` is already
   * fully erased.
   */
  default Type getErasure(Type t) { result = t }

  /** Gets a direct or indirect supertype of this type, including itself. */
  default Type getAnAncestor(Type sub) {
    result = sub
    or
    exists(Type mid | result = mid.getASupertype() and sub = getAnAncestor(mid))
  }

  /**
   * Holds if `t` is the most precise type of `n`, if any.
   */
  predicate exactTypeBase(TypeFlowNode n, Type t);

  /**
   * Holds if `n` has type `t` and this information is discarded, such that `t`
   * might be a better type bound for nodes where `n` flows to. This might include
   * multiple bounds for a single node.
   */
  predicate typeFlowBaseCand(TypeFlowNode n, Type t);

  /**
   * Holds if `n` is a value that is guarded by a disjunction of a dynamic type
   * check that checks if `n` is an instance of type `t_i` where `t` is one of
   * those `t_i`.
   */
  default predicate instanceofDisjunctionGuarded(TypeFlowNode n, Type t) { none() }

  /**
   * Holds if `t` is a raw type or parameterised type with unrestricted type
   * arguments.
   *
   * By default, no types are unbound.
   */
  default predicate unbound(Type t) { none() }
}

private import internal.TypeFlowImpl as Impl

/**
 * Provides an implementation of type-flow using input `I`.
 */
module Make<LocationSig Location, TypeFlowInput<Location> I> {
  import Impl::TypeFlow<Location, I>
}
