/**
 * @name Insufficient key size used with a cryptographic algorithm
 * @description Using cryptographic algorithms with too small of a key size can
 *              allow an attacker to compromise security.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id java/insufficient-key-size
 * @tags security
 *       external/cwe/cwe-326
 */

import java
import semmle.code.java.security.InsufficientKeySizeQuery

from DataFlow::Node source, DataFlow::Node sink
where
  exists(AsymmetricNonECKeyTrackingConfiguration config1 | config1.hasFlow(source, sink)) or
  exists(AsymmetricECKeyTrackingConfiguration config2 | config2.hasFlow(source, sink)) or
  exists(SymmetricKeyTrackingConfiguration config3 | config3.hasFlow(source, sink))
select sink, "This $@ is too small.", source, "key size"
