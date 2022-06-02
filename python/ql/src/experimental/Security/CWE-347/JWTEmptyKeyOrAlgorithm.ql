/**
 * @name JWT encoding using empty key or algorithm
 * @description The application uses an empty secret or algorithm while encoding a JWT Token.
 * @kind problem
 * @problem.severity warning
 * @id py/jwt-empty-secret-or-algorithm
 * @tags security
 */

// determine precision above
import python
import experimental.semmle.python.Concepts
import experimental.semmle.python.frameworks.JWT

from JwtEncoding jwtEncoding, string affectedComponent
where
  affectedComponent = "algorithm" and
  isEmptyOrNone(jwtEncoding.getAlgorithm())
  or
  affectedComponent = "key" and
  isEmptyOrNone(jwtEncoding.getKey())
select jwtEncoding, "This JWT encoding has an empty " + affectedComponent + "."
