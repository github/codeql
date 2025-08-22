/**
 * @name Disabled certificate revocation checking
 * @description Using revoked certificates is dangerous.
 *              Therefore, revocation status of certificates in a chain should be checked.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/disabled-certificate-revocation-checking
 * @tags security
 *       experimental
 *       external/cwe/cwe-299
 */

import java
deprecated import RevocationCheckingLib
deprecated import DisabledRevocationCheckingFlow::PathGraph

deprecated query predicate problems(
  DataFlow::Node sourceNode, DisabledRevocationCheckingFlow::PathNode source,
  DisabledRevocationCheckingFlow::PathNode sink, string message
) {
  DisabledRevocationCheckingFlow::flowPath(source, sink) and
  sourceNode = source.getNode() and
  message = "This disables revocation checking."
}
