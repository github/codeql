/**
 * @name Security implications associated with twisted.web.twcgi.CGIDirectory module.
 * @description Consider possible security implications associated with twisted.web.twcgi.CGIDirectory module.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b412-import-httpoxy
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/httpoxy-twisted-directory
 */

import python

from Attribute a
where a.getName() = "CGIDirectory" 
and a.getObject().toString() = "twcgi"
select a, "Consider possible security implications associated with twisted.web.twcgi.CGIDirectory module."