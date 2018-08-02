/**
 * @name Filter: only keep results in non-generated files
 * @description Exclude results that come from generated code.
 * @kind problem
 * @deprecated
 */
import semmle.code.csharp.commons.GeneratedCode
import external.DefectFilter

from DefectResult res
where not isGeneratedCode(res.getFile())
select res,
       res.getMessage()
