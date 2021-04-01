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
import experimental.semmle.python.security.JWT

from JWTEncoding jwtEncoding, string affectedComponent
where
  exists( |
    affectedComponent = "algorithm" and
    isEmptyOrNone(jwtEncoding.getAlgorithmNode())
    or
    affectedComponent = "key" and
    isEmptyOrNone(jwtEncoding.getKeyNode())
  )
select jwtEncoding, affectedComponent, "is empty."
