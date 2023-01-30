/**
 * @name Use of a hardcoded key for signing JWT
 * @description Using a fixed hardcoded key for signing JWT's can allow an attacker to compromise security.
 * @kind path-problem
 * @problem.severity error
 * @id go/hardcoded-key
 * @tags security
 *       experimental
 *       external/cwe/cwe-321
 */

import go
import HardcodedKeysLib
import DataFlow::PathGraph

from HardcodedKeys::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is used to sign a JWT token.", source.getNode(),
  "Hardcoded String"
