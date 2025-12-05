/**
 * @name Call to vulnerable method
 * @description Calling a method with a known security vulnerability may expose the application
 *              if the relevant dependency is not updated.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id binary/vulnerable-calls
 */

import VulnerableCalls

from VulnerableMethodCall call, string id
where call.getVulnerabilityId() = id
select call, "This call is potentially vulnerable to " + id
