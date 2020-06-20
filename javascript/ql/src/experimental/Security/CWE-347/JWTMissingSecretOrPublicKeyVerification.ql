/**
 * @name JWT Missing Secret Or Public Key Verification
 * @description The software does not verify the JWT token with a cryptographic secret or public key.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/jwt-missing-secret-or-public-key-verification
 * @tags security
 *       external/cwe/cwe-347
 */

import javascript
import DataFlow

from CallNode call
where
  call = moduleMember("jsonwebtoken", "verify").getACall() and
  call.getArgument(1).analyze().getABooleanValue() = false
select call
