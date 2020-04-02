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
 * Gets an access to property `name` of access path `base` in basic block `bb`.
 */
private PropAccess namedPropAccess(AccessPath base, PropertyName name, BasicBlock bb) {
  result.getBase() = base.getAnInstanceIn(bb) and
  (
    name = StaticPropertyName(result.getPropertyName())
    or
    exists(SsaVariable var |
      result.getPropertyNameExpr() = var.getAUse() and
      name = DynamicPropertyName(var)
    )
  )
}

private SsaVariable getRefinedVariable(SsaVariable variable) {
  result = variable.getDefinition().(SsaRefinementNode).getAnInput()
}

private SsaVariable getARefinementOf(SsaVariable variable) { variable = getRefinedVariable(result) }

/**
 * A representation of a (nested) property access on an SSA variable or captured variable
 * where each property name is either constant or itself an SSA variable.
 */
private newtype TAccessPath =
  /**
   * An access path rooted in an SSA variable.
   *
   * Refinement nodes are treated as no-ops so that all uses of a refined value are
   * given the same access path. Refinement nodes are therefore never treated as roots.
   */
  MkSsaRoot(SsaVariable var) {
    not exists(getRefinedVariable(var)) and
    not var.getSourceVariable().isCaptured() // Handled by MkCapturedRoot
  } or
  /**
   * An access path rooted in a captured variable.
   *
   * The SSA form for captured variables is too conservative for constructing
   * access paths across function boundaries, so in this case we use the source
   * variable as the root.
   */
  MkCapturedRoot(LocalVariable var) { var.isCaptured() } or
  /**
   * An access path rooted in the receiver of a function.
   */
  MkThisRoot(Function function) { function.getThisBinder() = function } or
  /**
   * A property access on an access path.
   */
  MkAccessStep(AccessPath base, PropertyName name) { exists(namedPropAccess(base, name, _)) }

/**
 * A representation of a (nested) property access on an SSA variable or captured variable
 * where each property name is either constant or itself an SSA variable.
 */
class AccessPath extends TAccessPath {
  /**
   * Gets an expression in `bb` represented by this access path.
   */
  Expr getAnInstanceIn(BasicBlock bb) {
    exists(SsaVariable var |
      this = MkSsaRoot(var) and
      result = getARefinementOf*(var).getAUseIn(bb)
    )
    or
    exists(Variable var |
      this = MkCapturedRoot(var) and
      result = var.getAnAccess() and
      result.getBasicBlock() = bb
    )
    or
    exists(ThisExpr this_ |
      this = MkThisRoot(this_.getBinder()) and
      result = this_ and
      this_.getBasicBlock() = bb
    )
    or
    exists(AccessPath base, PropertyName name |
      this = MkAccessStep(base, name) and
      result = namedPropAccess(base, name, bb)
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
    exists(SsaVariable var | this = MkSsaRoot(var) | result = var.getSourceVariable().getName())
    or
    this = MkThisRoot(_) and result = "this"
    or
    exists(AccessPath base, PropertyName name, string rest |
      rest = "." + any(string s | name = StaticPropertyName(s))
      or
      rest =
        "[" + any(SsaVariable var | name = DynamicPropertyName(var)).getSourceVariable().getName() +
          "]"
    |
      result = base.toString() + rest and
      this = MkAccessStep(base, name)
    )
  }
}
