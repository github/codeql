/**
 * @name Security implications associated with twisted.web.twcgi.CGIScript module.
 * @description Consider possible security implications associated with twisted.web.twcgi.CGIScript module.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b412-import-httpoxy
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/httpoxy-twisted-script
 */

import python

from Attribute a
where a.getName() = "CGIScript" 
and a.getObject().toString() = "twcgi"
select a, "Consider possible security implications associated with twisted.web.twcgi.CGIScript module."