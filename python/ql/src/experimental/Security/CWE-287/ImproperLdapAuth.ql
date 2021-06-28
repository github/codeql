/**
 * @name Improper LDAP Authentication
 * @description A user-controlled query carries no authentication
 * @kind problem
 * @problem.severity warning
 * @id py/improper-ldap-auth
 * @tags experimental
 *       security
 *       external/cwe/cwe-287
 */

// Determine precision above
import python
import experimental.semmle.python.security.LDAPImproperAuth

from LDAPBind ldapBind
where authenticatesImproperly(ldapBind)
select ldapBind, "The following LDAP bind operation is executed without authentication"
