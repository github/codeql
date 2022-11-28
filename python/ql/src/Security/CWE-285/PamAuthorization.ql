/**
 * @name PAM authorization bypass due to incorrect usage
 * @description Not using `pam_acct_mgmt` after `pam_authenticate` to check the validity of a login can lead to authorization bypass.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @id py/pam-auth-bypass
 * @tags security
 *       external/cwe/cwe-285
 */

import python
import DataFlow::PathGraph
import semmle.python.ApiGraphs
import semmle.python.security.dataflow.PamAuthorization

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "This PAM authentication call may lead to an authorization bypass, since `pam_acct_mgmt` is not called afterwards."
