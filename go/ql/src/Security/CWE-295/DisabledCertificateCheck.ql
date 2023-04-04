/**
 * @name Disabled TLS certificate check
 * @description If an application disables TLS certificate checking, it may be vulnerable to
 *              man-in-the-middle attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id go/disabled-certificate-check
 * @tags security
 *       external/cwe/cwe-295
 */

/*
 * The approach taken by this query is to look for assignments that set `InsecureSkipVerify`
 * (from struct `Config` of package `crypto/tls`) to `true`. We exclude assignments that are
 * guarded by a feature-flag selecting whether verification should be skipped or not, since
 * such assignments are not by themselves dangerous. Similarly, we exclude cases where the
 * name of the enclosing function or the name of a variable/field into which the configuration
 * flows suggests that it is deliberately insecure.
 *
 * We also exclude assignments in test code, where it makes sense to disable certificate checking.
 */

import go
import semmle.go.security.InsecureFeatureFlag::InsecureFeatureFlag

/**
 * Holds if `part` becomes a part of `whole`, either by (local) data flow or by being incorporated
 * into `whole` through having its address taken or being written to a field of `whole`.
 */
predicate becomesPartOf(DataFlow::Node part, DataFlow::Node whole) {
  DataFlow::localFlow(part, whole)
  or
  whole.(DataFlow::AddressOperationNode).getOperand() = part
  or
  exists(Write w | w.writesField(whole.(DataFlow::PostUpdateNode).getPreUpdateNode(), _, part))
}

/**
 * A flag suggesting a deliberately insecure certificate setup.
 */
class InsecureCertificateFlag extends FlagKind {
  InsecureCertificateFlag() { this = "insecureCertificate" }

  bindingset[result]
  override string getAFlagName() {
    result.regexpMatch("(?i).*(selfcert|selfsign|validat|verif|trust).*")
  }
}

/**
 * Gets a control-flow node that represents a (likely) flag controlling an insecure certificate setup.
 */
ControlFlow::ConditionGuardNode getAnInsecureCertificateCheck() {
  result.ensures(any(InsecureCertificateFlag f).getAFlag().getANode(), _)
}

/**
 * Returns flag kinds relevant to this query: a generic security feature flag, or one
 * specifically controlling insecure certificate configuration.
 */
FlagKind securityOrTlsVersionFlag() {
  result = any(SecurityFeatureFlag f) or
  result = any(InsecureCertificateFlag f)
}

/**
 * Holds if `name` is (likely to be) a general security flag or one specifically controlling
 * an insecure certificate setup.
 */
bindingset[name]
predicate isSecurityOrCertificateConfigFlag(string name) {
  name = securityOrTlsVersionFlag().getAFlagName()
}

from Write w, DataFlow::Node base, Field f, DataFlow::Node rhs
where
  w.writesField(base, f, rhs) and
  f.hasQualifiedName("crypto/tls", "Config", "InsecureSkipVerify") and
  rhs.getBoolValue() = true and
  // exclude writes guarded by a feature flag
  not [getASecurityFeatureFlagCheck(), getAnInsecureCertificateCheck()].dominatesNode(w) and
  // exclude results in functions whose name documents the insecurity
  not exists(FuncDef fn | fn = w.getRoot() |
    isSecurityOrCertificateConfigFlag(fn.getEnclosingFunction*().getName())
  ) and
  // exclude results that flow into a field/variable whose name documents the insecurity
  not exists(ValueEntity e, DataFlow::Node init |
    isSecurityOrCertificateConfigFlag(e.getName()) and
    any(Write w2).writes(e, init) and
    becomesPartOf*(base, init)
  ) and
  // exclude results in test code
  exists(File fl | fl = w.getFile() | not fl instanceof TestFile)
select w, "InsecureSkipVerify should not be used in production code."
