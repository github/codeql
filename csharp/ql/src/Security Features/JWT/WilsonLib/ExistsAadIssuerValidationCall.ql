/**
 * @name Exists AAD Issuer Validation Call
 * @description Verify that there is at least one call to `EnableAadSigningKeyIssuerValidation` if we detect the usage of Wilson library.
 * @kind problem
 * @tags security
 *       wilson-library
 * @id cs/wilson-library/exists-aad-issuer-validation-call
 * @problem.severity error
 */

import csharp
import WilsonLibAad

from TokenValidationParametersObjectCreation oc
where
  not exists(MethodCall c | c instanceof EnableAadSigningKeyIssuerValidationMethodCall) and
  oc.fromSource()
select oc,
  "A call to Wilson library's $@ without any call to `EnableAadSigningKeyIssuerValidation`. Visit https://aka.ms/wilson/vul-23030 for details.",
  oc, oc.getTarget().toString()
