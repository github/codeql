/**
 * @name Filter: only keep results that are outside of test files
 * @description Exclude results in test files.
 * @kind problem
 * @deprecated
 */
import csharp
import semmle.code.csharp.frameworks.Test
import external.DefectFilter

from DefectResult res
where not(res.getFile() instanceof TestFile)
select res,
       res.getMessage()
