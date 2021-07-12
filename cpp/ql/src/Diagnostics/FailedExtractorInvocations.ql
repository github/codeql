/**
 * @name Failed extractor invocations
 * @description Gives the command line of compilations for which extraction did not run to completion.
 * @kind diagnostic
 * @id cpp/diagnostics/failed-extractor-invocations
 */

import cpp

class AnonymousCompilation extends Compilation {
  override string toString() { result = "<compilation>" }
}

string describe(Compilation c) {
  if c.getArgument(1) = "--mimic"
  then result = "compiler invocation " + concat(int i | i > 1 | c.getArgument(i), " " order by i)
  else result = "extractor invocation " + concat(int i | | c.getArgument(i), " " order by i)
}

from Compilation c
where not c.normalTermination()
select c, "Extraction aborted for " + describe(c), 2
