/**
 * @name Timing attack against signature validation
 * @description When checking a signature over a message, a constant-time algorithm should be used.
 *              Otherwise, an attacker may be able to forge a valid signature for an arbitrary message
 *              by running a timing attack if they can send to the validation procedure
 *              both the message and the signature.
 *              A successful attack can result in authentication bypass.
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
