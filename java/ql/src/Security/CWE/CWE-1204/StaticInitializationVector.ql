/**
 * @name Using a static initialization vector for encryption
 * @description An initialization vector (IV) used for ciphers of certain modes (such as CBC or GCM) should be unique and unpredictable, to maximize encryption and prevent dictionary attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id java/static-initialization-vector
 * @tags security
 *       external/cwe/cwe-329
 *       external/cwe/cwe-1204
 */

import java
import semmle.code.java.security.StaticInitializationVectorQuery
import StaticInitializationVectorFlow::PathGraph

from StaticInitializationVectorFlow::PathNode source, StaticInitializationVectorFlow::PathNode sink
where StaticInitializationVectorFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "A $@ should not be used for encryption.", source.getNode(),
  "static initialization vector"
