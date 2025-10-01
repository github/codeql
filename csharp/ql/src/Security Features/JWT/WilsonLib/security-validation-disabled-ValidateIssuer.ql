/**
 * @name Security sensitive JsonWebTokenHandler ValidateIssuer is disabled
 * @description Issuer validaton is disabled for `JsonWebTokenHandler`.
 * @kind problem
 * @tags security
 *       wilson-library
 *       manual-verification-required
 * @id cs/wilson-library/security-issuervalidation-disabled
 * @problem.severity warning
 * @precision high
 */

import csharp
import wilsonlib

from
  DataFlow::Node source,
  DataFlow::Node sink
where
  FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidationTT::flow(source, sink) and
  exists(Assignment a, Property p, PropertyWrite pw |
    a.getLValue() = pw and
    p.getName() = "ValidateIssuer" and
    p.getAnAccess() = pw and
    pw = a.getLValue() and 
    sink.asExpr() = a.getRValue()
  )
select sink, "The ValidateIssuer security-sensitive property is being disabled by the following value: $@.",
    source, "false"
