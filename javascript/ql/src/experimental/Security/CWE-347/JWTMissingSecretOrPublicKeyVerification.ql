/**
 * @name JWT missing secret or public key verification
 * @description The application does not verify the JWT payload with a cryptographic secret or public key.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/jwt-missing-verification
 * @tags security
 *       external/cwe/cwe-347
 */

import javascript
import DataFlow
import semmle.javascript.RestrictedLocations

from CallNode call
where
  call = moduleMember("jsonwebtoken", "verify").getACall() and
  unique(boolean b | b = call.getArgument(1).analyze().getABooleanValue()) = false
select call.asExpr().(FirstLineOf),
  "does not verify the JWT payload with a cryptographic secret or public key."
