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
 *       experimental
 *       external/cwe/cwe-208
 */

import java
import semmle.code.java.dataflow.DataFlow
deprecated import NonConstantTimeCheckOnSignatureQuery
deprecated import NonConstantTimeCryptoComparisonFlow::PathGraph

deprecated query predicate problems(
  DataFlow::Node sinkNode, NonConstantTimeCryptoComparisonFlow::PathNode source,
  NonConstantTimeCryptoComparisonFlow::PathNode sink, string message1,
  NonConstantTimeCryptoComparisonFlow::PathNode source0, string message2
) {
  NonConstantTimeCryptoComparisonFlow::flowPath(source, sink) and
  (
    source.getNode().(CryptoOperationSource).includesUserInput() and
    sinkNode.(NonConstantTimeComparisonSink).includesUserInput()
  ) and
  sinkNode = sink.getNode() and
  message1 = "Timing attack against $@ validation." and
  source = source0 and
  message2 = source.getNode().(CryptoOperationSource).getCall().getResultType()
}
