/**
 * @name Dp not use xmlrpclib
 * @description Using xmlrpclib to parse untrusted XML data is known to be vulnerable to XML attacks. 
 * 				Use defused.xmlrpc.monkey_patch() function to monkey-patch xmlrpclib and mitigate XML vulnerabilities.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b411-import-xmlrpclib
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/xml-xmlrpc
 */

import python

from ImportExpr i
where i.getName().toString() = "SimpleXMLRPCServer"
select i, "Using xmlrpclib to parse untrusted XML data is known to be vulnerable to XML attacks."

