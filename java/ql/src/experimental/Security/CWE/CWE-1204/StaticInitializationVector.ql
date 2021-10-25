/**
 * @name Using a static initialization vector for encryption
 * @description A cipher needs an initialization vector (IV) in some cases,
 *              for example, when CBC or GCM modes are used. IVs are used to randomize the encryption,
 *              therefore they should be unique and ideally unpredictable.
 *              Otherwise, the same plaintexts result in same ciphertexts under a given secret key.
 *              If a static IV is used for encryption, this lets an attacker learn
 *              if the same data pieces are transferred or stored,
 *              or this can help the attacker run a dictionary attack.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id java/static-initialization-vector
 * @tags security
 *       external/cwe/cwe-329
 *       external/cwe/cwe-1204
 */

import java
import experimental.semmle.code.java.security.StaticInitializationVectorQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, StaticInitializationVectorConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "A $@ should not be used for encryption.", source.getNode(),
  "static initialization vector"
