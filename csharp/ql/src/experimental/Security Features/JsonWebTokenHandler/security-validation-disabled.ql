/**
 * @name Security sensitive JsonWebTokenHandler validations are disabled
 * @description Check if security sensitive token validations for `JsonWebTokenHandler` are being disabled.
 * @kind problem
 * @tags security
 *       JsonWebTokenHandler
 *       manual-verification-required
 * @id cs/json-webtoken-handler/security-validations-disabled
 * @problem.severity error
 * @precision high
 */

import csharp
import JsonWebTokenHandlerLib

from
  FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidation config,
  DataFlow::Node source, DataFlow::Node sink,
  TokenValidationParametersPropertySensitiveValidation pw, string qualifier, string name
where
  config.hasFlow(source, sink) and
  sink.asExpr() = pw.getAnAssignedValue() and
  pw.hasQualifiedName(qualifier, name)
select sink, "The security sensitive property $@ is being disabled by the following value: $@.", pw,
  printQualifiedName(qualifier, name), source, "false"
