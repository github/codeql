/**
 * @name Use of a broken or weak cryptographic hashing algorithm on sensitive data
 * @description Using broken or weak cryptographic hashing algorithms can compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id swift/weak-sensitive-data-hashing
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import swift
import codeql.swift.security.WeakSensitiveDataHashingQuery
import WeakSensitiveDataHashingFlow::PathGraph

from
  WeakSensitiveDataHashingFlow::PathNode source, WeakSensitiveDataHashingFlow::PathNode sink,
  string algorithm, SensitiveExpr expr
where
  WeakSensitiveDataHashingFlow::flowPath(source, sink) and
  algorithm = sink.getNode().(WeakSensitiveDataHashingSink).getAlgorithm() and
  expr = source.getNode().asExpr()
select sink.getNode(), source, sink,
  "Insecure hashing algorithm (" + algorithm + ") depends on $@.", source.getNode(),
  "sensitive data (" + expr.getSensitiveType() + " " + expr.getLabel() + ")"
