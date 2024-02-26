/**
 * Provides predicates for giving improved type bounds on expressions.
 *
 * An inferred bound on the runtime type of an expression can be either exact
 * or merely an upper bound. Bounds are only reported if they are likely to be
 * better than the static bound, which can happen either if an inferred exact
 * type has a subtype or if an inferred upper bound passed through at least one
 * explicit or implicit cast that lost type information.
 */

/** Provides the input specification. */
signature module TypeFlowInput {
  /**
   * A node for which type information is available. For example, expressions
   * and method declarations.
   */
  class TypeFlowNode {
    /** Gets a textual representation of this node. */
    string toString();

    /** Gets the type of this node. */
    Type getType();

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    );
  }

  /**
   * Holds if data can flow from `n1` to `n2` in one step, and `n1` is not
   * necessarily functionally determined by `n2`.
   */
  predicate joinStep0(TypeFlowNode n1, TypeFlowNode n2);

  /**
   * Holds if data can flow from `n1` to `n2` in one step, and `n1` is
   * functionally determined by `n2`.
   */
  predicate step(TypeFlowNode n1, TypeFlowNode n2);

  /**
   * Holds if `null` is the only value that flows to `n`.
   */
  predicate isNull(TypeFlowNode n);

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
cached
module Make<TypeFlowInput I> {
  import Impl::TypeFlow<I>
}
