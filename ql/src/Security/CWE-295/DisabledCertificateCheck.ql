/**
 * @name Disabled TLS certificate check
 * @description If an application disables TLS certificate checking, it may be vulnerable to
 *              man-in-the-middle attacks.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id go/disabled-certificate-check
 * @tags security
 *       external/cwe/cwe-295
 *
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

from Write w, DataFlow::Node base, Field f, DataFlow::Node rhs
where
  w.writesField(base, f, rhs) and
  f.hasQualifiedName("crypto/tls", "Config", "InsecureSkipVerify") and
  rhs.getBoolValue() = true and
  // exclude writes guarded by a feature flag
  not getAFeatureFlagCheck().dominatesNode(w) and
  // exclude results in functions whose name documents the insecurity
  not exists(FuncDef fn | fn = w.getRoot() |
    isFeatureFlagName(fn.getEnclosingFunction*().getName())
  ) and
  // exclude results that flow into a field/variable whose name documents the insecurity
  not exists(ValueEntity e, DataFlow::Node init |
    isFeatureFlagName(e.getName()) and
    any(Write w2).writes(e, init) and
    becomesPartOf*(base, init)
  ) and
  // exclude results in test code
  exists(File fl | fl = w.getFile() | not fl = any(TestCase tc).getFile())
select w, "InsecureSkipVerify should not be used in production code."
