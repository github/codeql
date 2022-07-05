/**
 * @name Security sensitive JsonWebTokenHandler validations are disabled
 * @description Check if secruity sensitive token validations for `JsonWebTokenHandler` are being disabled.
 * @kind problem
 * @tags security
 *       JsonWebTokenHandler
 *       manual-verification-required
 * @id cs/JsonWebTokenHandler/security-validations-disabled
 * @problem.severity error
 * @precision high
 */

import csharp
import JsonWebTokenHandlerLib

from
  FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidation config,
  DataFlow::Node source, DataFlow::Node sink,
  TokenValidationParametersPropertyWriteToBypassSensitiveValidation pw
where
  config.hasFlow(source, sink) and
  exists(Assignment a | a.getLValue() = pw | sink.asExpr() = a.getRValue())
select sink, "The security sensitive property $@ is being disabled by the following value: $@.", pw,
  pw.getTarget().toString(), source, "false"
