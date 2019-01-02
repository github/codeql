/**
 * @name Poorly documented files with many authors
 * @description Files with many authors are more error-prone, so the documentation requirements are stricter for those files.
 * @kind problem
 * @problem.severity warning
 * @deprecated
 */

import csharp
import external.VCS

predicate fileCommentRatio(File f, float ratio) {
  ratio = 100.0 * (f.getNumberOfLinesOfComments().(float) / f.getNumberOfLinesOfCode().(float))
}

from File f, int numAuthors, float docPercent
where
  numAuthors = strictcount(Author a | f = a.getAnEditedFile()) and
  fileCommentRatio(f, docPercent) and
  docPercent < 20.0 and
  numAuthors >= 3 and
  f.getNumberOfLinesOfCode() > 150
select f,
  "Poorly documented file (" + docPercent.floor().toString() + "% comments) with " +
    numAuthors.toString() + " authors."
