/**
 * @name LDAP query built from user-controlled sources
 * @description Building an LDAP query from user-controlled sources is vulnerable to insertion of
 *              malicious LDAP code by the user.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/ldap-injection
 * @tags security
 *       external/cwe/cwe-090
 */
import csharp
import semmle.code.csharp.security.dataflow.LDAPInjection::LDAPInjection

from TaintTrackingConfiguration c, Source source, Sink sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is used in an LDAP query.", source, "User-provided value"
