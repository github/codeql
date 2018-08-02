/**
 * @name Filter: only keep results that are outside of test methods
 * @description Exclude results in test methods.
 * @kind problem
 * @deprecated
 */
import csharp
import semmle.code.csharp.frameworks.Test
import external.DefectFilter

from DefectResult res
where not(res.getFile() instanceof TestFile) or
  not(res.getStartLine() = res.getFile().(TestFile).lineInTestMethod())
select res,
       res.getMessage()
