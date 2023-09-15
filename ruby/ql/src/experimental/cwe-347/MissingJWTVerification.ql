/**
 * @name JWT missing secret or public key verification
 * @description The application does not verify the JWT payload with a cryptographic secret or public key.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id rb/jwt-missing-verification
 * @tags security
 *       external/cwe/cwe-347
 */

private import codeql.ruby.Concepts

from JwtDecoding jwtDecoding
where not jwtDecoding.verifiesSignature()
select jwtDecoding.getPayload(), "is not verified with a cryptographic secret or public key."
