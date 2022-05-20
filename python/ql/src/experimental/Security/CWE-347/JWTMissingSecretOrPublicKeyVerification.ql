/**
 * @name JWT missing secret or public key verification
 * @description The application does not verify the JWT payload with a cryptographic secret or public key.
 * @kind problem
 * @problem.severity warning
 * @id py/jwt-missing-verification
 * @tags security
 *       external/cwe/cwe-347
 */

// determine precision above
import python
import experimental.semmle.python.Concepts

from JwtDecoding jwtDecoding
where not jwtDecoding.verifiesSignature()
select jwtDecoding.getPayload(), "is not verified with a cryptographic secret or public key."
