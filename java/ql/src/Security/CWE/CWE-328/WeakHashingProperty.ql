/**
 * @name Weak Hashing Property
 * @description Using weak cryptographic algorithms can allow an attacker to compromise security.
 * @id java/weak-hashing-property
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @tags security
 *      external/cwe/cwe-328
 */

import java
import semmle.code.java.security.WeakHashingAlgorithmPropertyQuery
import InsecureAlgorithmPropertyFlow::PathGraph

from InsecureAlgorithmPropertyFlow::PathNode source, InsecureAlgorithmPropertyFlow::PathNode sink
where InsecureAlgorithmPropertyFlow::flowPath(source, sink)
select sink.getNode(), sink, source, "The $@ algorithm is insecure.", source,
  getWeakHashingAlgorithmName(source.getNode())
