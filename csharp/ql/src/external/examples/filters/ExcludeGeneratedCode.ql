/**
 * @name Filter: removed results from generated code
 * @description Shows how to exclude certain files or folders from results.
 * @deprecated
 */

import csharp
import external.DefectFilter

predicate generatedFile(File f) { f.getAbsolutePath().matches("%generated%") }

from DefectResult res
where not generatedFile(res.getFile())
select res, res.getMessage()
