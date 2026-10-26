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
import semmle.javascript.RestrictedLocations

from DataFlow::CallNode call
where
  call = DataFlow::moduleMember("jsonwebtoken", "verify").getACall() and
  call.getArgument(1).analyze().getTheBooleanValue() = false
select call.getArgument(1),
  "This argument disables the integrity enforcement of the token verification."
