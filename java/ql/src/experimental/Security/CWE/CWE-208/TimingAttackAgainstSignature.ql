/**
 * @name Timing attack against signature validation
 * @description When checking a signature, a constant-time algorithm should be used.
 *              Otherwise, an attacker may be able to implement a timing attack
 *              if they control inputs for the cryptographic operation and the checking procedure.
 *              A successful attack may uncover a valid signature
 *              that in turn can result in authentication bypass.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/timing-attack-against-signature
 * @tags security
 *       external/cwe/cwe-208
 */

import java
import NonConstantTimeCheckOnSignatureQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, NonConstantTimeCryptoComparisonConfig conf
where
  conf.hasFlowPath(source, sink) and
  (
    source.getNode().(CryptoOperationSource).includesUserInput() and
    sink.getNode().(NonConstantTimeComparisonSink).includesUserInput()
  )
select sink.getNode(), source, sink, "Timing attack against $@ validation.", source,
  source.getNode().(CryptoOperationSource).getCall().getResultType()
