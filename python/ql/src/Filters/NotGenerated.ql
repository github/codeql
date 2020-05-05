/**
 * @name Filter: non-generated files
 * @description Only keep results that aren't (or don't appear to be) generated.
 * @kind problem
 * @id py/not-generated-file-filter
 */

import python
import external.DefectFilter
import semmle.python.filters.GeneratedCode

from DefectResult res
where not exists(GeneratedFile f | res.getFile() = f)
select res, res.getMessage()
