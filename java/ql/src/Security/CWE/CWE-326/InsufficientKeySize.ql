/**
 * @name Use of a cryptographic algorithm with insufficient key size
 * @description Using cryptographic algorithms with too small a key size can
 *              allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id java/insufficient-key-size
 * @tags security
 *       external/cwe/cwe-326
 */

import java
import semmle.code.java.security.InsufficientKeySizeQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, KeySizeConfiguration cfg
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "This $@ is less than the recommended key size of " + source.getState() + " bits.",
  source.getNode(), "key size"
