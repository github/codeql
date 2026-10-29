/**
 * @name Use of an inappropriate cryptographic hashing algorithm on passwords
 * @description Using inappropriate cryptographic hashing algorithms with passwords can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id swift/weak-password-hashing
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 *       external/cwe/cwe-916
 */

import swift
import codeql.swift.security.WeakPasswordHashingQuery
import WeakPasswordHashingFlow::PathGraph

from
  WeakPasswordHashingFlow::PathNode source, WeakPasswordHashingFlow::PathNode sink, string algorithm
where
  WeakPasswordHashingFlow::flowPath(source, sink) and
  algorithm = sink.getNode().(WeakPasswordHashingSink).getAlgorithm()
select sink.getNode(), source, sink,
  "Insecure hashing algorithm (" + algorithm + ") depends on $@.", source.getNode(),
  "password (" + source.getNode().asExpr() + ")"
