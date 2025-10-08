/**
 * @name Delegated IssuerValidator for JsonWebTokenHandler always return issuer argument back
 * @description `IssuerValidator` delegator for `JsonWebTokenHandler` always return the `issuer` argument back without any checks.
 *   Medium precision version that does not check for exception throws, so false positives are expected.
 * @kind problem
 * @tags security
 *       wilson-library
 *       manual-verification-required
 * @id cs/wilson-library/delegated-security-validations-always-return-issuer-parameter
 * @problem.severity warning
 * @precision medium
 */

import csharp
import DataFlow
import wilsonlib

from
  TokenValidationParametersPropertyWriteToValidationDelegatedIssuerValidator tv, Assignment a,
  CallableAlwaysReturnsParameter0MayThrowExceptions e
where a.getLValue() = tv and a.getRValue().getAChild*() = e
select tv,
  "Delegated $@ for `JsonWebTokenHandler` is $@.",
  tv, tv.getTarget().toString(), e, "a callable that always returns the 1st argument"
