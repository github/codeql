/**
 * @name Security sensitive JsonWebTokenHandler validations are disabled
 * @description Check if security sensitive token validations for `JsonWebTokenHandler` are being disabled.
 * @kind problem
 * @tags security
 *       experimental
 *       JsonWebTokenHandler
 *       manual-verification-required
 * @id cs/json-webtoken-handler/security-validations-disabled
 * @problem.severity error
 * @precision high
 */

import csharp
deprecated import JsonWebTokenHandlerLib
import semmle.code.csharp.commons.QualifiedName

deprecated query predicate problems(
  DataFlow::Node sink, string message, TokenValidationParametersPropertySensitiveValidation pw,
  string fullyQualifiedName, DataFlow::Node source, string value
) {
  FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidation::flow(source, sink) and
  sink.asExpr() = pw.getAnAssignedValue() and
  exists(string qualifier, string name | pw.hasFullyQualifiedName(qualifier, name) |
    fullyQualifiedName = getQualifiedName(qualifier, name)
  ) and
  message = "The security sensitive property $@ is being disabled by the following value: $@." and
  value = "false"
}
