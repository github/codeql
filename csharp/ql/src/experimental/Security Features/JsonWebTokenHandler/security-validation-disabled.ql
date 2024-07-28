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
import JsonWebTokenHandlerLib
import semmle.code.csharp.commons.QualifiedName

from
  DataFlow::Node source, DataFlow::Node sink,
  TokenValidationParametersPropertySensitiveValidation pw, string qualifier, string name
where
  FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidation::flow(source, sink) and
  sink.asExpr() = pw.getAnAssignedValue() and
  pw.hasFullyQualifiedName(qualifier, name)
select sink, "The security sensitive property $@ is being disabled by the following value: $@.", pw,
  getQualifiedName(qualifier, name), source, "false"
