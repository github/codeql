/**
 * Provides utility predicates to spot variable and parameter names that suggest deliberately insecure settings.
 */

import go

module InsecureFeatureFlag {
  /**
   * Holds if `name` may be the name of a feature flag that controls a security feature.
   */
  bindingset[name]
  predicate isSecurityFlagName(string name) { name.regexpMatch("(?i).*(secure|(en|dis)able).*") }

  /**
   * Holds if `name` may be the name of a feature flag that controls whether certificate checking is
   * enabled.
   */
  bindingset[name]
  predicate isCertificateFlagName(string name) {
    name.regexpMatch("(?i).*(selfCert|selfSign|validat|verif|trust).*")
  }

  /**
   * Holds if `name` suggests an old or legacy version of TLS.
   *
   * We accept 'intermediate' because it appears to be common for TLS users
   * to define three profiles: modern, intermediate, legacy/old, perhaps based
   * on https://wiki.mozilla.org/Security/Server_Side_TLS (though note the
   * 'intermediate' used there would now pass muster according to this query)
   */
  bindingset[name]
  predicate isLegacyTlsFlagName(string name) {
    name.regexpMatch("(?i).*(old|intermediate|legacy).*")
  }

  /**
   * A kind of flag that may indicate security expectations regarding the code it guards.
   */
  abstract class FlagKind extends string {
    FlagKind() {
      this = "securityFeature" or this = "legacyTlsVersion" or this = "insecureCertificate"
    }

    /**
     * Returns a flag name of this type.
     */
    abstract string getAFlagName();
  }

  /**
   * Flags suggesting an optional feature, perhaps deliberately insecure.
   */
  class SecurityFeatureFlag extends FlagKind {
    SecurityFeatureFlag() { this = "securityFeature" }

    bindingset[result]
    override string getAFlagName() { isSecurityFlagName(result) }
  }

  /**
   * Flags suggesting an optional feature, perhaps deliberately insecure.
   */
  string securityFeatureFlag() { result = "securityFeature" }

  /**
   * Flags suggesting support for an old or legacy TLS version.
   */
  class LegacyTlsVersionFlag extends FlagKind {
    LegacyTlsVersionFlag() { this = "legacyTlsVersion" }

    bindingset[result]
    override string getAFlagName() { isLegacyTlsFlagName(result) }
  }

  /**
   * Flags suggesting support for an old or legacy TLS version.
   */
  string legacyTlsVersionFlag() { result = "legacyTlsVersion" }

  /**
   * Flags suggesting a deliberately insecure certificate setup.
   */
  class InsecureCertificateFlag extends FlagKind {
    InsecureCertificateFlag() { this = "insecureCertificate" }

    bindingset[result]
    override string getAFlagName() { isCertificateFlagName(result) }
  }

  /**
   * Flags suggesting support for an old or legacy feature.
   */
  string insecureCertificateFlag() { result = "insecureCertificate" }

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
   * Holds for string literals or named values matching `flagKind` and their fields.
   */
  predicate exprIsFlag(Expr node, FlagKind flagKind) {
    node.getStringValue() = flagKind.getAFlagName() or
    node.(Name).getTarget().getName() = flagKind.getAFlagName() or
    exprIsFlag(node.(SelectorExpr).getBase(), flagKind) or
    exprIsFlag(node.(SelectorExpr).getSelector(), flagKind)
  }

  /**
   * Holds if `node` suggests an old TLS version according to `flagKind`.
   */
  predicate astNodeIsFlag(AstNode node, FlagKind flagKind) {
    // Map literal flag: value or "flag": value
    exprIsFlag(node.(KeyValueExpr).getKey(), flagKind)
    or
    // Variable initialisation flag := value
    exists(ValueSpec valueSpec, int childIdx |
      valueSpec.getName(childIdx) = flagKind.getAFlagName()
    |
      node = valueSpec.getInit(childIdx)
    )
    or
    // Assignment flag = value
    exists(Assignment assignment, int childIdx | exprIsFlag(assignment.getLhs(childIdx), flagKind) |
      node = assignment.getRhs(childIdx)
    )
    or
    // Case clause 'case flag:' or 'case "flag":'
    exprIsFlag(node.(CaseClause).getAnExpr(), flagKind)
  }

  /**
   * Gets a control-flow node that represents a (likely) security feature-flag check
   */
  ControlFlow::ConditionGuardNode getASecurityFeatureFlagCheck() {
    result.ensures(getAFlag(securityFeatureFlag()).getANode(), _)
  }

  /**
   * Gets a control-flow node that represents a (likely) flag controlling TLS version selection.
   */
  ControlFlow::ConditionGuardNode getALegacyTlsVersionCheck() {
    result.ensures(getAFlag(legacyTlsVersionFlag()).getANode(), _)
  }

  /**
   * Gets a control-flow node that represents a (likely) flag controlling an insecure certificate setup.
   */
  ControlFlow::ConditionGuardNode getAnInsecureCertificateCheck() {
    result.ensures(getAFlag(insecureCertificateFlag()).getANode(), _)
  }
}
