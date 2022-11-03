/*
 * @name Checks for model consistency
 */

import semmle.code.csharp.commons.ConsistencyChecks

from Element e, string m
where consistencyFailure(e, m)
select e, "Element class " + e.getPrimaryQlClasses() + " has consistency check failed: " + m
