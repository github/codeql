/**
 * @name Security implications associated with wsgiref.handlers.CGIHandler module.
 * @description Consider possible security implications associated with wsgiref.handlers.CGIHandler module.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b412-import-httpoxy
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/httpoxy-cgihandler
 */

import python

from Attribute a
where a.getName() = "CGIHandler" 
and a.getObject().(Attribute).getName() = "handlers"
and a.getObject().(Attribute).getObject().toString() = "wsgiref"
select a, "Consider possible security implications associated with wsgiref.handlers.CGIHandler module."