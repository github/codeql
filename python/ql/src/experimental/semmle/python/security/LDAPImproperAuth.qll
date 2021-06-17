/**
 * Provides a taint-tracking configuration for detecting LDAP improper authentication vulnerabilities
 */

import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

predicate authenticatesImproperly(LDAPBind ldapBind) {
  (
    DataFlow::localFlow(DataFlow::exprNode(any(None noneName)), ldapBind.getPassword()) or
    not exists(ldapBind.getPassword())
  )
  or
  exists(StrConst emptyString |
    emptyString.getText() = "" and
    DataFlow::localFlow(DataFlow::exprNode(emptyString), ldapBind.getPassword())
  )
}
