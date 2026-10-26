/**
 * @name Untrusted domain used in script or other content
 * @description Using a resource from an untrusted or compromised domain makes your code vulnerable to receiving malicious code.
 * @kind problem
 * @security-severity 7.2
 * @problem.severity error
 * @id js/functionality-from-untrusted-domain
 * @precision high
 * @tags security
 *       external/cwe/cwe-830
 */

import javascript
import semmle.javascript.security.FunctionalityFromUntrustedSource

from AddsUntrustedUrl s
where isUrlWithUntrustedDomain(s.getUrl())
select s, "Content loaded from untrusted domain with no integrity check."
