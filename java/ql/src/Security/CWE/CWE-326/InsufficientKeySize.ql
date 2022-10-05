/**
 * @name Insufficient key size used with a cryptographic algorithm
 * @description Using cryptographic algorithms with too small of a key size can
 *              allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/insufficient-key-size
 * @tags security
 *       external/cwe/cwe-326
 */

import java
import semmle.code.java.security.InsufficientKeySizeQuery
import DataFlow::PathGraph

// from Expr e, string msg
// where hasInsufficientKeySize(e, msg)
// select e, msg
from AsymmetricKeyTrackingConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "The $@ of an asymmetric key should be at least 2048 bits.",
  sink.getNode(), "size"
