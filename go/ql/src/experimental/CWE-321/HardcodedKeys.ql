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
import HardcodedKeys::Flow::PathGraph

from HardcodedKeys::Flow::PathNode source, HardcodedKeys::Flow::PathNode sink
where HardcodedKeys::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "$@ is used to sign a JWT token.", source.getNode(),
  "Hardcoded String"
