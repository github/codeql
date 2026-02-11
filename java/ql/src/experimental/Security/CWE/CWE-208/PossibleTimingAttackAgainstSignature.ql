/**
 * @name Possible timing attack against signature validation
 * @description When checking a signature over a message, a constant-time algorithm should be used.
 *              Otherwise, there is a risk of a timing attack that allows an attacker
 *              to forge a valid signature for an arbitrary message. For a successful attack,
 *              the attacker has to be able to send to the validation procedure both the message and the signature.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/possible-timing-attack-against-signature
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
  sinkNode = sink.getNode() and
  message1 = "Possible timing attack against $@ validation." and
  source = source0 and
  message2 = source.getNode().(CryptoOperationSource).getCall().getResultType()
}
