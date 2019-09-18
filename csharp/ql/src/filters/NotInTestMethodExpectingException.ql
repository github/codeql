/**
 * @name Filter: only keep results that are outside of a test method expecting an exception
 * @description Exclude results in test methods expecting exceptions.
 * @kind problem
 * @id cs/test-method-exception-filter
 */

import csharp
import semmle.code.csharp.frameworks.Test
import external.DefectFilter

predicate ignoredLine(File f, int line) {
  exists(TestMethod m | m.expectsException() |
    f = m.getFile() and
    line in [m.getLocation().getStartLine() .. m.getBody().getLocation().getEndLine()]
  )
}

from DefectResult res
where
  not res.getFile() instanceof TestFile
  or
  not ignoredLine(res.getFile(), res.getStartLine())
select res, res.getMessage()
