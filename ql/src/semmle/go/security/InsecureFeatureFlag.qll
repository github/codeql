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

  /** Gets a global value number representing a (likely) feature flag for certificate checking. */
  GVN getAFeatureFlag() {
    // a call like `cfg.disableVerification()`
    exists(DataFlow::CallNode c | isFeatureFlagName(c.getTarget().getName()) |
      result = globalValueNumber(c)
    )
    or
    // a variable or field like `insecure`
    exists(ValueEntity flag | isFeatureFlagName(flag.getName()) |
      result = globalValueNumber(flag.getARead())
    )
    or
    // a string constant such as `"insecure"` or `"skipVerification"`
    exists(DataFlow::Node const | isFeatureFlagName(const.getStringValue()) |
      result = globalValueNumber(const)
    )
    or
    // track feature flags through various operations
    exists(DataFlow::Node flag | flag = getAFeatureFlag().getANode() |
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
    result.ensures(getAFeatureFlag().getANode(), _)
  }
}
