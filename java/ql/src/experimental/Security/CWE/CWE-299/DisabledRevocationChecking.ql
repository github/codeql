/**
 * @name Disabled ceritificate revocation checking
 * @description Using revoked certificates is dangerous.
 *              Therefore, revocation status of certificates in a chain should be checked.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/disabled-certificate-revocation-checking
 * @tags security
 *       external/cwe/cwe-299
 */

import java
import RevocationCheckingLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, DisabledRevocationCheckingConfig config
where config.hasFlowPath(source, sink)
select source.getNode(), source, sink, "Revocation checking is disabled $@.", source.getNode(),
  "here"
