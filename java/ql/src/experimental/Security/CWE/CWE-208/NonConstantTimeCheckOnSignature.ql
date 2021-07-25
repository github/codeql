/**
 * @name Using a non-constant-time algorithm for checking a signature
 * @description When checking a signature, a constant-time algorithm should be used.
 *              Otherwise, an attacker may be able to implement a timing attack.
 *              A successful attack may uncover a valid signature
 *              that in turn can result in authentication bypass.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/non-constant-time-in-signature-check
 * @tags security
 *       external/cwe/cwe-208
 */

import java
import NonConstantTimeCheckOnSignatureQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, NonConstantTimeCryptoComparisonConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Using a non-constant-time method for checking a $@.", source,
  source.getNode().(CryptoOperationSource).getCall().getResultType()
