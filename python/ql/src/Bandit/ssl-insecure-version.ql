/**
 * @name Insecure SSL/TLS protocol
 * @description Function call with insecure SSL/TLS protocol identified, possible security issue
 *         https://bandit.readthedocs.io/en/latest/plugins/b502_ssl_with_bad_version.html
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision medium
 * @id py/bandit/ssl-insecure-version
 */

import python

predicate isAttribute(Attribute a, string enumName, string attrName) {
  a.getObject().toString() = enumName
  and a.getName() = attrName
}

from Attribute a
where isAttribute(a, "ssl", "PROTOCOL_SSLv2")
   or isAttribute(a, "ssl", "PROTOCOL_SSLv3")
   or isAttribute(a, "SSL", "SSLv2_METHOD")
   or isAttribute(a, "SSL", "SSLv23_METHOD")
   or isAttribute(a, "SSL", "SSLv3_METHOD")
select a, "Function call with insecure SSL/TLS protocol identified, possible security issue."
