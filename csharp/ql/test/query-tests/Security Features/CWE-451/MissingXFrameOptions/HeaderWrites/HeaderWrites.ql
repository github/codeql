/**
 * @kind problem
 * @id cs/test/clickjacking-header-write
 * @problem.severity warning
 */

import csharp
import semmle.code.csharp.security.MissingXFrameOptionsQuery

from Expr write
where write = getAClickjackingHeaderWrite()
select write, "A clickjacking-related response header is configured here."
