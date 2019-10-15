/**
 * @name Audit url open for permitted schemes
 * @description Audit url open for permitted schemes. Allowing use of file:/ or custom schemes is often unexpected.
 *         https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b310-urllib-urlopen
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision high
 * @id py/bandit/unverified-urlopen
 */

import python

predicate isAttribute(Attribute a, string enumName, string attrName) {
  a.getObject().toString() = enumName
  and a.getName() = attrName
}


from Attribute a
where isAttribute(a, "urllib", "urlopen")
   or isAttribute(a, "urllib", "urlretrieve")
   or isAttribute(a, "urllib", "URLopener")
   or isAttribute(a, "urllib", "FancyURLopener")
   or isAttribute(a, "urllib2", "urlopen")   
   or isAttribute(a, "request", "URLopener")   
   or isAttribute(a, "request", "FancyURLopener")      
   
select a, "Audit url open for permitted schemes. Allowing use of file:/ or custom schemes is often unexpected."
