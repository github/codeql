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
import RevocationCheckingLib
import DisabledRevocationCheckingFlow::PathGraph

from DisabledRevocationCheckingFlow::PathNode source, DisabledRevocationCheckingFlow::PathNode sink
where DisabledRevocationCheckingFlow::flowPath(source, sink)
select source.getNode(), source, sink, "This disables revocation checking."
