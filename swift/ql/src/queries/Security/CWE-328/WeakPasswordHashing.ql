/**
 * @name Use of an inappropriate cryptographic hashing algorithm on passwords
 * @description Using inappropriate cryptographic hashing algorithms with passwords can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id csharp/weak-password-hashing
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 *       external/cwe/cwe-916
 */

import csharp
import WeakPasswordHashingQuery
import WeakHashingFlow::PathGraph

from
  WeakHashingFlow::PathNode source, WeakHashingFlow::PathNode sink, string algorithm,
  PasswordExpr expr
where
  WeakHashingFlow::flowPath(source, sink) and
  algorithm = sink.getNode().(WeakPasswordHashingSink).getAlgorithm() and
  expr = source.getNode().asExpr()
select sink.getNode(), source, sink,
  "Insecure hashing algorithm (" + algorithm + ") depends on $@.", source.getNode(),
  "password (" + expr + ")"
