/**
 * @name Use of a hardcoded key for signing JWT
 * @description Using a hardcoded key for signing JWT can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @id java/hardcoded-jwt-key
 * @tags security
 *       experimental
 *       external/cwe/cwe-321
 */

import java
import HardcodedJwtKey
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, HardcodedJwtKeyConfiguration cfg
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is used to sign a JWT token.", source.getNode(),
  "Hardcoded String"
