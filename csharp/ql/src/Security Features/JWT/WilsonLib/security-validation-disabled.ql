/**
 * @name Security sensitive JsonWebTokenHandler validations are disabled
 * @description Check if security sensitive token validations for `JsonWebTokenHandler` are being disabled.
 * @kind problem
 * @tags security
 *       wilson-library
 *       manual-verification-required
 * @id cs/wilson-library/security-validations-disabled
 * @problem.severity warning
 * @precision high
 */

import csharp
import wilsonlib

from
  DataFlow::Node source, DataFlow::Node sink,
  TokenValidationParametersPropertyWriteToBypassSensitiveValidation pw
where
  FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidationTT::flow(source, sink) and
  exists(Assignment a | a.getLValue() = pw | sink.asExpr() = a.getRValue())
select sink, "The security sensitive property $@ is being disabled by the following value: $@.", pw,
  pw.getTarget().toString(), source, "false"
