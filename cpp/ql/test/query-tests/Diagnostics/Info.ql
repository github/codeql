import cpp
import Diagnostics.ExtractionProblems

string describe(File f) {
  exists(ExtractionProblem e | e.getFile() = f |
    result = "ExtractionProblem (severity " + e.getSeverity().toString() + ")"
  )
  or
  f.fromSource() and result = "fromSource"
  or
  exists(Compilation c | c.getAFileCompiled() = f |
    (c.normalTermination() and result = "normalTermination")
  )
}

from File f
select f, concat(f.getRelativePath(), ", "), concat(describe(f), ", ")
