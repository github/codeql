/**
 * @name Failed extractor invocations
 * @description Gives the command line of compilations for which extraction did not run to completion.
 * @kind diagnostic
 * @id cpp/diagnostics/failed-extractor-invocations
 */

import cpp

string describe(Compilation c) {
  if c.getArgument(1) = "--mimic"
  then result = "compiler invocation " + concat(int i | i > 1 | c.getArgument(i), " " order by i)
  else result = "extractor invocation " + concat(int i | | c.getArgument(i), " " order by i)
}

/** Gets the SARIF severity level that indicates an error. */
private int getErrorSeverity() { result = 2 }

from Compilation c
where not c.normalTermination()
select "Extraction aborted for " + describe(c), getErrorSeverity()
