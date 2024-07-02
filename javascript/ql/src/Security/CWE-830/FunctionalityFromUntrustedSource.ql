/**
 * @name Inclusion of functionality from an untrusted source
 * @description Including functionality from an untrusted source may allow
 *              an attacker to control the functionality and execute arbitrary code.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.0
 * @precision high
 * @id js/functionality-from-untrusted-source
 * @tags security
 *       external/cwe/cwe-830
 */

import javascript
import semmle.javascript.security.FunctionalityFromUntrustedSource

from AddsUntrustedUrl s
select s, s.getProblem()
