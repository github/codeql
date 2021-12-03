/**
 * @name LDAP query built from user-controlled sources
 * @description Building an LDAP query from user-controlled sources is vulnerable to insertion of
 *              malicious LDAP code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/ldap-injection
 * @tags security
 *       external/cwe/cwe-090
 */

import java
import semmle.code.java.dataflow.FlowSources
import LdapInjectionLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, LdapInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "LDAP query might include code from $@.", source.getNode(),
  "this user input"
