/**
 * @name JWT encoding using empty key or algorithm
 * @description The application uses an empty secret or algorithm while encoding a JWT Token.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id rb/jwt-empty-secret-or-algorithm
 * @tags security
 */

private import codeql.ruby.Concepts

from JwtEncoding jwtEncoding
where not jwtEncoding.signs()
select jwtEncoding.getPayload(), "This JWT encoding uses empty key or none algorithm."
