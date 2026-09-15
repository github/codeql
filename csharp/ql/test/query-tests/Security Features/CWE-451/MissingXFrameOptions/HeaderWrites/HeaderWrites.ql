/**
 * @kind problem
 * @id cs/test/clickjacking-header-write
 * @problem.severity warning
 */

import csharp
import Security_Features.MissingXFrameOptionsLib

from Expr write
where write = getAClickjackingHeaderWrite()
select write, "A clickjacking-related response header is configured here."
