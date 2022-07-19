/**
 * @name Using a static initialization vector for encryption
 * @description An initialization vector (IV) used for ciphers of certain modes (such as CBC or GCM) should be unique and unpredicateble.
 *              Otherwise, if the same IV is used with a the same secret key then the same plaintext results in same ciphertext, which weakens the encryption.
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
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, StaticInitializationVectorConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "A $@ should not be used for encryption.", source.getNode(),
  "static initialization vector"
