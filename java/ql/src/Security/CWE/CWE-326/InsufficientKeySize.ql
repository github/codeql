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
// from
//   AsymmetricKeyTrackingConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink,
//   KeyTrackingConfiguration cfg2 //, DataFlow::PathNode source2, DataFlow::PathNode sink2
// where
//   //cfg.hasFlowPath(source, sink) //or
//   cfg2.hasFlowPath(source, sink)
// select sink.getNode(), source, sink, "The $@ of an asymmetric key should be at least 2048 bits.",
//   sink.getNode(), "size"
from DataFlow::PathNode source, DataFlow::PathNode sink
where
  //hasInsufficientKeySize2(source, sink)
  exists(AsymmetricKeyTrackingConfiguration config1 | config1.hasFlowPath(source, sink)) or
  exists(AsymmetricECCKeyTrackingConfiguration config2 | config2.hasFlowPath(source, sink)) or
  exists(SymmetricKeyTrackingConfiguration config3 | config3.hasFlowPath(source, sink))
select sink.getNode(), source, sink, "This $@ is too small.", sink.getNode(), "key size"
