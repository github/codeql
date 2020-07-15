/**
 * Provides utility predicates to spot variable and parameter names that suggest deliberately insecure settings.
 */

import go

module InsecureFeatureFlag {
  /**
   * Holds if `name` may be the name of a feature flag that controls whether certificate checking is
   * enabled.
   */
  bindingset[name]
  predicate isFeatureFlagName(string name) {
    name.regexpMatch("(?i).*(secure|selfCert|selfSign|validat|verif|trust|(en|dis)able).*")
  }

  /**
   * Holds if `name` suggests an old or legacy version.
   *
   * We accept 'intermediate' because it appears to be common for TLS users
   * to define three profiles: modern, intermediate, legacy/old, perhaps based
   * on https://wiki.mozilla.org/Security/Server_Side_TLS (though note the
   * 'intermediate' used there would now pass muster according to this query)
   */
  bindingset[name]
  predicate isLegacyFlagName(string name) { name.regexpMatch("(?i).*(old|intermediate|legacy).*") }

  /**
   * A kind of flag that may indicate security expectations regarding the code it guards.
   */
  abstract class FlagKind extends string {
    FlagKind() { this = "feature" or this = "legacy" }

    /**
     * Returns a flag name of this type.
     */
    abstract string getAFlagName();
  }

  /**
   * Flags suggesting an optional feature, perhaps deliberately insecure.
   */
  class FeatureFlag extends FlagKind {
    FeatureFlag() { this = "feature" }

    bindingset[result]
    override string getAFlagName() { isFeatureFlagName(result) }
  }

  /**
   * Flags suggesting an optional feature, perhaps deliberately insecure.
   */
  string featureFlag() { result = "feature" }

  /**
   * Flags suggesting support for an old or legacy feature.
   */
  class LegacyFlag extends FlagKind {
    LegacyFlag() { this = "legacy" }

    bindingset[result]
    override string getAFlagName() { isLegacyFlagName(result) }
  }

  /**
   * Flags suggesting support for an old or legacy feature.
   */
  string legacyFlag() { result = "legacy" }

  /** Gets a global value number representing a (likely) security flag. */
  GVN getAFlag(FlagKind flagKind) {
    // a call like `cfg.disableVerification()`
    exists(DataFlow::CallNode c | c.getTarget().getName() = flagKind.getAFlagName() |
      result = globalValueNumber(c)
    )
    or
    // a variable or field like `insecure`
    exists(ValueEntity flag | flag.getName() = flagKind.getAFlagName() |
      result = globalValueNumber(flag.getARead())
    )
    or
    // a string constant such as `"insecure"` or `"skipVerification"`
    exists(DataFlow::Node const | const.getStringValue() = flagKind.getAFlagName() |
      result = globalValueNumber(const)
    )
    or
    // track feature flags through various operations
    exists(DataFlow::Node flag | flag = getAFlag(flagKind).getANode() |
      // tuple destructurings
      result = globalValueNumber(DataFlow::extractTupleElement(flag, _))
      or
      // type casts
      exists(DataFlow::TypeCastNode tc |
        tc.getOperand() = flag and
        result = globalValueNumber(tc)
      )
      or
      // pointer dereferences
      exists(DataFlow::PointerDereferenceNode deref |
        deref.getOperand() = flag and
        result = globalValueNumber(deref)
      )
      or
      // calls like `os.Getenv("DISABLE_TLS_VERIFICATION")`
      exists(DataFlow::CallNode call |
        call.getAnArgument() = flag and
        result = globalValueNumber(call)
      )
      or
      // comparisons like `insecure == true`
      exists(DataFlow::EqualityTestNode eq |
        eq.getAnOperand() = flag and
        result = globalValueNumber(eq)
      )
    )
  }

  /**
   * Gets a control-flow node that represents a (likely) feature-flag check for certificate checking.
   */
  ControlFlow::ConditionGuardNode getAFeatureFlagCheck() {
    result.ensures(getAFlag(featureFlag()).getANode(), _)
  }

  /**
   * Gets a control-flow node that represents a (likely) feature-flag check for certificate checking.
   */
  ControlFlow::ConditionGuardNode getALegacyVersionCheck() {
    result.ensures(getAFlag(legacyFlag()).getANode(), _)
  }
}
