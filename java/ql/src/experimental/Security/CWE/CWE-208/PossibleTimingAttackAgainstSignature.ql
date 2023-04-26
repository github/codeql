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
import NonConstantTimeCheckOnSignatureQuery
import NonConstantTimeCryptoComparisonFlow::PathGraph

from
  NonConstantTimeCryptoComparisonFlow::PathNode source,
  NonConstantTimeCryptoComparisonFlow::PathNode sink
where NonConstantTimeCryptoComparisonFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Possible timing attack against $@ validation.", source,
  source.getNode().(CryptoOperationSource).getCall().getResultType()
