/**
 * @name Improper LDAP Authentication
 * @description A user-controlled query carries no authentication
 * @kind problem
 * @problem.severity warning
 * @id py/improper-ldap-auth
 * @tags security
 *       external/cwe/cwe-287
 */

// Determine precision above
import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow

predicate authenticatesImproperly(LdapBind ldapBind) {
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

from LdapBind ldapBind
where authenticatesImproperly(ldapBind)
select ldapBind, "The following LDAP bind operation is executed without authentication"
