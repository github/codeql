/**
 * @name Filter: only keep results from source
 * @description Shows how to filter for only certain files
 * @kind problem
 * @id java/source-filter
 */

import java
import external.DefectFilter

from DefectResult res, CompilationUnit cu
where
  cu = res.getFile() and
  cu.fromSource()
select res, res.getMessage()
