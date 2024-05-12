/**
 * @name ASP.NET: leftover debug code
 * @description Finds leftover entry points in web applications
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/web/debug-code
 * @tags security
 *       maintainability
 *       frameworks/asp.net
 *       external/cwe/cwe-489
 */

import csharp
import semmle.code.csharp.commons.Util

from MainMethod m
where
  m.fromSource() and
  exists(UsingNamespaceDirective u |
    u.getFile() = m.getFile() and
    u.getImportedNamespace().hasFullyQualifiedName("System", "Web")
  )
select m, "Remove debug code if your ASP.NET application is in production."
