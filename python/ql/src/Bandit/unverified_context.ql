/**
 * @name Unverified context
 * @description By default, Python will create a secure, verified ssl context for use in such classes as HTTPSConnection.
 * 				However, it still allows using an insecure context via the _create_unverified_context that reverts to the 
 * 				previous behavior that does not validate certificates or perform hostname checks.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b323-unverified-context
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision medium
 * @id py/bandit/unverified-context
 */

import python

predicate isAttribute(Attribute a, string enumName, string attrName) {
  a.getObject().toString() = enumName
  and a.getName() = attrName
}

from Attribute a
where isAttribute(a, "ssl", "_create_unverified_context")
select a, "Unverified context"
