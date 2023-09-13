/**
 * @name Call to vulnerable function
 * @description Calling a function with a known security vulnerability may expose the application
 *              if the relevant dependency is not updated
 * @kind problem
 * @problem.severity info
 * @precision high
 * @id js/vulnerable-calls
 */

//
// NOTE: This query has no results when run out of the box, as it depends on models
// that are not part of this qlpack. The query metadata above deliberately does not mark it
// as a 'security' query as users would generally expect such a query to work out of the box.
//
import javascript
import semmle.javascript.security.VulnerableCalls

from string id, DataFlow::InvokeNode invoke
where invoke = ModelOutput::getAVulnerableCall(id)
select invoke, "This call is potentially vulnerable to " + id
