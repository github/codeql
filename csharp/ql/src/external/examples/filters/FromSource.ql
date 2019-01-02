/**
 * @name Filter: only keep results from source
 * @description Shows how to filter for only certain files
 * @deprecated
 */

import csharp
import external.DefectFilter

from DefectResult res
where res.getFile().fromSource()
select res, res.getMessage()
