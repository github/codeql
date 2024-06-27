/**
 * @name Value shadowing
 * @description Finds ambiguous accesses to client variables
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/web/ambiguous-client-variable
 * @tags security
 *       maintainability
 *       frameworks/asp.net
 *       external/cwe/cwe-348
 */

import csharp
import semmle.code.csharp.frameworks.system.web.Http

from IndexerAccess ia
where
  ia.getTarget().getDeclaringType().hasFullyQualifiedName("System.Web", "HttpRequest") and
  not isServerVariable(ia.getIndex(0))
select ia, "Ambiguous access to variable."
