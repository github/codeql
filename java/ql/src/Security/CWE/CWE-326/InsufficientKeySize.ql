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

from DataFlow::PathNode source, DataFlow::PathNode sink
where
  //exists(KeyTrackingConfiguration config1 | config1.hasFlowPath(source, sink))
  //or
  exists(AsymmetricNonECKeyTrackingConfiguration cfg | cfg.hasFlowPath(source, sink)) or
  exists(AsymmetricECKeyTrackingConfiguration cfg | cfg.hasFlowPath(source, sink)) or
  exists(SymmetricKeyTrackingConfiguration cfg | cfg.hasFlowPath(source, sink))
select sink.getNode(), source, sink, "This $@ is too small.", source.getNode(), "key size"
