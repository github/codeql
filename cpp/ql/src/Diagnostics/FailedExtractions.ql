/**
 * @kind diagnostic
 * @id cpp/diagnostics/failed-extractions
 */
import cpp

class AnonymousCompilation extends Compilation {
  override string toString() {
    result = "<compilation>"
  }
}

string describe(Compilation c) {
  if c.getArgument(1) = "--mimic"
  then result = "compiler invocation " + concat(int i | i > 1 | c.getArgument(i), " " order by i)
  else result = "extractor invocation " + concat(int i | | c.getArgument(i), " " order by i)
}

from Compilation c
where not c.normalTermination()
select c, "Extraction failed for " + describe(c), 2

