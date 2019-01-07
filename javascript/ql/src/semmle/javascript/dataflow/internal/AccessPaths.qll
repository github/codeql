/**
 * Provides classes for reasoning about certain property accesses as access paths.
 *
 * Access paths represent SSA variables with zero or more property accesses applied to them.
 * Each property name in the access must either be constant or itself be a use of an SSA
 * variable.
 *
 * If `x` and `y` are SSA variables, then `x`, `x.p`, `x.p["q"]`, `x[y]` and `x[y].q` are
 * access paths, but `x[x.y]` is not an access path.
 *
 * Access paths can be used to identify expressions that have the same value, disregarding
 * any heap modifications. In general, expressions that are instances of the same access
 * path are not guaranteed to evaluate to the same value nor do all expressions that evaluate
 * to the same value have the same access paths, so access paths are neither sound nor
 * complete as an approximation of expression semantics.
 */

import javascript

/**
 * A representation of a property name that is either statically known or is
 * the value of an SSA variable.
 */
private newtype PropertyName =
  StaticPropertyName(string name) { exists(PropAccess pa | name = pa.getPropertyName()) } or
  DynamicPropertyName(SsaVariable var) {
    exists(PropAccess pa | pa.getPropertyNameExpr() = var.getAUse())
  }

/**
 * Gets the representation of the property name of `pacc`, if any.
 */
private PropertyName getPropertyName(PropAccess pacc) {
  result = StaticPropertyName(pacc.getPropertyName())
  or
  exists(SsaVariable var |
    pacc.getPropertyNameExpr() = var.getAUse() and
    result = DynamicPropertyName(var)
  )
}

/**
 * A representation of a (nested) property access on an SSA variable
 * where each property name is either constant or itself an SSA variable.
 */
private newtype TAccessPath =
  MkRoot(SsaVariable var) or
  MkAccessStep(AccessPath base, PropertyName name) {
    exists(PropAccess pacc |
      pacc.getBase() = base.getAnInstance() and
      getPropertyName(pacc) = name
    )
  }

/**
 * A representation of a (nested) property access on an SSA variable
 * where each property name is either constant or itself an SSA variable.
 */
class AccessPath extends TAccessPath {
  /**
   * Gets an expression in `bb` represented by this access path.
   */
  Expr getAnInstanceIn(BasicBlock bb) {
    exists(SsaVariable var |
      this = MkRoot(var) and
      result = var.getAUseIn(bb)
    )
    or
    exists(PropertyName name |
      result = getABaseInstanceIn(bb, name) and
      getPropertyName(result) = name
    )
  }

  /**
   * Gets a property access in `bb` whose base is represented by the
   * base of this access path, and where `name` is bound to the last
   * component of this access path.
   *
   * This is an auxiliary predicate that's needed to enforce a better
   * join order in `getAnInstanceIn` above.
   */
  pragma[noinline]
  private PropAccess getABaseInstanceIn(BasicBlock bb, PropertyName name) {
    exists(AccessPath base | this = MkAccessStep(base, name) |
      result.getBase() = base.getAnInstanceIn(bb)
    )
  }

  /**
   * Gets an expression represented by this access path.
   */
  Expr getAnInstance() { result = getAnInstanceIn(_) }

  /**
   * Gets a textual representation of this access path.
   */
  string toString() {
    exists(SsaVariable var | this = MkRoot(var) | result = var.getSourceVariable().getName())
    or
    exists(AccessPath base, PropertyName name, string rest |
      rest = "." + any(string s | name = StaticPropertyName(s))
      or
      rest = "[" +
          any(SsaVariable var | name = DynamicPropertyName(var)).getSourceVariable().getName() + "]"
    |
      result = base.toString() + rest and
      this = MkAccessStep(base, name)
    )
  }
}
