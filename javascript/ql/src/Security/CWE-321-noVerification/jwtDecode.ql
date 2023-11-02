/**
 * @name JWT missing secret or public key verification
 * @description The application does not verify the JWT payload with a cryptographic secret or public key.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.0
 * @precision high
 * @id js/jwt-missing-verification
 * @tags security
 *       external/cwe/cwe-347
 */

import javascript

from DataFlow::Node sink
where
  // I must somehow check that following is implemented in server not browser
  sink = API::moduleImport("jwt-decode").getParameter(0).asSink()
select sink, "This Token is Decoded in without signature validation"
