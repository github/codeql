/**
 * @name Methods that call vulnerable code
 * @description Lists all methods that transitively call a vulnerable method,
 *              useful for generating models or understanding impact.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id binary/vulnerable-calls-summarize
 */

import VulnerableCalls

from CilMethodExt method, string id, string namespace, string className, string methodName
where
  method = getAVulnerableMethod(id) and
  method.hasFullyQualifiedName(namespace, className, methodName)
select method,
  "Method " + namespace + "." + className + "." + methodName +
    " transitively calls vulnerable code (" + id + ")"
