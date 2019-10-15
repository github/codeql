/**
 * @name  Use of HTTPSConnection on older versions of Python
 * @description Use of HTTPSConnection on older versions of Python prior to 2.7.9 and 3.4.3 do not provide security, see https://wiki.openstack.org/wiki/OSSN/OSSN-0033
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b309-httpsconnection
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision high
 * @id py/bandit/httplib
 */

import python

from Attribute a
where a.getName() = "HTTPSConnection" 
and 
	(a.getObject().toString() = "httplib"
	 or a.getObject().(Attribute).getName() = "client"
	 or a.getObject().(Attribute).getName() = "http_client")
select a, "Use of HTTPSConnection on older versions of Python prior to 2.7.9 and 3.4.3 do not provide security"