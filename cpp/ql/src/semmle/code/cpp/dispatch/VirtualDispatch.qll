import cpp

/**
 * A module for performing simple virtual dispatch analysis.
 */
module VirtualDispatch {
  /**
   * Gets a possible implementation target when the given function is the static target of a virtual call.
   */
  private MemberFunction getAPossibleImplementation(MemberFunction staticTarget) {
    /*
     * `IUnknown` is a COM interface with many sub-types, and many overrides (tens of thousands on
     * some databases), so we ignore any member functions defined within that interface.
     */

    not staticTarget.getDeclaringType().hasName("IUnknown") and
    result = staticTarget.getAnOverridingFunction*()
  }

  /** Gets the static type of the qualifier expression for the given call. */
  private Class getCallQualifierType(FunctionCall c) {
    result = c.getQualifier().getType().stripType() and
    /*
     * `IUnknown` is a COM interface with many sub-types (tens of thousands on some databases), so
     * we ignore any cases where the qualifier type is that interface.
     */

    not result.hasName("IUnknown")
  }

  /**
   * Gets a viable target for the given function call.
   *
   * If `c` is a virtual call, then we will perform a simple virtual dispatch analysis to return
   * the `Function` instances which might be a viable target, based on an analysis of the declared
   * type of the qualifier expression.
   *
   * (This analysis is imprecise: it looks for subtypes of the declared type of the qualifier expression
   * and the possible implementations of `c.getTarget()` that are declared or inherited by those subtypes.
   * This does not account for virtual inheritance and the ways this affects dispatch.)
   *
   * If `c` is not a virtual call, the result will be `c.getTarget()`.
   */
  Function getAViableTarget(Call c) {
    exists(Function staticTarget | staticTarget = c.getTarget() |
      if c.(FunctionCall).isVirtual() and staticTarget instanceof MemberFunction
      then
        exists(Class qualifierType, Class qualifierSubType |
          result = getAPossibleImplementation(staticTarget) and
          qualifierType = getCallQualifierType(c) and
          qualifierType = qualifierSubType.getABaseClass*() and
          mayInherit(qualifierSubType, result) and
          not cannotInherit(qualifierSubType, result)
        )
      else result = staticTarget
    )
  }

  /** Holds if `f` is declared in `c` or a transitive base class of `c`. */
  private predicate mayInherit(Class c, MemberFunction f) {
    f.getDeclaringType() = c.getABaseClass*()
  }

  /**
   * Holds if `c` cannot inherit the member function `f`,
   * i.e. `c` or one of its supertypes overrides `f`.
   */
  private predicate cannotInherit(Class c, MemberFunction f) {
    exists(Class overridingType, MemberFunction override |
      cannotInheritHelper(c, f, overridingType, override) and
      override.overrides+(f)
    )
  }

  pragma[noinline]
  private predicate cannotInheritHelper(
    Class c, MemberFunction f, Class overridingType, MemberFunction override
  ) {
    c.getABaseClass*() = overridingType and
    override.getDeclaringType() = overridingType and
    overridingType.getABaseClass+() = f.getDeclaringType()
  }
}
