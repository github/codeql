/**
 * @name Filter: non-generated files
 * @description Only keep results that aren't in generated files
 * @kind problem
 * @id java/not-generated-file-filter
 */

import java
import external.DefectFilter

from DefectResult res
where not res.getFile() instanceof GeneratedFile
select res, res.getMessage()
