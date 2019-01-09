/**
 * @name LDAP query built from user-controlled sources
 * @description Building an LDAP query from user-controlled sources is vulnerable to insertion of
 *              malicious LDAP code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/ldap-injection
 * @tags security
 *       external/cwe/cwe-090
 */

import csharp
import semmle.code.csharp.security.dataflow.LDAPInjection::LDAPInjection
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in an LDAP query.",
  source.getNode(), "User-provided value"
