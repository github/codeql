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
private PropertyName getPropertyName(DataFlow::PropRead pacc) {
  result = StaticPropertyName(pacc.getPropertyName())
  or
  exists(SsaVariable var |
    pacc.getPropertyNameExpr() = var.getAUse() and
    result = DynamicPropertyName(var)
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
  MkAccessStep(AccessPath base, PropertyName name) {
    exists(DataFlow::PropRead pacc |
      pacc.getBase() = base.getAnInstance() and
      getPropertyName(pacc) = name
    )
  }

/**
 * A representation of a (nested) property access on an SSA variable or captured variable
 * where each property name is either constant or itself an SSA variable.
 */
class AccessPath extends TAccessPath {
  /**
   * Gets a data flow node in `bb` represented by this access path.
   */
  DataFlow::Node getAnInstanceIn(BasicBlock bb) {
    exists(SsaVariable var |
      this = MkSsaRoot(var) and
      result = DataFlow::valueNode(getARefinementOf*(var).getAUseIn(bb))
    )
    or
    exists(Variable var |
      this = MkCapturedRoot(var) and
      result = var.getAnAccess().flow() and
      result.getBasicBlock() = bb
    )
    or
    exists(ThisExpr this_ |
      this = MkThisRoot(this_.getBinder()) and
      result = this_.flow() and
      this_.getBasicBlock() = bb
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
  private DataFlow::PropRead getABaseInstanceIn(BasicBlock bb, PropertyName name) {
    exists(AccessPath base | this = MkAccessStep(base, name) |
      result.getBase() = base.getAnInstanceIn(bb)
    )
  }

  /**
   * Gets a data flow node represented by this access path.
   */
  DataFlow::Node getAnInstance() { result = getAnInstanceIn(_) }

  /**
   * Gets an expression in `bb` represented by this access path.
   */
  Expr getAnInstanceExprIn(BasicBlock bb) { result = getAnInstanceIn(bb).asExpr() }

  /**
   * Gets an expression represented by this access path.
   */
  Expr getAnInstanceExpr() { result = getAnInstance().asExpr() }

  /**
   * Gets a textual representation of this access path.
   */
  string toString() {
    exists(SsaVariable var | this = MkSsaRoot(var) | result = var.getSourceVariable().getName())
    or
    exists(Variable var | this = MkCapturedRoot(var) | result = var.getName())
    or
    this = MkThisRoot(_) and result = "this"
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
