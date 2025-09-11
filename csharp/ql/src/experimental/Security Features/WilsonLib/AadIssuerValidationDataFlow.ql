/**
 * @name AAD Issuer Validation With Data Flow
 * @description Verify that after creating a new `TokenValidationParameters` object, there is a dataflow to call `EnableAadSigningKeyIssuerValidation`.
 * @kind problem
 * @tags security
 *       wilson-library
 * @id cs/wilson-library/aad-issuer-validation-data-flow
 * @problem.severity error
 */

import csharp
import WilsonLibAad

from TokenValidationParametersObjectCreation oc
where
  not isTokenValidationParametersCallingEnableAadSigningKeyIssuerValidation(oc) and
  oc.fromSource()
select oc,
  "The usage of Wilson library without validating the AAD key issuer if you use IdentityModel directly to validate Azure AD tokens was detected. Visit https://aka.ms/wilson/vul-23030 for details."
