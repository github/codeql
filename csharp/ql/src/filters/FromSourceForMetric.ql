/**
 * @name Filter: only keep metric results from source
 * @description Exclude results that do not come from source code files.
 * @kind treemap
 * @deprecated
 */
import csharp
import external.MetricFilter

from MetricResult res
where res.getFile().fromSource()
select res,
       res.getValue()
